import 'package:flutter/material.dart';
import 'package:puzzle/repositories/puzzle.repo.dart';
import 'package:puzzle/screens/puzzle_game.screen.dart';
import 'package:puzzle/screens/start_screen.dart';

class GameOverWidget extends StatelessWidget {
  GameOverWidget({Key? key, required this.steps}) : super(key: key);
  final int steps;
  int correctNumbers = 0;
  int correctCheckedNumbers = 0;
  List<Widget> _generateGrid() {
    List<List<int>> checkedMatrix = PuzzleRepo().getCheckedMatrix();
    List<List<int>> currentCheckedMatrix = PuzzleRepo().getCurrentCheckedMatrix();
    List<Widget> rows = [];
    for (var i = 0; i < checkedMatrix.length; i++) {
      List<Widget> columns = [];
      for (var j = 0; j < checkedMatrix[i].length; j++) {
        Color color = Colors.red;
        if (checkedMatrix[i][j] == 1) {
          correctNumbers++;
          color = Colors.yellow;
        }
        if (currentCheckedMatrix[i][j] == 1) {
          correctCheckedNumbers++;
          color = Colors.green;
        }
        columns.add(
          Container(
            margin: const EdgeInsets.all(1),
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.all(Radius.elliptical(5, 5)),
            ),
            child: const TextButton(
              child: (Text('')),
              onPressed: null,
            ),
          ),
        );
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: columns,
      ));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> grid = _generateGrid();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("GAME OVER"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Time expired!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text("You have made $steps actions"),
                const SizedBox(height: 10),
                Text("You have filled $correctNumbers fields correctly"),
                const SizedBox(height: 10),
                (correctCheckedNumbers == 1
                    ? Text("Of these, one $correctCheckedNumbers field was correct until the end")
                    : Text("Of these, $correctCheckedNumbers fields have been correct to the end")),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    child: Column(children: grid),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text(
                    "Restart",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PuzzleGame(
                          title: "Flutter Demo Puzzle Dage",
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: const Text(
                    "Back to start",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StartScreenWidget(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
