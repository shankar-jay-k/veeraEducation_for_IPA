import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as  http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:veera_education_flutter/Controllers/Colors.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:veera_education_flutter/Controllers/apiCalls.dart';
import 'package:veera_education_flutter/Models/CurvedUnderLine.dart';
import 'package:veera_education_flutter/Models/LoadingWidget.dart';
import 'package:veera_education_flutter/Views/Auth/SplashScreen.dart';
import 'package:veera_education_flutter/Views/HomePage/ClassRoom/index.dart';
import 'package:veera_education_flutter/Views/HomePage/Footer.dart';
import 'package:veera_education_flutter/Views/HomePage/OurJourney.dart';
import 'package:veera_education_flutter/Views/HomePage/PlanDetails.dart';
import 'package:veera_education_flutter/Models/Toasts.dart';
import 'package:veera_education_flutter/Models/appBarButtons.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'DemoClassCards.dart';
import 'VeeraMethodWorks.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';


final userStorage = GetStorage();
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex= 0;
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String? deviceId = '';

  String deviceName = 'Unknown';
  String osVersion = 'Unknown';
  String osType = 'Unknown';

  @override
  void initState() {
         // use this for getting unique device id,comment-out to use
         // functionToGetDeviceId();
         // initDeviceInfo();
    super.initState();
  }

  Future<void> initDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      setState(() {
        deviceName = androidInfo.model ?? 'Unknown';
        osVersion = 'Android ${androidInfo.version.release}';
        osType = 'Android';
      });
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      setState(() {
        deviceName = iosInfo.utsname.machine ?? 'Unknown';
        osVersion = '${iosInfo.systemName} ${iosInfo.systemVersion}';
        osType = 'iOS';
      });
    }
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // userStorage.erase();
      print('userData : ${userStorage.read('token')}');
    print('deviceName:${deviceName} , osVersion:${osVersion} , osType:${osType}');
    return Scaffold(
      backgroundColor: appColors.scaffold,
      appBar: AppBar(
        toolbarHeight: 85,
        backgroundColor: Colors.white,
        elevation: 6,
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0,left: 25),
          child: Image.asset(
            'assets/images/newLogo.png',
            width: MediaQuery.of(context).size.width * 0.43,

            fit: BoxFit.contain,
          ),
        ),
        leadingWidth: MediaQuery.of(context).size.width * 0.5,

      actions: [
         if(userStorage.read('paidUser') != null && userStorage.read('paidUser')) 
          appBarButton(
              title: 'Scan',
              icon: Icon(Icons.qr_code_scanner_outlined, color: Colors.black,),
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => QRScanner(),
                ));
              }
          ),
          appBarButton(
              title: 'Notify',
              icon: Icon(Icons.notifications_outlined, color: Colors.black,),
              onTap: () {}
          ),
          appBarButton(
              title: 'Profile',
              icon: Icon(Icons.account_circle_outlined, color: Colors.black,),
              onTap: (){
               showDialog(
                   context: context,
                   builder: (context)=>AlertDialog(
                     content: Text('Are you sure to logout?',style: TextStyle(fontFamily: 'Poppins-SemiBold'),),
                     actions: [
                       MaterialButton(color: Colors.red,child: Text('Cancel',style: TextStyle(fontFamily: 'Poppins-Medium',color: Colors.white),),onPressed: (){Navigator.of(context).pop();}),
                       MaterialButton(color: Colors.green,child: Text('Logout',style: TextStyle(fontFamily: 'Poppins-Medium',color: Colors.white),),onPressed: (){
                         Navigator.of(context).pop();
                         userStorage.erase();
                         Navigator.of(context).pushReplacement(MaterialPageRoute(
                           builder: (context) => SplashScreen(),
                         ));
                       }),
                     ],
                   ));

              }
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [


           userStorage.read('paidUser') != null &&  userStorage.read('paidUser') ?
           SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0,bottom: 10,left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello Tamizh,',style: TextStyle(fontFamily: 'Poppins-Bold',fontSize: 18),),
                    Text('Welcome to the Dashboard,',style: TextStyle(fontSize: 20,fontFamily: 'Poppins-SemiBold',color: Colors.grey),),
                  ],
                ),
              ),
            )
            : SizedBox(height: 10,),

            CarouselSlider.builder(
              itemCount: 3,
              itemBuilder: (BuildContext context, int index, int realIndex) {
                return Container(
                  width: MediaQuery.of(context).size.width ,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage('assets/images/banner${index == 2 ? 1 : index+1}.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: screenUtils.getScreenWidth(context) > 500 ?  250 : 180.0,
                aspectRatio: MediaQuery.of(context).size.width,
                autoPlay: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
            SizedBox(height: 12,),
            DotIndicator(
              itemCount: 3,
              currentIndex: _currentIndex,
              color: Colors.grey, // Change dot color as needed
              dotSize: 8.0, // Change dot size as needed
              dotSpacing: 12.0, // Change dot spacing as needed
              dotIndicatorType: DotIndicatorType.circle, // Change dot shape as needed
            ),

            ///This is how Veera's  method works
            userStorage.read('paidUser') != null && userStorage.read('paidUser')
                ? Container()
                : VeeraMethodWorks(),

            ///Demo class section
             Container(
               margin:EdgeInsets.only(bottom: 25,top:8),
               width: MediaQuery.of(context).size.width * 0.9,
               padding: EdgeInsets.all(5),
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(12),
                 // boxShadow: [
                 //   BoxShadow(
                 //     color: appColors.Shadow_Clr2,
                 //     offset: const Offset(
                 //       1.0,
                 //       3.0,
                 //     ),
                 //     blurRadius:10.0,
                 //   ),
                 // ],
                 color: Color(0xabebf2fc)
               ),
               child: Padding(
                 padding: const EdgeInsets.symmetric(vertical: 20.0),
                 child: Column(
                   children: [
                     userStorage.read('paidUser') != null && userStorage.read('paidUser')
                         ? Text('Our Special Features',style: TextStyle(color:Colors.black,fontFamily: 'apple-chancery',fontWeight: FontWeight.w800,fontSize: 19,letterSpacing: 1.5),)
                         : Text('DEMO CLASS',style: TextStyle( color:Colors.black,fontFamily: 'apple-chancery',fontWeight: FontWeight.w800,fontSize: 19,letterSpacing: 1.5),),
                     SizedBox(height: 8,),
                     CurvedDivider(
                       color: appColors.lightGold,
                       height: 10.0,
                     ),
                     SizedBox(height: 10,),

                     InkWell(
                         onTap: (){
                           Navigator.of(context).push(
                               MaterialPageRoute(builder: (context)=> IndexForClassRoom())
                           );
                         },
                         child: DemoClassCard(image: 'assets/images/4.png',title: 'FORMULA')),
                     Container(
                       margin: EdgeInsets.symmetric(vertical: 15),
                       decoration: BoxDecoration(
                         boxShadow: [
                           BoxShadow(
                             color: appColors.white,
                             offset: const Offset(
                               1.0,
                               3.0,
                             ),
                             blurRadius:10.0,
                           ),         ],
                         borderRadius: BorderRadius.circular(100),
                         color: Colors.white
                       ),
                       child: Padding(
                         padding: EdgeInsets.all(5),
                         child: Icon(Icons.add,size: 30,),
                       ),
                      ),

                     DemoClassCard(image: 'assets/images/5.png',title: 'CLASSROOM'),
                     Container(
                       margin: EdgeInsets.only(top: 15),
                       decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color: appColors.Shadow_Clr2,
                               offset: const Offset(
                                 1.0,
                                 3.0,
                               ),
                               blurRadius:10.0,
                             ),         ],
                           borderRadius: BorderRadius.circular(100),
                           color: Colors.white
                       ),
                       child: Padding(
                         padding: EdgeInsets.all(5),
                         child: Icon(Icons.add,size: 30,),
                       ),
                     ),


                     DemoClassCard(image: 'assets/images/6.png',title: 'SELF PRACTICE'),
                     Container(
                       margin: EdgeInsets.only(top: 15),
                       decoration: BoxDecoration(
                           boxShadow: [
                             BoxShadow(
                               color: appColors.Shadow_Clr2,
                               offset: const Offset(
                                 1.0,
                                 3.0,
                               ),
                               blurRadius:10.0,
                             ),         ],
                           borderRadius: BorderRadius.circular(100),
                           color: Colors.white
                       ),
                       child: Padding(
                         padding: EdgeInsets.all(5),
                         child: Icon(Icons.add,size: 30,),
                       ),
                     ),


                     DemoClassCard(image: 'assets/images/5.png',title: 'SPEAKING ROOM'),
                   ],
                 ),
               ),
             ),

            ///plan details
            userStorage.read('paidUser') != null && userStorage.read('paidUser')
                ? Container()
                : PlanDetails(),


            ///our journey
            userStorage.read('paidUser') != null && userStorage.read('paidUser')
                ? Container()
                : OurJourney(),


            ///footer
           Footer()
    ],
        ),
      ),
    );
  }

   functionToGetDeviceId() async {
     String? dId = await PlatformDeviceId.getDeviceId;
     deviceId = dId;
     setState(() {

     });
     print('Device Id :${deviceId}');
   }
}


