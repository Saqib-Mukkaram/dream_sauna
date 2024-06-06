import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dream_sauna/pages/edit_profile_page.dart';
import 'package:dream_sauna/services/service.dart';
import 'package:dream_sauna/utils/color.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var name;
  var email;
  var profileImage;
  var govtPhoto;
  var phone;
  var address;
  var businessName;
  var businessAddress;
  var businessDetail;
  bool loader = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getuser();
    });
  }

  getuser() async {
    setState(() {
      loader = true;
    });
    await UserService().getUser().then((value) {
      name = value["data"]["name"];
      email = value["data"]["email"];
      phone = value["data"]["phone"];
      address = value["data"]["address"];
      businessName = value["data"]["business_name"];
      businessAddress = value["data"]["business_address"];
      businessDetail = value["data"]["business_detail"];
      profileImage = value["data"]["profile_image"];
      govtPhoto = value["data"]["govt_photo"];
      setState(() {
        loader = false;
      });
    });
  }

  Widget build(BuildContext context) {
    // final user = UserPreferences.getUser();

    final image = profileImage.contains('http://')
        ? NetworkImage(profileImage)
        : FileImage(File(profileImage));
    if (govtPhoto == null) {
      govtPhoto = 'assets/images/placeholder.jpg';
    }

    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Column(
          children: [
            Container(
              // width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Container(
                    child: Column(
                      children: [
                        // Image(
                        //   image: NetworkImage(govtPhoto),
                        //   fit: BoxFit.cover,
                        //   width: MediaQuery.of(context).size.width,
                        //   height: MediaQuery.of(context).size.height * 0.25,
                        // ),
                      ],
                    ),
                  ),

                  // above icons
                  Positioned(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: myColor,
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // profile pitcure
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.14,
                    left: 25,
                    child: CircleAvatar(
                      radius: 40,
                      // backgroundColor: Colors.green,
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.black12,
                        child: CircleAvatar(
                          radius: 37,
                          backgroundImage: NetworkImage(profileImage),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: myColor)),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.mail,
                              size: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(email,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone_enabled_outlined,
                              size: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            // Text(phone,
                            //     style: TextStyle(
                            //         fontSize: 16, color: Colors.grey)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text('Business Into',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: myColor)),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.business,
                              size: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            if (businessName != null) ...[
                              Text(businessName,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey)),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Icon(
                                Icons.pin_drop,
                                size: 16,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              if (businessAddress != null) ...[
                                Text(businessAddress,
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey)),
                              ],
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.pages,
                              size: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            if (businessDetail != null) ...[
                              Text(businessDetail,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey)),
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        )),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EditProfilePage()),
            );
          },
          label: const Text('Edit'),
          icon: Icon(Icons.edit),
        ),
      ),
    );
  }
}
