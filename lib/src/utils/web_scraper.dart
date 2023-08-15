import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:dio/dio.dart';
import 'validations.dart';

typedef DataList = List<Map<String, dynamic>>;

class WebScraper {
  WebScraper(this._baseUrl) {
    final result = Validation.isBaseURL(_baseUrl);

    if (!result.isCorrect) throw Exception(result.description);
  }

  final String _baseUrl;

  Document? _document;

  Future<bool> loadWebPage(String path) async {
    final endpoint = Uri.encodeFull(_removeUnnecessarySlash(_baseUrl + path));

    try {
      _loadStaticPage(endpoint);
    } catch (e) {
      throw Exception(e.toString());
    }

    return true;
  }

  DataList getElement(String selector, List<String> attrs) {
    List<Map<String, dynamic>> elementData = [];

    if (_document == null) {
      throw Exception('getElement cannot be called before loadWebPage');
    }

    //? Using query selector to get a list of particular element.
    List<Element> elements = _document!.querySelectorAll(selector);

    for (final element in elements) {
      final Map<String, dynamic> attrData = {};

      for (final attr in attrs) {
        attrData.addEntries([MapEntry(attr, element.attributes[attr])]);
      }

      elementData.add({
        'text': element.text,
        'attributes': attrData,
        'element': element,
      });
    }
    return elementData;
  }

  _loadStaticPage(String endpoint) async {
    final dio = Dio();

    final response = await dio.get(endpoint);

    print(response.statusCode.toString());

    if (response.statusCode != 200) throw Exception('Error loading page');

    _document = parse(response.data);
  }

  String _removeUnnecessarySlash(String url) {
    RegExp regex = RegExp(r"/{2,}");
    final splitedUrl = url.split("://");
    final protocol = splitedUrl[0];
    final resultUrl = splitedUrl[1].replaceAll(regex, "/");

    return "$protocol://$resultUrl";
  }
}
