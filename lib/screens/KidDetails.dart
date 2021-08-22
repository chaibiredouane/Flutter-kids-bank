import 'package:first/models/kidModel.dart';
import 'package:first/tabs/top/math.dart';
import 'package:first/tabs/top/overview.dart';
import 'package:first/tabs/top/prayers.dart';
import 'package:first/tabs/top/reading.dart';
import 'package:flutter/material.dart';

class KidsDetails extends StatelessWidget {
  const KidsDetails(this.kid) : super();
  final Kid kid;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Color(0xff052555),
        appBar: AppBar(
          title: Text('Details : ' + kid.firstName! + ' ' + kid.lastName!),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Overview',
                icon: Icon(Icons.view_agenda),
              ),
              Tab(
                text: 'Prayers',
                icon: Icon(Icons.kayaking_sharp),
              ),
              Tab(
                text: 'Math',
                icon: Icon(Icons.calculate),
              ),
              Tab(
                text: 'Reading',
                icon: Icon(Icons.chrome_reader_mode_outlined),
              ),
            ],
          ),
        ),
        body: TabBarView(
            children: [Overview(kid), Prayers(kid), Math(kid), Reading(kid)]),
      ),
    );
  }
}
