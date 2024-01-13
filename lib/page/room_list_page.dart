import 'dart:io';

import 'package:chat_room/api/beans/room_bean.dart';
import 'package:chat_room/common/rtc_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../api/api.dart';
import '../api/beans/wrap_bean.dart';
import '../common/logger_util.dart';
import '../components/android_foreground_service_widget.dart';
import 'chat_room_page.dart';
import '../api/Api.dart' as api;

class RoomListPage extends StatefulWidget {
  const RoomListPage({super.key});

  @override
  State<StatefulWidget> createState() => RoomListPageState();
}

class RoomListCubit extends Cubit<List<ChannelListSimpleBean>> {
  RoomListCubit(super.initialState);

  void changeList(List<ChannelListSimpleBean> list) {
    List<ChannelListSimpleBean> result = List.empty(growable: true);
    result.addAll(list);
    emit(result);
  }

  void addRoom(ChannelListSimpleBean chatRecord) {
    // 将新数据添加到当前列表中
    List<ChannelListSimpleBean> currentList = state;
    currentList.add(chatRecord);
    emit(List<ChannelListSimpleBean>.from(currentList));
  }

  void clearRecord() {
    state.clear();
    emit(List<ChannelListSimpleBean>.from(state));
  }
}

class RoomListPageState extends State<RoomListPage> {
  final RoomListCubit _roomListCubit =
      RoomListCubit(List.empty(growable: true));

  @override
  void initState() {
    super.initState();
    if (Config.isTmpTest) {
      _roomListCubit.addRoom(ChannelListSimpleBean(Config.tmpChannelName, 1));
    } else {
      updateRoomList();
    }
  }

  void updateRoomList() {
    api.queryChannelList().then((value) {
      _roomListCubit.changeList(value);
    });
  }

  void _toRoom(BuildContext context, ChannelListSimpleBean roomBean) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      Widget widget = ChatRoomPage(roomBean.channel_name);
      if (!kIsWeb && Platform.isAndroid) {
        widget = AndroidForegroundServiceWidget(child: widget);
      }
      return widget;
    }));
  }

// 创建一个全局的 GlobalKey<FormState>
  final _formKey = GlobalKey<FormState>();
  final _textEditingController = TextEditingController();

// 创建一个方法来显示弹窗
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // 使用一个 ListView 包装一个 Column，以支持多个输入字段
        return AlertDialog(
          title: const Text('创建房间表单'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ListBody(
                children: <Widget>[
                  // 添加一个输入框
                  TextFormField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      labelText: '房间名',
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return '请输入内容';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            // 添加一个取消按钮
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // 添加一个确定按钮
            TextButton(
              child: const Text('确定'),
              onPressed: () {
                // 验证输入框的内容
                if (_formKey.currentState!.validate()) {
                  String value = _textEditingController.text;
                  _createRoom(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _createRoomAction() {
    _showDialog(context);
  }

  void _createRoom(String channelName) {
    RoomBean roomBean = RoomBean(channelName, default_image, default_roompwd,
        default_country, default_roomType);
    api.createRoom(roomBean).then((value) {
      if (value == null) {
        logger.d('创建房间失败');
      } else {
        Fluttertoast.showToast(msg: '创建房间成功');
        _toRoom(context, ChannelListSimpleBean(channelName, 1));
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
                  onPressed: () => {_createRoomAction()},
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white)),
                  child: const Text('创建房间')),
              Expanded(
                child: BlocBuilder<RoomListCubit, List<ChannelListSimpleBean>>(
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
                                    state[index].channel_name,
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
