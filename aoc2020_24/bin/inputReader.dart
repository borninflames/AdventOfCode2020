import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<int> readInputFile(String path) async {
  final file = File(path);
  final completer = Completer<int>();
  var inputStream = file.openRead();
  var floor = Floor(101);
  var sum = 0;
  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
    sum += floor.flipHexaTile(line);
  }, onDone: () {
    completer.complete(sum);
  }, onError: (e) {
    print(e.toString());
  });
  return completer.future;
}

class Floor {
  HexaTile refTile;
  var size = 0;
  List<List<HexaTile>> tiles;

  Floor(this.size) {
    tiles = List<List<HexaTile>>(size);
    for (var row = 0; row < size; row++) {
      tiles[row] = List<HexaTile>(size);
      for (var col = 0; col < size; col++) {
        if (row % 2 == 0 && col % 2 == 0 || row % 2 == 1 && col % 2 == 1) {
          tiles[row][col] = HexaTile(row, col, 0);
        }
      }
    }

    var refPoz = (size / 2).round();
    refTile = tiles[refPoz][refPoz];
  }

  int flipHexaTile(String line) {
    var l = line.split('');
    var dir = '';
    var currRow = refTile.row;
    var currCol = refTile.col;

    //e, se, sw, w, nw, ne
    for (var i = 0; i < l.length; i++) {
      if (dir.isEmpty) {
        switch (l[i]) {
          case 'e':
            currCol += 2;
            break;
          case 'w':
            currCol -= 2;
            break;
          default:
            dir = l[i];
        }
      } else {
        dir += l[i];
        switch (dir) {
          case 'se':
            currCol++;
            currRow++;
            break;
          case 'sw':
            currCol--;
            currRow++;
            break;
          case 'ne':
            currCol++;
            currRow--;
            break;
          case 'nw':
            currCol--;
            currRow--;
            break;
          default:
            print('HOUSTON BAJ VAN!!!');
        }
        dir = '';
      }
    }

    var currentTile = tiles[currRow][currCol];
    currentTile.colour = currentTile.colour == 0 ? 1 : 0;

    return currentTile.colour == 1 ? 1 : -1;
  }
}

class HexaTile {
  int row;
  int col;
  int colour; //0: white; 1: black
  HexaTile(this.row, this.col, this.colour);
}
