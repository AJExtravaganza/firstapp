import 'package:firstapp/models/tea.dart';
import 'package:firstapp/models/tea_collection.dart';
import 'package:firstapp/models/tea_producer.dart';
import 'package:firstapp/models/tea_producer_collection.dart';
import 'package:firstapp/models/tea_production.dart';
import 'package:firstapp/models/tea_production_collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewTeaToStash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Tea to Stash'),
      ),
      body: StashAddNewTeaForm(),
    );
  }
}

class StashAddNewTeaForm extends StatefulWidget {
  @override
  _StashAddNewTeaFormState createState() => new _StashAddNewTeaFormState();
}

class _StashAddNewTeaFormState extends State<StashAddNewTeaForm> {
  final _formKey = GlobalKey<FormState>();

  TeaProducer _producer;
  TeaProduction _production;
  int _quantity;

  List<DropdownMenuItem<TeaProducer>> getProducerDropdownList(
      BuildContext context) {
    return Provider.of<TeaProducerCollectionModel>(context)
        .items
        .map((producer) => DropdownMenuItem(
              child: Text(producer.asString()),
              value: producer,
            ))
        .toList();
  }

  List<DropdownMenuItem<TeaProduction>> getProductionDropdownList(
      BuildContext context) {
    return Provider.of<TeaProductionCollectionModel>(context)
        .items
        .map((production) => DropdownMenuItem(
              child: Text(production.asString()),
              value: production,
            ))
        .where((dropdownListItem) =>
            (_producer == null || dropdownListItem.value.producer == _producer))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: new ListView(children: <Widget>[
        DropdownButtonFormField(
          hint: Text('Select Producer'),
          items: getProducerDropdownList(context),
          value: _producer,
          onChanged: (value) {
            setState(() {
              _producer = value;
              if (_production != null && _production.producer != _producer) {
                _production = null;
              }
            });
          },
          isExpanded: true,
        ),
        DropdownButtonFormField(
            hint: Text('Select Production'),
            items: getProductionDropdownList(context),
            value: _production,
            onChanged: (value) {
              setState(() {
                _production = value;
                _producer = _production.producer;
              });
            },
            isExpanded: true),
        TextFormField(
            decoration: InputDecoration(
                labelText: 'Enter Quantity', hintText: 'Quantity'),
            initialValue: '1',
            validator: (value) {
              if (int.tryParse(value) == null) {
                return 'Please enter a valid quantity';
              }
            },
            onSaved: (value) {
              setState(() {
                _quantity = int.parse(value);
              });
            },
            keyboardType: TextInputType.number),
        RaisedButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: new Text('Add to Stash'),
            onPressed: () {addNewTeaFormSubmit(Provider.of<TeaCollectionModel>(context, listen: false));})
      ]),
    );
  }

  void addNewTeaFormSubmit(TeaCollectionModel teaCollection) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      teaCollection.put(Tea(_quantity, _production));
      Navigator.pop(context);
    }
  }
}
