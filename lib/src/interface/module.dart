import 'package:kagayaku_modules/kagayaku_modules.dart';
import 'package:kagayaku_modules/src/models/novel.dart';

abstract class ModuleInterface {
  final WebScraper webScraper = WebScraper('https://example.com/');

  GetNovel getPopularNovels();

  GetNovel getLatestNovels();

  GetNovel searchNovels(String query);
}
