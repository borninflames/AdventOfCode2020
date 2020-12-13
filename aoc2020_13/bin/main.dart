//import 'inputReader.dart' as input_reader;

void main(List<String> arguments) async {
  //var ferry = await input_reader.readInputFile('bin/input.txt');
  part1();
  //part2();
}

void part1() {
  var ts = 1006401;
  var busIds = {17, 37, 449, 23, 13, 19, 607, 41, 29};
  var earliestDepartments = <int>[];

  busIds.forEach((id) {
    earliestDepartments.add(findNextTimestamp(id, ts) - ts);
  });

  print(earliestDepartments);
}

int findNextTimestamp(int ts, int earliestTs) {
  var loop = 1;
  while (ts * loop < earliestTs) {
    loop++;
  }

  return loop * ts;
}

void part2() {
  var ids = [
    17,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    37,
    0,
    0,
    0,
    0,
    0,
    449,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    23,
    0,
    0,
    0,
    0,
    13,
    0,
    0,
    0,
    0,
    0,
    19,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    607,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    41,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    29
  ];

  print(ids.length);
}
