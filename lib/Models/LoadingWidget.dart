


import 'package:flutter/material.dart';
import 'package:veera_education_flutter/Controllers/Colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width:30,height:30,child: CircularProgressIndicator(color: appColors.lightGold,)),
            Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text('Loading...',style: TextStyle(fontFamily: 'poppins-medium'),),)
          ],
        ),
      ),
    );
  }
}

class LoadingCustomTitleWidget extends StatefulWidget {
  final String title;
  const LoadingCustomTitleWidget({super.key, required this.title});

  @override
  State<LoadingCustomTitleWidget> createState() => _LoadingCustomTitleWidgetState();
}

class _LoadingCustomTitleWidgetState extends State<LoadingCustomTitleWidget> {


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: AlertDialog(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width:30,height:30,child: CircularProgressIndicator(color: appColors.lightGold,)),
            Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text('${widget.title}',style: TextStyle(fontFamily: 'poppins-medium'),),)
          ],
        ),
      ),
    );
  }
}

 startLoading(context){
   showDialog(
       barrierColor: Colors.black38,
       barrierDismissible: false,
       context: context,
       builder: (BuildContext context){
         return LoadingWidget();
       }
   );

 }
 startCustomTitleLoading(title,context){
   showDialog(
       barrierColor: Colors.black38,
       barrierDismissible: false,
       context: context,
       builder: (BuildContext context){
         return LoadingCustomTitleWidget(title: title);
       }
   );

 }
 stopLoading(context){
  Navigator.of(context).pop();
}