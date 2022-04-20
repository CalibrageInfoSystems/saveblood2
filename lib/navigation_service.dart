import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class  NavigationService {

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

   Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState.pushNamed(routeName);
  }

  bool goBack() {
     navigatorKey.currentState.pop();
     return true;
  }
  
}