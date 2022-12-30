import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jsc_task2/providers/auth_provider.dart';
import 'package:jsc_task2/providers/post_provider.dart';
import 'package:jsc_task2/providers/user_provider.dart';
import 'package:jsc_task2/screens/login_screen.dart';
import 'package:jsc_task2/screens/splash_screen.dart';
import 'package:jsc_task2/screens/widgets/bottom_nav.dart';
import 'package:jsc_task2/screens/widgets/snack_bar.dart';
import 'package:jsc_task2/screens/widgets/text_widget.dart';
import 'package:jsc_task2/utils/const_color.dart';
import 'package:provider/provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
          ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
            ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
             ChangeNotifierProvider(
          create: (context) => PostProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        scaffoldMessengerKey: ShowDialogs.scaffoldMessengerKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: StreamBuilder(
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //   builder: (context, snapshot) {
        //   if (snapshot.connectionState == ConnectionState.active) {
        //     if (snapshot.hasData) {
        //       return const BottomNav();
        //     }else if(snapshot.hasError){
        //       Center(
        //         child: TextWidget(text: '${snapshot.error}', fontSize: 14),
        //       );
        //     }
        //   }
        //   if (snapshot.connectionState == ConnectionState.waiting) {
        //     const  Center(
        //         child:  CircularProgressIndicator(color: subColor,strokeWidth: 2,),
        //       );
        //   }
        //   return  LogInScreen();
        // },
        
        // ),
             home: const SplashScreen(),
      ),
    );
  }
}
