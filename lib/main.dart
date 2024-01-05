import 'package:chat_room/common/im_sdk.dart';
import 'package:chat_room/common/rtc_sdk.dart';
import 'package:chat_room/page/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'common/sp_util.dart';

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
    ToastContext().init(context);
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
      home: const SplashPage(),
    );
  }
}
