//? Your test file need to be called module_name_test.dart

//?  This is just a template for the module test file. this file doesn't work.

//! You need to put the module_name_test.dart file in the test/modules folder.

import 'package:kagayaku_modules/kagayaku_modules.dart' hide getSourceFromFile;
import 'package:test/test.dart';

import '../utils/methods.dart';

void main() async {
  late KagayakuModule module;
  setUp(() async {
    // You need to put your module id here. lang.module
    final source = await getSourceFromFile('en.yourmodule');

    module = KagayakuModule(source);
  });

  group('Your Module Name', () {
    group('Lists', () {
      test('Spotlight', () async {
        final novels = await module.getSpotlightNovels();

        isOk(novels);
      });
      test('Latest', () async {
        final novels = await module.getLatestNovels();

        isOk(novels);
      });
      test('Popular', () async {
        final novels = await module.getPopularNovels();

        isOk(novels);
      });
      test('Search', () async {});
    });
    test('Novel', () async {
      // ? You need to provide a url to a novel in your module
      final url = 'https://yourmodule.com/novel/your-novel/';
      final novel = await module.getNovelDetails(url);
    });
  });
}
