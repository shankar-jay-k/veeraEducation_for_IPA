import 'package:flutter/material.dart';
import 'package:veera_education_flutter/Controllers/Colors.dart';
import 'package:veera_education_flutter/Views/Auth/LoginPage.dart';
import 'package:veera_education_flutter/Views/HomePage/HomePage.dart';


class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scaffold,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(),
          SizedBox(),
          SizedBox(),
          // First part: Image
          Image.asset(
            'assets/images/welcome.png', // Replace 'your_image.png' with your image path
            width: MediaQuery.of(context).size.width,
            height: 250,
            fit: BoxFit.contain,
          ),

          // Second part: Title and paragraph
          Padding(
            padding: const EdgeInsets.only(bottom: 88.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Veera`s Education',
                  style: TextStyle(fontSize: 24, fontFamily : 'poppins-bold',),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'In the heart of Veera`s Education, amidst the hushed corridors where knowledge whispers its secrets, lies a vibrant tapestry woven with the hues of Hindi',
                    style: TextStyle(fontFamily: 'poppins-medium',fontSize: 14,letterSpacing: 1),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'A colourful tapestry woven with Hindi colours can be seen in the centre of Veera`s Education, among the quiet hallways where wisdom whispers its secrets',
                    style: TextStyle(fontFamily: 'poppins-medium',letterSpacing: 1,fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Third part: Button
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => LoginScreen(),
              ));
            },
            child: Text('Get Started',style: TextStyle(fontFamily: 'poppins-semibold',color:Colors.black,letterSpacing: 2),),
            style: ElevatedButton.styleFrom(
              backgroundColor: appColors.lightGold,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
          ),

          SizedBox(),
          SizedBox(),
          SizedBox(),

          SizedBox(),
          SizedBox(),
          SizedBox(),
        ],
      ),
    );
  }
}
