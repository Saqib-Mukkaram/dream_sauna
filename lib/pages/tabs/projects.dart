import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:dream_sauna/services/service.dart';
import 'package:dream_sauna/pages/createProject.dart';
import 'package:dream_sauna/theme.dart';


class ProjectNavBar extends StatefulWidget {
  const ProjectNavBar({Key? key}) : super(key: key);

  @override
  State<ProjectNavBar> createState() => _ProjectNavBarState();
}

class _ProjectNavBarState extends State<ProjectNavBar> {
  GlobalKey<FormState> bookingFormKey = GlobalKey<FormState>();

  final searchController = TextEditingController();

  var userToken;
  List projects = [];
  final format = DateFormat("yyyy-MM-dd HH:mm");

  bool buttonLoader = false;

  @override
  bool loader = false;
  final toDateController = TextEditingController();
  final fromDateController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  Future<void> _formDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(fromDateController.text),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDateController) {
      setState(() {
        fromDateController.text =
            DateFormat('yyyy-MM-dd').format(picked).toString();
      });
    }
  }

  Future<void> _toDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.parse(fromDateController.text),
        lastDate: DateTime(2101));
    if (picked != null && picked != toDateController) {
      setState(() {
        toDateController.text =
            DateFormat('yyyy-MM-dd').format(picked).toString();
      });
    }
  }

  getuser() async {
    setState(() {});
    await UserService().getUser().then((value) {
      userToken = value["data"]["api_token"];
      setState(() {
        getProjects();
      });
    });
  }

  getProjects() async {
    loader = true;
    var url = Uri.parse(
        'http://calcsoft.saunamaterialkit.com/api/sauna/merchant/project?search='+searchController.text);
    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "Authorization": "Bearer " + userToken.toString()
    });
    if (response.statusCode == 200) {
      setState(() {
        projects = jsonDecode(response.body);
        loader = false;
      });
    } else {
      loader = false;
      projects = [];
    }
    print(projects);
  }

  imageAdd(index){
    if(projects[index]['image1'] != null){
      return Image.network(
          'http://calcsoft.saunamaterialkit.com/' + projects[index]['image1'].toString()
      );
    }else if(projects[index]['image2'] != null){
      return Image.network(
          'http://calcsoft.saunamaterialkit.com/' + projects[index]['image2'].toString()
      );
    }else if(projects[index]['image3'] != null){
      return Image.network(
          'http://calcsoft.saunamaterialkit.com/' + projects[index]['image3'].toString()
      );
    }else if(projects[index]['image4'] != null){
      return Image.network(
          'http://calcsoft.saunamaterialkit.com/' + projects[index]['image4'].toString()
      );
    }else if(projects[index]['image5'] != null){
      return Image.network(
          'http://calcsoft.saunamaterialkit.com/' + projects[index]['image5'].toString()
      );
    }else{
      return Image.asset('assets/images/no-image.jpg');
    }
  }

  void initState() {
    loader = true;
    // TODO: implement initState
    super.initState();
    setState(() {
      getuser();
    });
  }

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: loader
          ? const SpinKitFadingCircle(
              // duration: Duration(milliseconds: 10000),
              color: Colors.black,
              size: 50.0,
            )
          : Column(
              children: <Widget>[
                Container(
                    child: SingleChildScrollView(
                        child: Column(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                        child: TextField(
                          keyboardType: TextInputType.text,
                            controller: searchController,
                            onSubmitted: (value) {
                              setState(() {
                                getProjects();
                              });
                            },
                            // onTapOutside: (){
                            //   setState(() {
                            //     getProjects();
                            //   });
                            // },
                            decoration: InputDecoration(
                              hoverColor: primaryColor,
                              contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                              hintText: 'Search...',
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: ()  {
                                  searchController.clear();
                                  getProjects();
                              },
                              ),
                              prefixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                },
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.teal, width: 0.0),
                                // borderRadius: BorderRadius.circular(30.0),
                              ),
                            )),
                      ),
                    ]))),
                Expanded(
                    child: ListView.builder(
                      // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        child: Card(
                          color: Colors.grey.shade200,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                leading: Container(
                                    child: imageAdd(index)
                                ),
                                title: Text(
                                  projects[index]['title'].toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Container(
                                  child: Text(projects[index]['description'].toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    softWrap: false,
                                  )
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(projects[index]['date'].toString()),
                                  const SizedBox(width: 8),
                                  TextButton(
                                    child: const Text('Details'),
                                    onPressed: () {
                                      /* ... */
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ],
                          ),
                        ));
                  },
                  itemCount: projects.length,
                )),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SingleImageUpload()))
              },
          label: const Text('Add Project')),
    );
  }
}
