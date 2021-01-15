void main(List<String> arguments) async {
  var cardPubKey = 12090988;
  var doorPubKey = 240583;
  //var cardPubKey = 5764801;
  //var doorPubKey = 17807724;
  getLoopSizes(cardPubKey, doorPubKey);

  print(getEncryptionKey(cardPubKey, 5864863));
  print(getEncryptionKey(doorPubKey, 4605164));
}

void getLoopSizes(int cardPubKey, int doorPubKey) {
  var subjectNumber = 1;
  var foundCardLoopSize = false;
  var foundDoorLoopSize = false;
  while (!foundCardLoopSize && !foundDoorLoopSize) {
    subjectNumber++;
    var value = 1;
    for (var i = 1;
        i <= 6000000 && (!foundCardLoopSize || !foundDoorLoopSize);
        i++) {
      value *= subjectNumber;
      value = value % 20201227;
      if (!foundCardLoopSize) {
        foundCardLoopSize = value == cardPubKey;
        if (foundCardLoopSize) {
          print('Subject number: ${subjectNumber}; Card loop size: ${i}');
        }
      }

      if (!foundDoorLoopSize) {
        foundDoorLoopSize = value == doorPubKey;
        if (foundDoorLoopSize) {
          print('Subject number: ${subjectNumber}; Door loop size: ${i}');
        }
      }
    }

    if (foundDoorLoopSize || foundCardLoopSize) {
      print('-----------------------------------------------------------');
    }

    if (foundDoorLoopSize && foundCardLoopSize) {
      print('Subject number: ${subjectNumber}');
    } else {
      foundDoorLoopSize = false;
      foundCardLoopSize = false;
    }
  }
}

int getEncryptionKey(int pubKey, int loopSize) {
  var value = 1;
  for (var i = 1; i <= loopSize; i++) {
    value *= pubKey;
    value = value % 20201227;
    //found = value == pubKey;
    // if (found) {
    //   print('Subject number: ${subjectNumber}; Loop size: ${i}');
    // }
  }

  return value;
}
