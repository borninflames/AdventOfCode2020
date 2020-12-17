import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<int> readInputFile(String path) async {
  final file = File(path);
  final completer = Completer<int>();
  var inputStream = file.openRead();
  var shit = Shit();
  var section = 0;

  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
    //print(line);
    if (line == '') {
      section++;
    } else {
      switch (section) {
        case 0:
          shit.addRule(line);
          break;
        case 1:
          shit.addMyTicket(line);
          break;

        case 2:
          shit.addTicket(line);
      }
    }
  }, onDone: () {
    print('Part 1 answer is: ${shit.part1()}');
    completer.complete(shit.part2());
  }, onError: (e) {
    print(e.toString());
  });
  return completer.future;
}

class Shit {
  var rules = <List<int>>[];
  var myTicket = <int>[];
  var tickets = <List<int>>[];

  int part2() {
    tickets = getValidTickets();
    print('Valid tickets: ${tickets.length}');

    var ruleOrder = <int, List<int>>{};

    for (var r = 0; r < rules.length; r++) {
      for (var ti = 0; ti < tickets[0].length; ti++) {
        var col = tickets.map((t) => t[ti]).toList(growable: false);

        if (col.every((n) => rules[r].any((rn) => rn == n))) {
          if (ruleOrder[r] == null) {
            ruleOrder[r] = <int>[];
          }
          ruleOrder[r].add(ti);
        }
      }
    }

    ruleOrder.forEach((key, value) {
      print('Rule[${key}] appliable on these columns ${value}');
    });

    print('----');

    while (ruleOrder.entries.any((e) => e.value.length != 1)) {
      ruleOrder.forEach((key, value) {
        if (ruleOrder[key].length == 1) {
          ruleOrder.entries.forEach((e) {
            if (e.key != key) {
              e.value.remove(ruleOrder[key].first);
            }
          });
        }
      });
    }

    ruleOrder.forEach((key, value) {
      print('Rule[${key}] appliable on these columns ${value}');
    });

    var sum = 1;
    for (var i = 0; i < 6; i++) {
      sum *= myTicket[ruleOrder[i].first];
    }
    return sum;
  }

  int part1() {
    var allRules = rules.expand((element) => element).toList();
    var allTickets = tickets.expand((element) => element).toList();
    var sumOfInvalidNumbers = 0;
    allTickets.forEach((tn) {
      if (allRules.every((rn) => rn != tn)) {
        sumOfInvalidNumbers += tn;
      }
    });
    return sumOfInvalidNumbers;
  }

  bool isValid(List<int> ticket) {
    var allRules = rules.expand((element) => element).toList();
    return !ticket.any((tn) => allRules.every((rn) => rn != tn));
  }

  List<List<int>> getValidTickets() {
    return tickets.where((ticket) => isValid(ticket)).toList();
  }

  void addRule(String line) {
    var ruleParts = line.split(': ');
    var ranges = ruleParts[1].split(' or ');
    var minMax = ranges[0].split('-').map((i) => int.parse(i)).toList();
    rules.add(
        List<int>.generate(minMax[1] - minMax[0] + 1, (i) => i + minMax[0]));
    minMax = ranges[1].split('-').map((i) => int.parse(i)).toList();
    rules.last.addAll(
        List<int>.generate(minMax[1] - minMax[0] + 1, (i) => i + minMax[0]));
  }

  void addMyTicket(String line) {
    myTicket = line.split(',').map((t) => int.parse(t)).toList();
  }

  List<int> addTicket(String line) {
    tickets.add(line.split(',').map((t) => int.parse(t)).toList());
    return tickets.last;
  }
}
