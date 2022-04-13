import 'package:flutter/material.dart';
import 'package:flutter_projects/ProductScreen.dart';
import 'package:flutter_projects/UpdateProductScreen.dart';




void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        ProductScreen.id: (context) => ProductScreen(),
        UpdateProductScreen.id: (context) => UpdateProductScreen(),

      },
      initialRoute: ProductScreen.id,
    );
  }
}
