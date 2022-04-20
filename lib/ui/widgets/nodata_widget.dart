import 'package:flutter/material.dart';
import 'package:flutter_logindemo/ui/widgets/GradientText.dart';
class NoDataAvaialble extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Center( 
  
       child: Column(children: <Widget>[
      Icon(Icons.error, size: 55.0, color: Colors.yellow,),
        GradientText('No Data',
              gradient: LinearGradient(colors: [
                Colors.orange[500], Colors.pinkAccent
              ]),)
      ],),
    );
  }
}