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
    print(line);
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
    completer.complete(shit.part1());
  }, onError: (e) {
    print(e.toString());
  });
  return completer.future;
}

class Shit {
  var rules = <List<int>>[];
  var myTicket = <int>[];
  var tickets = <List<int>>[];

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

  // int getInvalidNumbersSum(List<int> ticket) {
  //   var allRules = rules.expand((element) => element).toList();
  //   var sumOfInvalidNumbers = 0;
  //   ticket.forEach((n) {
  //     if (allRules.every((rn) => rn != n)) {}
  //   });
  // }

  void addRule(String line) {
    var ruleParts = line.split(': ');
    var ranges = ruleParts[1].split(' or ');
    var minMax = ranges[0].split('-').map((i) => int.parse(i)).toList();
    rules.add(List<int>.generate(minMax[1] - minMax[0], (i) => i + minMax[0]));
    minMax = ranges[1].split('-').map((i) => int.parse(i)).toList();
    rules.last.addAll(
        List<int>.generate(minMax[1] - minMax[0], (i) => i + minMax[0]));
  }

  void addMyTicket(String line) {
    myTicket = line.split(',').map((t) => int.parse(t)).toList();
  }

  List<int> addTicket(String line) {
    tickets.add(line.split(',').map((t) => int.parse(t)).toList());
    return tickets.last;
  }
}
