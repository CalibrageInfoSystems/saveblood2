import 'package:flutter/material.dart';

import '../widgets/responsive_ui.dart';

class CustomTextField2 extends StatelessWidget {
  final String hint;
  final TextEditingController textEditingController;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData icon;
  double _width;
  double _pixelRatio;
  bool large;
  bool medium;

  CustomTextField2({
    this.hint,
    this.textEditingController,
    this.keyboardType,
    this.icon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _pixelRatio = MediaQuery.of(context).devicePixelRatio;
    large = ResponsiveWidget.isScreenLarge(_width, _pixelRatio);
    medium = ResponsiveWidget.isScreenMedium(_width, _pixelRatio);
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: large ? 12 : (medium ? 10 : 8),
      child: TextFormField(
          controller: textEditingController,
          keyboardType: keyboardType,
          cursorColor: Colors.redAccent,
          obscureText: obscureText,
          // decoration: InputDecoration(
          //   prefixIcon: Icon(icon, color: Colors.redAccent, size: 20),
          //   hintText: hint,
          //   border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(30.0),
          //       borderSide: BorderSide.none),
          // ),
          decoration : InputDecoration(
          labelText: hint,
          fillColor: Colors.white,
          prefixIcon:Icon(icon),
          border: new OutlineInputBorder(
            borderRadius:new BorderRadius.circular(10.0),
            borderSide: new BorderSide(),
            
          ),
          //fillColor: Colors.green
        ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          }),
    );
  }
}
