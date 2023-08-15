import 'dart:io';

Future<List<String>> getSourceFromFile(String path) async {
  final module = File(path);
  final sourceContent = await module.readAsLines();

  final sourceContentList = sourceContent
      .where((line) => line.isNotEmpty)
      .where((line) => !line.startsWith('//'))
      .map((e) => e.trim())
      .toList();

  return sourceContentList;
}
