import 'package:flutter/material.dart';
import 'package:veera_education_flutter/Controllers/Colors.dart';

class appBarButton extends StatefulWidget {
  final Widget icon;
  final title;
  final onTap;
  const appBarButton({super.key, required this.icon, this.onTap, this.title});

  @override
  State<appBarButton> createState() => _appBarButtonState();
}

class _appBarButtonState extends State<appBarButton> {
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: widget.onTap,

      child: Padding(
        padding:EdgeInsets.only(right: screenUtils.getScreenWidth(context) > 500 ? 25 : 15,top:15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
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
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: widget.icon
                ),
              ),
            ),
            SizedBox(height: 5,),
            Text('${widget.title}',style: TextStyle(color: Colors.black,fontFamily: 'poppins-medium',fontSize: 10),)

          ],
        ),
      ),
    );
  }
}
