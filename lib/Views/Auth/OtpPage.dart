import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pinput/pinput.dart';
import 'package:veera_education_flutter/Controllers/Colors.dart';
import 'package:veera_education_flutter/Views/HomePage/HomePage.dart';
import 'package:http/http.dart' as http;

import '../../Controllers/apiCalls.dart';
import '../../Models/LoadingWidget.dart';
import '../../Models/Toasts.dart';

final userStorage = GetStorage();
class OtpPage extends StatefulWidget {
  final phoneNumber;
  const OtpPage({Key? key, this.phoneNumber}) : super(key: key);

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  String deviceModal = 'unknown';

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> initDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        deviceModal = '${androidInfo.model ?? 'Unknown'} - Android';
        // osVersion = 'Android ${androidInfo.version.release}';
      });
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        deviceModal = '${iosInfo.utsname.machine ?? 'Unknown'} - iOS';
        // osVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = appColors.lightGold;
    const fillColor = Colors.white;
    final defaultPinTheme = PinTheme(
      width: 46,
      height: 59,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: appColors.Shadow_Clr2,
            offset: const Offset(
              1.0,
              5.0,
            ),
            blurRadius:10.0,
          ),         ],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: appColors.ashGrey,),
      ),
    );

    /// Optionally you can use form to validate the Pinput
    return Scaffold(
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(

              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // First part: Image
                Image.asset(
                  'assets/images/login.jpg', // Replace 'your_image.png' with your image path
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  fit: BoxFit.contain,
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 88.0),
                  child: Column(
                    children: [
                      Text(
                        'OTP verification',
                        style: TextStyle(fontSize: 24, fontFamily : 'poppins-bold'),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Text(
                          "We've sent you an otp to your number +91-${widget.phoneNumber}.Enter the otp to continue",
                          style: TextStyle(fontFamily: 'arial',letterSpacing: 1.8, height: 1.5
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 35,),
                      Pinput(
                        length: 6,
                        controller: pinController,
                        focusNode: focusNode,
                        // androidSmsAutofillMethod:
                        // AndroidSmsAutofillMethod.smsUserConsentApi,
                        // listenForMultipleSmsOnAndroid: true,
                        defaultPinTheme: defaultPinTheme,
                        separatorBuilder: (index) => const SizedBox(width: 8),
                        // validator: (value) {
                        //   return value == '2222' ? null : 'Pin is incorrect';
                        // },
                        // onClipboardFound: (value) {
                        //   debugPrint('onClipboardFound: $value');
                        //   pinController.setText(value);
                        // },
                        hapticFeedbackType: HapticFeedbackType.lightImpact,
                        onCompleted: (pin) {
                          debugPrint('onCompleted: $pin');
                        },
                        onChanged: (value) {
                          debugPrint('onChanged: $value');
                        },
                        cursor: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 9),
                              width: 22,
                              height: 1,
                              color: focusedBorderColor,
                            ),
                          ],
                        ),
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: focusedBorderColor),
                          ),
                        ),
                        submittedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            color: fillColor,
                            borderRadius: BorderRadius.circular(19),
                            border: Border.all(color: focusedBorderColor),
                          ),
                        ),
                        errorPinTheme: defaultPinTheme.copyBorderWith(
                          border: Border.all(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    if(pinController.text.length != 0 && pinController.text.length == 6){
                      startLoading(context);
                      functionToVerifyOtp();

                    }
                      focusNode.unfocus();
                      formKey.currentState!.validate();

                  },
                  child: Text('Validate',style: TextStyle(fontFamily: 'poppins-bold',fontSize: 18,color:Colors.black,letterSpacing: 2,),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appColors.lightGold,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
                ),
                SizedBox(height: 25,),

              ],
            ),
          ),
        ),
      ),
    );
   }
  functionToVerifyOtp() async{
    try {
      Map<String, dynamic> body = {
        "otp": "${pinController.text}",
        "phoneNo": "${widget.phoneNumber}"
      };
      var responseData = await http.post(Uri.parse('https://veeras-edu-api.onrender.com/auth/signin/verify'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'deviceId' : deviceModal,
        },
        body: jsonEncode(body), // Encode the body as JSON string
      );

      Map<String, dynamic> response = json.decode(responseData.body);

      print('response for verifying otp api : ${response}');

       if(response['meta']['code']  == 200){
         if(response['meta']['message'] == 'Success'){
        functionToCheckUserAtMe(response['data']);
        userStorage.write('token', response['data']);

          setState(() {});
        }
         else{
           stopLoading(context);
           errorToast('Invalid OTP');
         }
      }
       else{
         stopLoading(context);
         errorToast('Invalid OTP');
       }
    } catch (e) {
      // Exception handling
      print('Exception getting otp: $e');
      stopLoading(context);

      showDialog(
          context: context,
          builder: (context)=>AlertDialog(
            title: Text("Error"),
            content: Text('Please check your internet or try again later'),
            actions: [
              MaterialButton(onPressed: (){
                Navigator.of(context).pop();

              },child: Text('ok'),)
            ],
          ));
    }
  }
  functionToCheckUserAtMe(token) async { 
    print('token is ${token}');
    try {
    var responses = await http.get(
      Uri.parse('https://veeras-edu-api.onrender.com/user/@me'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    // Print response status and body
    print('Response status: ${responses.statusCode}');
    print('Response body: ${responses.body}');

    if (responses.statusCode == 200) {
      // Decode the JSON response only if the status code is 200
      Map<String, dynamic> response = json.decode(responses.body);
      print('after decoding json');

      if (response['meta']['code'] == 200 && response['meta']['message'] == 'Success') {
        userStorage.write('userData', response['data']);
        stopLoading(context);
        successToast('Successfully logged in');
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomePage(),
        ));
        setState(() {});
      } else {
        stopLoading(context);
        errorToast('Invalid OTP');
      }
    } else {
      // Handle other status codes appropriately
      stopLoading(context);
      errorToast('Failed to retrieve user data');
    }
  } catch (e) {
    // Exception handling
    print('Exception user@me: $e');
    stopLoading(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text('Please check your internet or try again later'),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
  }
}
