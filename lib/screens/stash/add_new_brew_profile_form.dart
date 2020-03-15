import 'dart:math';

import 'package:firstapp/models/brew_profile.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/models/tea_collection.dart';
import 'package:firstapp/models/tea_producer.dart';
import 'package:firstapp/models/tea_producer_collection.dart';
import 'package:firstapp/models/tea_production.dart';
import 'package:firstapp/models/tea_production_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewBrewProfile extends StatelessWidget {
  final Tea _tea;

  AddNewBrewProfile(this._tea);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Tea to Stash'),
      ),
      body: AddNewBrewProfileForm(this._tea),
    );
  }
}

class AddNewBrewProfileForm extends StatefulWidget {
  final Tea _tea;

  AddNewBrewProfileForm(this._tea);

  @override
  _AddNewBrewProfileFormState createState() => new _AddNewBrewProfileFormState(_tea);
}

class _AddNewBrewProfileFormState extends State<AddNewBrewProfileForm> {
  final _formKey = GlobalKey<FormState>();

  final Tea _tea;

  String _name;
  int _nominalRatio;
  int _brewTemperatureCelsius;
  List<int> _steepTimings = [];

  _AddNewBrewProfileFormState(this._tea);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: new ListView(children: <Widget>[
        TextFormField(
            decoration: InputDecoration(
                labelText: 'Enter Profile Name', hintText: ''),
            initialValue: '',
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a name for this profile';
              }

              return null;
            },
            onSaved: (value) {
              setState(() {
                _name = value;
              });
            },
            keyboardType: TextInputType.text),
        TextFormField(
            decoration: InputDecoration(
                labelText: 'Enter Ratio', hintText: 'Enter x to represent 1:x leaf:water'),
            initialValue: '15',
            validator: (value) {
              if (int.tryParse(value) == null || int.parse(value) < 5 || int.parse(value) >200 ) {
                return 'Please enter a valid value (5-200)';
              }

              return null;
            },
            onSaved: (value) {
              setState(() {
                _nominalRatio = int.parse(value);
              });
            },
            keyboardType: TextInputType.number),
        TextFormField(
            decoration: InputDecoration(
                labelText: 'Enter Brew Temperature (°C)', hintText: ''),
            initialValue: '100',
            validator: (value) {
              if (int.tryParse(value) == null || int.parse(value) < 1 || int.parse(value) >100 ) {
                return 'Please enter a valid value (1-100)';
              }
            },
            onSaved: (value) {
              setState(() {
                _brewTemperatureCelsius = int.parse(value);
              });
            },
            keyboardType: TextInputType.number),
        TextFormField(
            decoration: InputDecoration(
                labelText: 'Enter Steep Timings', hintText: 'Enter in seconds, comma-separated.  First value is rinse.'),
            initialValue: '10,5,10,30',
            validator: (value) {
              if (value.split(',').length < 2  ) {
                return 'Please enter a valid set of comma-separated integers.';
              }

              try {
                value.replaceAll(' ', '').split(',').map((str) => int.parse(str));
              } on FormatException catch (err) {
                return 'Please enter a valid set of comma-separated integers.';
              }

              return null;
            },
            onSaved: (value) {
              setState(() {
                _steepTimings = value.replaceAll(' ', '').split(',').map((str) => max(int.parse(str), 0)).toList();
              });
            },
            keyboardType: TextInputType.number),
        RaisedButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: new Text('Add Brew Profile'),
            onPressed: () async {await addNewBrewProfileFormSubmit(Provider.of<TeaCollectionModel>(context, listen: false));})
      ]),
    );
  }

  void addNewBrewProfileFormSubmit(TeaCollectionModel teaCollection) async {
    bool defaultToFavorite =_tea.brewProfiles.length == 0;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      FocusScope.of(context).unfocus(); //Dismiss the keyboard
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Adding new brew profile...')));
      await teaCollection.putBrewProfile(BrewProfile(_name, _nominalRatio, _brewTemperatureCelsius, _steepTimings, defaultToFavorite), _tea);
      Navigator.pop(context);
    }
  }
}
