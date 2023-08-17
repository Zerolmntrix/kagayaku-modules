import 'models/novel.dart';
import 'utils/web_scraper.dart';

import 'models/novel_details.dart';

typedef NovelFunction = Future<List<NovelModel>>;

class KagayakuModule {
  KagayakuModule(this._source, this._sourceUrl)
      : _webScraper = WebScraper(_sourceUrl);

  final String _sourceUrl;
  final List<String> _source;
  final WebScraper _webScraper;

  String get sourceUrl => _sourceUrl;

  NovelFunction getSpotlightNovels() => _getNovelList('getSpotlightNovels');

  NovelFunction getLatestNovels() => _getNovelList('getLatestNovels');

  NovelFunction getPopularNovels() => _getNovelList('getPopularNovels');

  NovelFunction getNovelsBySearch(String query) async {
    final functionName = 'getNovelsBySearch';

    final List<String> function = _getFunctionContent(functionName);

    final functionArgs = {'query': query};

    if (function.isEmpty) throw Exception('Failed to load');

    final firstLine = _getFuncionFirstLine(function);

    final targetUrl = _getPageUrl(function);

    final args = _getArgs(firstLine);
    if (args.isEmpty) throw Exception('Args not found');

    final annotation = _getAnnotation(firstLine, 'by');

    final selectors = _getSelectors(function);

    switch (annotation) {
      case 'Url':
        String url = '';

        for (String arg in args) {
          url = targetUrl.replaceFirst('@arg[$arg]', functionArgs[arg]!);
        }

        if (!await _webScraper.loadWebPage(url)) {
          throw Exception('Failed to load');
        }

        return _getNovels(selectors);
      case 'Page':
        // TODO: Implement by page
        return _getNovels(selectors);
      default:
        throw Exception('Not found a valid annotation');
    }
  }

  Future<NovelDetails> getNovelDetails(String novelUrl) async {
    final List<String> function = _getFunctionContent('getNovelDetails');

    if (function.isEmpty) throw Exception('Failed to load');

    final String url = novelUrl.replaceFirst(_sourceUrl, '');

    if (!await _webScraper.loadWebPage(url)) throw Exception('Failed to load');

    // final selectors = _getSelectors(function);

    return NovelDetails();
  }

  NovelFunction _getNovelList(String name) async {
    final List<String> function = _getFunctionContent(name);

    if (function.isEmpty) throw Exception('Failed to load');

    final String url = _getPageUrl(function);

    if (!await _webScraper.loadWebPage(url)) throw Exception('Failed to load');

    final selectors = _getSelectors(function);

    return _getNovels(selectors);
  }

  List<NovelModel> _getNovels(Map<String, dynamic> selectors) {
    final List<NovelModel> novels = [];

    final sCover = selectors['cover'];
    final sTitle = selectors['title'];
    final sLink = selectors['link'];

    final DataList covers = _webScraper.getElement(sCover[0], [sCover[1]]);
    final DataList titles = _webScraper.getElement(sTitle[0], [sTitle[1]]);
    final DataList links = _webScraper.getElement(sLink[0], [sLink[1]]);

    for (int i = 0; i < covers.length; i++) {
      final String cover = covers[i]['attributes'][sCover[1]];
      final String title = titles[i]['text'];
      final String link = links[i]['attributes'][sLink[1]];

      novels.add(NovelModel(
        title: title,
        cover: cover,
        url: link,
      ));
    }

    return novels;
  }

  String _removeQuotes(String str) {
    if (str.length <= 2) return str;

    return str.substring(1, str.length - 1);
  }

  List<String> _getFunctionContent(String name) {
    List<String> functionContent = [];
    bool canAdd = false;

    final isNull = _source.where(_isReturnNull).toList();

    if (isNull.isNotEmpty) return functionContent;

    for (String line in _source) {
      if (line.startsWith('@fun $name(')) {
        for (String funcLine in _source) {
          if (funcLine.startsWith('@fun $name(')) {
            canAdd = true;
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

  String _getPageUrl(List<String> function) {
    String? url;
    for (String line in function) {
      if (line.startsWith('@url')) {
        url = _removeQuotes(line.substring('@url'.length).trim());
      }
    }

    if (url == null) throw Exception('Url not found');

    return url;
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

  String _getFuncionFirstLine(List<String> function) {
    for (String line in function) {
      if (line.startsWith('@fun')) {
        return line;
      }
    }

    return '';
  }

  String? _getAnnotation(String function, String name) {
    try {
      final annotation = function.substring(function.indexOf('@$name')).trim();

      return annotation.substring('@$name'.length).trim();
    } catch (e) {
      print(e);
    }

    return null;
  }

  List<String> _getArgs(String function) {
    List<String> args = [];
    RegExp regex = RegExp(r'@arg\s+(\w+)');

    Iterable<RegExpMatch> matches = regex.allMatches(function);

    for (var match in matches) {
      args.add(match.group(1)!);
    }

    return args;
  }
}
