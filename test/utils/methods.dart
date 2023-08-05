import 'package:kagayaku_modules/src/models/novel.dart';
import 'package:test/test.dart';

isNovelNotEmpty(NovelModel novel) {
  expect(novel.title, isNotEmpty);
  expect(novel.cover, isNotEmpty);
  expect(novel.url, isNotEmpty);
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
