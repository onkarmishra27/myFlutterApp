import 'package:first_app/Pages/homePage.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(Duration(milliseconds: 2000), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => MapSample()));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // backgroundColor: Image.asset('assets/images/back.png'),
        backgroundColor: Colors.amberAccent,
        body: Container(
          alignment: Alignment.center, // use aligment
          child: Image.asset('assets/images/splash.gif',
              height: 200, width: 200, fit: BoxFit.cover),
        ));

    // Container(
    //     height: double.infinity,
    //     width: double.infinity,
    //     child: Image.asset(
    //       'assets/images/splash.gif',
    //       width: 100,
    //       height: 50,
    //     )));
  }
}
