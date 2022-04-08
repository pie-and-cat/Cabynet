import 'package:flutter/material.dart';

import '../../extension.dart';
import '../create_event_page.dart';
import '../day_view_page.dart';
import '../../month_view_page.dart';
import '../week_view_page.dart';
import '../../manual_prescription_form.dart';
import '../../camerainput.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'dart:io';

class MobileHomePage extends StatelessWidget {
  const MobileHomePage({
    Key? key,
    required this.camera,
  }) : super(key: key);
  final CameraDescription camera;



  @override


  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Cabynet"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () => context.pushRoute(TakePictureScreen(camera: camera)),
              child: Text("Add a Prescription"),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () =>  context.pushRoute(NewApp()),
    child: Text("Add a Prescription (Manually)"),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => context.pushRoute(MonthViewPageDemo()),
    child: Text("Month View"),
            ),
          ],
        ),
      ),
    );
  }
}
