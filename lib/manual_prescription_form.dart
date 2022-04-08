import 'package:flutter/material.dart';
import '../month_view_page.dart';
//import 'model.dart';
import 'app_colors.dart';
import 'extension.dart';
import 'widgets/add_event_widget.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:cabynet/json_save.dart';
import 'package:camera/camera.dart';
import 'package:cabynet/parser.dart';
import 'package:flutter/material.dart';
//import 'globals.dart' as globals;
import 'main.dart';
import 'ocr_link.dart';
import 'manual_prescription_form.dart';


class NewApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<NewApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Manual Prescription Form",
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String name = "";
  String rx = "";
  String amt = "";
  String unit = "";
  String timeframe = "";
  String qt = "";

  void _submit() {
    Prescription? np = parse("");
    np?.setPrescription(name, rx, amt, unit, timeframe, qt);
    JsonSave save = JsonSave();
    save.addPrescription(np!);
    save.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manual Pescription Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    keyboardType: TextInputType.name,
                    onFieldSubmitted: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty ) {
                        return 'Please put in your name.';
                      }
                    },
                  ),
                  // this is where the
                  // input goes
                  TextFormField(
                    decoration: InputDecoration(labelText: 'rx number'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please put in a rx number.';
                      }
                    },
                    onFieldSubmitted: (value) {
                      setState(() {
                        rx = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'How many pills you take?'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please put the number of pills you take';
                      }
                    },

                    onFieldSubmitted: (value) {
                      setState(() {
                        amt = value;
                      });
                    },
                  ),TextFormField(
                      decoration: InputDecoration(labelText: 'What is your dosage?'),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please put in your dosage';
                        }
                      },
                    onFieldSubmitted: (value) {
                      setState(() {
                        unit = value;
                      });
                    },
                  ),TextFormField(
                    decoration: InputDecoration(labelText: 'When do you take your medicine?'),
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please put in when you take your medicine';
                      }
                    },
                    onFieldSubmitted: (value) {
                      setState(() {
                        timeframe = value;
                      });
                    },
                  ),TextFormField(
                    decoration: InputDecoration(labelText: 'How many pills are in your prescription?'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please put the amount of pills in your prescription';
                      }
                    },
                    onFieldSubmitted: (value) {
                      setState(() {
                        qt = value;
                      });
                    },
                  ),
                  RaisedButton(
                    onPressed: _submit,
                    child: Text("submit"),
                  ),
                  ElevatedButton(
                    onPressed: () => context.pushRoute(NewApp()),
                    child: Text("Add another Prescription?"),
                  ),
                  ElevatedButton(
                    onPressed: () => context.pushRoute(MonthViewPageDemo()),
                    child: Text("Calender View"),
                  ),

                ],
              ),
            ),
            // this is where
            // the form field
            // are defined
          ],
        ),
      ),
    );
  }
}