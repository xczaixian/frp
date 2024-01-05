import 'dart:async';

import 'package:chat_room/page/room_list_page.dart';
import 'package:flutter/material.dart';
import '../common/sp_util.dart';

import '../common/login_manager.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int _second = 3;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _second--;
      });
      if (_second == 0) {
        checkLogin(context);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(_second > 0 ? '这是引导页,$_second秒后跳转' : '正在登录...')),
      backgroundColor: Colors.white,
    );
  }
}
