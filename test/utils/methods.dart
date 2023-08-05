import 'dart:io';

import 'package:kagayaku_modules/src/models/novel.dart';
import 'package:test/test.dart';

isNovelNotEmpty(NovelModel novel) {
  expect(novel.title, isNotEmpty);
  expect(novel.cover, isNotEmpty);
  expect(novel.url, isNotEmpty);
}

Future<List<String>> getModuleFromFile(String moduleId) async {
  final id = moduleId.split('.');
  final language = id[0];
  final name = id[1];

  final module = File('lib/src/modules/$language/$name/module.kaya');
  final moduleContent = await module.readAsLines();

  final moduleContentList = moduleContent
      .where((element) => element.isNotEmpty)
      .where((element) => !element.startsWith('//'))
      .map((e) => e.trim())
      .toList();

  return moduleContentList;
}

isOk(List<NovelModel> novels) {
  expect(novels, isNotEmpty);

  for (final novel in novels) {
    isNovelNotEmpty(novel);
    print(novel.title);
  }
}

isSearchOk(List<NovelModel> novels, String search) {
  expect(novels, isNotEmpty);

  for (final novel in novels) {
    isNovelNotEmpty(novel);
    expect(novel.title, contains(search));
    print(novel.title);
  }
}
