import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/models/kidModel.dart';
import 'package:first/models/overviewModel.dart';
import 'package:first/services/overviewService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Overview extends StatelessWidget {
  const Overview(this.kid) : super();
  final Kid kid;

  Widget bodyData() => StreamBuilder<List<OverviewModel>>(
      stream: OverviewService().overviews,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');
        return Flexible(
          child: Card(
            color: Colors.transparent,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                    headingTextStyle: TextStyle(
                        fontSize: 10, height: 1.5, color: Colors.white),
                    dataTextStyle: TextStyle(
                        fontSize: 10, height: 1.5, color: Colors.white),
                    columns: [
                      DataColumn(label: Center(child: Text("Date"))),
                      DataColumn(label: Center(child: Text("Won"))),
                      DataColumn(label: Center(child: Text("Spent"))),
                      DataColumn(label: Center(child: Text("Solde")))
                    ],
                    rows: snapshot.data == null
                        ? []
                        : snapshot.data!
                            .where((i) => kid.uid == i.kidUid)
                            .map((e) => DataRow(cells: [
                                  DataCell(Center(child: Text(e.date!))),
                                  DataCell(
                                      Center(child: Text(e.won.toString()))),
                                  DataCell(
                                      Center(child: Text(e.spent.toString()))),
                                  DataCell(
                                      Center(child: Text(e.solde.toString()))),
                                ]))
                            .toList()),
              ),
            ),
          ),
        );
      });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: "imageKid" + kid.uid.toString(),
              child: CircleAvatar(
                backgroundImage: AssetImage(kid.imageUrl!),
                radius: 70,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  kid.solde.toString() + ' points',
                  style:
                      TextStyle(fontSize: 25, height: 1.5, color: Colors.white),
                ),
              ),
            ),
            bodyData(),
          ],
        ),
      ),
    );
  }
}

var _data = <OverviewModel>[
  OverviewModel(
      '1',
      'pb9PTDFlsVwBY9jyWkoh',
      DateFormat("yyyy-MM-dd").format(DateTime.now()),
      2,
      0,
      2,
      Timestamp.fromDate(DateTime.now())),
  OverviewModel(
      '2',
      'pb9PTDFlsVwBY9jyWkoh',
      DateFormat("yyyy-MM-dd")
          .format(DateTime.now().subtract(Duration(days: 1))),
      2,
      0,
      2,
      Timestamp.fromDate(DateTime.now())),
  OverviewModel(
      '3',
      'pb9PTDFlsVwBY9jyWkoh',
      DateFormat("yyyy-MM-dd")
          .format(DateTime.now().subtract(Duration(days: 2))),
      3,
      4,
      2,
      Timestamp.fromDate(DateTime.now())),
  OverviewModel(
      '21',
      'LGHKhlgFnumUtB2WDurQ',
      DateFormat("yyyy-MM-dd").format(DateTime.now()),
      2,
      0,
      2,
      Timestamp.fromDate(DateTime.now())),
  OverviewModel(
      '32',
      'LGHKhlgFnumUtB2WDurQ',
      DateFormat("yyyy-MM-dd")
          .format(DateTime.now().subtract(Duration(days: 1))),
      2,
      0,
      2,
      Timestamp.fromDate(DateTime.now())),
  OverviewModel(
      '23',
      'LGHKhlgFnumUtB2WDurQ',
      DateFormat("yyyy-MM-dd")
          .format(DateTime.now().subtract(Duration(days: 2))),
      3,
      4,
      2,
      Timestamp.fromDate(DateTime.now())),
  OverviewModel(
      '31',
      'uQDKP5goQwSoAVmUQb04',
      DateFormat("yyyy-MM-dd").format(DateTime.now()),
      2,
      0,
      2,
      Timestamp.fromDate(DateTime.now())),
  OverviewModel(
      '35',
      'uQDKP5goQwSoAVmUQb04',
      DateFormat("yyyy-MM-dd")
          .format(DateTime.now().subtract(Duration(days: 1))),
      2,
      0,
      2,
      Timestamp.fromDate(DateTime.now())),
  OverviewModel(
      '38',
      'uQDKP5goQwSoAVmUQb04',
      DateFormat("yyyy-MM-dd")
          .format(DateTime.now().subtract(Duration(days: 2))),
      3,
      4,
      2,
      Timestamp.fromDate(DateTime.now())),
];
