import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<int> readInputFile(String path) async {
  final file = File(path);
  final completer = Completer<int>();
  var inputStream = file.openRead();
  var tiles = <Tile>[];
  Tile currentTile;

  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
    if (line.isEmpty) {
      tiles.add(currentTile);
      currentTile = null;
    }
    if (line.startsWith('Tile')) {
      var parts = line.split(' ');
      currentTile = Tile(int.parse(parts[1].substring(0, parts[1].length - 1)));
    } else if (currentTile != null) {
      currentTile.pixels.add(line);
    }
  }, onDone: () {
    completer.complete(part1(tiles));
  }, onError: (e) {
    print(e.toString());
  });
  return completer.future;
}

int part1(List<Tile> tiles) {
  tiles.forEach((tile) {
    tiles
        .where((otherTile) =>
            otherTile.id != tile.id &&
            //!tile.areMatched(otherTile)
            otherTile.matchingTiles.isEmpty)
        .forEach((otherTile) {
      var sides = Side.values;
      for (var i = 0; i < sides.length; i++) {
        if (tile.match(otherTile, sides[i])) {
          print(
              'It\'s a MATCH on the ${sides[i]}: ${tile.id} <3 ${otherTile.id}');
          print(tile);
          print(otherTile);
          print('---------------------------------');
          break;
        }
      }
    });
  });

  var cornerIds = tiles
      .where((t) => t.matchingTiles.length == 2)
      .map((t) => t.id)
      .toList(growable: false);

  print(cornerIds);

  tiles
      // .where((t) => t.matchingTiles.length == 2)
      .forEach((t) => print(t));

  return cornerIds.reduce((a, b) => a * b);
}

class Tile {
  int id;
  var pixels = <String>[];
  Tile(this.id);
  var matchingTiles = <Side, int>{};

  void flip() {
    pixels = pixels.reversed.toList(growable: false);
  }

  void rotate() {
    var size = 10;
    var matrix = pixels.map((e) => e.split('')).toList(growable: false);
    var retValue = List<List<String>>.generate(10, (i) => List<String>(10));
    for (var row = 0; row < size; row++) {
      for (var index = 0; index < size; index++) {
        retValue[row][index] = matrix[size - index - 1][row];
      }
    }

    pixels = retValue.map((e) => e.join()).toList(growable: false);
  }

  void flipVertically() {
    pixels = pixels.reversed.toList(growable: false);
  }

  void flipHorizontally() {
    pixels = pixels
        .map((row) => row.split('').reversed.join())
        .toList(growable: false);
  }

  bool areMatched(Tile otherTile) {
    return matchingTiles.containsValue(otherTile.id);
  }

  bool match(Tile otherTile, Side side) {
    if (hasMatch(otherTile, side)) {
      return true;
    }
    otherTile.rotate();
    if (hasMatch(otherTile, side)) {
      return true;
    }
    otherTile.rotate();
    if (hasMatch(otherTile, side)) {
      return true;
    }
    otherTile.rotate();
    if (hasMatch(otherTile, side)) {
      return true;
    }

    otherTile.flip();
    if (hasMatch(otherTile, side)) {
      return true;
    }
    otherTile.rotate();
    if (hasMatch(otherTile, side)) {
      return true;
    }
    otherTile.rotate();

    if (hasMatch(otherTile, side)) {
      return true;
    }
    otherTile.rotate();
    if (hasMatch(otherTile, side)) {
      return true;
    }

    return false;
  }

  bool hasMatch(Tile otherTile, Side side) {
    switch (side) {
      case Side.top:
        if (pixels.first == otherTile.pixels.last) {
          matchingTiles[Side.top] = otherTile.id;
          otherTile.matchingTiles[Side.bottom] = id;
          return true;
        }
        break;
      case Side.bottom:
        if (pixels.last == otherTile.pixels.first) {
          matchingTiles[Side.bottom] = otherTile.id;
          otherTile.matchingTiles[Side.top] = id;
          return true;
        }
        break;
      case Side.left:
        if (hasMatchLeft(otherTile)) {
          matchingTiles[Side.left] = otherTile.id;
          otherTile.matchingTiles[Side.right] = id;
          return true;
        }
        break;
      case Side.right:
        if (hasMatchRight(otherTile)) {
          matchingTiles[Side.right] = otherTile.id;
          otherTile.matchingTiles[Side.left] = id;
          return true;
        }
    }
    return false;
  }

  bool hasMatchLeft(Tile otherTile) {
    for (var i = 0; i < pixels.length; i++) {
      if (pixels[i][0] != otherTile.pixels[i][9]) {
        return false;
      }
    }

    return true;
  }

  bool hasMatchRight(Tile otherTile) {
    for (var i = 0; i < pixels.length; i++) {
      if (pixels[i][9] != otherTile.pixels[i][0]) {
        return false;
      }
    }

    return true;
  }

  void printPixels() {
    pixels.forEach((element) {
      print(element);
    });
    print('                                ');
  }

  @override
  String toString() {
    return '${id}: ${matchingTiles}';
  }
}

enum Side { top, right, bottom, left }
