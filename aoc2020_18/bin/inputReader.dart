import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<int> readInputFile(String path) async {
  final file = File(path);
  final completer = Completer<int>();
  var inputStream = file.openRead();
  var sum = 0;

  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
    sum += sumRow(line);
  }, onDone: () {
    completer.complete(sum);
  }, onError: (e) {
    print(e.toString());
  });
  return completer.future;
}

int sumRow(String row) {
  var digitExp = RegExp(r'\d');
  row = row.replaceAll(' ', '');
  var r = row.split('');
  var sum = 0;
  var op = '+';
  for (var i = 0; i < r.length; i++) {
    var char = r[i];
    if (digitExp.hasMatch(char)) {
      var numb = int.parse(char);
      switch (op) {
        case '+':
          sum += numb;
          break;
        case '*':
          sum *= numb;
      }
    } else if (char == '+' || char == '*') {
      op = char;
    } else if (char == '(') {
      var closingBracketPos = findClosingBracket(r, i);
      var numb = sumRow(row.substring(i + 1, closingBracketPos));
      switch (op) {
        case '+':
          sum += numb;
          break;
        case '*':
          sum *= numb;
      }

      i = closingBracketPos;
    }
  }

  return sum;
}

int findClosingBracket(List<String> r, int index) {
  var stack = <String>[];
  var found = false;

  for (var i = index; i < r.length && !found; i++) {
    var char = r[i];
    switch (char) {
      case '(':
        stack.insert(0, char);
        break;
      case ')':
        stack.removeAt(0);
        if (stack.isEmpty) {
          return i;
        }
        break;
    }
  }

  return -666;
}
