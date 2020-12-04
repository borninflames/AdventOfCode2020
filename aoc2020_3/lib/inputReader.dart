import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<List<String>> readInputFile(String path) async {
  final file = File(path);
  var trees = <String>[];
  final completer = Completer<List<String>>();
  var inputStream = file.openRead();
  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
    trees.add(line);
    //print(line);
  }, onDone: () {
    completer.complete(trees);
  }, onError: (e) {
    print(e.toString());
  });

  return completer.future;
}
