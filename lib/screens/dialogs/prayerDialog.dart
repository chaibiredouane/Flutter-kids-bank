import 'package:first/models/kidModel.dart';
import 'package:flutter/material.dart';

class PrayerDialog extends StatefulWidget {
  const PrayerDialog(this.kid) : super();
  final Kid kid;

  @override
  _PrayerDialogState createState() => _PrayerDialogState();
}

class _PrayerDialogState extends State<PrayerDialog> {
  List<Map<String, bool>> _values = [
    {'fajr': true},
    {'dhuhr': false},
    {'asr': true},
    {'maghrib': false},
    {'isha': true}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.baseline,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          for (int i = 0; i <= _values.length - 1; i++)
            ListTile(
              title: Text(
                _values[i].entries.first.key,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.black38),
              ),
              leading: Switch(
                value: _values[i].entries.first.value,
                onChanged: (bool value) {
                  setState(() {
                    _preLocation(context);
                    _values[i] = {_values[i].entries.first.key: value};
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}

ThemeData _buildShrineTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: _shrineColorScheme,
    toggleableActiveColor: shrinePink400,
    accentColor: shrineBrown900,
    primaryColor: shrinePink100,
    buttonColor: shrinePink100,
    scaffoldBackgroundColor: shrineBackgroundWhite,
    cardColor: shrineBackgroundWhite,
    textSelectionColor: shrinePink100,
    errorColor: shrineErrorRed,
    buttonTheme: const ButtonThemeData(
      colorScheme: _shrineColorScheme,
      textTheme: ButtonTextTheme.normal,
    ),
    primaryIconTheme: _customIconTheme(base.iconTheme),
    textTheme: _buildShrineTextTheme(base.textTheme),
    primaryTextTheme: _buildShrineTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildShrineTextTheme(base.accentTextTheme),
    iconTheme: _customIconTheme(base.iconTheme),
  );
}

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: shrineBrown900);
}

TextTheme _buildShrineTextTheme(TextTheme base) {
  var copyWith = base.caption!.copyWith(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: defaultLetterSpacing,
  );
  return base
      .copyWith(
        caption: copyWith,
        button: base.button!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: shrineBrown900,
        bodyColor: shrineBrown900,
      );
}

const ColorScheme _shrineColorScheme = ColorScheme(
  primary: shrinePink100,
  primaryVariant: shrineBrown900,
  secondary: shrinePink50,
  secondaryVariant: shrineBrown900,
  surface: shrineSurfaceWhite,
  background: shrineBackgroundWhite,
  error: shrineErrorRed,
  onPrimary: shrineBrown900,
  onSecondary: shrineBrown900,
  onSurface: shrineBrown900,
  onBackground: shrineBrown900,
  onError: shrineSurfaceWhite,
  brightness: Brightness.light,
);

const Color shrinePink50 = Color(0xFFFEEAE6);
const Color shrinePink100 = Color(0xFFFEDBD0);
const Color shrinePink300 = Color(0xFFFBB8AC);
const Color shrinePink400 = Color(0xFFEAA4A4);

const Color shrineBrown900 = Color(0xFF442B2D);
const Color shrineBrown600 = Color(0xFF7D4F52);

const Color shrineErrorRed = Color(0xFFC5032B);

const Color shrineSurfaceWhite = Color(0xFFFFFBFA);
const Color shrineBackgroundWhite = Colors.white;

const defaultLetterSpacing = 0.03;

final _formKey = GlobalKey<FormState>();
String error = '';
TextEditingController _nameFieldController = TextEditingController();
TextEditingController _textFieldController = TextEditingController();

Future<void> _displayTextInputDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('TextField in Dialog'),
        content: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                controller: _textFieldController,
                decoration: InputDecoration(hintText: "Text Field in Dialog"),
              ),
              TextField(
                controller: _nameFieldController,
                decoration: InputDecoration(hintText: "Test"),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('CANCEL'),
            onPressed: () {
              _preLocation(context);
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              print(_textFieldController.text);
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

Map<String, bool> prayerList = {
  'Fajr': false,
  'Dhuhr': false,
  'Asr': false,
  'maghrib': false,
  'Isha': false,
};

Future<dynamic> _preLocation(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Prayers'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context, null);
                  },
                  child: Text('Cancle'),
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context, prayerList);
                    print(prayerList);
                  },
                  child: Text('Done'),
                ),
              ],
              content: Container(
                width: double.minPositive,
                height: 300,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: prayerList.length,
                  itemBuilder: (BuildContext context, int index) {
                    String _key = prayerList.keys.elementAt(index);
                    return CheckboxListTile(
                      value: prayerList[_key],
                      title: Text(_key),
                      onChanged: (val) {
                        setState(() {
                          prayerList[_key] = val!;
                        });
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      });
}
