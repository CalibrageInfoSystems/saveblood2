import 'package:flutter/material.dart';
import 'package:flutter_logindemo/ui/widgets/GradientText.dart';
class NoInterntet extends StatelessWidget {
  const NoInterntet({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
      padding: EdgeInsets.all(10),
      child: Center( child: Column(children: <Widget>[
      Icon(Icons.error, size: 55.0, color: Colors.red,),
        GradientText('No Internet',
              gradient: LinearGradient(colors: [
                Colors.orange[500], Colors.pinkAccent
              ]),)
      ],),),
    );
  }
}