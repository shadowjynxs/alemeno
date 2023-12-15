import 'package:alemeno/screens/homepage/homepage.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCGHugA1x9mYDFZYzXROU7NCR1tsLxtSwM",
        projectId: "alemeno-787d2",
        messagingSenderId: "315177451379",
        appId: "1:315177451379:web:834961165857589e700f06",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: "confirmed_order_group",
        channelKey: "confirmed_order",
        channelName: "Confirmed Order",
        channelDescription: "Test channel",
      )
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: "confirmed_channel_group",
        channelGroupName: "Confirmed Order",
      )
    ],
  );
  bool isNotificationOn = await AwesomeNotifications().isNotificationAllowed();
  if (!isNotificationOn) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MainApp(),
    ),
  );

  // runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      );
    });
  }
}
