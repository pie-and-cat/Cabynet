// A screen that allows users to take a picture using a given camera.
import 'dart:async';
import 'dart:io';

import 'package:cabynet/extension.dart';
import 'package:cabynet/json_save.dart';
import 'package:camera/camera.dart';
import 'package:cabynet/parser.dart';
import 'package:flutter/material.dart';
//import 'globals.dart' as globals;
import 'main.dart';
import 'month_view_page.dart';
import 'ocr_link.dart';
import 'manual_prescription_form.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.

            final image = await _controller.takePicture();
            //K89146132788957
            OcrLink? o = OcrLink.getInstance();
            String response = await o?.ocrQuery(image.path,"K89146132788957");
            Prescription? presc = parse(response);
            if(presc == null){
              await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context)  => NewApp(),
                  ),
              );
            }else{
              JsonSave save = JsonSave();
              save.addPrescription(presc);
              save.save();
            }


            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  String imagePath;

  OcrLink? o = OcrLink.getInstance();
  late Future<dynamic>? response = notNull(o, imagePath);
  late Prescription? presc = parse(response.toString());

  static Future<dynamic>? notNull(OcrLink? o, String imagePath){
    if(o != null){
      return o.ocrQuery(imagePath,"K89146132788957");
    }

  }
  DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  String test(int val){
    if(val == 0){
      return "yes!";
    }
      return "no";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Take a picture!")),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body:Column(
        children:
        [Image.file(File(imagePath)),
          ElevatedButton(
            onPressed: () => context.pushRoute(NewApp()),
            child: Text("Add another Prescription?"),
          ),
          ElevatedButton(
            onPressed: () => context.pushRoute(MonthViewPageDemo()),
            child: Text("Calender View"),
          ),],
      )

    );
  }
}