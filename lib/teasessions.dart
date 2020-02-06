import 'package:flutter/material.dart';

class SessionsView extends StatefulWidget {

  @override
  _SessionsViewState createState() => _SessionsViewState();
}

class _SessionsViewState extends State<SessionsView>{
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: sessionTabs.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text('New Tea Session'),
            bottom: TabBar(
              tabs: sessionTabs,
            ),
          ),
          body: Center(
            child: Text('placeholder'),
          ),
        ));
  }
}

List<Tab> sessionTabs = <Tab>[
  Tab(
    text: 'Timer',
  ),
  Tab(text: 'Tea'),
  Tab(text: 'Pots')
];
