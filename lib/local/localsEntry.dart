import 'package:itaxe/Utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'localsDBWorker.dart';
import 'localsModel.dart' show LocalModel, localModel;

class LocalEntry extends StatelessWidget {
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _rueController = TextEditingController();
  final TextEditingController _quartierController = TextEditingController();
  final TextEditingController _secteurController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LocalEntry() {
    _placeController.addListener(() {
      localModel.entityBeingEdited.place = _placeController.text;
    });
    _rueController.addListener(() {
      localModel.entityBeingEdited.rue = _rueController.text;
    });
    _quartierController.addListener(() {
      localModel.entityBeingEdited.quartier = _quartierController.text;
    });
    _secteurController.addListener(() {
      localModel.entityBeingEdited.secteur = _secteurController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    /*nous voudrons nous assurer que les valeurs précédentes pour
    le titre et le contenu sont affichées à l'écran lors de l'édition.*/
    _placeController.text = localModel.entityBeingEdited.place;
    _rueController.text = localModel.entityBeingEdited.rue;
    _quartierController.text = localModel.entityBeingEdited.quartier;
    _secteurController.text = localModel.entityBeingEdited.secteur;

    return ScopedModel(
      model: localModel,
      child: ScopedModelDescendant<LocalModel>(
        builder: (BuildContext inContext, Widget inChild, LocalModel inModel) {
          return Scaffold(
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Row(
                children: <Widget>[
                  FlatButton(
                      onPressed: () {
                        FocusScope.of(inContext).requestFocus(FocusNode());
                        inModel.setStackIndex(0);
                      },
                      child: Text("Quitter")),
                  Spacer(),
                  FlatButton(
                      onPressed: () {
                        _saveLocal(inContext, localModel);
                      },
                      child: Text("Enregistrer")),
                ],
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.title),
                    title: TextFormField(
                      maxLength: 200,
                      controller: _placeController,
                      decoration: InputDecoration(
                          labelText: "Place",
                          labelStyle: TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.w500)),
                      validator: (String inValue) {
                        if (inValue.length == 0) {
                          return "Entrer une place svp.";
                        }
                        return null;
                      },
                    ),
                  ),ListTile(
                    leading: Icon(Icons.title),
                    title: TextFormField(
                      maxLength: 200,
                      controller: _rueController,
                      decoration: InputDecoration(
                          labelText: "Rue",
                          labelStyle: TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.w500)),
                      validator: (String inValue) {
                        if (inValue.length == 0) {
                          return "Entrer une rue svp.";
                        }
                        return null;
                      },
                    ),
                  ),ListTile(
                    leading: Icon(Icons.title),
                    title: TextFormField(
                      maxLength: 200,
                      controller: _quartierController,
                      decoration: InputDecoration(
                          labelText: "Quartier",
                          labelStyle: TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.w500)),
                      validator: (String inValue) {
                        if (inValue.length == 0) {
                          return "Entrer un quartier svp.";
                        }
                        return null;
                      },
                    ),
                  ),ListTile(
                    leading: Icon(Icons.title),
                    title: TextFormField(
                      maxLength: 200,
                      controller: _secteurController,
                      decoration: InputDecoration(
                          labelText: "Secteur",
                          labelStyle: TextStyle(
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.w500)),
                      validator: (String inValue) {
                        if (inValue.length == 0) {
                          return "Entrer un secteur svp.";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveLocal(BuildContext inContext, LocalModel inModel) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    if (inModel.entityBeingEdited.id == null) {
      await LocalDBWorker.db.createLocal(localModel.entityBeingEdited);
    } else {
      await LocalDBWorker.db.updateLocal(localModel.entityBeingEdited);
    }

    localModel.loadData("locals", LocalDBWorker.db);
    inModel.setStackIndex(0);

    Scaffold.of(inContext).showSnackBar(SnackBar(
      content: Text("Le local a été ajouté avec succès"),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
    ));
  }
}
