import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SteepTimer extends StatefulWidget {
  @override
  State<SteepTimer> createState() => _SteepTimer();
}

class _SteepTimer extends State<SteepTimer> {
  Duration timerDuration;

  @override
  void initState() {
    super.initState();
    timerDuration = Duration(seconds: 10);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        TimerIconButton(),
        Text('SteepTimerStub')
//        TimerDisplay()
      ],
    );
  }

//  showPopup(BuildContext context, Widget widget, String title,
//      {BuildContext popupContext}) {
//    Navigator.push(
//      context,
//      PopupLayout(
//        top: 30,
//        left: 30,
//        right: 30,
//        bottom: 50,
//        child: PopupContent(
//          content: Scaffold(
//            appBar: AppBar(
//              title: Text(title),
//              leading: new Builder(builder: (context) {
//                return IconButton(
//                  icon: Icon(Icons.arrow_back),
//                  onPressed: () {
//                    try {
//                      Navigator.pop(context); //close the popup
//                    } catch (e) {}
//                  },
//                );
//              }),
//              brightness: Brightness.light,
//            ),
//            resizeToAvoidBottomPadding: false,
//            body: widget,
//          ),
//        ),
//      ),
//    );
//  }

  showPopup(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(title: Text('My Page')),
          body: Center(
            child: FlatButton(
              child: Text('POP'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    ));
  }
}

class TimerDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _SteepTimer parentTimerState =
        context.findAncestorStateOfType<_SteepTimer>();
    String currentValueStr = parentTimerState.timerDuration.toString();
    return FlatButton(
      child: Text(currentValueStr),
      onPressed: parentTimerState.showPopup(context),
    );
  }
}

class TimerIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        launchTestModal(context);
      },
      alignment: Alignment.centerLeft,
      icon: Icon(Icons.timelapse),
    );
  }
}

launchTestModal(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return Text('something');
        },
        fullscreenDialog: true,
      ));
}
