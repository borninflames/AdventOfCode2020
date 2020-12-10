import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<List<int>> readInputFile(String path) async {
  final file = File(path);
  final completer = Completer<List<int>>();
  var inputStream = file.openRead();
  var numbers = <int>[];
  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
    numbers.add(int.parse(line));
  }, onDone: () {
    completer.complete(numbers);
  }, onError: (e) {
    print(e.toString());
  });
  return completer.future;
}
