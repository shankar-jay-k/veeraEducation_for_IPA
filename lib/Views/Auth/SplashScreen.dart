import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:veera_education_flutter/Views/Auth/GetStarted.dart';
import 'package:veera_education_flutter/Views/HomePage/HomePage.dart';


final userStorage = GetStorage();
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);
    _controller.forward();

    // Navigate to home page after 3 seconds
     Future.delayed(Duration(seconds: 3), () {
       if(userStorage.read('userData') != null){
         Navigator.of(context).pushReplacement(MaterialPageRoute(
           builder: (context) => HomePage(),
         ));
       }
       else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => GetStarted(),
        ));
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Image.asset(
              'assets/images/newLogo.png', // Replace 'logo.png' with your image path
              width: double.infinity,
              height: 200,
            ),
          ),
        ),
      ),
    );
   }
  }