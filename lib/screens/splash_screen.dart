import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jsc_task2/screens/login_screen.dart';
import 'package:jsc_task2/screens/widgets/bottom_nav.dart';
import 'package:jsc_task2/utils/box_dec.dart';
import 'package:jsc_task2/utils/const_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
     Timer(
        const Duration(seconds: 1),
        () => checkLogIn(context),
      );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   
    return Container(
      decoration: BoxDeco.containerBoxDecoration(),
      child:const Scaffold(
        backgroundColor: Colors.transparent,
        body:Center(
                child: Text(
                  'Snapgram',
                  style: TextStyle(
                    fontFamily: 'Snapgram',
                    color: subColor,
                    fontStyle: FontStyle.italic,
                    fontSize: 40,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
      ),
    );
  }

    checkLogIn(context) async {
    final pref = await SharedPreferences.getInstance();
    final check = pref.getBool('isLoged');

    if (check == false || check == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>  LogInScreen(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const BottomNav(),
        ),
      );
    }
  }
}
