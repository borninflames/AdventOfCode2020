import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<int> readInputFile(String path) async {
  final file = File(path);
  final completer = Completer<int>();
  var inputStream = file.openRead();
  var seaportComputer = SeaportComputer();
  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
    seaportComputer.parseInstruction(line);
  }, onDone: () {
    completer.complete(seaportComputer.sumMemory());
  }, onError: (e) {
    print(e.toString());
  });
  return completer.future;
}

class SeaportComputer {
  String mask;
  Map<int, int> mem = <int, int>{};

  void parseInstruction(String instruction) {
    var instrParts = instruction.split(' = ');
    if (instrParts[0] == 'mask') {
      mask = instruction.split(' = ')[1];
    } else {
      var regex = RegExp(r'\[(\d+)\]');
      var match = regex.firstMatch(instrParts[0]);
      if (match != null) {
        var value = getMaskedValue(instrParts[1]);
        mem[int.parse(match.group(1))] = value;
      }
    }
  }

  int sumMemory() {
    var sum = 0;
    mem.forEach((key, value) {
      sum += value;
    });
    return sum;
  }

  int getMaskedValue(String val) {
    var value = int.parse(val);
    print('Value: ${value}');
    var binary = value.toRadixString(2);
    binary = binary.padLeft(36, '0');
    print('Binary: ${binary}');

    var maskedBinary = '';
    for (var i = 0; i < mask.length; i++) {
      if (mask[i] != 'X') {
        maskedBinary += mask[i];
      } else {
        maskedBinary += binary[i];
      }
    }

    value = int.parse(maskedBinary, radix: 2);
    print('Value again: ${value}');
    return value;
  }
}
