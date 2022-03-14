import 'dart:async';
import 'package:flutter/material.dart';
import 'package:puzzle/repositories/puzzle.repo.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({Key? key, required this.valueChanged}) : super(key: key);
  final ValueChanged<bool> valueChanged;

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> with TickerProviderStateMixin {
  int _counter = PuzzleRepo().getStartTime();
  Timer? timer;
  bool _showAnimatedTime = false;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    super.initState();
    _restartTimer();
    PuzzleRepo().getController().listen((event) async {
      bool add = event['added'];
      int time = event['time'];
      // -1 -> restart starTtime
      if (time == -1) {
        _counter = PuzzleRepo().getStartTime();
        setState(() {
          _showAnimatedTime = false;
        });
      } else if (add) {
        _counter += time;
        setState(() {
          _showAnimatedTime = true;
        });
        await Future.delayed(const Duration(milliseconds: 3000));
        setState(() {
          _showAnimatedTime = false;
        });
      } else if (!add) {
        _counter -= time;
        setState(() {});
      }
      _restartTimer();
    });
  }

  _restartTimer() {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        _decrementCounter();
      },
    );
  }

  void _decrementCounter() {
    if (_counter == 0) {
      widget.valueChanged(true);
      timer!.cancel();
    }
    setState(
      () {
        --_counter;
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  _buildTimeChangedButton() {
    return Positioned(
      left: 15,
      top: -5,
      child: Visibility(
        visible: _showAnimatedTime,
        child: ScaleTransition(
          scale: _animation,
          child: const FloatingActionButton(
            backgroundColor: Colors.green,
            child: Text('+5'),
            onPressed: null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              (_counter > 0
                  ? Text(
                      '${(_counter / 60).floor()}'.padLeft(2, '0') + ':' + '${_counter % 60}'.padLeft(2, '0'),
                      style: Theme.of(context).textTheme.headline4,
                    )
                  : Text(
                      "GAME OVER!",
                      style: Theme.of(context).textTheme.headline4,
                    )),
              _buildTimeChangedButton(),
            ],
          ),
        ],
      ),
    );
  }
}
