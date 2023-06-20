import 'package:cubimer/data/scramble.dart';
import 'package:cubimer/main.dart';
import 'package:cubimer/widgets/scrambles_drawer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:localstorage/localstorage.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

enum TimerState { NEW, WAIT, RUNNING, STOP, END }

class CenterTimer extends ConsumerStatefulWidget {
  const CenterTimer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CenterTimerState();
}

// TODO: Add controller to change colors
class _CenterTimerState extends ConsumerState<CenterTimer> {
  var _textStyle =
      TextStyle(color: Color(0xff1D1B1E), fontFamily: "RobotoMono");

  var _timerState = TimerState.NEW;
  var _timer = StopWatchTimer();

  void _toggleTextStyle() {
    setState(() {
      if (_timerState == TimerState.WAIT) {
        _textStyle =
            TextStyle(color: Colors.green, fontFamily: _textStyle.fontFamily);
      } else if (_timerState == TimerState.STOP) {
        _textStyle = TextStyle(
            color: Color(0xff1D1B1E), fontFamily: _textStyle.fontFamily);
      }
    });
  }

  bool _onKey(KeyEvent event) {
    final key = event.logicalKey.keyLabel;

    if (key == " ") {
      if (event is KeyDownEvent) {
        onTapDownController(TapDownDetails());
      } else if (event is KeyUpEvent) {
        onTapUpController(TapUpDetails(kind: PointerDeviceKind.unknown));
      }
    }

    return false;
  }

  void onTapDownController(TapDownDetails _) async {
    print("Holding");

    setState(() {
      if (_timerState == TimerState.NEW) {
        _timerState = TimerState.WAIT;
      } else if (_timerState == TimerState.RUNNING) {
        _timerState = TimerState.STOP;
      }
    });
    _toggleTextStyle();

    if (_timerState == TimerState.WAIT) {
      _timer.onResetTimer();
    } else if (_timerState == TimerState.STOP) {
      _timer.onStopTimer();

      final currScramble = ref.watch(currentScrambleProvider);

      await ref
          .read(scrambleListProvider.notifier)
          .add(time: _timer.rawTime.value, scramble: currScramble);
    }

    // TODO: Store scramble time
  }

  void onTapUpController(TapUpDetails _) async {
    print("Stopped holding");

    setState(() {
      if (_timerState == TimerState.WAIT) {
        _timerState = TimerState.RUNNING;
      } else if (_timerState == TimerState.STOP) {
        _timerState = TimerState.NEW;
      }
    });
    _toggleTextStyle();

    if (_timerState == TimerState.RUNNING) {
      _timer.onStartTimer();
    } else if (_timerState == TimerState.NEW) {
      // TODO: Add way to randomize scramble
      ref.read(currentScrambleProvider.notifier).state =
          CurrentScramble.genScramble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storage.ready,
        builder: (_, __) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: onTapDownController,
            onTapUp: onTapUpController,
            child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Padding(
                    padding: EdgeInsets.all(32),
                    child: StreamBuilder<int>(
                      stream: _timer.rawTime,
                      initialData: 0,
                      builder: (context, snap) {
                        final rawTime = snap.data!;
                        return Text(Scramble.timeToString(rawTime),
                            style: _textStyle);
                      },
                    )))));
  }

  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_onKey);
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(_onKey);
    super.dispose();
  }
}
