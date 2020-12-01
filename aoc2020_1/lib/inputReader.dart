import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<List<int>> readInputFile(String path) async {
  final file = File(path);
  var input = <int>[];
  final completer = Completer<List<int>>();
  var inputStream = file.openRead();
  inputStream
      .transform(utf8.decoder) // Decode bytes to UTF-8.
      .transform(LineSplitter()) // Convert stream to individual lines.
      .listen((String line) {
    input.add(int.parse(line));
  }, onDone: () {
    completer.complete(input);
  }, onError: (e) {
    print(e.toString());
  });

  return completer.future;
}
