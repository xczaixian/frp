import 'dart:async';
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chat_room/api/api.dart';
import 'package:chat_room/common/login_manager.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import 'logger_util.dart';

class Config {
  // 填写项目的 App ID，可在声网控制台中生成
  // static const String appId = "41cb6429b9da4589a083282a1f339714";
  static const String appId = "e4e5265a2566410ab86b0290c72aef00";
  //是否临时测试模式
  static const bool isTmpTest = false;
  // 填写声网控制台中生成的临时 Token
  static const String tmpToken =
      "007eJxTYLg++Xp93Naf+/7q+cnFTln06P1D+eanq8tVL+XPKi3wFdBRYEg1STU1MjNNNDI1MzMxNEhMsjBLMjCyNEg2N0pMTTMwEF61KLUhkJGh6LoGKyMDIwMLEIP4TGCSGUyyQMmS1OISBgYAQDIjNQ==";
  static const String tmpChannelName = 'test';
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
        ('xc:[onError] err: $err, msg: $msg');
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        logger.d(
            '[xc:onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        logger.d(
            '[xc:onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
      },
      onAudioDeviceStateChanged: (deviceId, deviceType, deviceState) =>
          {logger.d('onAudioDeviceStateChanged()+$deviceState')},
      onAudioDeviceVolumeChanged: (deviceType, volume, muted) =>
          {logger.d("onAudioDeviceVolumeChanged()+$volume")},
      onAudioSubscribeStateChanged:
          (channel, uid, oldState, newState, elapseSinceLastState) =>
              {logger.d("onAudioSubscribeStateChanged()+$newState")},
      onLocalAudioStateChanged: (connection, state, error) =>
          {logger.d("onLocalAudioStateChanged()+$state")},
      onRemoteAudioStateChanged:
          (connection, remoteUid, state, reason, elapsed) =>
              {logger.d("onRemoteAudioStateChanged()+$state")},
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

  //切换静音状态,true:的话静音，false，取消静音
  switchSoundOffState(bool state) {
    _engine.muteLocalAudioStream(state);
    _engine.muteAllRemoteAudioStreams(state);
    logger.d('改变静音状态:$state');
  }

  joinChannel(String channelName) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await Permission.microphone.request();
    }
    String token;
    if (Config.isTmpTest) {
      token = Config.tmpToken;
    } else {
      token = await getAgoraToken(channelName, getUid());
    }
    int uid = getUid();
    logger.d('设置的uid=$uid');
    await _engine.joinChannel(
        token: token,
        channelId: channelName,
        uid: uid,
        options: ChannelMediaOptions(
          channelProfile: _channelProfileType,
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          autoSubscribeAudio: true,
          enableAudioRecordingOrPlayout: true,
          publishMicrophoneTrack: true,
        ));
  }

  leaveChannel() async {
    await _engine.leaveChannel();
  }
}
