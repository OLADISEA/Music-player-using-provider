import 'package:flutter/material.dart';

import '../pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          //logo
          DrawerHeader(
              child: Center(
                child: Icon(
                  Icons.music_note,
                  size: 40,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              )),

          //home tile
          Padding(
              padding: EdgeInsets.only(left: 25,top: 25),
              child: ListTile(
                title: Text('H O M E'),
                leading: Icon(Icons.home),
                onTap: () => Navigator.pop(context),
              ),
          ),

          //settings tile
          Padding(
            padding: EdgeInsets.only(left: 25,top: 25),
            child: ListTile(
              title: Text('S E T T I N G S'),
              leading: Icon(Icons.settings),
              onTap: () {
                //pop the drawer
                Navigator.pop(context);
                // move to the setting page
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const SettingsPage()));
              },
            ),
          )
        ],
      ),
    );
  }
}
