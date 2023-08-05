//? Your test file need to be called module_name_test.dart

//?  This is just a template for the module test file. this file doesn't work.

//! You need to put the module_name_test.dart file in the test/modules folder.

import 'package:kagayaku_modules/src/source_data.dart';
import 'package:test/test.dart';

import '../utils/methods.dart';

void main() async {
  late SourceData sourceData;
  setUp(() async {
    // You need to put your module id here. lang.module
    final module = await getModuleFromFile('en.yourmodule');

    sourceData = SourceData(module);
  });

  group('Your Module Name', () {
    group('Lists', () {
      test('Spotlight', () async {
        final novels = await sourceData.getSpotlightNovels();

        isOk(novels);
      });
      test('Latest', () async {
        final novels = await sourceData.getLatestNovels();

        isOk(novels);
      });
      test('Popular', () async {
        final novels = await sourceData.getPopularNovels();

        isOk(novels);
      });
      test('Search', () async {});
    });
    test('Novel', () async {});
  });
}
