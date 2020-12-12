import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<Ferry> readInputFile(String path) async {
  final file = File(path);
  final completer = Completer<Ferry>();
  var inputStream = file.openRead();
  var ferry = Ferry();
  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
    ferry.action(line);
  }, onDone: () {
    print('Ferry position: [${ferry.x}, ${ferry.y}]');
    completer.complete(ferry);
  }, onError: (e) {
    print(e.toString());
  });
  return completer.future;
}

class Ferry {
  var x = 0;
  var y = 0;
  var dir = 0; //degrees

  void action(String line) {
    var action = line[0];
    var value = int.parse(line.substring(1));
    var direction = toDir(action);
    switch (action) {
      case 'N':
      case 'S':
      case 'E':
      case 'W':
        move(direction, value);
        break;
      case 'L':
      case 'R':
        turn(action, value);
        break;
      case 'F':
        move(dir, value);
    }
  }

  void turn(String action, int value) {
    switch (action) {
      case 'L':
        dir = (dir - value) % 360;
        //print('L -> New dir: ${dir}');
        break;
      case 'R':
        dir = (dir + value) % 360;
        //print('R -> New dir: ${dir}');
        break;
      default:
        throw Exception('Wrong action was given for turn method.');
    }
  }

  void move(int dir, int value) {
    switch (dir) {
      case 270:
        y += value;
        break;
      case 90:
        y -= value;
        break;
      case 0:
        x += value;
        break;
      case 180:
        x -= value;
        break;
      default:
        throw Exception('Wrong action was given for move method. ${dir}');
    }
  }

  int toDir(String act) {
    switch (act) {
      case 'N':
        return 270;
      case 'S':
        return 90;
        break;
      case 'E':
        return 0;
        break;
      case 'W':
        return 180;
      default:
        return -1;
    }
  }
}
