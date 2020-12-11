import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<List<String>> readInputFile(String path) async {
  final file = File(path);
  final completer = Completer<List<String>>();
  var inputStream = file.openRead();
  var ferry = <String>[];
  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
    if (ferry.isEmpty) {
      ferry.add('.' * (line.length + 2));
    }
    ferry.add('.' + line + '.');
  }, onDone: () {
    ferry.add('.' * ferry[0].length);
    completer.complete(ferry);
  }, onError: (e) {
    print(e.toString());
  });
  return completer.future;
}
