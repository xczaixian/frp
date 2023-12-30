import 'package:chat_room/common/SPUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../page/ChatRoomPage.dart';
import 'UuidUtil.dart';

class IMConfig {
  static String AppKey = '1129231215169095#chat-room';

  static String getUserName() {
    return SPUtil.instance.getOrSetString(SPKey.username, getUUid());
  }

  static String getPassword() {
    return SPUtil.instance.getOrSetString(SPKey.password, getUUid());
  }
}

class ChatRecord {
  ChatRecord(this.content, this.authorName, this.headUrl, this.isOwn);

  String content;
  String authorName;
  String headUrl;
  bool isOwn;
}

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

class IMSDK {
  IMSDK._();

  static final IMSDK _instance = IMSDK._();

  static IMSDK get instance => _instance;

  ChatRecordCubit chatRecordCubit =
      ChatRecordCubit(List<ChatRecord>.empty(growable: true));

  ChatRecordCubit get cubit => chatRecordCubit;

  String? chatRoomId;

  onAppInit() async {
    await _initIM();
    await _checkLogin();
  }

  onAppLeave() async {
    await _loginOut();
  }

  sendMsg(String content) {
    if (chatRoomId != null) {
      final msg = EMMessage.createTxtSendMessage(
        targetId: chatRoomId!,
        content: content,
        chatType: ChatType.ChatRoom,
      );
      // 聊天室消息的优先级。如果不设置，默认值为 `Normal`，即“普通”优先级。
      // msg.chatroomMessagePriority = ChatRoomMessagePriority.High;
      EMClient.getInstance.chatManager.sendMessage(msg);
    }
  }

