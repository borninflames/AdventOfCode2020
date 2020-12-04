import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<int> readInputFile(String path) async {
  final file = File(path);
  var validIdsCount = 0;
  var currentId = <String, String>{};
  final completer = Completer<int>();
  var inputStream = file.openRead();
  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
    if (line.isNotEmpty) {
      var props = line.split(' ');
      for (var prop in props) {
        var keyValue = prop.split(':');
        currentId[keyValue[0]] = keyValue[1];
      }
    } else {
      print('${currentId}');
      validIdsCount += isValidID(currentId) ? 1 : 0;
      currentId = {};
    }
  }, onDone: () {
    completer.complete(validIdsCount);
  }, onError: (e) {
    print(e.toString());
  });

  return completer.future;
}

bool isValidID(Map<String, String> id) {
  return id.containsKey('byr') &&
      id['byr'].isNotEmpty &&
      id.containsKey('iyr') &&
      id['iyr'].isNotEmpty &&
      id.containsKey('eyr') &&
      id['eyr'].isNotEmpty &&
      id.containsKey('hgt') &&
      id['hgt'].isNotEmpty &&
      id.containsKey('hcl') &&
      id['hcl'].isNotEmpty &&
      id.containsKey('ecl') &&
      id['ecl'].isNotEmpty &&
      id.containsKey('pid') &&
      id['pid'].isNotEmpty;
}

class IdentityCard {
  String byr; // (Birth Year)
  String iyr; // (Issue Year)
  String eyr; // (Expiration Year)
  String hgt; // (Height)
  String hcl; // (Hair Color)
  String ecl; // (Eye Color)
  String pid; // (Passport ID)
  String cid; // (Country ID)
}
