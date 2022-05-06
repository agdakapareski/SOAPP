import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soapp/tab_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 2500)).then((value) {
      Route route = CupertinoPageRoute(
        builder: (context) => const TabScreen(),
      );

      Navigator.pushReplacement(context, route);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    SizedBox(),
                  ],
                ),
              ),
              Image.asset('images/ic_launcher.png'),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'SOAPP',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      'Developed by :',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Laurensius Agdaka Pareski',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'PT. KONIMEX',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
