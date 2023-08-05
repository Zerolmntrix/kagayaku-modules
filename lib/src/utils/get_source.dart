import 'dart:io';

Future<List<String>> getSourceFromFile(String moduleId) async {
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
