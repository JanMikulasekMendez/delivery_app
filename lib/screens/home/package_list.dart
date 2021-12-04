import 'package:deliveryapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:deliveryapp/models/package.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

import 'my_cell.dart';

class PackageList extends StatefulWidget {
  PackageList({Key? key, required this.packages}) : super(key: key);
  List<Package> packages;

  @override
  _PackageListState createState() => _PackageListState();
}

class _PackageListState extends State<PackageList> {
  int _currentSelection = 0;
  List<Package> sortedPackages = [];
  List<Package> packages = [];

  Map<int, Widget> _children = {
    0: Text('Waiting'),
    1: Text('Delivered'),
    2: Text('All'),
  };

  List<Package> filterPackages(List<Package> packages) {

    switch (_currentSelection) {
      case 0:

        sortedPackages =
            packages.where((element) => element.delivered == false).toList();
        sortedPackages.sort((a, b) => a.estimatedAt.compareTo(b.estimatedAt));
        return sortedPackages;
      case 1:

        sortedPackages =
            packages.where((element) => element.delivered == true).toList();
        sortedPackages.sort((a, b) => a.arrivedAt.compareTo(b.arrivedAt));
        return sortedPackages;
      case 2:
        sortedPackages = packages;
        var sortedPackages1 = sortedPackages.where((element) => element.delivered == false).toList();
        var sortedPackages2 = sortedPackages.where((element) => element.delivered == true).toList();
        sortedPackages1.sort((a, b) => a.estimatedAt.compareTo(b.estimatedAt));
        sortedPackages2.sort((a, b) => a.arrivedAt.compareTo(b.arrivedAt));
        sortedPackages = sortedPackages1 + sortedPackages2;
        return sortedPackages;
      default:
        sortedPackages = packages;
        sortedPackages.sort((a, b) => a.name.compareTo(b.name));
        return sortedPackages;
    }
  }

  @override
  Widget build(BuildContext context) {
    packages = filterPackages(widget.packages);
    //packages = packages.where((element) => element.name == "test").toList();
    //print(packages.length);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 20,
        ),
        MaterialSegmentedControl(
          children: _children,
          selectionIndex: _currentSelection,
          borderColor: Colors.grey,
          selectedColor: MyThemes.backgroundColorAlt!,
          unselectedColor: MyThemes.navbarColor!,
          borderRadius: 8.0,
          //disabledChildren: _disabledIndices,
          onSegmentChosen: (index) {
            setState(() {
              _currentSelection = index as int;
            });
          },
        ),
        Expanded(
          child: Container(
            child: ListView.builder(
                itemCount: packages.length + 1,
                itemBuilder: (context, index) {
                  if (index == packages.length) {
                    return SizedBox(
                      height: 20,
                    );
                  } else {
                    return MyCell(package: packages[index]);
                  }
                }),
          ),
        ),
      ],
    );
  }
}
