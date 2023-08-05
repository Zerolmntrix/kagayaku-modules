//? Your test file need to be called module_name_test.dart

//?  This is just a template for the module test file. this file doesn't work.

//! You need to put the module_name_test.dart file in the test/modules folder.

import 'package:kagayaku_modules/src/kagayaku_modules_base.dart';
import 'package:kagayaku_modules/src/utils/get_source.dart';
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
    test('Novel', () async {});
  });
}
