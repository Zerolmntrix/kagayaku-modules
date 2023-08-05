class Validation {
  static ValidationReturn isBaseURL(String url) {
    const protocols = ['http', 'https'];
    List<String> split = url.split('://');
    String? protocol = _getProtocol(split);

    if (split.isEmpty) {
      return ValidationReturn(
        false,
        'bring url to the format scheme:[//]domain; EXAMPLE: https://google.com',
      );
    }

    if (!protocols.contains(protocol)) {
      return ValidationReturn(false, 'use [http/https] protocol');
    }

    return ValidationReturn(true, 'ok');
  }

  static String? _getProtocol(List<String> url) {
    if (url.isEmpty) return null;

    return url.first;
  }
}

class ValidationReturn {
  ValidationReturn(this.isCorrect, this.description);

  final bool isCorrect;
  final String description;
}
