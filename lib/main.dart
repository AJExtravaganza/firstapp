// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstapp/db.dart';
import 'package:firstapp/models/active_tea_session.dart';
import 'package:firstapp/models/brewing_vessel.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/models/tea_collection.dart';
import 'package:firstapp/models/tea_producer.dart';
import 'package:firstapp/models/tea_producer_collection.dart';
import 'package:firstapp/models/tea_production.dart';
import 'package:firstapp/models/tea_production_collection.dart';
import 'package:firstapp/models/teapot_collection.dart';
import 'package:firstapp/screens/authentication/authentication_wrapper.dart';
import 'package:firstapp/screens/services/auth.dart';
import 'package:firstapp/screens/stash/stash.dart';
import 'package:firstapp/climate.dart' as climate;
import 'package:firstapp/screens/teasessions/teasessions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> updateTeaData(BuildContext context) async {
  final producers =
      Provider.of<TeaProducerCollectionModel>(context, listen: false);
  final productions =
      Provider.of<TeaProductionCollectionModel>(context, listen: false);
  final teas = Provider.of<TeaCollectionModel>(context, listen: false);

  await producers.fetch();
  await productions.fetch();
  await teas.fetch();
  
}

void resetTeaData(BuildContext context) async {
  final producers =
      Provider.of<TeaProducerCollectionModel>(context, listen: false);
  final productions =
      Provider.of<TeaProductionCollectionModel>(context, listen: false);
  final teas = Provider.of<TeaCollectionModel>(context, listen: false);
  final user = await fetchUser();

  final old_producers = await Firestore.instance
      .collection(producers.dbCollectionName)
      .getDocuments();
  final old_productions = await Firestore.instance
      .collection(productions.dbCollectionName)
      .getDocuments();
  final old_teas =
      await user.reference.collection(teas.dbFieldName).getDocuments();

  print('Deleting all producers, productions and teas...');

  old_teas.documents.forEach((doc) async {
    await doc.reference.delete();
  });
  old_productions.documents.forEach((doc) async {
    await doc.reference.delete();
  });
  old_producers.documents.forEach((doc) async {
    await doc.reference.delete();
  });
  print('done.');
  print('Repopulating database/local collections...');

  final xizihaoRef = await producers.put(TeaProducer('Xizihao', 'XZH'));
  final dayiRef =
      await producers.put(TeaProducer('Menghai Dayi Tea Factory', 'Dayi'));
  final wistariaRef = await producers.put(TeaProducer('Wistaria', 'Wistaria'));

  final dingjiRef = await productions.put(TeaProduction(
      'Dingji Gushu', 400, producers.getById(xizihaoRef.documentID), 2007));
  final lmeRef = await productions.put(TeaProduction(
      "Laoman'e Gushu", 500, producers.getById(xizihaoRef.documentID), 2006));
  final seven542Ref = await productions.put(TeaProduction(
      '502-7542', 357, producers.getById(dayiRef.documentID), 2005));
  final purpleDayiRef = await productions.put(TeaProduction(
      'Purple Dayi', 357, producers.getById(dayiRef.documentID), 2003));
  final ziyinNannuoRef = await productions.put(TeaProduction(
      'Ziyin Nannuo', 357, producers.getById(wistariaRef.documentID), 2003));
  final zipinRef = await productions.put(TeaProduction(
      'Zipin', 357, producers.getById(wistariaRef.documentID), 2003));

  await teas.put(Tea(3, productions.getById(dingjiRef.documentID)));
  await teas.put(Tea(2, productions.getById(seven542Ref.documentID)));
  await teas.put(Tea(2, productions.getById(seven542Ref.documentID)));
  await teas.put(Tea(1, productions.getById(ziyinNannuoRef.documentID)));

  print('done.');
}

void main() {
  List<BrewingVessel> userTeapotCollection = getSampleVesselList();
  final teaProducerCollectionModel = TeaProducerCollectionModel();
  final teaProductionCollectionModel =
      TeaProductionCollectionModel(teaProducerCollectionModel);
  final teaCollectionModel = TeaCollectionModel(teaProductionCollectionModel);

  runApp(StreamProvider<FirebaseUser>(
    create: (_) => AuthService().activeUser,
    child: MultiProvider(
      providers: [
        ChangeNotifierProvider<TeaProducerCollectionModel>(
          create: (_) => teaProducerCollectionModel,
        ),
        ChangeNotifierProvider<TeaProductionCollectionModel>(
          create: (_) => teaProductionCollectionModel,
        ),
        ChangeNotifierProvider<TeaCollectionModel>(
          create: (_) => teaCollectionModel,
        ),
        ChangeNotifierProvider<TeapotCollectionModel>(
            create: (_) => TeapotCollectionModel(userTeapotCollection)),
        ChangeNotifierProvider<ActiveTeaSessionModel>(
            create: (_) => ActiveTeaSessionModel(teaCollectionModel)),
      ],
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final teaCollection = Provider.of<TeaCollectionModel>(context, listen: false);
    final activeTeaSession = Provider.of<ActiveTeaSessionModel>(context, listen: false);

    if (teaCollection.needsInitialisation) {
      activeTeaSession.initialLoad(context);
    } else {
      activeTeaSession.refresh(context);
    }



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
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  static final String sessionTabLabel = 'Session';
  static final String stashTabLabel = 'Stash';
  static final String climateTabLabel = 'Climate';
  static final SESSIONTABIDX = 0;
  static final STASHTABIDX = 1;

  bool stashTeaSelectionMode = false;

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

    //Provide initial trigger of update for tea
//    resetTeaData(context);
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
          title: stashTeaSelectionMode
              ? Text("Select a Tea")
              : TabBar(
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
