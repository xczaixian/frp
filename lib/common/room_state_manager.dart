import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/beans/user_info.dart';
import 'im_sdk.dart';

// 麦克风已上麦的用户
class MicUserCubit extends Cubit<List<UserInfo>> {
  MicUserCubit(super.initialState);

  void addUser(UserInfo userInfo) {
    List<UserInfo> currentList = state;
    currentList.add(userInfo);
    emit(List<UserInfo>.from(currentList));
  }

  void removeUser(int userId) {
    List<UserInfo> currentList =
        state.where((element) => element.id != userId).toList(growable: true);
    emit(List<UserInfo>.from(currentList));
  }

  void setList(List<UserInfo> list) {
    emit(list);
  }
}

// 房间用户列表
class RoomUserCubit extends Cubit<List<UserInfo>> {
  RoomUserCubit(super.initialState);

  void addUser(UserInfo userInfo) {
    List<UserInfo> currentList = state;
    currentList.add(userInfo);
    emit(List<UserInfo>.from(currentList));
  }

  void removeUser(int userId) {
    List<UserInfo> currentList =
        state.where((element) => element.id != userId).toList(growable: true);
    emit(List<UserInfo>.from(currentList));
  }

  void setList(List<UserInfo> list) {
    emit(list);
  }
}

// 房间是否静音状态，默认false
class SoundOffCubit extends Cubit<bool> {
  SoundOffCubit(super.initialState);

  void switchState() => emit(!state);
}

// 聊天记录
class ChatRecordCubit extends Cubit<List<ChatRecord>> {
  ChatRecordCubit(super.initialState);

  void changeRecrod(List<ChatRecord> list) {
    if (state.isNotEmpty) {
      state.clear();
    }
    state.addAll(list);
    emit(state);
  }

  void addRecord(ChatRecord chatRecord) {
    // 将新数据添加到当前列表中
    List<ChatRecord> currentList = state;
    currentList.add(chatRecord);
    emit(List<ChatRecord>.from(currentList));
  }

  void clearRecord() {
    state.clear();
    emit(List<ChatRecord>.from(state));
  }
}

MicUserCubit? _micUserCubit;

MicUserCubit get getMicUserCubit => _micUserCubit!;

SoundOffCubit? _soundOffCubit;

SoundOffCubit get getSoundOffCubit => _soundOffCubit!;

ChatRecordCubit? _chatRecordCubit;

ChatRecordCubit get getChatRecordCubit => _chatRecordCubit!;

RoomUserCubit? _roomUserCubit;

RoomUserCubit get getRoomUserCubit => _roomUserCubit!;

// 进入聊天室的时候初始化状态
void initRoomState() {
  _micUserCubit = MicUserCubit(List.empty(growable: true));
  _soundOffCubit = SoundOffCubit(false);
  _chatRecordCubit = ChatRecordCubit(List<ChatRecord>.empty(growable: true));
  _roomUserCubit = RoomUserCubit(List.empty(growable: true));
}

// 退出聊天室的时候清除状态
void releaseRoomState() {
  _micUserCubit?.close();
  _micUserCubit = null;
  _soundOffCubit?.close();
  _soundOffCubit = null;
  _chatRecordCubit?.close();
  _chatRecordCubit = null;
  _roomUserCubit?.close();
  _roomUserCubit = null;
}
