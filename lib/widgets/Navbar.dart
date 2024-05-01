import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:math';
import 'dart:typed_data';

import 'package:dream_sauna/utils/image_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dream_sauna/pages/profile_page.dart';
import 'package:dream_sauna/auth/splash.dart';
import 'package:http/http.dart' as http;
import 'package:dream_sauna/services/service.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class NavBar extends StatefulWidget {
  List userData;

  NavBar({Key? key, required this.userData}) : super(key: key);
  @override
  void initState() {
    print(userData);
  }

  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  WidgetsToImageController _captureController = WidgetsToImageController();
  var name;
  var email;
  var profileImage;
  bool loader = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getuser();
    });
  }

  Future<void> captureAndShare(XFile qrCode, String username) async {
    Completer<void> completer = Completer<void>();

    WidgetsToImage(
      controller: _captureController,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Image.file(
              File(qrCode.path),
              fit: BoxFit.cover,
              width: 90,
              height: 90,
            ),
            Text(username),
          ],
        ),
      ),
    );

    final pngbytes = await _captureController.capture() as Uint8List;
    final fileForShare = XFile.fromData(pngbytes);
    Share.shareXFiles([fileForShare], text: 'Qr Code');

    // Complete the Future
    completer.complete();

    // Wait for the capturing process to complete
    await completer.future;
  }

  fileFromImageUrl(String url, String userName) async {
    final response = await http.get(
      Uri.parse(url),
    );

    final documentDirectory = await getApplicationDocumentsDirectory();

    var randomNumber = Random();

    final file = File(
      join(
        documentDirectory.path,
        "${randomNumber.nextInt(100)}_$userName.png",
      ),
    );

    file.writeAsBytesSync(response.bodyBytes);

    return XFile(file.path);
  }

  getuser() async {
    setState(() {
      loader = true;
    });
    await UserService().getUser().then((value) {
      name = value["data"]["name"];
      email = value["data"]["email"];
      profileImage = value["data"]["profile_image"];
      setState(() {
        loader = false;
      });
    });
  }

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  profileImage,
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF099BBB),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () => {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ProfilePage()))
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share'),
            onTap: () async {
              await UserService().getUser().then((value) async {
                var qrCode = value["data"]["qrcode_url"];
                var username = value["data"]["name"];
                // var name = value["data"]["name"];
                var email = value["data"]["email"];
                // var phone = value["data"]["phone"];
                // var address = value["data"]["address"];
                // var businessName = value["data"]["business_name"];
                var businessAddress = value["data"]["business_address"];
                var type = value["data"]["type"];
                XFile shareFile = await fileFromImageUrl(qrCode, username);
                Get.to(ImageShare(
                  username: username,
                  qrCode: shareFile,
                  email: email,
                  // phone: phone,
                  // address: address,
                  // businessName: businessName,
                  bussinessAddress: businessAddress,
                  type: type,
                ));
                // Call captureAndShare function and wait for it to complete
                // await captureAndShare(shareFile, username);
              });
            },
          ),
          Divider(),
          // ListTile(
          //   leading: Icon(Icons.settings),
          //   title: Text('Settings'),
          //   onTap: () => null,
          // ),
          // ListTile(
          //   leading: Icon(Icons.description),
          //   title: Text('Policies'),
          //   onTap: () => null,
          // ),
          // Divider(),
          ListTile(
            title: Text('Logout'),
            leading: Icon(Icons.exit_to_app),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              SharedPreferences.getInstance();
              prefs.clear();

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => splachScreen()),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