  _addListener() {
    // 注册连接状态监听
    EMClient.getInstance.addConnectionEventHandler(
      "UNIQUE_HANDLER_ID",
      EMConnectionEventHandler(
        // sdk 连接成功;
        onConnected: () => {logger.d("onConnected()")},
        // 由于网络问题导致的断开，sdk会尝试自动重连，连接成功后会回调 "onConnected";
        onDisconnected: () => {logger.d("onDisconnected()")},
        // 用户 token 鉴权失败;
        onUserAuthenticationFailed: () =>
            {logger.d("onUserAuthenticationFailed()")},
        // 由于密码变更被踢下线;
        onUserDidChangePassword: () => {logger.d("onUserDidChangePassword()")},
        // 用户被连接被服务器禁止;
        onUserDidForbidByServer: () => {logger.d("onUserDidForbidByServer()")},
        // 用户登录设备超出数量限制;
        onUserDidLoginTooManyDevice: () =>
            {logger.d("onUserDidLoginTooManyDevice()")},
        // 用户从服务器删除;
        onUserDidRemoveFromServer: () =>
            {logger.d("onUserDidRemoveFromServer()")},
        // 调用 `kickDevice` 方法将设备踢下线，被踢设备会收到该回调；
        onUserKickedByOtherDevice: () =>
            {logger.d("onUserKickedByOtherDevice()")},
        // 登录新设备时因达到了登录设备数量限制而导致当前设备被踢下线，被踢设备收到该回调；
        onUserDidLoginFromOtherDevice: (String deviceName) =>
            {logger.d("onUserDidLoginFromOtherDevice(),$deviceName")},
        // Token 过期;
        onTokenDidExpire: () => {logger.d("onTokenDidExpire()")},
        // Token 即将过期，需要调用 renewToken;
        onTokenWillExpire: () => {logger.d("onTokenWillExpire()")},
      ),
    );
    // 添加消息状态变更监听
    EMClient.getInstance.chatManager.addMessageEvent(
        // ChatMessageEvent 对应的 key。
        "UNIQUE_HANDLER_ID",
        ChatMessageEvent(
          onSuccess: (msgId, msg) {
            logger.d("send message succeed");
            EMTextMessageBody body = msg.body as EMTextMessageBody;
            chatRecordCubit.addRecord(ChatRecord(
                body.content,
                msg.from ?? 'unknown',
                'assets/images/default_avatar.jpg',
                true));
          },
          onProgress: (msgId, progress) {
            logger.d("send message succeed");
          },
          onError: (msgId, msg, error) {
            logger.d(
              "send message failed, code: ${error.code}, desc: ${error.description}",
            );
          },
        ));

    // 添加收消息监听
    EMClient.getInstance.chatManager.addEventHandler(
      // EMChatEventHandler 对应的 key。
      "UNIQUE_HANDLER_ID",
      EMChatEventHandler(
        onMessagesReceived: (messages) {
          for (var msg in messages) {
            switch (msg.body.type) {
              case MessageType.TXT:
                {
                  EMTextMessageBody body = msg.body as EMTextMessageBody;
                  logger.d(
                    "receive text message: ${body.content}, from: ${msg.from}",
                  );
                  cubit.addRecord(ChatRecord(
                      body.content,
                      msg.from ?? 'unknown',
                      'assets/images/default_avatar.jpg',
                      false));
                }
                break;
              case MessageType.IMAGE:
                {
                  logger.d(
                    "receive image message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.VIDEO:
                {
                  logger.d(
                    "receive video message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.LOCATION:
                {
                  logger.d(
                    "receive location message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.VOICE:
                {
                  logger.d(
                    "receive voice message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.FILE:
                {
                  logger.d(
                    "receive image message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.CUSTOM:
                {
                  logger.d(
                    "receive custom message, from: ${msg.from}",
                  );
                }
                break;
              case MessageType.CMD:
                {
                  // 当前回调中不会有 CMD 类型消息，CMD 类型消息通过 `EMChatEventHandler#onCmdMessagesReceived` 回调接收
                }
                break;
            }
          }
        },
      ),
    );
  }

  _removeListener() {
    // 解注册连接状态监听
    EMClient.getInstance.removeConnectionEventHandler(
      "UNIQUE_HANDLER_ID",
    );
    EMClient.getInstance.chatManager.removeMessageEvent(
      "UNIQUE_HANDLER_ID",
    );
    EMClient.getInstance.chatManager.removeEventHandler(
      "UNIQUE_HANDLER_ID",
    );
  }

  onJoinChatRoom() async {
    _addListener();
    _joinIMChatRoom();
  }

  Future<void> _joinIMChatRoom() async {
    EMPageResult<EMChatRoom>? result;
    // 获取公开聊天室列表，每次最多可获取 1,000 个。
    logger.d('请求聊天室');
    try {
      result = await EMClient.getInstance.chatRoomManager
          .fetchPublicChatRoomsFromServer(
        pageNum: 1,
        pageSize: 10,
      );
    } on EMError catch (e) {
      logger.e(e);
    }
    logger.d('获取聊天室结果：$result');
// 加入聊天室
    try {
      if (result != null && result.data != null && result.data!.isNotEmpty) {
        EMChatRoom chatRoom = result.data!.first;
        await EMClient.getInstance.chatRoomManager
            .joinChatRoom(chatRoom.roomId);
        logger.d('聊天室加入成功，chatRoomId=${chatRoom.roomId}');
        chatRoomId = chatRoom.roomId;
      } else {
        logger.d('找不到聊天室房间');
      }
    } on EMError catch (e) {
      logger.e(e);
    }
  }

  onLeaveChatRoom() async {
    if (chatRoomId != null) {
      try {
        await EMClient.getInstance.chatRoomManager.leaveChatRoom(chatRoomId!);
        logger.d('聊天室退出成功,chatroomid=$chatRoomId');
        chatRoomId = null;
      } on EMError catch (e) {
        logger.e(e);
      }
    }

    cubit.clearRecord();
    _removeListener();
  }

  _checkLogin() async {
    bool? hasRegister = SPUtil.instance.getBool(SPKey.hasRegister);
    if (hasRegister == null || !hasRegister) {
      await _register();
    }
    await _login();
  }

  _register() async {
    try {
      await EMClient.getInstance
          .createAccount(IMConfig.getUserName(), IMConfig.getPassword());
      SPUtil.instance.setBool(SPKey.hasRegister, true);
      logger.d('sign up success;');
    } on EMError catch (e) {
      logger.e(e);
    }
  }

  _login() async {
    try {
      await EMClient.getInstance
          .login(IMConfig.getUserName(), IMConfig.getPassword());
      logger.d('login success,userName=${IMConfig.getUserName()}');
    } on EMError catch (e) {
      logger.e(e);
    }
  }

  _loginOut() async {
    try {
      await EMClient.getInstance.logout(true);
    } on EMError catch (e) {
      logger.e(e);
    }
  }
}

Future<void> _initIM() async {
  EMOptions options = EMOptions(
    appKey: IMConfig.AppKey,
    autoLogin: false,
  );
  await EMClient.getInstance.init(options);
  // 通知 SDK UI 已准备好。该方法执行后才会收到 `EMChatRoomEventHandler`、`EMContactEventHandler` 和 `EMGroupEventHandler` 回调。
  await EMClient.getInstance.startCallback();
}
