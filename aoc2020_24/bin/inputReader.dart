import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<int> readInputFile(String path) async {
  final file = File(path);
  final completer = Completer<int>();
  var inputStream = file.openRead();
  var floor = Floor(1001);
  var sum = 0;
  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
    sum += floor.flipHexaTile(line);
  }, onDone: () {
    print(
        'MinRow: ${floor.minRowNum} MaxRow: ${floor.maxRowNum} MinCol: ${floor.minColNum} MaxCol: ${floor.maxColNum}');
    print('The PART 1 answer is: ${sum}');
    completer.complete(floor.daysArePassing(100));
  }, onError: (e) {
    print(e.toString());
  });
  return completer.future;
}

class Floor {
  HexaTile refTile;
  int minRowNum;
  int minColNum;
  int maxRowNum;
  int maxColNum;
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

    minColNum = size;
    minRowNum = size;
    maxColNum = 0;
    maxRowNum = 0;
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

    maxRowNum = currRow > maxRowNum ? currRow : maxRowNum;
    minRowNum = currRow < minRowNum ? currRow : minRowNum;
    maxColNum = currCol > maxColNum ? currCol : maxColNum;
    minColNum = currCol < minColNum ? currCol : minColNum;

    return currentTile.colour == 1 ? 1 : -1;
  }

  int daysArePassing(int days) {
    for (var i = 1; i <= days; i++) {
      tiles = applyRules();
      print(tiles
          .expand((tr) => tr.where((t) => t != null && t.colour == 1).toList())
          .length);
    }

    var allBlackTiles = tiles
        .expand((tr) => tr.where((t) => t != null && t.colour == 1).toList());
    return allBlackTiles.length;
  }

  List<List<HexaTile>> applyRules() {
    var t = List<List<HexaTile>>(size);
    for (var row = 0; row < size; row++) {
      t[row] = List<HexaTile>(size);
      for (var col = 0; col < size; col++) {
        if (row % 2 == 0 && col % 2 == 0 || row % 2 == 1 && col % 2 == 1) {
          t[row][col] = applyRule(tiles[row][col]);
        }
      }
    }
    return t;
  }

  HexaTile applyRule(HexaTile tile) {
    var adjacent = getAdjacentHexaTiles(tile);
    var blackAdjacentCount = adjacent.where((t) => t.colour == 1).length;
    var colour = tile.colour;
    if (tile.colour == 0 && blackAdjacentCount == 2) {
      colour = 1;
    }

    if (tile.colour == 1 &&
        (blackAdjacentCount == 0 || blackAdjacentCount > 2)) {
      colour = 0;
    }

    return HexaTile(tile.row, tile.col, colour);
  }

  List<HexaTile> getAdjacentHexaTiles(HexaTile tile) {
    var row = tile.row;
    var col = tile.col;
    var adjacentTiles = <HexaTile>[];

    if (col >= 2) {
      adjacentTiles.add(tiles[row][col - 2]);
    }
    if (col < size - 2) {
      adjacentTiles.add(tiles[row][col + 2]);
    }

    if (row > 0) {
      if (col > 0) {
        adjacentTiles.add(tiles[row - 1][col - 1]);
      }
      if (col < size - 1) {
        adjacentTiles.add(tiles[row - 1][col + 1]);
      }
    }

    if (row < size - 1) {
      if (col > 0) {
        adjacentTiles.add(tiles[row + 1][col - 1]);
      }
      if (col < size - 1) {
        adjacentTiles.add(tiles[row + 1][col + 1]);
      }
    }

    return adjacentTiles;
  }
}

class HexaTile {
  int row;
  int col;
  int colour; //0: white; 1: black
  HexaTile(this.row, this.col, this.colour);
}
