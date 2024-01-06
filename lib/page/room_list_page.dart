import 'dart:io';

import 'package:chat_room/api/beans/room_bean.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../api/api.dart';
import '../common/logger_util.dart';
import '../common/rtc_sdk.dart';
import '../components/android_foreground_service_widget.dart';
import 'chat_room_page.dart';
import '../api/Api.dart' as api;

class RoomListPage extends StatefulWidget {
  const RoomListPage({super.key});

  @override
  State<StatefulWidget> createState() => RoomListPageState();
}

class RoomListCubit extends Cubit<List<RoomBean>> {
  RoomListCubit(super.initialState);

  void changeList(List<RoomBean> list) {
    List<RoomBean> result = List.empty(growable: true);
    result.addAll(list);
    emit(result);
  }

  void addRoom(RoomBean chatRecord) {
    // 将新数据添加到当前列表中
    List<RoomBean> currentList = state;
    currentList.add(chatRecord);
    emit(List<RoomBean>.from(currentList));
  }

  void clearRecord() {
    state.clear();
    emit(List<RoomBean>.from(state));
  }
}

class RoomListPageState extends State<RoomListPage> {
  final RoomListCubit _roomListCubit =
      RoomListCubit(List.empty(growable: true));

  @override
  void initState() {
    super.initState();
    updateRoomList(false);
  }

  void updateRoomList(bool addAlways) {
    api.queryChannelList().then((value) {
      if (value.isNotEmpty) {
        _roomListCubit.changeList(value);
      } else if (addAlways) {
        _roomListCubit.addRoom(RoomBean(default_channel_name, default_image,
            default_roompwd, default_country, default_roomType));
      }
    });
  }

  void _toRoom(BuildContext context, RoomBean roomBean) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      Widget widget = ChatRoomPage(roomBean.channelName);
      if (!kIsWeb && Platform.isAndroid) {
        widget = AndroidForegroundServiceWidget(child: widget);
      }
      return widget;
    }));
  }

  void createRoom() {
    api.createRoom(default_channel_name, default_image).then((value) {
      if (value.isNotEmpty) {
        Fluttertoast.showToast(msg: '创建房间失败:$value');
      } else {
        Fluttertoast.showToast(msg: '创建房间成功');
        updateRoomList(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => _roomListCubit,
      child: Container(
          padding: const EdgeInsets.only(top: 30),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              TextButton(
                  onPressed: () => {createRoom()},
                  child: const Text('创建房间'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white))),
              Expanded(
                child: BlocBuilder<RoomListCubit, List<RoomBean>>(
                  builder: (context, state) {
                    return state.isEmpty
                        ? Container(
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: const Center(
                              child: Text(
                                '当前没有房间..',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.blue),
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: state.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  _toRoom(context, state[index]);
                                },
                                title: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: Text(
                                    state[index].channelName,
                                    style: const TextStyle(
                                        fontSize: 24, color: Colors.green),
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
              ),
            ],
          )),
    ));
  }
}
