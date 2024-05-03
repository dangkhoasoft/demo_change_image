import 'dart:io';
import 'dart:typed_data';
import 'package:change_image_profile/controlller/image_picker_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:change_image_profile/utils.dart';
import 'package:change_image_profile/add_resource/add_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
// save images // get link after saving
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Uint8List? _image;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void saveImage() async {
    String resp = await StoreData().saveData(file: _image!);
  }

  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ImagePickerController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Upload"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  controller.pickImage();
                },
                child: const Text('Pick Your Image'),
              ),
            ),
            Obx(() {
              return Container(
                child: controller.image.value.path == ''
                    ? const Icon(
                        Icons.camera,
                        size: 50,
                      )
                    : Image.file(File(controller.image.value.path)),
              );
            }),
            ElevatedButton(
                onPressed: () {
                  controller.uploadImageToFirebase();
                },
                child: const Text('Upload to Firebase  Storage'))
          ],
        ),
      ),
    );
  }
}
