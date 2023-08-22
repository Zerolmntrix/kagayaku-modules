import 'dart:io';

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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

  Future<bool> loadWebPage(String path, bool useWebView) async {
    final endpoint = Uri.encodeFull(_removeUnnecessarySlash(_baseUrl + path));

    try {
      if (useWebView) {
        await _loadWebViewPage(endpoint);
      } else {
        await _loadStaticPage(endpoint);
      }
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

    List<Element> elements = querySelectorAll(selector);

    for (final element in elements) {
      final Map<String, dynamic> attrData = {};

      for (final attr in attrs) {
        attrData.addEntries([MapEntry(attr, element.attributes[attr])]);
      }

      elementData.add({
        'text': element.text.trim(),
        'attributes': attrData,
        'element': element,
        'position': _getElementPosition(selector, elements),
      });
    }
    return elementData;
  }

  _loadStaticPage(String endpoint) async {
    final dio = Dio();

    final response = await dio.get(endpoint);

    if (response.statusCode != 200) throw Exception('Error loading page');

    _document = parse(response.data);
  }

  _loadWebViewPage(String endpoint) async {
    if (!Platform.isIOS && !Platform.isAndroid) {
      throw Exception('WebView is only supported on mobile devices');
    }

    HeadlessInAppWebView? headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(endpoint)),
      onLoadStop: (controller, url) async {
        final result = await controller.evaluateJavascript(
          source: "new XMLSerializer().serializeToString(document);",
        );

        _document = parse(result);
      },
    );

    await headlessWebView.run();

    await headlessWebView.dispose();
  }

  querySelectorAll(String rawSelector) {
    Element? currentElement = _document!.body;
    List<Element> result = [];
    final selectors = getSelectorList(rawSelector.split(' '));

    if (selectors.length == 1) return _document!.querySelectorAll(rawSelector);

    for (final currentSelector in selectors) {
      if (numberSyntax.hasMatch(currentSelector)) {
        final selector = currentSelector.replaceFirst(numberSyntax, '');

        final positionMatch = currentSelector.replaceAll(RegExp(r'\D'), '');
        final int position = int.parse(positionMatch) - 1;

        final elements = currentElement!.querySelectorAll(selector);

        currentElement = elements[position];

        if (selectors.last == currentSelector) {
          result.add(currentElement);
        }

        continue;
      }

      if (selectors.last == currentSelector) {
        final elements = currentElement!.querySelectorAll(currentSelector);
        result.addAll(elements);
      }

      currentElement = currentElement?.querySelector(currentSelector);
    }
    return result;
  }

  List<String> getSelectorList(List<String> selectors) {
    List<String> currentGroup = [];
    List<String> resultArray = [];

    for (String item in selectors) {
      if (numberSyntax.hasMatch(item)) {
        if (currentGroup.isNotEmpty) resultArray.add(currentGroup.join(' '));
        resultArray.add(item);
        currentGroup.clear();
      } else {
        currentGroup.add(item);
      }
    }

    if (currentGroup.isNotEmpty) resultArray.add(currentGroup.join(' '));

    return resultArray;
  }

  int _getElementPosition(String selector, List<Element> elements) {
    RegExp pattern = RegExp(r"<\d+>");

    if (!pattern.hasMatch(selector)) return 0;

    Match? match = pattern.firstMatch(selector);
    final int position = int.parse(
      match!.group(0)!.replaceAll('<', '').replaceAll('>', ''),
    );

    return elements.length > position ? position : 1;
  }

  String _removeUnnecessarySlash(String url) {
    RegExp regex = RegExp(r"/{2,}");
    final splitedUrl = url.split("://");
    final protocol = splitedUrl[0];
    final resultUrl = splitedUrl[1].replaceAll(regex, "/");

    return "$protocol://$resultUrl";
  }
}
