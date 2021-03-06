import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List namaznames = [
    'Fajr',
    'Sunrise',
    'Dhuhr',
    'Asr',
    'Sunset',
    'Maghrib',
    'Isha'
  ];
  DateTime _currentdate = DateTime.now();
  String currmonth = '';
  String currdate = '';
  String curryear = '';
  String hijri='';
  //  String url = "http://api.aladhan.com/v1/hijriCalendarByCity?city=Karachi&country=Pakistan&method=1&month=10&year=1441";
  String name;
  List data;

  initializedate() {
    setState(() {
      currmonth = DateFormat.M().format(_currentdate);
      currdate = DateFormat.d().format(_currentdate);
      curryear = DateFormat.y().format(_currentdate);
    });
  }

  Future makeRequestsingleitem() async {
    String url =
        "http://api.aladhan.com/v1/calendarByCity?city=Karachi&country=Pakistan&method=&month=$currmonth&year=$curryear";
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var extractdata = JsonDecoder().convert(response.body);
    int todaydate = int.parse(currdate) - 1;
    data = extractdata["data"];

    print(data[todaydate]['date']['readable']);

    setState(() {});
  }

  Future _selectdate(BuildContext cntxt) async {
    final DateTime _selDate = await showDatePicker(
      context: cntxt,
      initialDate: _currentdate,
      firstDate: DateTime(2008),
      lastDate: DateTime(2050),
    );
    if (_selDate != null) {
      setState(() {
        _currentdate = _selDate;
      });
      initializedate();
      makeRequestsingleitem();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializedate();
    makeRequestsingleitem();
  }

  @override
  Widget build(BuildContext context) {
    String _formattedDate = DateFormat.yMMMEd().format(_currentdate);
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        centerTitle: true,
        backgroundColor: Colors.teal[800],
        title: Text("Namaz Timings",),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                _selectdate(context);
              }),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(

              colors: [Colors.teal[200], Colors.white],
              begin: Alignment.centerRight,
              end: Alignment.centerLeft
              ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            Container(
              child: Text(
                'Namaz Timings',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
            ),
            SizedBox(height: 5),
            Container(
              child: Text(
                'Date: ' + _formattedDate,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.teal[800],
                      ),
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data == null ? 0 : namaznames.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      leading: Text(namaznames[i],
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.teal[800],
                              fontWeight: FontWeight.w600)),
                      trailing: Text(
                          data[int.parse(currdate) - 1]['timings']
                              [namaznames[i]],
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
