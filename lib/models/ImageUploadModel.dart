import 'dart:io';

import 'package:image_picker/image_picker.dart';
//
// import 'dart:html';

class ImageUploadModel {

  String? name;
  String? detail;
  DateTime? selectDate;
  XFile? photo1;
  XFile? photo2;
  XFile? photo3;
  XFile? photo4;
  XFile? photo5;

  ImageUploadModel({
     this.name,
    this.detail,
    this.selectDate,
    this.photo1,
    this.photo2,
    this.photo3,
    this.photo4,
    this.photo5,
  });
}