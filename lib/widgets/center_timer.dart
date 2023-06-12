import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

enum TimerState { NEW, WAIT, RUNNING, STOP, END }

class CenterTimer extends StatefulWidget {
  const CenterTimer({super.key});

  @override
  State<StatefulWidget> createState() => _CenterTimerState();
}

// TODO: Add controller to change colors
class _CenterTimerState extends State<CenterTimer> {
  var _textStyle =
      TextStyle(color: Color(0xff1D1B1E), fontFamily: "RobotoMono");
  final timerFont = "RobotoMono";

  var _timerState = TimerState.NEW;
  var _timer = StopWatchTimer();

  void _toggleTextStyle() {
    setState(() {
      if (_timerState == TimerState.WAIT) {
        _textStyle = TextStyle(color: Colors.green, fontFamily: timerFont);
      } else if (_timerState == TimerState.STOP) {
        _textStyle = TextStyle(color: Color(0xff1D1B1E), fontFamily: timerFont);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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

                    var displayTime = StopWatchTimer.getDisplayTime(rawTime);
                    if (rawTime < StopWatchTimer.getMilliSecFromSecond(10)) {
                      displayTime = StopWatchTimer.getDisplayTime(rawTime,
                              hours: false, minute: false)
                          .substring(1);
                    } else if (rawTime <
                        StopWatchTimer.getMilliSecFromMinute(1)) {
                      displayTime = StopWatchTimer.getDisplayTime(rawTime,
                          hours: false, minute: false);
                    } else if (rawTime <
                        StopWatchTimer.getMilliSecFromMinute(10)) {
                      displayTime =
                          StopWatchTimer.getDisplayTime(rawTime, hours: false)
                              .substring(1);
                    } else if (rawTime <
                        StopWatchTimer.getMilliSecFromHour(1)) {
                      displayTime =
                          StopWatchTimer.getDisplayTime(rawTime, hours: false);
                    }

                    return Text(displayTime, style: _textStyle);
                  },
                ))));
  }

  void onTapDownController(TapDownDetails _) {
    print("Holding");

    // TODO: fix timerstate here
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
    }
  }

  void onTapUpController(TapUpDetails _) {
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
    }
  }
}
