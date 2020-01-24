import 'package:itaxe/Utils.dart' as utils;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'localsModel.dart';

class LocalDBWorker {
  LocalDBWorker._();

  static final LocalDBWorker db = LocalDBWorker._();

  Database _db;

  //Rien de compliqué ici, plutot évident non ?
  //C'est juste un accesseur(getter)
  Future get database async {
    if (_db == null) {
      _db = await initializeDatabase();
    }
    return _db;
  }

  Future<Database> initializeDatabase() async {
    String path = join(utils.docsDir.path, "local.db");

    //Création de la table et insertion de données.
    Database db = await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database inDB, int inVersion) async {
          await inDB.execute("CREATE TABLE IF NOT EXISTS locals ("
              "id INTEGER PRIMARY KEY,"
              "place TEXT,"
              "rue TEXT,"
              "quartier TEXT,"
              "secteur TEXT"
              ")");
        });

    return db;
  }

  Local localFromMap(Map inMap) {
    Local local = Local();

    local.id = inMap["id"];
    local.place = inMap["place"];
    local.rue = inMap["rue"];
    local.quartier = inMap["quartier"];
    local.secteur = inMap["secteur"];

    return local;
  }

  Map<String, dynamic> localToMap(Local inLocal) {
    Map<String, dynamic> map = Map<String, dynamic>();

    map["id"] = inLocal.id;
    map["place"] = inLocal.place;
    map["rue"] = inLocal.rue;
    map["quartier"] = inLocal.quartier;
    map["secteur"] = inLocal.secteur;

    return map;
  }

  //Sauvegarde du local
  Future createLocal(Local inLocal) async {
    Database db = await database;
    var val = await db.rawQuery("SELECT MAX(id)+1 as id FROM locals");
    int id = val.first["id"];

    if (id == null) {
      id = 1;
    }

    return db.rawInsert(
        "INSERT INTO local (id,place,rue,quartier,secteur)"
            " VALUES(?,?,?,?)",
        [id, inLocal.place, inLocal.rue, inLocal.quartier,inLocal.secteur]);
  }

  Future<Local> getLocal(int inID) async {
    Database db = await database;
    var rec = await db.query("locals", where: "id = ?", whereArgs: [inID]);

    return localFromMap(rec.first);
  }

  //Récupération de toutes les données de la table
  Future<List> getAll() async {
    Database db = await database;
    var recs = await db.query("locals");
    var list = recs.isNotEmpty ? recs.map((m) => localFromMap(m)).toList() : [];

    return list;
  }

  Future updateLocal(Local inLocal) async {
    Database db = await database;
    return await db.update("locals", localToMap(inLocal),
        where: "id = ?", whereArgs: [inLocal.id]);
  }

  Future deleteLocal(int inID) async {
    Database db = await database;
    return await db.delete("locals", where: "id = ?", whereArgs: [inID]);
  }
//Fin
}