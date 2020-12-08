import 'inputReader.dart' as input_reader;

void main(List<String> arguments) async {
  var code = await input_reader.readInputFile('bin/input.txt');

  var program = Program();
  program.code = code;
  program.run();
  print(program.loopPtrs);

  var terminated = false;
  for (var i = 0; i < program.loopPtrs.length && !terminated; i++) {
    print(i);
    terminated = program.tryRun(program.loopPtrs[i]);
  }

  if (terminated) {
    print('The program is successfully terminated.');
  }
  print('The acc is: ${program.acc}');
}

class Program {
  List<input_reader.Instruction> code;
  var ptrs = <int>[];
  var loopPtrs = <int>[];
  var ptr = 0;
  var acc = 0;
  var accBeforeLoop = -1;

  bool run() {
    ptrs = <int>[];
    loopPtrs = <int>[];
    var ptr = 0;
    acc = 0;
    accBeforeLoop = -1;
    while (ptr < code.length &&
        (ptrs.every((i) => i != ptr) || loopPtrs.every((i) => i != ptr))) {
      var instr = code[ptr];
      if (ptrs.any((i) => i == ptr)) {
        loopPtrs.add(ptr);
        if (accBeforeLoop == -1) {
          accBeforeLoop = acc;
        }
      } else {
        ptrs.add(ptr);
      }

      ptr = execute(instr, ptr);
    }

    return ptr == code.length;
  }

  bool tryRun(int susPtr) {
    ptrs = <int>[];
    var ptr = 0;
    acc = 0;
    accBeforeLoop = -1;
    while (ptr < code.length && ptrs.every((i) => i != ptr)) {
      var instr = code[ptr];
      ptrs.add(ptr);
      ptr = execute(instr, ptr, susPtr: susPtr);
    }

    return ptr == code.length;
  }

  int execute(input_reader.Instruction instr, int ptr, {int susPtr = -1}) {
    switch (instr.comm) {
      case 'jmp':
        if (ptr == susPtr) {
          ptr++; //nop
        } else {
          ptr += instr.arg;
        }
        return ptr;
      case 'acc':
        acc += instr.arg;
        ptr++;
        return ptr;
      case 'nop':
        if (ptr == susPtr) {
          ptr += instr.arg;
        } else {
          ptr++;
        }
    }
    return ptr;
  }
}
