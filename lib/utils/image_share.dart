import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ImageShare extends StatefulWidget {
  final XFile qrCode;
  final String username;
  final type;
  final String email;
  final String bussinessAddress;

  ImageShare(
      {required this.username,
      required this.qrCode,
      required this.type,
      required this.email,
      required this.bussinessAddress,
      super.key});

  @override
  State<ImageShare> createState() => _ImageShareState();
}

class _ImageShareState extends State<ImageShare> {
  final GlobalKey globalKey = GlobalKey();

  Future<Uint8List> captureWidget() async {
    final RenderRepaintBoundary boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;

    final ui.Image image = await boundary.toImage();

    final ByteData byteData =
        await image.toByteData(format: ui.ImageByteFormat.png) as ByteData;

    final Uint8List pngBytes = byteData.buffer.asUint8List();

    return pngBytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Share Card"),
        ),
        body: Center(
          child: RepaintBoundary(
            key: globalKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Card(
                  elevation: 8,
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                            colors: [
                          ui.Color.fromARGB(255, 9, 155, 187),
                          ui.Color.fromARGB(255, 7, 169, 206),
                          ui.Color.fromARGB(255, 102, 227, 255),
                          ui.Color.fromARGB(255, 0, 208, 255),
                        ],
                            stops: const [
                          0.1,
                          0.3,
                          0.9,
                          1.0
                        ])),
                    height: 575,
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16),
                              child: Image.file(
                                File(widget.qrCode.path),
                                fit: BoxFit.cover,
                                height: 300,
                                width: 300,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.type == 'merchant'
                                      ? "Merchant: "
                                      : "Contractor: ",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  widget.username,
                                  style: TextStyle(
                                      fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Email: ",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  widget.email,
                                  style: TextStyle(
                                      fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Address: ",
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      overflow: TextOverflow.ellipsis),
                                ),
                                Text(
                                  widget.bussinessAddress,
                                  style: TextStyle(
                                      fontSize: 24, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final Uint8List image = await captureWidget();
            // Save the PNG to a temporary file
            final tempDir = await getTemporaryDirectory();
            final tempFile = File('${tempDir.path}/image.png');
            await tempFile.writeAsBytes(image);

            // Create an XFile from the captured image
            final XFile shareFile = XFile(tempFile.path);
            // XFile.fromData(image, name: 'ShareCard.png');

            // Share the XFile using Share.shareXFiles
            await Share.shareXFiles(
              [shareFile],
            );
            // final Uint8List image = await captureWidget();
            // final sharefile = XFile.fromData(image, name: 'ShareCard.png',);

            // await Share.shareXFiles([sharefile],text: "Share");
          },
          child: Icon(Icons.share),
        ));
  }
}
