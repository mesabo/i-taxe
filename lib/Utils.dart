import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'BaseModel.dart';

Directory docsDir;

/*@selectDate
*Une date est requise pour un enregistrement de redevable
* , alors elle est soit la date ou l'heure actuelle ou choisie par l'utilisateur.*/

Future selectDate(BuildContext inContext, BaseModel inModel,
    String inDateString) async {
  DateTime intitialDate = DateTime.now(); //Date par @défaut: date actuelle

  if (inDateString != null) {
    List datePart = inDateString.split(",");
    intitialDate = DateTime(
        int.parse(datePart[0]), int.parse(datePart[1]), int.parse(datePart[2]));
  }
}