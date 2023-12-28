// ignore_for_file: camel_case_types, use_key_in_widget_constructors, non_constant_identifier_names, prefer_const_constructors, prefer_const_constructors_in_immutables, unnecessary_new

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class qrcode extends StatefulWidget {
  final String value1;
  final String value2;

  qrcode({required this.value1, required this.value2});

  @override
  State<qrcode> createState() => _qrcodeState();
}

class _qrcodeState extends State<qrcode> {
  final GlobalKey _screenshotKey = GlobalKey();
  ScreenshotController screenshotController = ScreenshotController();

  SaveToGallery() {
    screenshotController.capture().then((Uint8List? image) {
      saveScreenshot(image!);
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Image saved to gallery')));
  }

  saveScreenshot(Uint8List bytes) async {
    final name = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '_')
        .replaceAll(':', '_');
    await ImageGallerySaver.saveImage(bytes, name: name);
  }

  @override
  Widget build(BuildContext context) {
    String uniqueIdentifier = 'ㅤ'; // Your unique identifier here
    String qrCodeData = '$uniqueIdentifier${widget.value1}:${widget.value2}';

    return Screenshot(
      key: _screenshotKey,
      controller: screenshotController,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(30, 107, 107, 107),
          title: Text(
            'QR Code',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              QrImageView(
                data: qrCodeData,
                version: QrVersions.auto,
                size: 200.0,
              ),
              Text('District name: ${widget.value1}'),
              Text('Police station name: ${widget.value2}'),
              TextButton(
                onPressed: () {
                  SaveToGallery();
                },
                child: Text("Save QR"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
