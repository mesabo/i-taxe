import 'package:itaxe/BaseModel.dart';

class Local {
  int id;
  String place;
  String rue;
  String quartier;
  String secteur;

  String toString() {
    return "{id=$id, place=$place, rue=$rue, quartier=$quartier, secteur=$secteur}";
  }
}

class LocalModel extends BaseModel {}

LocalModel localModel = LocalModel();