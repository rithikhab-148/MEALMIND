/*
 * MealMind - Smart Food Waste Weighing Scale System
 * Hardware: ESP32 Dev Module + HX711 Load Cell Amplifier (50kg / 100kg Load Cell)
 * 
 * Flow:
 * Food Waste Deposited -> Load Cell Deflection -> HX711 ADC -> ESP32 Processing 
 * -> Weight Stabilization -> Automated HTTP JSON Transmission to MealMind API / Firestore
 */

#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include "HX711.h"

// WiFi Credentials
const char* WIFI_SSID = "CAMPUS_WIFI_OR_HOTSPOT";
const char* WIFI_PASS = "WiFiPassword123";

// MealMind API Endpoint
const char* MEALMIND_API_URL = "http://192.168.1.100:8000/iot/waste-event";
const char* DEVICE_ID = "ESP32_DINING_HALL_A_BIN_01";
const char* DINING_HALL_ID = "hall_a";

// Pin Configuration
const int HX711_DOUT_PIN = 21;
const int HX711_SCK_PIN = 22;
const int TARE_BUTTON_PIN = 19;
const int STATUS_LED_PIN = 2;

HX711 scale;

// Calibration Factor (Set based on standard 1kg/5kg test weight)
float calibration_factor = 2280.0; 

// State Tracking
float previous_weight = 0.0;
const float MIN_WEIGHT_THRESHOLD_KG = 0.20; // Ignore tiny fluctuations < 200g
const float STABILIZATION_TOLERANCE = 0.05; // 50g tolerance for settled reading
unsigned long last_reading_time = 0;

void setup() {
  Serial.begin(115200);
  pinMode(TARE_BUTTON_PIN, INPUT_PULLUP);
  pinMode(STATUS_LED_PIN, OUTPUT);
  digitalWrite(STATUS_LED_PIN, LOW);

  Serial.println("\n[MealMind IoT] Initializing Smart Food Waste Scale...");

  // Initialize HX711
  scale.begin(HX711_DOUT_PIN, HX711_SCK_PIN);
  scale.set_scale(calibration_factor);
  scale.tare(); // Reset scale to 0
  Serial.println("[MealMind IoT] Load Cell Tared to 0.00 kg");

  // Connect to WiFi
  connectWiFi();
}

void connectWiFi() {
  Serial.print("[MealMind IoT] Connecting to WiFi: ");
  Serial.println(WIFI_SSID);
  WiFi.begin(WIFI_SSID, WIFI_PASS);

  int retries = 0;
  while (WiFi.status() != WL_CONNECTED && retries < 20) {
    delay(500);
    Serial.print(".");
    retries++;
  }

  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("\n[MealMind IoT] WiFi Connected! IP: " + WiFi.localIP().toString());
    digitalWrite(STATUS_LED_PIN, HIGH);
  } else {
    Serial.println("\n[MealMind IoT] WiFi Connection Failed (Offline Mode)");
  }
}

void sendWasteEvent(float weightKg, const char* wasteType) {
  if (WiFi.status() != WL_CONNECTED) {
    Serial.println("[MealMind IoT] Warning: Offline, attempting reconnect...");
    connectWiFi();
    if (WiFi.status() != WL_CONNECTED) return;
  }

  HTTPClient http;
  http.begin(MEALMIND_API_URL);
  http.addHeader("Content-Type", "application/json");

  StaticJsonDocument<256> doc;
  doc["device_id"] = DEVICE_ID;
  doc["dining_hall_id"] = DINING_HALL_ID;
  doc["meal_type"] = "Lunch";
  doc["food_item"] = "Mixed Plate Waste";
  doc["waste_weight_kg"] = weightKg;
  doc["waste_type"] = wasteType;

  String requestBody;
  serializeJson(doc, requestBody);

  Serial.print("[MealMind IoT] Transmitting payload: ");
  Serial.println(requestBody);

  int httpResponseCode = http.POST(requestBody);
  if (httpResponseCode > 0) {
    String response = http.getString();
    Serial.printf("[MealMind IoT] HTTP Response Code: %d, Response: %s\n", httpResponseCode, response.c_str());
  } else {
    Serial.printf("[MealMind IoT] Error sending POST: %s\n", http.errorToString(httpResponseCode).c_str());
  }

  http.end();
}

void loop() {
  // Check Tare Button
  if (digitalRead(TARE_BUTTON_PIN) == LOW) {
    Serial.println("[MealMind IoT] Tare button pressed. Resetting zero baseline...");
    scale.tare();
    previous_weight = 0.0;
    delay(1000);
  }

  if (scale.is_ready()) {
    float current_weight = scale.get_units(5); // Average of 5 readings
    if (current_weight < 0) current_weight = 0.0;

    // Detect new food deposition
    float weight_diff = current_weight - previous_weight;

    if (weight_diff > MIN_WEIGHT_THRESHOLD_KG) {
      Serial.printf("[MealMind IoT] Deposition Detected: +%.2f kg (Total: %.2f kg)\n", weight_diff, current_weight);
      
      // Wait 2 seconds for weight to stabilize
      delay(2000);
      float settled_weight = scale.get_units(10);
      float verified_deposit = settled_weight - previous_weight;

      if (verified_deposit > MIN_WEIGHT_THRESHOLD_KG) {
        Serial.printf("[MealMind IoT] Stabilized Weight: %.2f kg. Sending to MealMind Cloud...\n", verified_deposit);
        sendWasteEvent(verified_deposit, "Plate waste");
        previous_weight = settled_weight;
      }
    }
  }

  delay(500);
}
