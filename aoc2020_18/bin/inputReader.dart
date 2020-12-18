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
    sum += sumRow2(line);
  }, onDone: () {
    completer.complete(sum);
  }, onError: (e) {
    print(e.toString());
  });
  return completer.future;
}

var digitExp = RegExp(r'\d');

int sumRow(String row) {
  row = row.replaceAll(' ', '');
  var r = row.split('');
  var sum = 0;
  var op = '+';
  for (var i = 0; i < r.length; i++) {
    var char = r[i];
    if (digitExp.hasMatch(char)) {
      var numb = int.parse(char);
      sum = doMathStuff1(sum, op, numb);
    } else if (char == '+' || char == '*') {
      op = char;
    } else if (char == '(') {
      var closingBracketPos = findClosingBracket(r, i);
      var numb = sumRow(row.substring(i + 1, closingBracketPos));
      sum = doMathStuff1(sum, op, numb);
      i = closingBracketPos;
    }
  }

  return sum;
}

int doMathStuff1(int sum, String op, int numb) {
  switch (op) {
    case '+':
      sum += numb;
      break;
    case '*':
      sum *= numb;
  }
  return sum;
}

int sumRow2(String row) {
  row = row.replaceAll(' ', '');
  var r = row.split('');
  var sum = 0;
  var op = '+';
  var temp = <int>[];
  for (var i = 0; i < r.length; i++) {
    var char = r[i];
    if (digitExp.hasMatch(char)) {
      var numb = int.parse(char);
      sum = doMathStuff2(sum, op, numb, temp);
    } else if (char == '+' || char == '*') {
      op = char;
    } else if (char == '(') {
      var closingBracketPos = findClosingBracket(r, i);
      var numb = sumRow2(row.substring(i + 1, closingBracketPos));
      sum = doMathStuff2(sum, op, numb, temp);
      i = closingBracketPos;
    }
  }

  if (temp.isNotEmpty) {
    sum *= temp.first;
  }

  return sum;
}

int doMathStuff2(int sum, String op, int numb, List<int> temp) {
  switch (op) {
    case '+':
      if (temp.isNotEmpty) {
        temp.first += numb;
      } else {
        sum += numb;
      }
      break;
    case '*':
      if (temp.isNotEmpty) {
        sum *= temp.first;
        temp.removeAt(0);
      }
      temp.insert(0, numb);
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
    }
  }

  return -666;
}
