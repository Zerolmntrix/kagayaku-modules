//! Please don't modify the imports.
import 'package:kagayaku_modules/kagayaku_modules.dart';
import 'package:kagayaku_modules/src/interface/module.dart';
import 'package:kagayaku_modules/src/models/novel.dart';

//? You can use this as a template for your module.

// * This is the main class of your module.
class YourModuleName implements ModuleInterface {
  //! The url needs to be in the info.json file of the module. baseUrl: example.com
  @override
  final webScraper = WebScraper('https://example.com');

  @override
  getPopularNovels() async {
    List<NovelModel> novels = [];

    return novels;
  }

  @override
  getLatestNovels() async {
    List<NovelModel> novels = [];
    //? The same as getPopularNovels() but for the latest novels.

    return novels;
  }

  @override
  searchNovels(query) async {
    //? This method depends a lot on how the site search works.
    List<NovelModel> novels = [];

    return novels;
  }
}
