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
    tiles.add(currentTile);
    var part1Answer = part1(tiles);
    var image = constructImage(tiles);

    image.forEach((row) {
      print(row);
    });
    completer.complete(part1Answer);
  }, onError: (e) {
    print(e.toString());
  });
  return completer.future;
}

int part1(List<Tile> tiles) {
  findMatchingTiles(tiles, tiles[0]);

  var cornerIds = tiles
      .where((t) => t.matchedTiles.length == 2)
      .map((t) => t.id)
      .toList(growable: false);

  //print(cornerIds);

  //tiles.forEach((t) => print(t));

  return cornerIds.reduce((a, b) => a * b);
}

int part2(List<Tile> tiles) {
  constructImage(tiles);
  return -666;
}

void findMatchingTiles(List<Tile> tiles, Tile tile) {
  if (tile.matchedTiles.length == 4) {
    return;
  }
  var sides = Side.values
      .where((side) => !tile.matchedTiles.containsKey(side))
      .toList(growable: false);
  for (var i = 0; i < sides.length; i++) {
    var found = false;
    for (var j = 0; j < tiles.length && !found; j++) {
      var otherTile = tiles[j];
      if (otherTile.matchedTiles.isEmpty) {
        found = tile.match(otherTile, sides[i]); //forgat
      } else {
        found = tile.hasMatch(otherTile, sides[i]); //forgatás nélkül
      }
      if (found) {
        findMatchingTiles(tiles, otherTile);
      }
    }
  }
}

List<String> constructImage(List<Tile> tiles) {
  var image = <String>[];
  var tile = tiles.firstWhere((t) =>
      !t.matchedTiles.containsKey(Side.top) &&
      !t.matchedTiles.containsKey(Side.left));

  while (tile.matchedTiles.containsKey(Side.bottom)) {
    var nextTile = tile;
    var lines = <StringBuffer>[];
    while (nextTile.matchedTiles.containsKey(Side.right)) {
      var startI = 0;
      var endI = nextTile.pixels.length;
      var startChar = 0;
      var endChar = nextTile.pixels[0].length;
      if (nextTile.matchedTiles.containsKey(Side.top)) {
        startI = 1;
      }
      if (nextTile.matchedTiles.containsKey(Side.bottom)) {
        endI--;
      }

      if (nextTile.matchedTiles.containsKey(Side.left)) {
        startChar = 1;
      }
      if (nextTile.matchedTiles.containsKey(Side.right)) {
        endChar--;
      }
      for (var i = startI; i < endI; i++) {
        var row = nextTile.pixels[i].substring(startChar, endChar);
        if (lines.length == i - startI) {
          lines.add(StringBuffer(row));
        } else {
          lines[i - startI].write(row);
        }
      }

      nextTile =
          tiles.firstWhere((t) => t.id == nextTile.matchedTiles[Side.right]);
    }

    image.addAll(lines.map((e) => e.toString()));

    tile = tiles.firstWhere((t) => t.id == tile.matchedTiles[Side.bottom]);
  }

  return image;
}

class Tile {
  int id;
  var pixels = <String>[];
  Tile(this.id);
  var matchedTiles = <Side, int>{};

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

  bool match(Tile otherTile, Side side) {
    if (hasMatch(otherTile, side)) {
      return true;
    }

    for (var i = 0; i < 3; i++) {
      otherTile.rotate();
      if (hasMatch(otherTile, side)) {
        return true;
      }
    }

    otherTile.flip();

    if (hasMatch(otherTile, side)) {
      return true;
    }

    for (var i = 0; i < 3; i++) {
      otherTile.rotate();
      if (hasMatch(otherTile, side)) {
        return true;
      }
    }
    return false;
  }

  bool hasMatch(Tile otherTile, Side side) {
    var hasMatch = false;
    Side otherSide;
    switch (side) {
      case Side.top:
        hasMatch = pixels.first == otherTile.pixels.last;
        otherSide = Side.bottom;
        break;
      case Side.bottom:
        hasMatch = pixels.last == otherTile.pixels.first;
        otherSide = Side.top;
        break;
      case Side.left:
        hasMatch = hasMatchLeft(otherTile);
        otherSide = Side.right;
        break;
      case Side.right:
        hasMatch = hasMatchRight(otherTile);
        otherSide = Side.left;
    }
    if (hasMatch) {
      matchedTiles[side] = otherTile.id;
      otherTile.matchedTiles[otherSide] = id;
    }

    return hasMatch;
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
    return '${id}: ${matchedTiles}';
  }
}

enum Side { top, right, bottom, left }
