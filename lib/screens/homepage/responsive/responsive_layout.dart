import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileDevice;
  final Widget desktopDevice;

  const ResponsiveLayout({
    super.key,
    required this.mobileDevice,
    required this.desktopDevice,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return mobileDevice;
      } else if (constraints.maxWidth > 600) {
        return desktopDevice;
      } else {
        return const Center(
          child: Text("Something is wrong"),
        );
      }
    });
  }
}
