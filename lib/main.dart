// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firstapp/teasessions.dart' as teasessions;
import 'package:firstapp/climate.dart' as climate;
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TeaVault',
      home: Scaffold(
        appBar: AppBar(
          title: Text('TeaVault'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              SessionsHomeMenuItem(),
              StashHomeMenuItem(),
              ClimateHomeMenuItem(),
            ],
          ),
        ),
      ),
    );
  }
}

Scaffold getStubContent([String textContent='STUBCONTENT']) {
  return Scaffold(
    appBar: AppBar(
      title: Text('${textContent}APPBARTITLE'),
    ),
    body: Center(child: Text(textContent)),
  );
}

abstract class HomeMenuButton extends StatelessWidget {
  final String labelText = null;

  PageRoute getNavigationTarget();

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(labelText),
      onPressed: () {
        Navigator.push(context, getNavigationTarget());
      },
    );
  }
}

class ViewSessionsHomeMenuButton extends HomeMenuButton {
  final String labelText = 'Sessions';

  @override
  PageRoute getNavigationTarget() => ViewSessionsRoute();
}

class ViewStashHomeMenuButton extends HomeMenuButton {
  final String labelText = 'Stash';

  getNavigationTarget() => ViewStashRoute();
}

class ViewClimateHomeMenuButton extends HomeMenuButton {
  final String labelText = 'Climate';

  PageRoute getNavigationTarget() => ViewClimateRoute();
}

class ViewSessionsRoute extends PageRoute {
  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return teasessions.SessionsView();
  }

  @override
  bool get maintainState => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 0);
}

class ViewStashRoute extends PageRoute {
  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // TODO: implement buildPage
    return getStubContent('STASH');
  }

  @override
  bool get maintainState => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 0);
}

class ViewClimateRoute extends PageRoute {
  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Scaffold(
      appBar: AppBar(title: Text('Climate Control Chart')),
      body: Center(child: climate.DateTimeComboLinePointChart.withSampleData(),),

    );
  }

  @override
  bool get maintainState => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 0);
}

class StashHomeMenuItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ViewStashHomeMenuButton(),
        Text('AddToStashButtonPlaceholder')
      ],
    );
  }
}

class SessionsHomeMenuItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ViewSessionsHomeMenuButton(),
        Text('NewSessionButtonPlaceholder')
      ],
    );
  }
}

class ClimateHomeMenuItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[ViewClimateHomeMenuButton()],
    );
  }
}

