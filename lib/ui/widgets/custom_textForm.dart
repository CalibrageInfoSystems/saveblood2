import 'package:flutter/material.dart';
class CustomTextFormField extends StatelessWidget {
   
   final String hint;
   final TextInputType keybordtype;

CustomTextFormField({this.hint,this.keybordtype});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius:new BorderRadius.circular(10.0) ,
      elevation:12 ,
          child: TextFormField(
           decoration: new InputDecoration(
          labelText: hint,
          fillColor: Colors.white,
          border: new OutlineInputBorder(
            borderRadius:new BorderRadius.circular(10.0),
            borderSide: new BorderSide(),
            
          ),
          //fillColor: Colors.green
        ),
        
        validator: (val) {
          if (val.length == 0) {
            return "Email cannot be empty";
          } else {
            return null;
          }
        },
      
        keyboardType: keybordtype,
        // style: new TextStyle(
        //   fontFamily: "Poppins",
        // ),
      ),
    );
  }
}