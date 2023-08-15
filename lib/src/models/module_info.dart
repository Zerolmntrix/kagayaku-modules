class ModuleInfo {
  final String name;
  final String icon;
  final String language;
  final String developer;
  final String baseUrl;

  ModuleInfo({
    required this.name,
    required this.icon,
    required this.language,
    required this.developer,
    required this.baseUrl,
  });

  ModuleInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? 'Unknown',
        icon = json['icon'] ?? 'icon in info.json',
        language = json['language'] ?? '',
        developer = json['developer'] ?? 'Unknown',
        baseUrl = json['baseUrl'] ?? '';
}
