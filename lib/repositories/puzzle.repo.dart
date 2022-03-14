import 'dart:async';

class PuzzleRepo {
  static final PuzzleRepo _puzzleRepo = PuzzleRepo._internal();
  static final StreamController<dynamic> _controller = StreamController<dynamic>.broadcast();

  final List<List<int>> _puzzleOrderMatrix4x4 = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
    [13, 14, 15, 16],
  ];

  // Bereits korrekt platzierte Nummern werden hier vermerkt mit 1 auch wenn sie wieder verschoben worden sind
  final List<List<int>> _checkedMatrix4x4 = [
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
  ];

  // Im moment korrekt platzierte Nummern werden hier vermerkt mit 1 aber wiede auf 0 gesetzt wenn sie nicht mehr stimmen
  final List<List<int>> _checkedCurrentMatrix4x4 = [
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 0, 0, 0],
  ];

  factory PuzzleRepo() {
    return _puzzleRepo;
  }

  // privater constructor mit der Kombination mit der Factory
  PuzzleRepo._internal();

  int startTime = 60;

  addValueInCheckedMatrix(int newPosX, int newPosY) {
    // es gibt nur extra Zeit wenn die Zahl zum ersten mal korrekt platziert wurde
    if (_checkedMatrix4x4[newPosX][newPosY] == 0) {
      _checkedMatrix4x4[newPosX][newPosY] = 1;
      addTime(5);
    }
  }

  addValueInCurrentCheckedMatrix(int posX, int posY, int value) {
    _checkedCurrentMatrix4x4[posX][posY] = value;
  }

  List<List<int>> getCheckedMatrix() {
    return _checkedMatrix4x4;
  }

  List<List<int>> getCurrentCheckedMatrix() {
    return _checkedCurrentMatrix4x4;
  }

  resetCheckedMatrix() {
    for (int i = 0; i < _checkedMatrix4x4.length; i++) {
      for (int j = 0; j < _checkedMatrix4x4[i].length; j++) {
        _checkedMatrix4x4[i][j] = 0;
      }
    }
  }

  resetCheckedCurrentMatrix() {
    for (int i = 0; i < _checkedCurrentMatrix4x4.length; i++) {
      for (int j = 0; j < _checkedCurrentMatrix4x4[i].length; j++) {
        _checkedCurrentMatrix4x4[i][j] = 0;
      }
    }
  }

  int getStartTime() {
    return startTime;
  }

  setStartTime(int time) {
    startTime = time;
  }

  List<List<int>> getPuzzleOrderMatrix4x4() {
    return _puzzleOrderMatrix4x4;
  }

  addTime(int extraTime) {
    _controller.add({"added": true, 'time': extraTime});
  }

  removeTime(int removeTime) {
    _controller.add({"added": false, 'time': removeTime});
  }

  resetStartTime() {
    _controller.add({"added": false, "time": -1});
  }

  Stream<dynamic> getController() {
    return _controller.stream.asBroadcastStream();
  }
}
