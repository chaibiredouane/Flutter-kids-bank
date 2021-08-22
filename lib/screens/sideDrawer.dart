import 'package:first/models/user.dart';
import 'package:first/services/authentication.dart';
import 'package:first/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    return Container(
      child: SafeArea(
        child: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(user!.displayName != null
                    ? user.displayName.toString()
                    : "Redouane CHAIBI"),
                accountEmail: Text(user.email.toString()),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/redouane.jpg'),
                  radius: 50,
                ),
              ),
              ListTile(
                title: Text('Accueil'),
                leading: Icon(Icons.home),
                onTap: () => Navigator.pushNamed(context, '/accueil'),
              ),
              ListTile(
                title: Text('Kids'),
                leading: Icon(Icons.family_restroom_outlined),
                onTap: () => Navigator.pushNamed(context, '/kids'),
              ),
              ListTile(
                title: Text('Products'),
                leading: Icon(Icons.list_alt_outlined),
                onTap: () => Navigator.pushNamed(context, '/products'),
              ),
              ListTile(
                title: Text('Logout'),
                leading: Icon(Icons.logout),
                onTap: () async {
                  await AuthenticationService().signOut();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
