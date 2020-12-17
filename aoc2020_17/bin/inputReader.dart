import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<int> readInputFile(String path) async {
  final file = File(path);
  final completer = Completer<int>();
  var inputStream = file.openRead();
  var fuck = Fuck();
  fuck.initCubes(6);
  var y = 0;

  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
    fuck.addRow(line, y);
    y++;
  }, onDone: () {
    fuck.doCircles(6);
    completer.complete(fuck.getActiveCubes());
  }, onError: (e) {
    print(e.toString());
  });
  return completer.future;
}

class Fuck {
  var cubes = <Cube>[];
  var xRange = [0, 2];
  var yRange = [0, 2];
  var zRange = [0, 0];

  void doCircles(int times) {
    for (var i = 0; i < times; i++) {
      doCircle();
      printZLayer(0);
      print('-- finished ${i + 1}. circle --');
    }
  }

  int getActiveCubes() {
    return cubes.where((c) => c.isActive).length;
  }

  void doCircle() {
    expand();
    var newStateOfCubes = <Cube>[];
    cubes.forEach((cube) {
      if (cube.x >= xRange.first &&
          cube.x <= xRange.last &&
          cube.y >= yRange.first &&
          cube.y <= yRange.last &&
          cube.z >= zRange.first &&
          cube.z <= zRange.last) {
        var nghbrs = cubes
            .where((c) =>
                c.isActive &&
                (c.x - cube.x).abs() <= 1 &&
                (c.y - cube.y).abs() <= 1 &&
                (c.z - cube.z).abs() <= 1)
            .toList(growable: false);
        var neighbors = nghbrs.length;
        var newState =
            cube.isActive ? neighbors == 3 || neighbors == 4 : neighbors == 3;

        newStateOfCubes.add(Cube(cube.x, cube.y, cube.z, newState));
      } else {
        newStateOfCubes.add(cube);
      }

      // if (cube.isActive != newState) {
      //   print(
      //       'State changed: [${cube.x}, ${cube.y}, ${cube.z}] -> ${newState ? '#' : '.'}');
      //   stdin.readLineSync();
      // }
    });

    cubes = newStateOfCubes;
  }

  void addRow(String line, int y) {
    var initData = line.split('');
    for (var x = 0; x < initData.length; x++) {
      if (initData[x] == '#') {
        var foundCubes =
            cubes.where((c) => c.x == x && c.y == y && c.z == 0).toList();
        if (foundCubes.isEmpty) {
          cubes.add(Cube(x, y, 0, true));
        } else {
          foundCubes.first.isActive = true;
        }
      }
    }
  }

  void initCubes2(int size) {
    var start = ((size / 2) * -1).round();
    for (var x = start; x < size; x++) {
      for (var y = start; y < size; y++) {
        for (var z = start; z < size; z++) {
          cubes.add(Cube(x, y, z, false));
        }
      }
    }
  }

  void expand() {
    xRange.first--;
    xRange.last++;
    yRange.first--;
    yRange.last++;
    zRange.first--;
    zRange.last++;
    //wRange.first--;
    //wRange.last++;

    print('xRange: ${xRange}');
    print('yRange: ${yRange}');
    print('zRange: ${zRange}');
    //print('wRange: ${wRange}');
  }

  void initCubes(int size) {
    //var start = ((size / 2) * -1).round();
    //print('initCubes Start: ${start}');
    for (var x = xRange.first - size; x <= xRange.last + size; x++) {
      for (var y = yRange.first - size; y <= yRange.last + size; y++) {
        for (var z = yRange.first - size; z <= zRange.last + size; z++) {
          // for (var w = start; w < size; w++) {
          //   cubes.add(Cube(x, y, z, w, false));
          // }
          cubes.add(Cube(x, y, z, false));
        }
      }
    }
  }

  void printZLayer2(int z, int size) {
    var start = ((size / 2) * -1).round();
    for (var y = start; y < size; y++) {
      var line = '';
      for (var x = start; x < size; x++) {
        try {
          line +=
              cubes.firstWhere((c) => c.x == x && c.y == y && c.z == z).isActive
                  ? '#'
                  : '.';
        } catch (e) {
          print(e);
          print('No element at: x: ${x}, y: ${y}, z: ${z}');
        }
      }
      print(line);
    }
  }

  void printZLayer(int z) {
    for (var y = yRange.first; y <= yRange.last; y++) {
      var line = '';
      for (var x = xRange.first; x <= xRange.last; x++) {
        //try {
        line +=
            cubes.firstWhere((c) => c.x == x && c.y == y && c.z == z).isActive
                ? '#'
                : '.';
        //} catch (e) {
        //print(e);
        //print('No element at: x: ${x}, y: ${y}, z: ${z}');
        //}
      }
      print(line);
    }
  }
}

class Cube {
  int x;
  int y;
  int z;
  bool isActive;

  Cube(this.x, this.y, this.z, this.isActive);
}
