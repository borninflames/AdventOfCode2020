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
      validIdsCount += isValidIDv2(currentId) ? 1 : 0;
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

bool isValidIDv2(Map<String, String> id) {
  return hasProp(id, 'byr') &&
      int.parse(id['byr']) >= 1920 &&
      int.parse(id['byr']) <= 2002 &&
      hasProp(id, 'iyr') &&
      int.parse(id['iyr']) >= 2010 &&
      int.parse(id['iyr']) <= 2020 &&
      hasProp(id, 'eyr') &&
      int.parse(id['eyr']) >= 2020 &&
      int.parse(id['eyr']) <= 2030 &&
      hasProp(id, 'hgt') &&
      isValidHeight(id['hgt']) &&
      hasProp(id, 'hcl') &&
      RegExp(r'^#[0-9a-f]{6}$').hasMatch(id['hcl']) &&
      hasProp(id, 'ecl') &&
      RegExp(r'^(amb|blu|brn|gry|grn|hzl|oth)$').hasMatch(id['ecl']) &&
      hasProp(id, 'pid') &&
      RegExp(r'^[0-9]{9}$').hasMatch(id['pid']);
}

bool hasProp(Map<String, String> id, String key) {
  return id.containsKey(key) && id[key].isNotEmpty;
}

bool isValidHeight(String height) {
  var hStr = height.substring(0, height.length - 2);
  var h = int.tryParse(hStr);
  if (h == null) {
    return false;
  }

  if (height.endsWith('in')) {
    return h >= 59 && h <= 76;
  }
  if (height.endsWith('cm')) {
    return h >= 150 && h <= 193;
  }

  return false;
}
