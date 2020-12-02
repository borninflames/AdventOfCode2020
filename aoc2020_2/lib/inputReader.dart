import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<int> readInputFile(String path) async {
  final file = File(path);
  var countValidPasswords = 0;
  final completer = Completer<int>();
  var inputStream = file.openRead();
  inputStream
      .transform(utf8.decoder) // Decode bytes to UTF-8.
      .transform(LineSplitter()) // Convert stream to individual lines.
      .listen((String line) {
    countValidPasswords += PasswordRule(line).isValid2() ? 1 : 0;
  }, onDone: () {
    completer.complete(countValidPasswords);
  }, onError: (e) {
    print(e.toString());
  });

  return completer.future;
}

class PasswordRule {
  String pwd;
  String char;
  int min;
  int max;

  PasswordRule(String line) {
    var parts = line.split('-');
    min = int.parse(parts[0]);
    parts = parts[1].split(' ');
    max = int.parse(parts[0]);
    char = parts[1][0];
    pwd = parts[2];
  }

  bool isValid() {
    var count = char.allMatches(pwd).length;
    return count >= min && count <= max;
  }

  bool isValid2() {
    return (pwd[min - 1] == char && (pwd[max - 1] != char)) ||
        (pwd[min - 1] != char && pwd[max - 1] == char);
  }
}
