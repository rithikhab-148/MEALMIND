# MealMind IoT: Smart Weighing Scale Integration

## Overview
MealMind supports optional hardware-assisted automated food waste tracking. The smart scale module can be installed under cafeteria plate scrape bins or kitchen prep bins to measure food waste continuously in real-time without requiring kitchen staff to manually weigh every container.

---

## Hardware Architecture

```
+------------------+         +---------------+         +---------------+         +-------------------------+
| Food Waste Bin   |  --->   | 4x Strain     |  --->   | HX711 24-bit  |  --->   | ESP32 Microcontroller   |
| (Deposition)     |         | Gauge Sensors |         | ADC Amplifier |         | (Wi-Fi 802.11 b/g/n)    |
+------------------+         +---------------+         +---------------+         +-------------------------+
                                                                                              |
                                                                                              v  (HTTP POST JSON)
                                                                                 +-------------------------+
                                                                                 | MealMind FastAPI Engine |
                                                                                 | / Cloud Firestore       |
                                                                                 +-------------------------+
```

---

## Hardware Bill of Materials (BOM)

| Component | Specification | Quantity | Purpose |
| :--- | :--- | :--- | :--- |
| **Microcontroller** | ESP32 WROOM-32 Dev Kit | 1 | Sensor reading, debouncing, WiFi HTTP/MQTT client |
| **ADC Amplifier** | HX711 24-Bit ADC Module | 1 | Amplifies millivolt signal from load cells |
| **Load Cells** | 4x 50kg Strain Gauge Load Cells (or 1x 100kg Single Point) | 1 Set | Measures bin load up to 200 kg |
| **Tare Push Button** | Momentary SPST Button | 1 | Zero-calibrates the empty container weight |
| **Status LED** | 5mm Green / RGB LED + 220Ω Resistor | 1 | Network & transmission activity indicator |
| **Power Supply** | 5V 2A Micro-USB / Type-C Power Adapter | 1 | Stable power supply for sensor and ESP32 |

---

## Pinout & Wiring Table

| HX711 Pin | ESP32 GPIO Pin | Description |
| :--- | :--- | :--- |
| `VCC` | `5V` / `VIN` | Power supply |
| `GND` | `GND` | Common Ground |
| `DT` (Data) | `GPIO 21` | Serial Data line |
| `SCK` (Clock) | `GPIO 22` | Serial Clock line |

| Button / LED | ESP32 GPIO Pin | Description |
| :--- | :--- | :--- |
| `Tare Button` | `GPIO 19` (to GND, internal pull-up) | Zero calibration |
| `Status LED` | `GPIO 2` | High when connected to WiFi |

---

## Calibration Procedure

1. Connect the ESP32 via USB and open Arduino IDE / PlatformIO Serial Monitor at **115200 baud**.
2. Remove any weight from the scale and press the **Tare Button**.
3. Place a known calibration weight (e.g., 5.00 kg dumbbell or water container) onto the scale.
4. Calculate the calibration factor:
   $$\text{calibration\_factor} = \frac{\text{Raw Reading}}{\text{Known Weight in kg}}$$
5. Update `calibration_factor = 2280.0;` in `smart_scale.ino` and re-upload.

---

## API Payload Specification

When food waste deposition stabilizes for > 2 seconds, the scale automatically sends:

```json
POST /iot/waste-event
Host: api.mealmind.institution.edu:8000
Content-Type: application/json

{
  "device_id": "ESP32_DINING_HALL_A_BIN_01",
  "dining_hall_id": "hall_a",
  "meal_type": "Lunch",
  "food_item": "Mixed Plate Waste",
  "waste_weight_kg": 4.65,
  "waste_type": "Plate waste",
  "timestamp": "2026-08-27T13:45:00Z"
}
```

The MealMind API automatically ingests this event and appends it to today's active meal waste log in Firestore.
