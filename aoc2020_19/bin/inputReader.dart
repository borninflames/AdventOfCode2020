import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<int> readInputFile(String path) async {
  final file = File(path);
  final completer = Completer<int>();
  var inputStream = file.openRead();
  var rules = List<Rule>(200);
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
    var maxLength = 0;
    messagesToCheck.forEach((e) {
      if (e.length > maxLength) {
        maxLength = e.length;
      }
    });
    print('Max length of messages : ${maxLength}');
    var validMessages = traverse(rules, 0, 0, messagesToCheck);
    completer.complete(countValidMessages(validMessages, messagesToCheck));
  }, onError: (e) {
    print(e.toString());
  });
  return completer.future;
}

int countValidMessages(List<String> validMessages, List<String> messages) {
  print('Length : ${validMessages.length}');
  var maxLength = 0;
  validMessages.forEach((e) {
    if (e.length > maxLength) {
      maxLength = e.length;
    }
  });

  print('Max length of valid messages : ${maxLength}');

  return validMessages
      .where((vMsg) => messages.any((msg) => vMsg == msg))
      .length;
}

List<String> traverse(
    List<Rule> rules, int i, int level, List<String> messagesToCheck) {
  var rule = rules[i];
  rule.increaseUsed();
  if (rule.val.isNotEmpty) {
    return [rule.val];
  }

  var messages = <String>[];
  for (var j = 0; j < rule.rulesLength; j++) {
    var messagesToCombine = List<List<String>>(rule.rules[j].length);

    for (var k = 0; k < rule.rules[j].length; k++) {
      var r = rule.rules[j][k];
      messagesToCombine[k] = traverse(rules, r, level + 1, messagesToCheck);
    }

    var combinedMessages = <String>[];
    messagesToCombine[0].forEach((leftMessage) {
      if (messagesToCombine.length > 1) {
        messagesToCombine[1].forEach((rightMessage) {
          if (messagesToCombine.length > 2 && messagesToCombine[2] != null) {
            messagesToCombine[2].forEach((rightMessage2) {
              var msg = leftMessage + rightMessage + rightMessage2;
              if (messagesToCheck.any((mtc) => mtc.contains(msg))) {
                combinedMessages.add(msg);
              }
            });
          } else {
            var msg = leftMessage + rightMessage;
            if (messagesToCheck.any((mtc) => mtc.contains(msg))) {
              combinedMessages.add(msg);
            }
          }
        });
      } else {
        if (messagesToCheck.any((mtc) => mtc.contains(leftMessage))) {
          combinedMessages.add(leftMessage);
        }
      }
    });

    if (combinedMessages.length > 1000) {
      print('combined messages length: ${combinedMessages.length}');
    }

    messages.addAll(combinedMessages);
  }

  messages = messages.toSet().toList();
  return messages;
}

class Rule {
  int id = -1;
  String val = '';
  var rules = <List<int>>[];
  var rulesLength = 0;
  var usedTimes = 0;

  void increaseUsed() {
    usedTimes++;
    if (id == 8 || id == 11) {
      print('${id} is used');
      if (usedTimes >= 5) {
        rulesLength = 1;
        print('Disabled rule: ${id}');
      }
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
      rule.rulesLength = rule.rules.length;
    }
  }

  return rule;
}
