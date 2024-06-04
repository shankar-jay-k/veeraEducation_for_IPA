import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:veera_education_flutter/Controllers/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:veera_education_flutter/Models/LoadingWidget.dart';
import 'package:veera_education_flutter/Models/Toasts.dart';
import 'package:veera_education_flutter/Views/HomePage/HomePage.dart';

final userStorage = GetStorage();
class PlanDetails extends StatefulWidget {
  const PlanDetails({super.key});

  @override
  State<PlanDetails> createState() => _PlanDetailsState();
}

class _PlanDetailsState extends State<PlanDetails> {

  String chosenPlan = '';
  int chosenPlanTotal = 0;
  double chosenPlanGst = 0;
  double total = 0;
    String keyId = "rzp_test_gKANZdsNdLqaQs";
    String keySecret = "3UFrNGkdLR9apMa3dOUE1jvh";

  final _razorpay = Razorpay();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
      _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    });
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Show loading with custom title
    startCustomTitleLoading('Redirecting to dashboard', context);

    // Print the response for debugging purposes
    print(response);

    // Wait for 3 seconds and then execute the following code
    Future.delayed(Duration(seconds: 3), () {
        userStorage.write('paidUser',true);
          setState(() {
                  });
          stopLoading(context);
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage()));
          successToast('You`re in DashBoard');
      // Optionally verify the payment signature
      verifySignature(
        signature: response.signature,
        paymentId: response.paymentId,
        orderId: response.orderId,
      );
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response);
    // Do something when payment fails
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message ?? ''),
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response);
    // Do something when an external wallet is selected
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.walletName ?? ''),
      ),
    );
  }

