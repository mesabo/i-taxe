import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';

import 'localsDBWorker.dart';
import 'localsModel.dart' show Local, LocalModel, localModel;

class LocalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: localModel,
        child: ScopedModelDescendant<LocalModel>(
          builder: (BuildContext inContext, Widget inChild, LocalModel inModel) {
            return Scaffold(
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.grey,
                  onPressed: () {
                    localModel.entityBeingEdited = Local();
                    localModel
                        .setStackIndex(1); //index 1 renvoie la page d'édition
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
                body: ListView.builder(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    itemCount: localModel.entityList.length,
                    itemBuilder: (BuildContext inBuildContext, int inInDex) {
                      Local local = localModel.entityList[inInDex];
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: .25,
                        child: Card(
                          elevation: 8,
                          child: ListTile(
                            title: Text(
                              "${local.place}"
                            ),
                            subtitle: Text("${local.quartier}"),
                          ),
                        ),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: "Supprimer",
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              _deleteLocal(inContext, local);
                            },
                          ),
                          IconSlideAction(
                              caption: "Editer",
                              color: Colors.green,
                              icon: Icons.update,
                              onTap: () async {
                                localModel.entityBeingEdited =
                                await LocalDBWorker.db.getLocal(local.id);
                                localModel.setStackIndex(1);
                              }),
                        ],
                      );
                    }));
          },
        ));
  }

  Future _deleteLocal(BuildContext inContext, Local local) {
    int couper(String txtLeng) {
      int taille;
      if (txtLeng.length < 8) {
        txtLeng = txtLeng.padRight(8, "");
        taille = txtLeng.length;
      }
      if (txtLeng.length > 8) {
        txtLeng = txtLeng.substring(0, 8);
        taille = txtLeng.length;
      } else {
        taille = txtLeng.length;
      }

      return taille;
    }

    return Alert(
      context: inContext,
      type: AlertType.warning,
      title: "SUPPRESSION",
      content: Text(
        "${local.place.substring(0, couper(local.place))}....",
        style: TextStyle(
            color: Colors.black,
            decoration: TextDecoration.overline,
            fontSize: 24,
            fontStyle: FontStyle.italic),
      ),
      desc: "Etes-vous sur de vouloir supprimer c local?",
      buttons: [
        DialogButton(
          child: Text(
            "Annuler",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(inContext),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "supprimer",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            await LocalDBWorker.db.deleteLocal(local.id);
            Navigator.of(inContext).pop();
            Scaffold.of(inContext).showSnackBar(SnackBar(
              content: Text("Local supprimé avec succès."),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ));
            localModel.loadData("locals", LocalDBWorker.db);
          },
          color: Color.fromRGBO(200, 25, 10, 1.0),
        )
      ],
    ).show();
  }
}