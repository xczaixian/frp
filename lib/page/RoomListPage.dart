import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../common/RTCSDK.dart';
import '../components/android_foreground_service_widget.dart';
import 'ChatRoomPage.dart';

class RoomListPage extends StatelessWidget {
  const RoomListPage({super.key});

  void _toRoom(BuildContext context) {
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
              itemCount: 1,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    _toRoom(context);
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
