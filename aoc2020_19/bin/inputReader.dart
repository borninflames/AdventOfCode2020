import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<int> readInputFile(String path) async {
  final file = File(path);
  final completer = Completer<int>();
  var inputStream = file.openRead();
  var rules = List<Rule>(133);
  var section = 1;
  var messagesToCheck = <String>[];

  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
    if (line.isEmpty) {
      section++;
    } else {
      if (section == 1) {
        var rule = parseLine(line);
        rules[rule.id] = rule;
      } else {
        messagesToCheck.add(line);
      }
    }
  }, onDone: () {
    var validMessages = traverse(rules, 0, 0);
    //print(validMessages);
    completer.complete(countValidMessages(validMessages, messagesToCheck));
  }, onError: (e) {
    print(e.toString());
  });
  return completer.future;
}

int countValidMessages(List<String> validMessages, List<String> messages) {
  print('Length : ${validMessages.length}');

  return validMessages
      .where((vMsg) => messages.any((msg) => vMsg == msg))
      .length;
}

List<String> traverse(List<Rule> rules, int i, int level) {
  var rule = rules[i];
  rule.increaseUsed();
  if (rule.val.isNotEmpty) {
    return [rule.val];
  }

  var messages = <String>[];
  for (var j = 0; j < rule.rules.length; j++) {
    if ((rule.id == 8 || rule.id == 11) && rule.isDisabled && j == 1) {
      break;
    }
    var messagesToCombine = List<List<String>>(rule.rules[j].length);

    for (var k = 0; j < rule.rules.length && k < rule.rules[j].length; k++) {
      var r = rule.rules[j][k];
      messagesToCombine[k] = traverse(rules, r, level + 1);
      if ((rule.id == 8 || rule.id == 11) &&
          rule.isDisabled &&
          rule.rules.length > 1) {
        rule.rules.removeLast();
      }
    }

    var combinedMessages = <String>[];
    messagesToCombine[0].forEach((leftMessage) {
      if (messagesToCombine.length > 1) {
        messagesToCombine[1].forEach((rightMessage) {
          if (messagesToCombine.length > 2 && messagesToCombine[2] != null) {
            messagesToCombine[2].forEach((rightMessage2) {
              combinedMessages.add(leftMessage + rightMessage + rightMessage2);
            });
          } else {
            combinedMessages.add(leftMessage + rightMessage);
          }
        });
      } else {
        combinedMessages.add(leftMessage);
      }
    });

    messages.addAll(combinedMessages);
  }

  return messages;
}

class Rule {
  int id = -1;
  String val = '';
  var rules = <List<int>>[];
  var isDisabled = false;
  var usedTimes = 0;

  void increaseUsed() {
    usedTimes++;
    if ((id == 8 || id == 11) && usedTimes >= 2) {
      isDisabled = true;
      print('Disabled rule: ${id}');
    }
    if (usedTimes > 10000) {
      print('Rule ${id} has been used ${usedTimes} times...');
    }
  }

  Rule(this.id);

  @override
  String toString() {
    if (val.isNotEmpty) {
      return '[${id}: "${val}"]';
    } else {
      return '[${id}: ${rules}]';
    }
  }
}

Rule parseLine(String line) {
  var lineParts = line.split(': ');
  var rule = Rule(int.parse(lineParts[0]));

  if (line.contains('"')) {
    var valParts = lineParts[1].split('"');
    if (valParts.isNotEmpty) {
      rule.val = valParts[1];
    }
  } else {
    var ruleParts = lineParts[1].split(' | ');
    for (var i = 0; i < ruleParts.length; i++) {
      rule.rules.add(ruleParts[i].split(' ').map((r) => int.parse(r)).toList());
    }
  }

  return rule;
}
