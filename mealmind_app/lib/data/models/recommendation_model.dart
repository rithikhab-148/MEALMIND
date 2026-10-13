class RecommendationModel {
  final String id;
  final String category;
  final String title;
  final String description;
  final String impactLevel; // 'Critical', 'High', 'Medium', 'Low'
  final String estimatedSavingsMonthly;
  final String targetRole; // 'Kitchen Staff', 'Admin', 'All'
  final String icon;
  final bool isApplied;

  RecommendationModel({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.impactLevel,
    required this.estimatedSavingsMonthly,
    required this.targetRole,
    this.icon = 'eco',
    this.isApplied = false,
  });

  factory RecommendationModel.fromMap(Map<String, dynamic> map) {
    return RecommendationModel(
      id: map['id'] ?? '',
      category: map['category'] ?? 'General',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      impactLevel: map['impact_level'] ?? 'Medium',
      estimatedSavingsMonthly: map['estimated_savings_monthly'] ?? '₹5,000',
      targetRole: map['target_role'] ?? 'Staff',
      icon: map['icon'] ?? 'eco',
      isApplied: map['is_applied'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'description': description,
      'impact_level': impactLevel,
      'estimated_savings_monthly': estimatedSavingsMonthly,
      'target_role': targetRole,
      'icon': icon,
      'is_applied': isApplied,
    };
  }
}
