
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:brew_crew/shared/loading.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // form values
  String? _currrentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    return StreamBuilder<UserData>(
        stream: DataBaseService(
          uid: user.uid,
        ).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(children: <Widget>[
                const Text(
                  'Update your brew settings',
                  style: TextStyle(fontSize: 18.0),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  initialValue: _currrentName ?? userData?.name,
                  decoration: textInputDecoration,
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) {
                    setState(() {
                      _currrentName = val;
                    });
                  },
                ),
                const SizedBox(
                  height: 20.0,
                ),
                DropdownButtonFormField(
                  value: _currentSugars ?? userData?.sugars,
                  decoration: textInputDecoration,
                  hint: const Text('Number of sugars'),
                  items: sugars.map((sugar) {
                    return DropdownMenuItem(
                      child: Text('$sugar sugars'),
                      value: sugar,
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _currentSugars = '$val';
                    });
                  },
                ),
                Slider(
                    min: 100.0,
                    max: 900,
                    divisions: 8,
                    value: (_currentStrength ?? userData!.strength).toDouble(),
                    activeColor:
                        Colors.brown[_currentStrength ?? userData!.strength],
                    inactiveColor:
                        Colors.brown[_currentStrength ?? userData!.strength],
                    onChanged: (val) {
                      setState(() {
                        _currentStrength = val.round();
                      });
                    }),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.pink),
                    onPressed: () async {
                      // save those value
                      if (_formKey.currentState!.validate()) {
                        await DataBaseService(uid: user.uid).updateUserData(
                            _currentSugars ?? userData!.sugars,
                            _currrentName ?? userData!.name,
                            _currentStrength ?? userData!.strength);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ))
              ]),
            );
          } else {
            return const Loading();
          }
        });
  }
}
