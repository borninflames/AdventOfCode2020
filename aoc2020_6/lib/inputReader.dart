import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<int> readInputFile(String path) async {
  final file = File(path);
  var count = 0;
  var answers = <String>[];
  final completer = Completer<int>();
  var inputStream = file.openRead();
  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
    if (line.isEmpty) {
      count += countAnswers2(answers);
      print(count);
      answers = <String>[];
    } else {
      answers.add(line);
    }
  }, onDone: () {
    completer.complete(count);
  }, onError: (e) {
    print(e.toString());
  });

  return completer.future;
}

int countAnswers2(List<String> answers) {
  return answers[0]
      .split('')
      .where((a) => answers.every((pa) => pa.contains(a)))
      .length;
}

int countAnswers(String answers) {
  return answers
      .split('')
      .asMap()
      .entries
      .where((i) => answers.indexOf(i.value) == i.key)
      .length;
}
