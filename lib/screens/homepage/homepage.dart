
import 'package:alemeno/screens/homepage/responsive/desktop/desktop_page.dart';
import 'package:alemeno/screens/homepage/responsive/mobile/mobile_page.dart';
import 'package:alemeno/screens/homepage/responsive/responsive_layout.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileDevice: MobilePage(),
        desktopDevice: DesktopPage(),
      ),
    );
  }
}