enum DotIndicatorType {
  circle,
  square,
}

class DotIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Color color;
  final double dotSize;
  final double dotSpacing;
  final DotIndicatorType dotIndicatorType;

  const DotIndicator({
    required this.itemCount,
    required this.currentIndex,
    required this.color,
    this.dotSize = 8.0,
    this.dotSpacing = 10.0,
    this.dotIndicatorType = DotIndicatorType.circle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
            (index) => _buildDot(index),
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      width: dotSize,
      height: dotSize,
      margin: EdgeInsets.symmetric(horizontal: dotSpacing / 2),
      decoration: BoxDecoration(
        shape: dotIndicatorType == DotIndicatorType.circle
            ? BoxShape.circle
            : BoxShape.rectangle,
        color: index == currentIndex ? color : color.withOpacity(0.4),
      ),
    );
  }
}

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String token = userStorage.read('token');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.scannerBg,
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),

        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 350.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: appColors.white,
          borderRadius: 10,
          overlayColor: appColors.scannerBg,
          borderLength: 60,
          borderWidth: 20,
          cutOutBottomOffset: 80,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) async{

    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      // Print the scanned data
      print('scanned Data ${scanData.code}');

      // Parse the JSON string into a Map
      Map<String, dynamic> code = jsonDecode(scanData.code ?? '');


       functionToSendLoginDetails(code);
    });
  }
  functionToSendLoginDetails(code)async{
    controller?.dispose();
    startLoading(context);

    Map<String, dynamic> body = {
      "channel": "${code['hashedData']}",
    };
    var responseData = await http.post(Uri.parse('https://veeras-edu-api.onrender.com/auth/signin-qr'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization' : 'Bearer $token'
      },
      body: jsonEncode(body), // Encode the body as JSON string
    );

    Map<String, dynamic> response = json.decode(responseData.body);
      print('response from qr sign-in qr Api : ${response}');
    if(response['meta']['code']  == 200){
      stopLoading(context);
      successToast('${response['meta']['message']}');
      showScannedDataDetails(code);
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()));
      setState(() {});
    }
    else{
      stopLoading(context);
      errorToast('${response['meta']['message']}');
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()));
    }

  }
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

   showScannedDataDetails(code) {
     controller?.dispose();
    showDialog(
        context: context,
        builder: (context)=>AlertDialog(
          title: Text('Confirmation',style: TextStyle(fontFamily: 'Poppins-SemiBold',decoration: TextDecoration.underline),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('IP address',style: TextStyle(fontFamily: 'Poppins-Light' ),),
                    Text('${code['details']['ip']}',style: TextStyle(fontFamily: 'Poppins-Medium'),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Location',style: TextStyle(fontFamily: 'Poppins-Light' ),),
                    Text('${getTextBeforeComma(code['details']['location'])}',style: TextStyle(fontFamily: 'Poppins-Medium'),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Browser',style: TextStyle(fontFamily: 'Poppins-Light' ),),
                    Text('${code['details']['browser']}',style: TextStyle(fontFamily: 'Poppins-Medium'),),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            MaterialButton(color: Colors.red,child: Text('Cancel',style: TextStyle(fontFamily: 'Poppins-Medium',color: Colors.white),),onPressed: (){
              Navigator.of(context).pop();
              startLoading(context);
              functionToAuthorizeApp(false,code);
            }),
            MaterialButton(color: Colors.green,child: Text('Authorize',style: TextStyle(fontFamily: 'Poppins-Medium',color: Colors.white),),onPressed: (){
              Navigator.of(context).pop();
              startLoading(context);
              functionToAuthorizeApp(true,code);
            }),
          ],
        ));
   }

   functionToAuthorizeApp(isType,code) async {
     startLoading(context);

     Map<String, dynamic> body = {
       "channel": "${code['hashedData']}",
       "isApprove" : isType
     };
     var responseData = await http.post(Uri.parse('https://veeras-edu-api.onrender.com/auth/authorize-qr'),
       headers: <String, String>{
         'Content-Type': 'application/json; charset=UTF-8',
         'Authorization' : 'Bearer $token'
       },
       body: jsonEncode(body), // Encode the body as JSON string
     );

     Map<String, dynamic> response = json.decode(responseData.body);
     print('response from qr authorize qr Api : ${response},   token is ${token}');
     if(response['meta']['code']  == 200){
       stopLoading(context);
       successToast('Logged-in successfully');

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()));
       setState(() {});
     }
     else{
       stopLoading(context);
       errorToast('Failed to authorize');
       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()));
     }

   }
  String getTextBeforeComma(String input) {
    List<String> parts = input.split(',');
    return parts.isNotEmpty ? parts[0].trim() : '';
  }

}
