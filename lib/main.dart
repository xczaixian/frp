import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chat_room/common/IMSDK.dart';
import 'package:chat_room/common/RTCSDK.dart';
import 'package:chat_room/page/RoomListPage.dart';
import 'package:flutter/material.dart';

import 'common/SPUtil.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // IMSDK.instance.onAppInit();
  // SPUtil.instance.initSP();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  initApp() {
    SPUtil.instance.initSP();
    IMSDK.instance.onAppInit();
    RTCSDK.instance.initRtcEngine();
  }

  leaveApp() {
    IMSDK.instance.onAppLeave();
    RTCSDK.instance.releaseRtcEngine();
  }

  @override
  void initState() {
    super.initState();
    initApp();
  }

  @override
  void dispose() {
    leaveApp();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat room',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RoomListPage(),
    );
  }
}
