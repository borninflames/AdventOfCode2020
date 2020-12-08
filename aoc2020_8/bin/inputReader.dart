import 'dart:async';
import 'dart:io';
import 'dart:convert';

Future<List<Instruction>> readInputFile(String path) async {
  final file = File(path);
  final completer = Completer<List<Instruction>>();
  var program = <Instruction>[];
  var inputStream = file.openRead();
  inputStream.transform(utf8.decoder).transform(LineSplitter()).listen(
      (String line) {
    var inst = line.split(' ');
    program.add(Instruction(inst[0], int.parse(inst[1])));
  }, onDone: () {
    completer.complete(program);
  }, onError: (e) {
    print(e.toString());
  });
  return completer.future;
}

class Instruction {
  String comm;
  int arg;

  Instruction(this.comm, this.arg);
}
