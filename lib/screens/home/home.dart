import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/home/settings_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:brew_crew/screens/home/brew_list.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/models/brew.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser>(context);

    void _showSettingsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Provider.value(
                value: user,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 60.0),
                  child: const SettingsForm(),
                ));
          });
    }

    return StreamProvider<List<Brew>>.value(
      value: DataBaseService().brews,
      initialData: const [],
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: const Text('Brew crew'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: [
            TextButton.icon(
              icon: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              label: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
            TextButton.icon(
              onPressed: () => _showSettingsPanel(),
              icon: const Icon(
                Icons.settings,
                color: Colors.black,
              ),
              label: const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image:AssetImage('assets/coffee_bg.png'),
              fit: BoxFit.cover)
          ),
          child: const BrewList()),
      ),
    );
  }
}
