import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:deliveryapp/shared/constants.dart';


class Loading extends StatelessWidget {
  Loading({required this.loadingReason});

  final String loadingReason;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: gradientDecoration,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(loadingReason, style: TextStyle(fontSize: 24), textAlign: TextAlign.center,),
              SizedBox(height: 20,),
              CircleAvatar(
                radius: 75,
                backgroundColor: MyThemes.backgroundColorAlt,
                child: SpinKitFadingFour(
                color: MyThemes.navbarColor!,
                size: 75.0,
              ),

              ),

            ],
          )
        ),
      ),
    );
  }
}

class LoadingConnecting extends StatelessWidget {
  LoadingConnecting({required this.loadingReason});

  final String loadingReason;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: gradientDecoration,
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(loadingReason, style: TextStyle(fontSize: 24), textAlign: TextAlign.center,),
                SizedBox(height: 20,),
                CircleAvatar(
                  radius: 75,
                  backgroundColor: MyThemes.backgroundColorAlt,
                  child: SpinKitPouringHourGlass(
                    color: MyThemes.navbarColor!,
                    size: 75.0,
                  ),

                ),

              ],
            )
        ),
      ),
    );
  }
}

class LoadingNoDataFound extends StatelessWidget {
  LoadingNoDataFound({required this.loadingReason});

  final String loadingReason;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: gradientDecoration,
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(loadingReason, style: TextStyle(fontSize: 24), textAlign: TextAlign.center,),
                SizedBox(height: 20,),
                CircleAvatar(
                  radius: 75,
                  backgroundColor: MyThemes.backgroundColorAlt,
                  child: Icon(
                  Icons.archive_outlined,
                  size: 100,
                  color: MyThemes.buttonColor,
                )),

              ],
            )
        ),
      ),
    );
  }
}