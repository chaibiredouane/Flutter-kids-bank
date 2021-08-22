import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first/models/kidModel.dart';
import 'package:first/models/mathModel.dart';
import 'package:first/services/mathService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Math extends StatefulWidget {
  const Math(this.kid) : super();
  final Kid kid;

  @override
  _MathState createState() => _MathState();
}

  final noteController = TextEditingController();
class _MathState extends State<Math> {
  Widget bodyData() => StreamBuilder<List<MathModel>>(
      stream: MathService().maths,
      builder: (context, snapshot) {
        return Flexible(
          child: Card(
            color: Colors.transparent,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                    headingTextStyle: TextStyle(
                        fontSize: 10, height: 1.5, color: Colors.white),
                    dataTextStyle: TextStyle(
                        fontSize: 10, height: 1.5, color: Colors.white),
                    columns: [
                      DataColumn(label: Center(child: Text("Date"))),
                      DataColumn(label: Center(child: Text("Done"))),
                      DataColumn(label: Center(child: Text("Note"))),
                    ],
                    rows: snapshot.data == null ? [] :
                          snapshot.data!.where((i) => widget.kid.uid == i.kidUid).map((e) => DataRow(cells: [
                              DataCell(Center(child: Text(e.date!))),
                              DataCell(Center(
                                  child: (e.done!)
                                      ? Icon(Icons.verified_user,
                                          color: Colors.green)
                                      : Icon(Icons.cancel, color: Colors.red))),
                              DataCell(Center(child: Text(e.note!))),
                            ]))
                        .toList()),
              ),
            ),
          ),
        );
      });

Future<dynamic> _addMath(BuildContext context, mathList) async {
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
                      Navigator.pop(context, mathList);
                    },
                    child: Text('Add'),
                  ),
                ],
                content: Container(
                  width: double.minPositive,
                  height: 350,
                  child: Column(
                    children: [
                      TextFormField(
                            controller: noteController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), ],
                            decoration:InputDecoration( labelText: "Note /20 ",
                  hintText: "Note /20",
                  icon: Icon(Icons.iso_rounded))),
                          
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: mathList.length,
                        itemBuilder: (BuildContext context, int index) {
                          String _key = mathList.keys.elementAt(index);
                          return CheckboxListTile(
                            value: mathList[_key],
                            title: Text(
                              _key,
                            ),
                            onChanged: (val) {
                              setState(() {
                                mathList[_key] = val!;
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
        Map<String, bool> mathList = {
      'Done': false,
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
            SizedBox(
              height: 10,
            ),
            bodyData(),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () =>
                  {_navigateAndDisplaySelection(context, widget.kid, mathList)},
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

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

  void _navigateAndDisplaySelection(BuildContext context, kid, mathList) async {
    final result = await _addMath(context, mathList);
    if (result != null) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('$result')));
      MathService().persistMath(kid.uid, DateFormat("yyyy-MM-dd").format(_date),
          mathList['Done'],   noteController.value.text + '/20');
    }
  }
}

var _data = <MathModel>[
  MathModel(
      '1',
      'LGHKhlgFnumUtB2WDurQ',
      DateFormat("yyyy-MM-dd").format(DateTime.now()),
      true,
      '18/20',
      Timestamp.fromDate(DateTime.now())),
  MathModel(
      '2',
      'LGHKhlgFnumUtB2WDurQ',
      DateFormat("yyyy-MM-dd").format(DateTime.now()),
      true,
      '19/20',
      Timestamp.fromDate(DateTime.now())),
  MathModel(
      '2',
      'LGHKhlgFnumUtB2WDurQ',
      DateFormat("yyyy-MM-dd").format(DateTime.now()),
      true,
      '20/20',
      Timestamp.fromDate(DateTime.now())),
  MathModel(
      '10',
      'LGHKhlgFnumUtB2WDurQ',
      DateFormat("yyyy-MM-dd").format(DateTime.now()),
      false,
      '',
      Timestamp.fromDate(DateTime.now())),
  MathModel(
      '12',
      'uQDKP5goQwSoAVmUQb04',
      DateFormat("yyyy-MM-dd").format(DateTime.now()),
      false,
      '',
      Timestamp.fromDate(DateTime.now())),
];
