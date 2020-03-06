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

void updateTeaData(BuildContext context) async {
  await Provider.of<TeaProducerCollectionModel>(context, listen: false).fetch();
  await Provider.of<TeaProductionCollectionModel>(context, listen: false).fetch();
  await Provider.of<TeaCollectionModel>(context, listen: false).fetch();
}

void resetTeaData(BuildContext context) async {
  final producers = Provider.of<TeaProducerCollectionModel>(context, listen: false);
  final productions = Provider.of<TeaProductionCollectionModel>(context, listen: false);
  final teas = Provider.of<TeaCollectionModel>(context, listen: false);
  final user = await fetchUser();

  final old_producers = await Firestore.instance.collection(producers.dbCollectionName).getDocuments();
  final old_productions = await Firestore.instance.collection(productions.dbCollectionName).getDocuments();
  final old_teas = await user.reference.collection(teas.dbCollectionName).getDocuments();

  print('Deleting all producers, productions and teas...');

  old_teas.documents.forEach((doc) async {await doc.reference.delete();});
  old_productions.documents.forEach((doc) async {await doc.reference.delete();});
  old_producers.documents.forEach((doc) async { await doc.reference.delete();});
  print('done.');
  print('Repopulating database/local collections...');

  final xizihaoRef = await producers.put(TeaProducer('Xizihao', 'XZH'));
  final dayiRef = await producers.put(TeaProducer('Menghai Dayi Tea Factory', 'Dayi'));
  final wistariaRef = await producers.put(TeaProducer('Wistaria', 'Wistaria'));

  final dingjiRef = await productions.put(TeaProduction('Dingji Gushu', 400, producers.getById(xizihaoRef.documentID), 2007));
  final seven542Ref = await productions.put(TeaProduction('502-7542', 357, producers.getById(dayiRef.documentID), 2005));
  final ziyinNannuoRef = await productions.put(TeaProduction('Ziyin Nannuo', 357, producers.getById(wistariaRef.documentID), 2003));

  await teas.put(Tea(3, productions.getById(dingjiRef.documentID)));
  await teas.put(Tea(2, productions.getById(seven542Ref.documentID)));
  await teas.put(Tea(1, productions.getById(ziyinNannuoRef.documentID)));

  print('done.');

  //List<Tea> getSampleTeaList() {
//  return [
//    Tea(2007, Producer('Xizihao', 'XZH'), Production("Dingji Gushu")),
//    Tea(2005, Producer('Menghai Dayi Tea Factory', 'Dayi'),
//        Production("502-7542")),
//    Tea(2005, Producer('Menghai Dayi Tea Factory', 'Dayi'),
//        Production("504-8542")),
//    Tea(2009, Producer('Menghai Dayi Tea Factory', 'Dayi'),
//        Production("901-7542")),
//    Tea(2007, Producer('Wisteria'), Production("Honyin (Red Mark)")),
//    Tea(2007, Producer('Wisteria'), Production("Lanyin (Blue Mark)")),
//    Tea(2003, Producer('Wisteria'), Production("Ziyin Youle (Purple Mark)")),
//    Tea(2003, Producer('Wisteria'), Production("Ziyin Nannuo (Blue Mark)")),
//    Tea(2001, Producer('Xiaguan'), Production("8653 Tiebing")),
//    Tea(2013, Producer('Xiaguan'), Production("Love Forever (Paper Tong)")),
//    Tea(2004, Producer('Xiaguan'), Production("Jinsi")),
//  ];
//}
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
            create: (_) => ActiveTeaSessionModel()),
      ],
      child: MyApp(),
    ),
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
    //Provide initial trigger of update for tea
    resetTeaData(context);

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
