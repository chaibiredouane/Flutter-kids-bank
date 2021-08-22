import 'package:first/screens/sideDrawer.dart';
import 'package:flutter/material.dart';

class Accueil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bank Kids by chaibi')),
      drawer: SideDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Image.asset(
              'assets/images/rayan.jpg',
              height: 150,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Image.asset(
              'assets/images/tasnim.jpg',
              height: 150,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Image.asset(
              'assets/images/sira.jpg',
              height: 150,
            ),
          )
        ],
      ),
    );
  }
}
