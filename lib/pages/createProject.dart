import 'dart:io';
import 'package:dream_sauna/pages/tabs/projects.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:http/http.dart' as http;
import 'package:dream_sauna/services/service.dart';

class SingleImageUpload extends StatefulWidget {
  @override
  _SingleImageUploadState createState() {
    return _SingleImageUploadState();
  }
}

class _SingleImageUploadState extends State<SingleImageUpload> {
  GlobalKey<FormState> ProjectFormKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  XFile? photo1;
  XFile? photo2;
  XFile? photo3;
  XFile? photo4;
  XFile? photo5;

  var userToken;

  final format = DateFormat("yyyy-MM-dd");

  bool buttonLoader = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getuser();
    });
  }


  getuser() async {
    setState(() {});
    await UserService().getUser().then((value) {
      userToken = value["data"]["api_token"];
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
        child: Builder(
          builder: (context) => Scaffold(
         appBar: new AppBar(
           centerTitle: true,
           title: const Text('Add New Project'),
         ),
         body: Container(
           child: SingleChildScrollView(
             child: Padding(
               padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                 child: Form(
                   key: ProjectFormKey,
                   child: Column(
                   crossAxisAlignment: CrossAxisAlignment.stretch,
                   mainAxisSize: MainAxisSize.min,
                   children: <Widget>[
                     TextFormField(
                       controller: titleController,
                       validator: MinLengthValidator(1, errorText: "Project title field is required"),
                       textCapitalization: TextCapitalization.words,
                       decoration: const InputDecoration(
                         labelText: 'Project Title',
                         suffixIcon: Align(
                           widthFactor: 1.0,
                           heightFactor: 1.0,
                           child: Icon(
                             Icons.title,
                           ),
                         ),
                       ),
                     ),
                     TextFormField(
                       controller: descriptionController,
                       validator: MinLengthValidator(1, errorText: "Description field is required"),
                       textCapitalization: TextCapitalization.words,
                       decoration: const InputDecoration(
                         labelText: 'Description',
                         suffixIcon: Align(
                           widthFactor: 1.0,
                           heightFactor: 1.0,
                           child: Icon(
                             Icons.text_snippet_outlined,
                           ),
                         ),
                       ),
                     ),
                     DateTimeField(
                       controller: dateController,
                       validator: (val) {
                         if (val == null) return 'Select Project Date';
                       },
                       format: format,
                       decoration: InputDecoration(
                         labelText: 'Project Date',
                         suffixIcon: Align(
                           widthFactor: 0.0,
                           heightFactor: 0.0,
                           child: Icon(
                             Icons.calendar_month,
                           ),
                         ),
                       ),
                       onShowPicker: (context, currentValue) async {
                         final date = await showDatePicker(
                             context: context,
                             firstDate: DateTime.now(),
                             initialDate: currentValue ?? DateTime.now(),
                             lastDate: DateTime(2050));
                         if (date != null) {
                           return date;
                         } else {
                           return currentValue;
                         }
                       },
                     ),
                     SizedBox(height: 10,),
                     GridView.count(
                       physics: NeverScrollableScrollPhysics(),
                       shrinkWrap: true,
                       crossAxisCount: 3,
                       childAspectRatio: 1,
                       children: [
                         firstPhoto(),
                         secondPhoto(),
                         thirdPhoto(),
                         fourthPhoto(),
                         fifthPhoto(),
                       ],
                     ),
                     SizedBox(height: 10,),
                     Container(
                       child: buttonLoader
                           ? RawMaterialButton(
                         onPressed: (){},
                         child: Container(
                             height: height * 0.1 - 40,
                             alignment: Alignment.center,
                             padding: const EdgeInsets.only(left: 100, right: 100, top: 5, bottom: 5),
                             width: width,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(10),
                               color: const Color(0xFF099BBB),
                             ),
                             child: SpinKitFadingCircle(
                               color: Colors.white,
                               size: 25,
                             )
                         ),
                       )
                           : RawMaterialButton(
                         onPressed: () {
                           if (ProjectFormKey.currentState!
                               .validate()) {
                             setState(() {
                               addProject();
                             });
                             // Navigator.pop(context);
                             return;
                           }
                         },
                         child: Container(
                           height: height * 0.1 - 40,
                           alignment: Alignment.center,
                           padding: const EdgeInsets.only(left: 100, right: 100, top: 5, bottom: 5),
                           width: width,
                           decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10),
                             color: const Color(0xFF099BBB),
                           ),
                           child: const Text(
                             "Save Project",
                             style: TextStyle(
                                 color: Colors.white,
                                 fontWeight: FontWeight.bold),
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
                 )
             )
           ),
         ),
       ),
     ),
    );
  }

  Widget firstPhoto(){
    if(photo1 == null){
      return Card(
        child: IconButton(
          icon: Icon(Icons.add, size: 40, color: Colors.black26,),
          onPressed: () {
            _FirstshowPicker(context);
            // _onAddImageClick(index);
          },
        ),
      );
    }else{
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: <Widget>[

            Image.file(
              // uploadModel.imageUrl as File,
              File(photo1!.path),
              width: 300,
              height: 300,

            ),
            Positioned(
              right: 5,
              top: 5,
              child: InkWell(
                child: Icon(
                  Icons.remove_circle,
                  size: 20,
                  color: Colors.red,
                ),
                onTap: () {
                  setState(() {
                    photo1 = null;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

  }
  Widget secondPhoto(){
    if(photo2 == null){
      return Card(
        child: IconButton(
          icon: Icon(Icons.add, size: 40, color: Colors.black26,),
          onPressed: () {
            _SecondshowPicker(context);
          },
        ),
      );
    }else{
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: <Widget>[

            Image.file(
              File(photo2!.path),
              width: 300,
              height: 300,

            ),
            Positioned(
              right: 5,
              top: 5,
              child: InkWell(
                child: Icon(
                  Icons.remove_circle,
                  size: 20,
                  color: Colors.red,
                ),
                onTap: () {
                  setState(() {
                    photo2 = null;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

  }
  Widget thirdPhoto(){
    if(photo3 == null){
      return Card(
        child: IconButton(
          icon: Icon(Icons.add, size: 40, color: Colors.black26,),
          onPressed: () {
            _ThirdshowPicker(context);
            // _onAddImageClick(index);
          },
        ),
      );
    }else{
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: <Widget>[
            Image.file(
              File(photo3!.path),
              width: 300,
              height: 300,

            ),
            Positioned(
              right: 5,
              top: 5,
              child: InkWell(
                child: Icon(
                  Icons.remove_circle,
                  size: 20,
                  color: Colors.red,
                ),
                onTap: () {
                  setState(() {
                    photo3 = null;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

  }
  Widget fourthPhoto(){
    if(photo4 == null){
      return Card(
        child: IconButton(
          icon: Icon(Icons.add, size: 40, color: Colors.black26,),
          onPressed: () {
            _FourthshowPicker(context);
          },
        ),
      );
    }else{
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: <Widget>[

            Image.file(
              // uploadModel.imageUrl as File,
              File(photo4!.path),
              width: 300,
              height: 300,

            ),
            Positioned(
              right: 5,
              top: 5,
              child: InkWell(
                child: Icon(
                  Icons.remove_circle,
                  size: 20,
                  color: Colors.red,
                ),
                onTap: () {
                  setState(() {
                    photo4 = null;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

  }
  Widget fifthPhoto(){
    if(photo5 == null){
      return Card(
        child: IconButton(
          icon: Icon(Icons.add, size: 40, color: Colors.black26,),
          onPressed: () {
            _FifthshowPicker(context);
          },
        ),
      );
    }else{
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: <Widget>[

            Image.file(
              // uploadModel.imageUrl as File,
              File(photo5!.path),
              width: 300,
              height: 300,

            ),
            Positioned(
              right: 5,
              top: 5,
              child: InkWell(
                child: Icon(
                  Icons.remove_circle,
                  size: 20,
                  color: Colors.red,
                ),
                onTap: () {
                  setState(() {
                    photo5 = null;
                  });
                },
              ),
            ),
          ],
        ),
      );
    }

  }

  void _FirstshowPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  _firstPickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _firstPickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void _SecondshowPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  _secondPickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _secondPickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void _ThirdshowPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  _thirdPickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _thirdPickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void _FourthshowPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  _fourthPickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _fourthPickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void _FifthshowPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  _fifthPickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _fifthPickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _firstPickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          photo1 = pickedFile;
        });
      }
    } catch (e) {
      print(e);
    }
  }
  Future<void> _secondPickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          photo2 = pickedFile;
        });
      }
    } catch (e) {
      print(e);
    }
  }
  Future<void> _thirdPickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          photo3 = pickedFile;
        });
      }
    } catch (e) {
      print(e);
    }
  }
  Future<void> _fourthPickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          photo4 = pickedFile;
        });
      }
    } catch (e) {
      print(e);
    }
  }
  Future<void> _fifthPickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          photo5 = pickedFile;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void addProject() async {

    buttonLoader = true;

    var url = Uri.parse('http://calcsoft.saunamaterialkit.com/api/sauna/merchant/project');
    var request = http.MultipartRequest(
      'POST', url,
    );
    Map<String,String> headers={
      "Authorization": "Bearer " + userToken.toString(),
      "Accept": "application/json",
      "Content-type": "multipart/form-data"
    };
    if(photo1 != null){
      request.files.add(
        await http.MultipartFile(
          'image1',
          File(photo1!.path).readAsBytes().asStream(),
          File(photo1!.path).lengthSync(),
          filename: photo1!.path.split("/").last,
        ),
      );
    }
    if(photo2 != null){
      request.files.add(
        await http.MultipartFile(
          'image2',
          File(photo2!.path).readAsBytes().asStream(),
          File(photo2!.path).lengthSync(),
          filename: photo1!.path.split("/").last,
        ),
      );
    }
    if(photo3 != null){
      request.files.add(
        await http.MultipartFile(
          'image3',
          File(photo3!.path).readAsBytes().asStream(),
          File(photo3!.path).lengthSync(),
          filename: photo3!.path.split("/").last,
        ),
      );
    }
    if(photo4 != null){
      request.files.add(
        await http.MultipartFile(
          'image4',
          File(photo4!.path).readAsBytes().asStream(),
          File(photo4!.path).lengthSync(),
          filename: photo4!.path.split("/").last,
        ),
      );
    }
    if(photo5 != null){
      request.files.add(
        await http.MultipartFile(
          'image5',
          File(photo5!.path).readAsBytes().asStream(),
          File(photo5!.path).lengthSync(),
          filename: photo5!.path.split("/").last,
        ),
      );
    }
    request.headers.addAll(headers);
    request.fields.addAll({
      "title": titleController.text,
      "description": descriptionController.text,
      "date": dateController.text,
    });
    print("request: "+request.toString());
    var res = await request.send().then((response) {
      print(response.statusCode);
       if(response.statusCode == 200){
         showMessage(context, "Your project save successfully", Colors.green);
         setState(() {
           titleController.clear();
           descriptionController.clear();
           dateController.clear();
           photo1 = null;
           photo2 = null;
           photo3 = null;
           photo4 = null;
           photo5 = null;
           buttonLoader = false;
           // Navigator.pop(context);

           Navigator.push(context,
               MaterialPageRoute(builder: (context) => ProjectNavBar()));


         });
       }else{
         showMessage(context, "Your project is not save", Colors.red);
         setState(() {
           buttonLoader = false;
         });
      }
    });
  }
  static showMessage(context, msg, color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: color,
      content: Text(msg),
    ));
  }

}