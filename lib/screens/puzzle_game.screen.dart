import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/models/puzzle_item.model.dart';
import 'package:puzzle/repositories/puzzle.repo.dart';
import 'package:puzzle/screens/gameover_screen.dart';
import 'package:puzzle/templates/timer.template.dart';

class PuzzleGame extends StatefulWidget {
  const PuzzleGame({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<PuzzleGame> createState() => _PuzzleGame();
}

class _PuzzleGame extends State<PuzzleGame> with TickerProviderStateMixin {
  final List<List<PuzzleItem>> puzzleMatrix = [];
  final int listHeight = 4;
  final int listWidth = 4;

  final List<int> resultMatrix = [];

  final double defaultWidth = 75.0;
  final double defaultHeight = 75.0;
  int steps = 0;
  bool isFirst = true;
  bool won = false;

  @override
  void initState() {
    PuzzleRepo().setStartTime(30);
    for (var element in List<PuzzleItem>.generate((listHeight * listHeight) - 1, (i) => PuzzleItem(i + 1))) {
      resultMatrix.add(element.value);
    }
    _reShuffle();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _checkCurrentState(value, xRow, yRow, PuzzleItem item) {
    final int xRowFrom = xRow;
    final int yRowFrom = yRow;

    final int yPosRight = yRowFrom + 1;
    final int yPosLeft = yRowFrom - 1;
    final int xPosAbove = xRowFrom - 1;
    final int xPosUnder = xRowFrom + 1;
    PuzzleItem emptyItem = PuzzleItem(-1);

    setState(() {});

    if (value == -1) {
      return debugPrint('Hit empty place');
    }
    // Check if we are in xRow 0 or in xRow 3 than we not to check upper and down
    try {
      if (xRow == 0 || xRow == puzzleMatrix.length - 1) {
        if (yRow > 0 && puzzleMatrix[xRowFrom][yPosLeft].value == -1) {
          emptyItem = puzzleMatrix[xRowFrom][yPosLeft];
          _changePosition(xRowFrom, yPosLeft, value, xRowFrom, yRowFrom, item, emptyItem);
        } else if (yPosRight < puzzleMatrix[0].length && puzzleMatrix[xRow][yPosRight].value == -1) {
          emptyItem = puzzleMatrix[xRow][yPosRight];
          _changePosition(xRowFrom, yPosRight, value, xRowFrom, yRowFrom, item, emptyItem);
        } else if (xRow == puzzleMatrix.length - 1 && puzzleMatrix[xPosAbove][yRow].value == -1) {
          emptyItem = puzzleMatrix[xPosAbove][yRow];
          _changePosition(xPosAbove, yRowFrom, value, xRowFrom, yRowFrom, item, emptyItem);
        } else if (xRow == 0 && puzzleMatrix[xPosUnder][yRow].value == -1) {
          emptyItem = puzzleMatrix[xPosUnder][yRow];
          _changePosition(xPosUnder, yRowFrom, value, xRowFrom, yRowFrom, item, emptyItem);
        } else {
          return debugPrint('no free place X ROW');
        }
      } else if (yRow == 0 || yRow == puzzleMatrix[0].length - 1) {
        // Only Check up down
        if (puzzleMatrix[xPosAbove][yRow].value == -1) {
          emptyItem = puzzleMatrix[xPosAbove][yRow];
          _changePosition(xPosAbove, yRow, value, xRowFrom, yRowFrom, item, emptyItem);
        } else if (puzzleMatrix[xPosUnder][yRow].value == -1) {
          emptyItem = emptyItem = puzzleMatrix[xPosUnder][yRow];
          _changePosition(xPosUnder, yRow, value, xRowFrom, yRowFrom, item, emptyItem);
        } else if (yRow == puzzleMatrix[0].length - 1 && puzzleMatrix[xRow][yPosLeft].value == -1) {
          emptyItem = puzzleMatrix[xRow][yPosLeft];
          _changePosition(xRow, yPosLeft, value, xRowFrom, yRowFrom, item, emptyItem);
        } else if (yRow == 0 && puzzleMatrix[xRow][yPosRight].value == -1) {
          emptyItem = puzzleMatrix[xRow][yPosRight];
          _changePosition(xRow, yPosRight, value, xRowFrom, yRowFrom, item, emptyItem);
        } else {
          return debugPrint('no free place Y ROW');
        }
      } else {
        //Check if Upper on is -1
        if (puzzleMatrix[xPosAbove][yRow].value == -1) {
          //found empy place above
          emptyItem = puzzleMatrix[xPosAbove][yRow];
          _changePosition(xPosAbove, yRow, value, xRowFrom, yRowFrom, item, emptyItem);
        } else if (puzzleMatrix[xPosUnder][yRow].value == -1) {
          //found empy place under
          emptyItem = puzzleMatrix[xPosUnder][yRow];
          _changePosition(xPosUnder, yRow, value, xRowFrom, yRowFrom, item, emptyItem);
        } else if (puzzleMatrix[xRow][yPosLeft].value == -1) {
          //found empy place left
          emptyItem = puzzleMatrix[xRow][yPosLeft];
          _changePosition(xRow, yPosLeft, value, xRowFrom, yRowFrom, item, emptyItem);
        } else if (puzzleMatrix[xRow][yPosRight].value == -1) {
          //found empy place right
          emptyItem = puzzleMatrix[xRow][yPosRight];
          _changePosition(xRow, yPosRight, value, xRowFrom, yRowFrom, item, emptyItem);
        } else {
          item.width = defaultWidth;
          item.height = defaultHeight;
          setState(() {});
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  _changePosition(xRow, yRow, value, newEmptyPlaceX, newEmptyPlaceY, PuzzleItem item, PuzzleItem? otherItem) async {
    puzzleMatrix[newEmptyPlaceX][newEmptyPlaceY] = PuzzleItem(-1);
    // einfaerben von korrekt platzierten felder
    PuzzleRepo().addValueInCurrentCheckedMatrix(newEmptyPlaceX, newEmptyPlaceY, 0);
    if (PuzzleRepo().getPuzzleOrderMatrix4x4()[xRow][yRow] == value) {
      PuzzleRepo().addValueInCheckedMatrix(xRow, yRow);
      PuzzleRepo().addValueInCurrentCheckedMatrix(xRow, yRow, 1);
      puzzleMatrix[xRow][yRow] = PuzzleItem(value, color: Colors.green);
    } else {
      PuzzleRepo().addValueInCurrentCheckedMatrix(xRow, yRow, 0);
      puzzleMatrix[xRow][yRow] = PuzzleItem(value);
    }
    steps++;
    item.width = defaultWidth;
    item.height = defaultHeight;
    otherItem?.width = defaultWidth;
    otherItem?.height = defaultHeight;
    _checkSort();
  }

  _checkSort() {
    List<int> currentStep = [];
    for (var row in puzzleMatrix) {
      {
        for (var value in row) {
          {
            if (value.value != -1) currentStep.add(value.value);
          }
        }
      }
    }
    Function eq = const ListEquality().equals;
    if (eq(currentStep, resultMatrix)) {

      won = true;
    } else {
      won = false;
    }
    setState(() {});
  }

  _reShuffle() {
    steps = 0;
    puzzleMatrix.clear();
    PuzzleRepo().resetCheckedMatrix();
    PuzzleRepo().resetCheckedCurrentMatrix();
    var list = List<PuzzleItem>.generate((listHeight * listWidth) - 1, (i) => PuzzleItem(i + 1));
    list.add(PuzzleItem(-1));
    shuffle(list);

    for (var i = 0; i < list.length; i++) {
      if (list[i].value - 1 == i) {
        list[i].color = Colors.green;
      }
    }

    var chunks = [];
    int chunkSize = listWidth;
    for (var i = 0; i < list.length; i += chunkSize) {
      chunks.add(list.sublist(i, i + chunkSize > list.length ? list.length : i + chunkSize));
    }

    for (var element in chunks) {
      puzzleMatrix.add(element);
    }

    for (var i = 0; i < puzzleMatrix.length; i++) {
      for (var j = 0; j < puzzleMatrix.length; j++) {
        if (puzzleMatrix[i][j].color == Colors.green) {
          PuzzleRepo().addValueInCheckedMatrix(i, j);
          PuzzleRepo().addValueInCurrentCheckedMatrix(i, j, 1);
        }
      }
    }

    PuzzleRepo().resetStartTime();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> data = [];
    List<Widget> rowItems = [];

    int xRow = 0;
    for (var x in puzzleMatrix) {
      {
        rowItems = _generateRow(x, xRow);
        data.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: [...rowItems]));
        xRow++;
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(children: [
          SizedBox(height: 40, child: Center(child: Text("You did Steps: $steps"))),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              margin: const EdgeInsets.all(10),
              child: Column(children: [...data]),
            ),
          ),
          SizedBox(
            height: 80,
            child: Center(
              child: ElevatedButton(onPressed: () => _reShuffle(), child: const Text("Reshuffle")),
            ),
          ),
          SizedBox(
            height: 40,
            child: TimerWidget(
              valueChanged: (bool value) => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameOverWidget(steps: steps)),
                ),
              },
            ),
          ),
        ]),
      ),
    );
  }

  List<Widget> _generateRow(List<PuzzleItem> x, int xRow) {
    List<Widget> row = [];
    x.asMap().forEach((key, y) => {
          row.add(
            StatefulBuilder(
              builder: (BuildContext context, void Function(void Function()) setState) {
                AnimationController controller = AnimationController(duration: const Duration(seconds: 2), vsync: this)
                  ..addListener(() => setState(() {}));
                Animation<Offset> animation =
                    Tween(begin: const Offset(0.0, 0.0), end: const Offset(0.0, 0.0)).animate(controller);
                return Container(
                  padding: const EdgeInsets.all(5),
                  child: SizedBox(
                    width: y.width,
                    height: y.height,
                    child: Visibility(
                      visible: y.value > 0,
                      child: Transform.translate(
                        offset: animation.value,
                        child: Container(
                          decoration: BoxDecoration(
                              color: y.color, borderRadius: const BorderRadius.all(Radius.elliptical(5, 5))),
                          child: TextButton(
                            child: (y.value == -1
                                ? const Text('')
                                : Text(
                                    '${y.value}',
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            onPressed: () {
                              _checkCurrentState(y.value, xRow, key, y);
                              setState(() {});
                              controller.forward();
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        });
    return row;
  }
}
