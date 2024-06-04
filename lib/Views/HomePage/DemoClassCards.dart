import 'package:flutter/material.dart';
import 'package:veera_education_flutter/Controllers/Colors.dart';

class DemoClassCard extends StatefulWidget {
  final image;
  final title;
  final onTap;

  const DemoClassCard({super.key, this.image, this.title, this.onTap});

  @override
  State<DemoClassCard> createState() => _DemoClassCardState();
}

class _DemoClassCardState extends State<DemoClassCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15),
        width: MediaQuery.of(context).size.width * 0.80,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Color(0xffebf2fc),
                width: 2),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFEFEFEF),
                offset: const Offset(
                  5.0,
                  10.0,
                ),
                blurRadius:50.0,spreadRadius: 12
              ),         ],
            color: Colors.white
        ),
        child: Column(
          children: [
            Container(
                height: 180,
                width: MediaQuery.of(context).size.width * 0.82,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Image.asset('${widget.image}',fit: BoxFit.cover)),
            SizedBox(height: 18,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${widget.title}',style: TextStyle(fontFamily: 'poppins-semibold',fontSize: 15),),
                  SizedBox()
                  // InkWell(
                  //   onTap: widget.onTap,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         border: Border.all(color: appColors.lightGold),
                  //         borderRadius: BorderRadius.circular(20)
                  //     ),
                  //     child: Padding(
                  //       padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                  //       child:Text('VIEW',style: TextStyle(fontFamily: 'poppins-bold',fontSize: 15,letterSpacing: 2),),
                  //
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}
