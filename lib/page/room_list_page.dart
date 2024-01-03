import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../common/logger_util.dart';
import '../common/rtc_sdk.dart';
import '../components/android_foreground_service_widget.dart';
import 'chat_room_page.dart';
import '../api/Api.dart' as api;

class RoomListPage extends StatelessWidget {
  const RoomListPage({super.key});

  void _toRoom(BuildContext context, int index) {
    if (index == 1) {
      api
          .getVerificationCode('18390059526')
          .then((value) => logger.d('收到验证码：$value'));
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      Widget widget = const ChatRoomPage();
      if (!kIsWeb && Platform.isAndroid) {
        widget = AndroidForegroundServiceWidget(child: widget);
      }

      return widget;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.only(top: 30),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: ListView.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    _toRoom(context, index);
                  },
                  title: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: const Text(
                      Config.channelName,
                      style: TextStyle(fontSize: 24, color: Colors.green),
                    ),
                  ),
                );
              },
            )));
  }
}
