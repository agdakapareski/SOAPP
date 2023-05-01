import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:soapp/home_page.dart';
import 'package:soapp/providers/histori_provider.dart';
import 'package:soapp/providers/sesi_provider.dart';
import 'package:soapp/providers/stock_provider.dart';
import 'package:soapp/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: providers,
      child: const MyApp(),
    ),
  );
}

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<SesiProvider>(create: (_) => SesiProvider()),
  ChangeNotifierProvider<StockProvider>(create: (_) => StockProvider()),
  ChangeNotifierProvider<HistoriProvider>(create: (_) => HistoriProvider()),
];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SOAPP',
      theme: ThemeData(
        fontFamily: 'Lato',
        primarySwatch: Colors.red,
      ),
      // home: const SplashScreen(),
      home: const HomePage(),
    );
  }
}
