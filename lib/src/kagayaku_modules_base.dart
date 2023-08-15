import 'models/novel.dart';
import 'utils/web_scraper.dart';

import 'models/novel_details.dart';

typedef NovelFunction = Future<List<NovelModel>>;

class KagayakuModule {
  KagayakuModule(this._kayaContent) {
    _readSource();
  }

  late final String sourceUrl;
  final List<String> _kayaContent;
  late final WebScraper _webScraper;

  NovelFunction getSpotlightNovels() => _getNovelList('getSpotlightNovels');

  NovelFunction getLatestNovels() => _getNovelList('getLatestNovels');

  NovelFunction getPopularNovels() => _getNovelList('getPopularNovels');

  Future<NovelDetails> getNovelDetails(String novelUrl) async {
    final List<String> function = [];

    function.addAll(_getFunctionContent('getNovelDetails'));

    if (function.isEmpty) throw Exception('Failed to load');

    final String url = novelUrl.replaceFirst(sourceUrl, '');

    if (!await _webScraper.loadWebPage(url)) throw Exception('Failed to load');

    // final selectors = _getSelectors(function);

    return NovelDetails();
  }

  NovelFunction _getNovelList(String name) async {
    List<NovelModel> novels = [];
    final List<String> function = [];

    function.addAll(_getFunctionContent(name));

    if (function.isEmpty) throw Exception('Failed to load');

    final String? url = _getPageUrl(function);

    if (url == null) return novels;

    if (!await _webScraper.loadWebPage(url)) throw Exception('Failed to load');

    final selectors = _getSelectors(function);

    final sCover = selectors['cover'];
    final sTitle = selectors['title'];
    final sLink = selectors['link'];

    // final DataList covers = _webScraper.getElement(sCover[0], [sCover[1]]);
    // final DataList titles = _webScraper.getElement(sTitle[0], [sTitle[1]]);
    // final DataList links = _webScraper.getElement(sLink[0], [sLink[1]]);

    // for (int i = 0; i < covers.length; i++) {
    //   final String cover = covers[i]['attributes'][sCover[1]];
    //   final String title = titles[i]['text'];
    //   final String link = links[i]['attributes'][sLink[1]];
    //
    //   novels.add(NovelModel(
    //     title: title,
    //     cover: cover,
    //     url: link,
    //   ));
    // }

    return novels;
  }

  void _readSource() async {
    for (String line in _kayaContent) {
      if (line.startsWith('@source')) {
        final baseUrl = line.substring('@source'.length).trim();
        _webScraper = WebScraper(_removeQuotes(baseUrl));
        sourceUrl = _removeQuotes(baseUrl);
        break;
      }
    }
  }

  String _removeQuotes(String str) {
    if (str.length <= 2) return "";

    return str.substring(1, str.length - 1);
  }

  List<String> _getFunctionContent(String name) {
    List<String> functionContent = [];
    bool canAdd = false;

    final isNull = _kayaContent.where(_isReturnNull).toList();

    if (isNull.isNotEmpty) return functionContent;

    for (String line in _kayaContent) {
      if (line.startsWith('@fun $name(')) {
        for (String funcLine in _kayaContent) {
          if (funcLine.startsWith('@fun $name(')) {
            canAdd = true;
            continue;
          }
          if (canAdd && funcLine.startsWith('@return')) {
            canAdd = false;
            break;
          }
          if (canAdd) functionContent.add(funcLine);
        }
        break;
      }
    }

    return functionContent;
  }

  bool _isReturnNull(String line) {
    if (!line.startsWith('@return')) return false;
    final returnLine = line.substring('@return'.length).trim().toLowerCase();
    if (returnLine.contains('null')) return true;

    return false;
  }

  String? _getPageUrl(List<String> function) {
    String? url;

    for (String line in function) {
      if (line.startsWith('@url')) {
        url = line.substring('@url'.length).trim();
        break;
      }
    }

    if (url == null) return null;

    return _removeQuotes(url);
  }

  Map<String, dynamic> _getSelectors(List<String> function) {
    Map<String, dynamic> selectors = {};

    for (String line in function) {
      if (line.contains('@selector')) {
        final String selectorLine = line.substring('@var'.length).trim();
        final List<String> parts = selectorLine.split('->');
        final String key = parts[0].trim();
        final String value = _removeQuotes(
          parts[1].trim().substring('@selector'.length).trim(),
        );

        final List<String> valueParts = '$value@'.trim().split('@');

        final String selector = valueParts[0].trim();
        final String attribute = valueParts[1].trim();

        selectors[key] = [selector, attribute];
      }
    }

    return selectors;
  }
}
