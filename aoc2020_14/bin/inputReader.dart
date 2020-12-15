import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'dart:math';

Future<int> readInputFile(String path) async {
  final file = File(path);
  final completer = Completer<int>();
  var inputStream = file.openRead();
  var seaportComputer = SeaportComputer();
  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
    seaportComputer.parseInstruction(line);
  }, onDone: () {
    completer.complete(seaportComputer.sumMemory2());
  }, onError: (e) {
    print(e.toString());
  });
  return completer.future;
}

class SeaportComputer {
  String mask;
  Map<String, int> mem = <String, int>{};

  void parseInstruction(String instruction) {
    var instrParts = instruction.split(' = ');
    if (instrParts[0] == 'mask') {
      mask = instruction.split(' = ')[1];
      print(
          'New mask---------------------------------------------------------------------------');
    } else {
      var regex = RegExp(r'\[(\d+)\]');
      var match = regex.firstMatch(instrParts[0]);
      if (match != null) {
        var value = int.parse(instrParts[1]);
        var nextAddr = getMaskedAddress(match.group(1));
        print('Raw address:    ${match.group(1)}');
        print('Masked address: ${nextAddr}');

        var memAddresses = mem.keys.toList();
        //végigmegyek a már meglévő memória címeken
        memAddresses.forEach((addr) {
          //distinct
          if (!areDistinct(addr, nextAddr)) {
            print('Are they equal: ${addr == nextAddr}');
            //csökkentjük az eredeti halmazt, az újat is, hogy distinctek legyenek
            if (addr != nextAddr) {
              var shrinkedAddr = separate(addr, nextAddr);
              mem[shrinkedAddr] = mem[addr];
              mem.remove(addr);
            }
          }
        });

        mem[nextAddr] = value;
        print(
            '--------------------------------------------------------------------------------------------');
      }
    }
  }

  String separate(String addr, String nextAddr) {
    var shrinkedAddr = '';
    for (var i = 0; i < addr.length; i++) {
      if (addr[i] == nextAddr[i]) {
        shrinkedAddr += addr[i];
      } else if (addr[i] == 'X' && nextAddr[i] != 'X') {
        shrinkedAddr += nextAddr[i] == '1' ? '0' : '1';
      } else if (addr[i] != 'X' && nextAddr[i] == 'X') {
        shrinkedAddr += addr[i];
      }
    }

    print('${addr} was shrinked to be distinct from: ${nextAddr}');
    print('${shrinkedAddr}');
    return shrinkedAddr;
  }

  bool isLargerSet(String addr, String nextAddr) {
    if (addr == nextAddr) {
      return true;
    }
    var chars = addr.split('');
    var retVal = true;
    for (var i = 0; i < chars.length && retVal; i++) {
      if (chars[i] == 'X' && nextAddr[i] != 'X') {
        retVal = false;
        print('isLargerSet: ${retVal} [${i}]');
      }
    }

    return retVal;
  }

  bool areDistinct(String addr, String nextAddr) {
    var retVal = false;
    for (var i = 0; i < addr.length && !retVal; i++) {
      retVal = addr[i] == '1' && nextAddr[i] == '0' ||
          addr[i] == '0' && nextAddr[i] == '1';
    }
    if (!retVal) {
      print('Not distinct: ${addr}');
      print('With this:    ${nextAddr}');
    }

    return retVal;
  }

  int sumMemory() {
    var sum = 0;
    mem.forEach((key, value) {
      sum += value;
    });
    return sum;
  }

  int sumMemory2() {
    var sum = 0;
    print('There are ${mem.length} values');
    mem.forEach((key, value) {
      var exponent = 'X'.allMatches(key).length;
      var a = pow(2, exponent);
      sum += (value * a);
    });
    return sum;
  }

  String getMaskedAddress(String addr) {
    var addrNum = int.parse(addr);
    var binary = addrNum.toRadixString(2);
    binary = binary.padLeft(36, '0');

    var maskedBinary = '';
    for (var i = 0; i < mask.length; i++) {
      switch (mask[i]) {
        case '0':
          maskedBinary += binary[i];
          break;
        case '1':
          maskedBinary += '1';
          break;
        case 'X':
          maskedBinary += 'X';
          break;
        default:
      }
    }
    return maskedBinary;
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
