// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstapp/db.dart';
import 'package:firstapp/models/active_tea_session.dart';
import 'package:firstapp/models/brewing_vessel.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/models/tea_collection.dart';
import 'package:firstapp/models/teapot_collection.dart';
import 'package:firstapp/screens/authentication/authentication_wrapper.dart';
import 'package:firstapp/screens/services/auth.dart';
import 'package:firstapp/screens/stash/stash.dart';
import 'package:firstapp/climate.dart' as climate;
import 'package:firstapp/screens/teasessions/teasessions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  List<Tea> userTeaCollection = getSampleTeaList();
  List<BrewingVessel> userTeapotCollection = getSampleVesselList();

  runApp(MultiProvider(
    providers: [
      StreamProvider<FirebaseUser>(create: (_) => AuthService().activeUser),
      ChangeNotifierProvider<TeaCollectionModel>(
          create: (_) => TeaCollectionModel(userTeaCollection)),
      ChangeNotifierProvider<TeapotCollectionModel>(
          create: (_) => TeapotCollectionModel(userTeapotCollection)),
      ChangeNotifierProvider<ActiveTeaSessionModel>(
          create: (_) => ActiveTeaSessionModel()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //  TODO: Remove this automatic test signout once signing out UI has been implemented
//    AuthService().signOut();

    return MaterialApp(
      title: 'TeaVault',
      home: AuthenticationWrapper(HomeView()),
    );
  }
}

Scaffold getStubContent([String textContent = 'STUBCONTENT']) {
  return Scaffold(
    appBar: AppBar(
      title: Text('${textContent}APPBARTITLE'),
    ),
    body: Center(child: Text(textContent)),
  );
}

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  static final String sessionTabLabel = 'Session';
  static final String stashTabLabel = 'Stash';
  static final String climateTabLabel = 'Climate';

  final List<Tab> homeTabs = <Tab>[
    Tab(
      text: sessionTabLabel,
    ),
    Tab(
      text: stashTabLabel,
    ),
    Tab(
      text: climateTabLabel,
    )
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: homeTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: homeTabs.length,
      child: Scaffold(
        appBar: AppBar(
//          title: Text('TeaVault v0.1'),
          title: TabBar(
            controller: _tabController,
            tabs: homeTabs,
          ),
        ),
        body: TabBarView(
            controller: _tabController,
            children: homeTabs.map((Tab tab) {
              if (tab.text == sessionTabLabel) {
                return SessionsView();
              } else if (tab.text == stashTabLabel) {
                return StashView();
              } else if (tab.text == climateTabLabel) {
                return climate.DateTimeComboLinePointChart.withSampleData();
              } else {
                return getStubContent(
                    'ERROR: INVALID TAB ${tab.text} SPECIFIED');
              }
            }).toList()),
      ),
    );
  }
}
