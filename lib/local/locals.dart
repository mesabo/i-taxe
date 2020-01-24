import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'localsDBWorker.dart';
import 'localsEntry.dart';
import 'localsList.dart';
import 'localsModel.dart' show LocalModel, localModel;

class Local extends StatelessWidget {
  Local() {
    localModel.loadData("locals", LocalDBWorker.db);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: localModel,
        child: ScopedModelDescendant<LocalModel>(
          builder: (BuildContext inContext, Widget inChild, LocalModel inModel) {
            return IndexedStack(
              index: inModel.stackIndex,
              children: <Widget>[LocalList(), LocalEntry()],
            );
          },
        ));
  }
}
