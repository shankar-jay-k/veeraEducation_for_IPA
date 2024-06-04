import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:veera_education_flutter/Views/Auth/SplashScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    // Change the status bar color to white with dark icons
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'Veera Education',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light, // Set the theme to light
       theme: ThemeData(
        fontFamily: 'arial', ),
      home:   SplashScreen(),
    );
  }
}
