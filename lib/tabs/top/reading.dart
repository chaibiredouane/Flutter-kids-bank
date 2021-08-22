import 'package:first/common/constants.dart';
import 'package:first/models/kidModel.dart';
import 'package:first/models/mathModel.dart';
import 'package:first/models/readingModel.dart';
import 'package:first/services/mathService.dart';
import 'package:first/services/readingService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Reading extends StatefulWidget {
  const Reading(this.kid) : super();
  final Kid kid;

  @override
  _ReadingState createState() => _ReadingState();
}

  final titleController = TextEditingController();
  final progressController = TextEditingController();

    @override
  void dispose() {
    titleController.dispose();
    progressController.dispose();
  }

class _ReadingState extends State<Reading> {
  Widget bodyData() => StreamBuilder<List<ReadingModel>>(
      stream: ReadingService().readings,
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
                      DataColumn(label: Center(child: Text("Title"))),
                      DataColumn(label: Center(child: Text("Finished"))),
                      DataColumn(label: Center(child: Text("Progress"))),
                    ],
                    rows: snapshot.data == null ? [] :
                          snapshot.data!.where((i) => widget.kid.uid == i.kidUid).map((e) => DataRow(cells: [
                              DataCell(Center(child: Text(e.date!))),
                              DataCell(Center(child: Text(e.title!))),
                            DataCell(Center(
                                  child: (e.finished!)
                                      ? Icon(Icons.verified_user,
                                          color: Colors.green)
                                      : Icon(Icons.cancel, color: Colors.red))),
                            DataCell(Center(child: Text(e.progress!))),
                            ]))
                        .toList()),
              ),
            ),
          ),
        );
      });


void _navigateAndDisplaySelection(BuildContext context, kid, readingList) async {
    final result = await _addReading(context, readingList);
    if (result != null) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('$result')));
     ReadingService().persistReading(kid.uid, DateFormat("yyyy-MM-dd").format(_date), titleController.value.text, readingList['Finished'], progressController.value.text + '%');
    }
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

Future<dynamic> _addReading(BuildContext context, readingList) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: StatefulBuilder(
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
                            Navigator.pop(context, readingList);
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
                                  controller: titleController,
                                  decoration:InputDecoration( labelText: "Title",
                        hintText: "Title",
                        icon: Icon(Icons.iso_rounded))),
                            TextFormField(
                                  controller: progressController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), ],
                                  decoration:InputDecoration( labelText: "Progress %",
                        hintText: "Progress %",
                        icon: Icon(Icons.title))),
                                
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: readingList.length,
                              itemBuilder: (BuildContext context, int index) {
                                String _key = readingList.keys.elementAt(index);
                                return CheckboxListTile(
                                  value: readingList[_key],
                                  title: Text(
                                    _key,
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      readingList[_key] = val!;
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
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, bool> readingList = {
      'Finished': false,
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
                  {_navigateAndDisplaySelection(context, widget.kid, readingList)},
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
