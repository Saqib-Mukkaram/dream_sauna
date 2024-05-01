import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dream_sauna/services/service.dart';
import 'package:dream_sauna/utils/color.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:dream_sauna/utils/apis.dart';
// import 'package:';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  GlobalKey<FormState> editProfileFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final businessNameController = TextEditingController();
  final businessAddressController = TextEditingController();
  final businessDetailController = TextEditingController();

  final String imagePath =
      'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png';

  var name;
  var email;
  var profileImage;
  var govtPhoto;
  var phone;
  var address;
  var businessName;
  var businessAddress;
  var businessDetail;

  var userToken;
  bool loader = false;

  var userName = 'Not date';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      // userName = UserService.getUserName();
      getuser();
    });

    print(userName);
  }

  getuser() async {

    setState(() {
      loader = true;
    });
    await UserService().getUser().then((value) {
      // nameController.text = value["data"]["name"];
      phoneController.text = value["data"]["phone"];
      businessNameController.text = value["data"]["business_name"];
      businessAddressController.text = value["data"]["business_address"];
      businessDetailController.text = value["data"]["business_detail"] == null ? '' : value["data"]["business_detail"];

      name = value["data"]["name"];
      email = value["data"]["email"];
      phone = value["data"]["phone"];
      address = value["data"]["address"];
      businessName = value["data"]["business_name"];
      businessAddress = value["data"]["business_address"];
      businessDetail = value["data"]["business_detail"];
      profileImage = value["data"]["profile_image"];
      govtPhoto = value["data"]["govt_photo"];
      userToken = value["data"]["api_token"];

      setState(() {
        loader = false;
      });
    });
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final image = profileImage.contains('http://')
        ? NetworkImage(profileImage)
        : NetworkImage(imagePath);
    return Container(
      child: Builder(
        builder: (context) => Scaffold(
          // appBar: AppBar(
          //   title: Text('Back'),
          // ),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 30),
              Text(userName),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Text('Edit your profile', style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: myColor)),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Stack(
                  children: [
                    SizedBox(
                      height: 120,
                    ),
                    ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: Ink.image(
                          image: image as ImageProvider,
                          fit: BoxFit.cover,
                          width: 128,
                          height: 128,
                          child: InkWell(
                            // onTap: () async {
                            //   final image = await ImagePicker()
                            //       // .getImage(source: ImageSource.gallery);
                            //
                            //   if (image == null) return;
                            //
                            //   final directory =
                            //       await getApplicationDocumentsDirectory();
                            //   final name = basename(image.path);
                            //   final imageFile = File('${directory.path}/$name');
                            //   final newImage =
                            //       await File(image.path).copy(imageFile.path);
                            //
                            //   // setState(() => image = user.copy(imagePath: newImage.path));
                            // },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Form(
                  key: editProfileFormKey,
                  child: Container(
                    height: height - 320,
                    width: width-100,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: nameController,
                            validator: MinLengthValidator(1, errorText: "Name field is required"),
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              suffixIcon: Align(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: Icon(
                                  Icons.person_2_outlined,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: phoneController,
                            validator: MinLengthValidator(1,
                                errorText: "Phone field is required"),
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                              suffixIcon: Align(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: Icon(
                                  Icons.phone_enabled_outlined,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: businessNameController,
                            validator: MinLengthValidator(1,
                                errorText: "Business name field is required"),
                            textCapitalization: TextCapitalization.words,
                            decoration: const InputDecoration(
                              labelText: 'Business Name',
                              suffixIcon: Align(
                                widthFactor: 1.0,
                                heightFactor: 1.0,
                                child: Icon(
                                  Icons.business,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            controller: businessAddressController,
                            validator: MinLengthValidator(1, errorText: "Business address field is required"),
                            decoration: const InputDecoration(
                              labelText: 'Business Address',
                              suffixIcon: Align(
                                widthFactor: 0.0,
                                heightFactor: 0.0,
                                child: Icon(
                                  Icons.pin_drop,
                                ),
                              ),
                            ),
                          ),
                          TextFormField(
                            minLines: 4, // any number you need (It works as the rows for the textarea)
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: businessDetailController,
                            validator: MinLengthValidator(1, errorText: "Business details field is required"),
                            decoration: const InputDecoration(
                              labelText: 'Business Details',
                              suffixIcon: Align(
                                // alignment: Alignment.topRight,
                                widthFactor: 0.0,
                                heightFactor: 0.0,
                                child: Icon(
                                  Icons.pages,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Row(
                              children: [
                                RawMaterialButton(
                                  onPressed: () => Navigator.pop(context),
                                  // child: const Text('Cancel')),
                                  child: Container(
                                    height: height * 0.1 - 40,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40, top: 0, bottom: 0),
                                    // height: height * 0.08,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: const Color(0x20099BBB),
                                    ),
                                    child: const Text(
                                      "Cancel",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Color(0xFF099BBB),
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                RawMaterialButton(
                                  onPressed: () {

                                    if (editProfileFormKey.currentState!
                                        .validate()) {
                                      print('abc');
                                      updateProfile();
                                      // setState(() {
                                      //   updateProfile();
                                      // });
                                      // return;
                                    }
                                  },
                                  // child: const Text('Add Booking'))
                                  child: Container(
                                    height: height * 0.1 - 40,
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.only(
                                        left: 40, right: 40, top: 0, bottom: 0),
                                    // height: height * 0.08,

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: const Color(0xFF099BBB),
                                    ),
                                    child: const Text(
                                      "Update",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void updateProfile() async {
    var url = Uri.parse(Apis.profileUpdateApi);

    var response = await http.post(
      url,
      headers:{
        'Content-Type': 'application/json; charset=UTF-8',
        "Accept": "application/json",
        "Authorization": "Bearer " + userToken.toString()
      },
      body: jsonEncode({
        'name': nameController.text,
        'phone': phoneController.text,
        'business_name': businessNameController.text,
        'business_address': businessNameController.text,
        'business_detail': businessDetailController.text,
      }),
    );
    try {
      if (response.statusCode == 200) {
        // UserService().setUser(_data).then((value) {});
          nameController.clear();
          phoneController.clear();
          businessNameController.clear();
          businessAddressController.clear();
          businessDetailController.clear();
          // Navigator.push(context, MaterialPageRoute(builder: (context) => ));
      } else {
        loader = false;

      }
    }catch(e) {

    }
  }
}
