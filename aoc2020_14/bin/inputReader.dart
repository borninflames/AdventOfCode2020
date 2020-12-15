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
    } else {
      mem = addInstruction(instrParts);
      print(mem.length);
    }
  }

  Map<String, int> addInstruction(List<String> instrParts) {
    var memResult = <String, int>{};
    var regex = RegExp(r'\[(\d+)\]');
    var match = regex.firstMatch(instrParts[0]);
    if (match != null) {
      var value = int.parse(instrParts[1]);
      var nextAddr = getMaskedAddress(match.group(1));

      var memAddresses = mem.keys.toList();
      memAddresses.forEach((addr) {
        if (addr == nextAddr) {
          memResult[nextAddr] = value;
        } else if (!areDistinct(addr, nextAddr)) {
          var address = addr.split('');
          var changed = false;

          //separate addresses if necessary
          for (var i = 0; i < addr.length; i++) {
            if (addr[i] == nextAddr[i] ||
                addr[i] != 'X' && nextAddr[i] == 'X') {
              continue;
            }
            changed = true;

            var newAddr = List<String>.from(address);
            newAddr[i] = nextAddr[i] == '1' ? '0' : '1';
            address[i] = nextAddr[i] == '0' ? '0' : '1';

            //add value to an adress variant
            if (hasX(newAddr.join(), nextAddr)) {
              memResult[newAddr.join()] = mem[addr];
            }
          }
          if (!changed && hasX(addr, nextAddr)) {
            memResult[addr] = mem[addr];
          }
        } else {
          memResult[addr] = mem[addr];
        }
      });
      memResult[nextAddr] = value;
    }

    return memResult;
  }

  bool hasX(String shrinkedAddr, String nextAddr) {
    for (var i = 0; i < nextAddr.length; i++) {
      if (shrinkedAddr[i] != nextAddr[i] && nextAddr[i] != 'X') {
        return true;
      }
    }
    return false;
  }

  bool areDistinct(String addr, String nextAddr) {
    for (var i = 0; i < addr.length; i++) {
      if (addr[i] == '1' && nextAddr[i] == '0' ||
          addr[i] == '0' && nextAddr[i] == '1') {
        return true;
      }
    }

    return false;
  }

  int sumMemory2() {
    var sum = 0;
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
}
