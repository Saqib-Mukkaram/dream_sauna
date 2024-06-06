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
    final RenderRepaintBoundary? boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      throw Exception("Boundary is null");
    }

    final ui.Image image = await boundary.toImage();
    final ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png) as ByteData;
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 8,
              child: RepaintBoundary(
                key: globalKey,
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomCenter,
                          colors: [
                            ui.Color.fromARGB(255, 245, 166, 35),
                            ui.Color.fromARGB(255, 242, 191, 58),
                            ui.Color.fromARGB(255, 255, 220, 94),
                            ui.Color.fromARGB(255, 255, 194, 71),
                          ],
                          stops: const [
                            0.1,
                            0.3,
                            0.7,
                            1.0
                          ])),
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, top: 8, bottom: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                File(widget.qrCode.path),
                                fit: BoxFit.contain,
                                height: 300,
                                width: 300,
                              ),
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                widget.username,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Email: ",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                widget.email,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Address: ",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Text(
                                widget.bussinessAddress,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              final Uint8List image = await captureWidget();
              // Save the PNG to a temporary file
              final tempDir = await getTemporaryDirectory();
              final tempFile = File('${tempDir.path}/image.png');
              await tempFile.writeAsBytes(image);

              // Create an XFile from the captured image
              final XFile shareFile = XFile(tempFile.path);

              // Share the XFile using Share.shareXFiles
              await Share.shareXFiles(
                [shareFile],
              );
            } catch (e) {
              print(e);
              // Handle error accordingly
            }
          },
          child: Icon(Icons.share),
        ));
  }
}