// create order
  void createOrder() async {
    String username = keyId;
    String password = keySecret;
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$username:$password'))}';

    Map<String, dynamic> body = {
      "amount": total * 100,
      "currency": "INR",
      "receipt": "rcptid_11"
    };
    var res = await http.post(
      Uri.https(
          "api.razorpay.com", "v1/orders"), //https://api.razorpay.com/v1/orders
      headers: <String, String>{
        "Content-Type": "application/json",
        'authorization': basicAuth,
      },
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      openGateway(jsonDecode(res.body)['id']);
    }
    print(res.body);
  }

  openGateway(String orderId) {
    var options = {
      'key': keyId,
      'amount': 100, //in the smallest currency sub-unit.
      'name': 'Veera`s Education',
      'order_id': orderId, // Generate order_id using Orders API
      'description': 'Payment for ${chosenPlan} month',
      'timeout': 60 * 5, // in seconds // 5 minutes
      'prefill': {
        'contact': '9123456789',
        'email': 'ary@example.com',
      }
    };
    _razorpay.open(options);
  }

  verifySignature({
    String? signature,
    String? paymentId,
    String? orderId,
  }) async {
    Map<String, dynamic> body = {
      'razorpay_signature': signature,
      'razorpay_payment_id': paymentId,
      'razorpay_order_id': orderId,
    };

    var parts = [];
    body.forEach((key, value) {
      parts.add('${Uri.encodeQueryComponent(key)}='
          '${Uri.encodeQueryComponent(value)}');
    });
    var formData = parts.join('&');
    var res = await http.post(
      Uri.https(
        "10.0.2.2", // my ip address , localhost
        "razorpay_signature_verify.php",
      ),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded", // urlencoded
      },
      body: formData,
    );

    print(res.body);
    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.body),
        ),
      );
    }
  }

  @override
  void dispose() {
    _razorpay.clear(); // Removes all listeners
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin:EdgeInsets.only( top:8),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 25),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white
          ),
          child: Column(
            children: [
              Text('CHOOSE YOUR PLAN',style: TextStyle(fontFamily: 'apple-chancery',fontWeight: FontWeight.w800,fontSize: 19,),),
              SizedBox(height: 10,),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                  child:Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/images/flags/India.png',height: 28,),
                      Text('  INDIA',style: TextStyle(fontFamily: 'poppins-medium',fontSize: 15,letterSpacing: 2),),
                    ],
                  ),

                ),
              ),
              SizedBox(height: 15,),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xffeae5de),
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                  child: Text('Complete platform',style: TextStyle(fontFamily: 'poppins-medium',fontSize: 15,letterSpacing: 2),),
                ),
              ),
              SizedBox(height: 25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text('Popular',style: TextStyle(fontFamily: 'poppins-medium',fontSize: 15),),
                      InkWell(
                        onTap: (){
                          chosenPlanTotal = 0;
                          chosenPlan = '1';
                          int price = int.parse(chosenPlan);
                          chosenPlanTotal = 830 * price;
                          chosenPlanGst = (chosenPlanTotal * 18) / 100;
                          total = chosenPlanGst + chosenPlanTotal;
                          setState(() {

                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5),
                          width: MediaQuery.of(context).size.width * 0.43,
                          height:200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            border: Border.all(color: chosenPlan == '1' ?  appColors.lightGold : appColors.Shadow_Clr2 ,width: 2),
                           boxShadow: [
                            chosenPlan == '1' ?
                            BoxShadow(
                                color: Colors.black,
                                offset: const Offset(
                                  5.0,
                                  12.0,
                                ),
                                blurRadius:1.0,
                                spreadRadius: 2
                            )
                            : BoxShadow(
                                color: appColors.Shadow_Clr2,
                                offset: const Offset(
                                  1.0,
                                  3.0,
                                ),
                                blurRadius:10.0,
                              ),],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: chosenPlan == '1' ?  [appColors.lightGold,appColors.lightGold,] : [Colors.white,Colors.white,] ,
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Text('1 Month plan',style: TextStyle(fontFamily: 'poppins-semibold'),),
                              ),
                              Divider(color:chosenPlan == '1' ? Colors.white : Colors.grey[300],thickness: 1),
                              SizedBox(height: 10,),
                              Text('₹ 830',style: TextStyle(fontSize:24,fontFamily: 'Poppins-SemiBold'),),
                              SizedBox(height: 10,),
                              Text('INR / month',style: TextStyle(fontFamily: 'poppins-semibold'),),
                              SizedBox(height: 15,),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            color: Color(0xffd4ffd9),
                            border: Border.all(color: Color(0xff219b2d)),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: Text('  Most popular  ',style: TextStyle(fontFamily: 'poppins-medium',color: Colors.black,fontSize: 15,),)),
                      InkWell(
                        onTap: (){
                          chosenPlanTotal = 0;
                          chosenPlan = '5';
                          int price = int.parse(chosenPlan);
                          chosenPlanTotal = 830 * price;
                          chosenPlanGst = (chosenPlanTotal * 18) / 100;
                          total = chosenPlanGst + chosenPlanTotal;
                          setState(() {

                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width * 0.43,
                          height:200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),

                            border: Border.all(color: chosenPlan == '5' ?  appColors.lightGold : appColors.Shadow_Clr2 ,width: 2),

                            boxShadow: [
                              chosenPlan == '5' ?
                              BoxShadow(
                                  color: Colors.black,
                                  offset: const Offset(
                                    5.0,
                                    12.0,
                                  ),
                                  blurRadius:1.0,
                                  spreadRadius: 2
                              )
                                  : BoxShadow(
                                color: appColors.Shadow_Clr2,
                                offset: const Offset(
                                  1.0,
                                  3.0,
                                ),
                                blurRadius:10.0,
                              ),],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: chosenPlan == '5' ? [appColors.lightGold,appColors.lightGold] : [Colors.white,Colors.white],
                            ),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Text('5 Months plan',style: TextStyle(fontFamily: 'poppins-semibold'),),
                              ),
                              Divider(color:chosenPlan == '5' ? Colors.white : Colors.grey[300],thickness: 1),
                              SizedBox(height: 10,),
                              Text('₹ 830',style: TextStyle(fontSize:24,fontFamily: 'Poppins-SemiBold'),),
                              SizedBox(height: 10,),
                              Text('INR / month',style: TextStyle(fontFamily: 'poppins-semibold'),),
                              Text('+',style: TextStyle(fontSize:24,fontFamily: 'poppins-medium'),),
                              Text('1 month extra',style: TextStyle(fontFamily: 'poppins-bold'),),
                              SizedBox(height: 15,),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        if(chosenPlan != '')
        Container(
          margin:EdgeInsets.only(bottom: 15,top:8),
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 25),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: appColors.scaffold
          ),
          alignment: Alignment.center,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            margin:EdgeInsets.only( top:8,right: 25,left: 25),
            padding: EdgeInsets.symmetric(vertical: 25),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: appColors.Shadow_Clr2,
                  offset: const Offset(
                    1.0,
                    3.0,
                  ),
                  blurRadius:10.0,
                ),         ],
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('ORDER SUMMARY',style: TextStyle(fontSize: 17,fontFamily: 'poppins-bold',letterSpacing: 2),),
                  SizedBox(height: 25,),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.45,

                      child: Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${chosenPlan} Month  X 830',style: TextStyle(fontFamily: 'poppins-semibold'),),
                                Text('₹${chosenPlanTotal}',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 16),),
                              ],
                            ),
                            SizedBox(height: 15,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('GST  18%',style: TextStyle(fontFamily: 'poppins-semibold'),),
                                Text('₹${chosenPlanGst}',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 16),),

                              ],
                            ),
                            SizedBox(height: 15,),
                            Divider(color: appColors.lightGold,thickness: 1,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('TOTAL',style: TextStyle(fontFamily: 'poppins-semibold',fontSize: 17),),
                                Text('₹${total}',style: TextStyle(fontWeight: FontWeight.w800,fontSize: 16),),
                              ],
                            ),
                            Divider(color: appColors.lightGold,thickness: 1,),

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                  MaterialButton(
                      color: appColors.lightGold,
                      onPressed: (){
                        startLoading(context);
                        createOrder();
                      },
                      child: Text('PAY NOW',style: TextStyle(fontSize: 17,fontFamily: 'poppins-semibold',letterSpacing: 2,color: Colors.black),)                      ,)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
