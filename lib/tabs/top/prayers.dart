import 'package:first/models/kidModel.dart';
import 'package:first/models/prayersModel.dart';
import 'package:first/services/prayerService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Prayers extends StatefulWidget {
  const Prayers(this.kid) : super();
  final Kid kid;

  @override
  _PrayersState createState() => _PrayersState();
}

class _PrayersState extends State<Prayers> {
  Widget bodyData() => StreamBuilder<List<Prayer>>(
    stream: PrayerService().prayers,
    builder: (context, snapshot) {
      return Flexible(
            child: Card(
              color: Colors.transparent,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                      headingTextStyle:
                          TextStyle(fontSize: 10, height: 1.5, color: Colors.white),
                      dataTextStyle:
                          TextStyle(fontSize: 10, height: 1.5, color: Colors.white),
                      columns: [
                        DataColumn(label: Center(child: Text("Date"))),
                        DataColumn(label: Center(child: Text("Fajr"))),
                        DataColumn(label: Center(child: Text("Dhuhr"))),
                        DataColumn(label: Center(child: Text("Asr"))),
                        DataColumn(label: Center(child: Text("Maghrib"))),
                        DataColumn(label: Center(child: Text("Isha"))),
                        DataColumn(label: Center(child: Text("Solde"))),
                      ],
                      rows: snapshot.data == null ? [] :
                          snapshot.data!.where((i) => widget.kid.uid == i.kidUid).map((e) => DataRow(cells: [
                                DataCell(Text(e.date!)),
                                DataCell(Center(
                                    child: (e.fajr!)
                                        ? Icon(Icons.verified_user,
                                            color: Colors.green)
                                        : Icon(Icons.cancel, color: Colors.red))),
                                DataCell(Center(
                                    child: (e.dhuhr!)
                                        ? Icon(Icons.verified_user,
                                            color: Colors.green)
                                        : Icon(Icons.cancel, color: Colors.red))),
                                DataCell(Center(
                                    child: (e.asr!)
                                        ? Icon(Icons.verified_user,
                                            color: Colors.green)
                                        : Icon(Icons.cancel, color: Colors.red))),
                                DataCell(Center(
                                    child: (e.maghrib!)
                                        ? Icon(Icons.verified_user,
                                            color: Colors.green)
                                        : Icon(Icons.cancel, color: Colors.red))),
                                DataCell(Center(
                                    child: (e.isha!)
                                        ? Icon(Icons.verified_user,
                                            color: Colors.green)
                                        : Icon(Icons.cancel, color: Colors.red))),
                                DataCell(Center(child: Text(e.total.toString()))),
                              ]))
                          .toList()),
                ),
              ),
            ),
          );
    }
  );

  DateTime _date = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    DateTime? _datePicker = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2020),
        lastDate: DateTime(2050),
        builder: (context, child){
          return SingleChildScrollView(child: child,)
        });
    if (_datePicker != null && _datePicker != _date) {
      setState(() {
        _date = _datePicker;
      });
    }
  }

  Future<dynamic> _addPrayers(BuildContext context, prayerList) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(DateFormat("yyyy-MM-dd").format(_date)),
                    Container(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _selectDate(context);
                          });
                        },
                        icon: Icon(Icons.calendar_today),
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context, null);
                    },
                    child: Text('Cancle'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context, prayerList);
                    },
                    child: Text('Add'),
                  ),
                ],
                content: Container(
                  width: double.minPositive,
                  height: 350,
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: prayerList.length,
                        itemBuilder: (BuildContext context, int index) {
                          String _key = prayerList.keys.elementAt(index);
                          return CheckboxListTile(
                            value: prayerList[_key],
                            title: Text(
                              _key,
                            ),
                            onChanged: (val) {
                              setState(() {
                                prayerList[_key] = val!;
                              });
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, bool> prayerList = {
      'Fajr': false,
      'Dhuhr': false,
      'Asr': false,
      'Maghrib': false,
      'Isha': false,
    };
    return Center(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: "imageKid" + widget.kid.uid.toString(),
              child: CircleAvatar(
                backgroundImage: AssetImage(widget.kid.imageUrl!),
                radius: 70,
              ),
            ),
            bodyData(),
             SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () => {
                _navigateAndDisplaySelection(context, widget.kid, prayerList)
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateAndDisplaySelection(
      BuildContext context, kid, prayerList) async {
    final result = await _addPrayers(context, prayerList);
    if (result != null) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('$result')));
      Prayer item = Prayer(
          null,
          kid.uid,
          DateFormat("yyyy-MM-dd").format(DateTime.now()),
          prayerList['Fajr'],
          prayerList['Dhuhr'],
          prayerList['Asr'],
          prayerList['Maghrib'],
          prayerList['Isha'],
         0);
      PrayerService().persistPrayer(
          kid.uid,
          DateFormat("yyyy-MM-dd").format(_date),
          prayerList['Fajr'],
          prayerList['Dhuhr'],
          prayerList['Asr'],
          prayerList['Maghrib'],
          prayerList['Isha'],
          0);
    }
  }
}

