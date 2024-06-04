import 'package:flutter/material.dart';
import 'package:veera_education_flutter/Controllers/Colors.dart';

class OurJourney extends StatelessWidget {
  const OurJourney({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:EdgeInsets.only(bottom: 35,top:8),
      width: MediaQuery.of(context).size.width * 0.95,
      padding: EdgeInsets.symmetric(vertical: 25),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white
      ),
      child: Column(
        children: [
          Text('OUR JOURNEY',style: TextStyle(fontFamily: 'apple-chancery',fontWeight: FontWeight.w800,fontSize: 19,letterSpacing: 2),),
          SizedBox(height: 25,),
          journeyDetails('Veera’s institute was established','2009',true),
          journeyDetails('Veera’s institute was born & made of its first video \n recording on DVD,s but unable to launch','2012',true),
          journeyDetails('Launched of its first service to the public through \n offline','2016',true),
          journeyDetails('For the first time the service was offered online','2019',true),
          journeyDetails('Veera’s Education firm turn to private limited','2022',true),
          journeyDetails('Finally, in front of all with a full range of services','2023',true),
          journeyDetails('Website launch','2024',false),

        ],
      ),
    );
  }

  journeyDetails(text,year,showDivider){
    return Padding(
      padding: EdgeInsets.all(3),
      child: Column(
        children: [
          Text(text,style: TextStyle(fontFamily: 'poppins-medium'),textAlign: TextAlign.center),
          SizedBox(height: 5,),
          Text(year,style: TextStyle(fontFamily: 'poppins-bold',fontSize: 16,color: appColors.lightGold),),
          if(showDivider)
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            height:25,width: 2,
            decoration: BoxDecoration(
                color: Colors.black
            ),
          )

        ],
      ),
    );
  }
}
