import 'dart:math';

import 'package:firstapp/models/brew_profile.dart';
import 'package:firstapp/models/tea.dart';
import 'package:firstapp/models/tea_collection.dart';
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
        title: Text('Add New Brew Profile'),
      ),
      body: AddNewBrewProfileForm(this._tea),
    );
  }
}

class EditBrewProfile extends StatelessWidget {
  final Tea _tea;
  final BrewProfile _brewProfile;

  EditBrewProfile(this._tea, this._brewProfile);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Existing Brew Profile'),
      ),
      body: EditBrewProfileForm(this._tea, this._brewProfile),
    );
  }
}

abstract class BrewProfileForm extends StatefulWidget {

}

class AddNewBrewProfileForm extends BrewProfileForm {
  final Tea _tea;

  AddNewBrewProfileForm(this._tea);

  @override
  _BrewProfileFormState createState() => new _AddBrewProfileFormState(_tea);
}

class EditBrewProfileForm extends BrewProfileForm {
  final Tea _tea;
  final BrewProfile _brewProfile;

  EditBrewProfileForm(this._tea, this._brewProfile);


  @override
  _BrewProfileFormState createState() => new _EditBrewProfileFormState(_tea, _brewProfile);
}

class _AddBrewProfileFormState extends _BrewProfileFormState {
  bool editExisting = false;
  _AddBrewProfileFormState(Tea tea) : super(tea);
}

class _EditBrewProfileFormState extends _BrewProfileFormState {
  bool editExisting = true;
  _EditBrewProfileFormState(Tea tea, BrewProfile brewProfile) : super(tea, brewProfile.name, brewProfile.nominalRatio, brewProfile.brewTemperatureCelsius, brewProfile.steepTimings);
}

class _BrewProfileFormState extends State<BrewProfileForm> {
  final _formKey = GlobalKey<FormState>();
  bool editExisting;

  final Tea _tea;

  String _name;
  int _nominalRatio;
  int _brewTemperatureCelsius;
  List<int> _steepTimings = [];

  _BrewProfileFormState(this._tea, [this._name = '', this._nominalRatio = 15, this._brewTemperatureCelsius = 100, this._steepTimings]);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: new ListView(children: <Widget>[
        TextFormField(
            enabled: !this.editExisting,
            decoration: InputDecoration(
                labelText: 'Enter Profile Name', hintText: ''),
            initialValue: this._name,
            validator: (value) {
              value = value.trim();
              if (value.isEmpty) {
                return 'Please enter a name for this profile';
              } else if (!this.editExisting && _tea.brewProfiles.where((brewProfile) => brewProfile.name == value).length > 0) {
                return 'A brew profile named $value already exists for this tea';
              }

              return null;
            },
            onSaved: (value) {
              setState(() {
                value = value.trim();
                _name = value.trim();
              });
            },
            keyboardType: TextInputType.text),
        TextFormField(
            decoration: InputDecoration(
                labelText: 'Enter Ratio', hintText: 'Enter x to represent 1:x leaf:water'),
            initialValue: this._nominalRatio.toString(),
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
            initialValue: this._brewTemperatureCelsius.toString(),
            validator: (value) {
              if (int.tryParse(value) == null || int.parse(value) < 1 || int.parse(value) >100 ) {
                return 'Please enter a valid value (1-100)';
              }

              return null;
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
            initialValue: _steepTimings != null && _steepTimings.length > 0 ? _steepTimings.join(',') : '',
            validator: (value) {
              if (value.split(',').length < 2  ) {
                return 'Please enter a valid set of comma-separated integers.';
              }

              try {
                value.replaceAll(' ', '').split(',').where((str) => str != '').map((str) => int.parse(str));
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
            child: new Text('Save Brew Profile'),
            onPressed: () async {await brewProfileFormSubmit(Provider.of<TeaCollectionModel>(context, listen: false), edit: this.editExisting);})
      ]),
    );
  }

  void brewProfileFormSubmit(TeaCollectionModel teaCollection, {edit = false}) async {
    bool defaultToFavorite = !_tea.hasCustomBrewProfiles || _tea.defaultBrewProfile.name == _name;
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      FocusScope.of(context).unfocus(); //Dismiss the keyboard
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('Adding new brew profile...')));
      await teaCollection.updateBrewProfile(BrewProfile(_name, _nominalRatio, _brewTemperatureCelsius, _steepTimings, defaultToFavorite), _tea);
      Navigator.pop(context);
    }
  }
}
