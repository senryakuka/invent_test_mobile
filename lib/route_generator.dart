import 'package:tesandroid/src/screens/product_list.dart';
import 'package:flutter/material.dart';
import 'package:tesandroid/src/screens/search.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/ProductsList':
        return MaterialPageRoute(builder: (_) => ProductListWidget());
      case '/Search':
        return MaterialPageRoute(builder: (_) => SearchWidget());

      // If args is not of the correct type, return an error page.
      // You can also throw an exception while in development.

      //return _errorRoute();
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
