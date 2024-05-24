// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:test_project/home.dart';
import 'package:test_project/utils/utils.dart';


class NewSplashScreen extends StatefulWidget {
  const NewSplashScreen({super.key});

  @override
  _NewSplashScreenState createState() => _NewSplashScreenState();
}

class _NewSplashScreenState extends State<NewSplashScreen>
    with TickerProviderStateMixin {

  static const MethodChannel _channel =
  MethodChannel('flutter_developer_detection');
  double _fontSize = 2;
  double _containerSize = 1.5;
  double _textOpacity = 0.0;
  double _containerOpacity = 0.0;

  late AnimationController _controller;
  late Animation<double> animation1;

  // bool? _developerMode;
  bool? recall;

  String _wifiName = 'Unknown';
  String _bssid = 'Unknown';



  @override
  void initState() {
    super.initState();

    _requestPermissions();


    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));

    animation1 = Tween<double>(begin: 40, end: 20).animate(CurvedAnimation(
        parent: _controller, curve: Curves.fastLinearToSlowEaseIn))
      ..addListener(() {
        setState(() {
          _textOpacity = 1.0;
        });
      });

    _controller.forward();

    Timer(Duration(seconds: 3), () {
      setState(() {
        _fontSize = 1.06;
      });
    });

    Timer(Duration(seconds: 3), () {
      setState(() {
        _containerSize = 2;
        _containerOpacity = 1;
      });
    });

    Timer(Duration(seconds: 4), () async {

      if(recall!=true) {
        Navigator.pushReplacement(
            context, PageTransition(MyHomePage(title: 'Exchange Currencies',)));
      }else{
        Utils.showPopDialog(context,title: "Developer Mode is turned on, please turn it off and try again",buttonText: "Okay", negFunction:() {
          Timer(Duration(seconds: 1), () {
            Navigator.pushReplacement(
                context, PageTransition(MyHomePage(title: 'Exchange Currencies',)));
          });
        });

      }
    });
  }



  Future<void> initPlatformState() async {
    bool developerMode;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      developerMode = await FlutterJailbreakDetection.developerMode;
      print(" developerMode $developerMode");
      if(developerMode!=false){
        setState(() {
          recall=true;
        });
      }
    }  on PlatformException  {
      developerMode = true;
    }

    // if (!mounted) return;
    //
    // setState(() {
    //   _developerMode = developerMode;
    // });
  }

  Future<void> _requestPermissions() async {

    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      bool isLocationEnabled = await Permission.location.serviceStatus.isEnabled;

      if (isLocationEnabled) {
        Utils.checkWifi(context);

      } else {
        setState(() {
          _wifiName = 'Location services are disabled';
          _bssid = 'Location services are disabled';
        });
      }
      initPlatformState();
    } else {
      setState(() {
        _wifiName = 'Location permission denied';
        _bssid = 'Location permission denied';
      });
    }
  }




  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              AnimatedContainer(
                  duration: Duration(milliseconds: 3000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: _height / _fontSize),
              AnimatedOpacity(
                duration: Duration(milliseconds: 2000),
                opacity: _textOpacity,
                child: Text(
                  'Exchange',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    fontSize: animation1.value,
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 3000),
              curve: Curves.fastLinearToSlowEaseIn,
              opacity: _containerOpacity,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 3000),
                curve: Curves.fastLinearToSlowEaseIn,
                height: _width / _containerSize,
                width: _width / _containerSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                // child: Image.asset('assets/images/file_name.png')
                child: Image.asset('assets/logo.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageTransition extends PageRouteBuilder {
  final Widget page;

  PageTransition(this.page)
      : super(
          pageBuilder: (context, animation, anotherAnimation) => page,
          transitionDuration: Duration(milliseconds: 2000),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
              curve: Curves.fastLinearToSlowEaseIn,
              parent: animation,
            );
            return Align(
              alignment: Alignment.bottomCenter,
              child: SizeTransition(
                sizeFactor: animation,
                axisAlignment: 0,
                child: page,
              ),
            );
          },
        );
}

