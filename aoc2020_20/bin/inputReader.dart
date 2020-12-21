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
    print('PART 1: ${part1Answer}');

    var sum = part2(tiles);

    completer.complete(sum);
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

  return cornerIds.reduce((a, b) => a * b);
}

int part2(List<Tile> tiles) {
  var image = constructImage(tiles);
  var picture = Tile(666);
  picture.pixels = image;
  picture.printPixels();
  print(
      '________________________________________________________________________');
  picture.rotate(size: picture.pixels[0].length);
  markSeamonsters(picture.pixels);
  picture.printPixels();

  var oneLine = picture.pixels.join();
  var sum = '#'.allMatches(oneLine).length;
  return sum;
}

void markSeamonsters(List<String> image) {
  // image = <String>[
  //   '______________________________________________________________________',
  //   '_________________________..................#._________________________',
  //   '_________________________#....##....##....###_________________________',
  //   '_________________________.#..#..#..#..#..#..._________________________',
  //   '______________________________________________________________________'
  // ];
  // image = <String>[
  //   '..................#.',
  //   '#....##....##....###',
  //   '.#..#..#..#..#..#...'
  // ];
  var seamonster = <String>[
    '..................#.',
    '#....##....##....###',
    '.#..#..#..#..#..#...'
  ];
  for (var row = 0; row < image.length - 2; row++) {
    for (var col = 0; col < image[0].length - seamonster[0].length + 1; col++) {
      var imagePart = <String>[];
      var changedImagePart = <String>[];
      for (var i = 0; i < seamonster.length; i++) {
        imagePart
            .add(image[row + i].substring(col, col + seamonster[i].length));
        changedImagePart.add(imagePart.last);
      }

      // imagePart.forEach((element) {
      //   print(element);
      // });
      // print('_____________________________________');

      var foundSeamonster = true;
      for (var i = 0; i < seamonster.length && foundSeamonster; i++) {
        for (var j = 0; j < seamonster[i].length && foundSeamonster; j++) {
          if (seamonster[i][j] == '#') {
            if (imagePart[i][j] != '#') {
              foundSeamonster = false;
            } else {
              changedImagePart[i] =
                  changedImagePart[i].replaceFirst('#', 'O', j);
            }
          }
        }
      }

      if (foundSeamonster) {
        // changedImagePart.forEach((element) {
        //   print(element);
        // });
        // print('_____________________________________');

        for (var i = 0; i < imagePart.length; i++) {
          image[row + i] =
              image[row + i].replaceFirst(imagePart[i], changedImagePart[i]);
        }
      }
    }
  }

  // image.forEach((element) {
  //   print(element);
  // });
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
  Tile tile;

  do {
    if (tile == null) {
      tile = tiles.firstWhere((t) =>
          !t.matchedTiles.containsKey(Side.top) &&
          !t.matchedTiles.containsKey(Side.left));
    } else {
      tile = tiles.firstWhere((t) => t.id == tile.matchedTiles[Side.bottom]);
    }

    var nextTile = tile;
    var lines = <StringBuffer>[];

    do {
      if (lines.isNotEmpty) {
        nextTile =
            tiles.firstWhere((t) => t.id == nextTile.matchedTiles[Side.right]);
      }
      for (var i = 1; i < nextTile.pixels.length - 1; i++) {
        var row =
            nextTile.pixels[i].substring(1, nextTile.pixels[i].length - 1);
        if (lines.length == i - 1) {
          lines.add(StringBuffer(row));
        } else {
          lines[i - 1].write(row);
        }
      }
    } while (nextTile.matchedTiles.containsKey(Side.right));
    image.addAll(lines.map((e) => e.toString()));
  } while (tile.matchedTiles.containsKey(Side.bottom));

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

  void rotate({int size = 10}) {
    var matrix = pixels.map((e) => e.split('')).toList(growable: false);
    var retValue = List<List<String>>.generate(size, (i) => List<String>(size));
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
