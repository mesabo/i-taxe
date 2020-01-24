import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shifting_tabbar/shifting_tabbar.dart';
import 'Utils.dart' as utils;
import 'local/locals.dart';

void main() {
  startMeUp() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    utils.docsDir = docsDir;

    runApp(FlutterItaxe());
  }

  startMeUp();
}

class FlutterItaxe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: ShiftingTabBar(
            color: Colors.grey,
            forceUpperCase: false,
            brightness: Brightness.dark,
            tabs: [
              ShiftingTab(icon: Icon(Icons.map), text: "Local"),
              ShiftingTab(
                  icon: Icon(Icons.group), text: "Redevable"),
            ],
          ),
          body: TabBarView(
            children: [Icon(Icons.add),Icon(Icons.group)],
          ),
        ),
      ),
    );
  }
}