import 'package:flutter/material.dart';
import 'package:soapp/session_page.dart';
import 'package:soapp/home_page.dart';
import 'package:soapp/widget/colors.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  int currentTab = 1;
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomePage();

  changePage(int tab, Widget page) {
    setState(() {
      currentTab = tab;
      currentScreen = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        // color: Colors.white,
        elevation: 10,
        surfaceTintColor: Colors.white,
        child: Container(
          // color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentTab = 1;
                    currentScreen = const HomePage();
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.upload_file,
                      color: currentTab == 1 ? warnaUtama : Colors.grey,
                    ),
                    Text(
                      'Master Data',
                      style: TextStyle(
                        color: currentTab == 1 ? warnaUtama : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentTab = 2;
                    currentScreen = const CountPage();
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calculate_outlined,
                      color: currentTab == 2 ? warnaUtama : Colors.grey,
                    ),
                    Text(
                      'Stock Opname',
                      style: TextStyle(
                        color: currentTab == 2 ? warnaUtama : Colors.grey,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
      ),
    );
  }
}
