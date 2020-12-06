import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<int> readInputFile(String path) async {
  final file = File(path);
  var maxSeatId = 0;
  var lines = <String>[];
  final completer = Completer<int>();
  var inputStream = file.openRead();
  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
    lines.add(line);
    var seatId = calcSeatId(line);
    maxSeatId = maxSeatId < seatId ? seatId : maxSeatId;
  }, onDone: () {
    searchFreeSeats(lines);
    completer.complete(maxSeatId);
  }, onError: (e) {
    print(e.toString());
  });

  return completer.future;
}

int calcSeatId(String line) {
  line = line.replaceAll('F', '0');
  line = line.replaceAll('B', '1');
  line = line.replaceAll('L', '0');
  line = line.replaceAll('R', '1');
  var colStr = line.substring(line.length - 3);
  var rowStr = line.substring(0, line.length - 3);

  return int.parse(rowStr, radix: 2) * 8 + int.parse(colStr, radix: 2);
}

void searchFreeSeats(List<String> lines) {
  for (var row = 0; row < 111; row++) {
    for (var col = 0; col < 8; col++) {
      var line = row
              .toRadixString(2)
              .padLeft(7, '0')
              .replaceAll('0', 'F')
              .replaceAll('1', 'B') +
          col
              .toRadixString(2)
              .padLeft(3, '0')
              .replaceAll('0', 'L')
              .replaceAll('1', 'R');
      if (!lines.any((l) => l == line)) {
        print('Row: ${row}, Col: ${col} - ${line} - ${row * 8 + col}');
      }
    }
  }
}
