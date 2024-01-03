import 'dart:async';
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'logger_util.dart';

class Config {
// 填写项目的 App ID，可在声网控制台中生成
  static const String appId = "41cb6429b9da4589a083282a1f339714";
// 填写声网控制台中生成的临时 Token
  static const String token =
      "007eJxTYKibp/j9bYz2t8PikssVd23cw2PHovkv61qGUIqy2yzd+1UKDCaGyUlmJkaWSZYpiSamFpaJBhbGRhZGiYZpxsaW5oYmid21qQ2BjAx8s7xZGRkgEMxnKEktLolPzkgsiS/Kz89lYAAAGI4hOA==";
// 填写频道名
  static const String channelName = "test_chat_room";

  static int uid = Random().nextInt(200);
}

class MicCubit extends Cubit<bool> {
  MicCubit(super.initialState);

  void switchState() => emit(!state);
}

class RTCSDK {
  RTCSDK._();

  static final RTCSDK _instance = RTCSDK._();

  static RTCSDK get instance => _instance;

  late final RtcEngine _engine;

  final ChannelProfileType _channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting;
  late final RtcEngineEventHandler _rtcEngineEventHandler;

  Future<void> initRtcEngine() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: Config.appId,
    ));

    _rtcEngineEventHandler = RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        ('[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        logger.d(
            '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        logger.d(
            '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
      },
    );

    _engine.registerEventHandler(_rtcEngineEventHandler);

    await _engine.enableAudio();
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.setAudioProfile(
      profile: AudioProfileType.audioProfileDefault,
      scenario: AudioScenarioType.audioScenarioGameStreaming,
    );
  }

  releaseRtcEngine() {
    _engine.release();
  }

  switchAudioUpload(bool enable) {
    //这里false是发布（默认），true是取消发布
    _engine.muteLocalAudioStream(!enable);
    logger.d('改变音频上传状态:$enable');
  }

  joinChannel() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }

    await _engine.joinChannel(
        token: Config.token,
        channelId: Config.channelName,
        uid: Config.uid,
        options: ChannelMediaOptions(
          channelProfile: _channelProfileType,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
        ));
  }

  leaveChannel() async {
    await _engine.leaveChannel();
  }
}
