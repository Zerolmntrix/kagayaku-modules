class NovelDetails {
  const NovelDetails({
    this.title,
    this.cover,
    this.author,
    this.status,
    this.genres,
    this.description,
    this.chapters,
    this.chapterName,
    this.chapterLink,
    this.chapterDate,
  });

  final String? title;
  final String? cover;
  final String? author;
  final String? status;
  // ? For genres, you need to provide a selector for a single genre. same for chapters
  // Like ".novel-info .novel-genres .genre" instead of ".novel-info .novel-genres"
  final String? genres;
  final String? description;
  // Here you need to provide a selector that contains the a single chapter like in the genres
  final String? chapters;
  // These will be sought within each chapter
  final String? chapterName;
  final String? chapterLink;
  final String? chapterDate;
}
