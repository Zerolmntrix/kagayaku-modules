abstract class Languages {
  static String get(String key) => _languages[key] ?? 'Unknown';

  static const Map _languages = {
    'all': 'All',
    'ar': 'العربية', // Arabic
    'bg': 'български', // Bulgarian
    'ca': 'Català', // Catalan
    'zh': '中文', // Chinese
    'en': 'English', // English
    'fr': 'Français', // French
    'de': 'Deutsch', // German
    'hi': 'हिन्दी', // Hindi
    'id': 'Indonesia', // Indonesian
    'it': 'Italiano', // Italian
    'ja': '日本語', // Japanese
    'ko': '한국어', // Korean
    'pl': 'Polski', // Polish
    'pt': 'Português', // Portuguese
    'ru': 'Pусский', // Russian
    'es': 'Español', // Spanish
    'th': 'ไทย', // Thai
    'tr': 'Türkçe', // Turkish
    'uk': 'Yкраїнська', // Ukrainian
    'vi': 'Tiếng Việt', // Vietnamese
  };
}
