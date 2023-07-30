class NovelModel {
  NovelModel({required this.title, required this.cover, required this.url});

  final String title;
  final String cover;
  final String url;
}

typedef GetNovel = Future<List<NovelModel>>;
typedef DataList = List<Map<String, dynamic>>;
