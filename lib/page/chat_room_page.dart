import 'package:chat_room/common/im_sdk.dart';
import 'package:chat_room/common/rtc_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:async';

import '../common/logger_util.dart';

class ChatRoomPage extends StatefulWidget {
  const ChatRoomPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoomPage> {
  // 默认状态打开
  MicCubit micCubit = MicCubit(true);

  @override
  void initState() {
    super.initState();

    // IM初始化
    IMSDK.instance.onJoinChatRoom();
    IMSDK.instance.chatRecordCubit.addRecord(ChatRecord(
        '为什么猪不能上天空呢？因为它们会变成猪飞机！😄',
        '莉莉',
        'assets/images/default_avatar.jpg',
        false));

    RTCSDK.instance.joinChannel();
  }

  @override
  void dispose() {
    IMSDK.instance.onLeaveChatRoom();

    RTCSDK.instance.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/bg2.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: BlocProvider(
        create: (context) => IMSDK.instance.chatRecordCubit,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 46),
              child: TopBar(),
            ),
            const SizedBox(
              height: 10,
            ),
            RankBar(),
            MicGrid(),
            const Expanded(child: ChatWindow()),
            BlocProvider(
              create: (context) => micCubit,
              child: BottomToolBar(),
            ),
          ],
        ),
      ),
    ));
  }
}

class ChatWindow extends StatelessWidget {
  const ChatWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ChatList(),
        ),
        GiftRow(),
      ],
    );
  }
}

class ChatOtherWidget extends StatelessWidget {
  final ChatRecord chatRecord;

  const ChatOtherWidget(this.chatRecord, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 5),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(chatRecord.headUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                chatRecord.authorName,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 240),
              child: Card(
                color: Colors.black, // 设置背景颜色为黑色
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // 设置圆角半径
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    chatRecord.content,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}

class ChatOwnWidget extends StatelessWidget {
  final ChatRecord chatRecord;

  const ChatOwnWidget(this.chatRecord, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 240),
                child: Card(
                  color: Colors.black, // 设置背景颜色为黑色
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // 设置圆角半径
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      chatRecord.content,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                      softWrap: true,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        Container(
          margin: const EdgeInsets.only(right: 0),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(chatRecord.headUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

class ChatList extends StatelessWidget {
  ChatList({super.key});

  ScrollController _scrollController = ScrollController();

  void smoothScrollTo(double offset) {
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRecordCubit, List<ChatRecord>>(
        builder: (context, state) {
      return BlocListener<ChatRecordCubit, List<ChatRecord>>(
        listener: (context, state) {
          Future.delayed(
              const Duration(milliseconds: 50),
              () =>
                  {smoothScrollTo(_scrollController.position.maxScrollExtent)});
        },
        child: ListView.builder(
            controller: _scrollController,
            itemCount: state.length,
            reverse: true,
            itemBuilder: (context, index) {
              ChatRecord chatRecord = state[index];
              return Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 10, top: 10, bottom: 10),
                  child: chatRecord.isOwn
                      ? ChatOwnWidget(chatRecord)
                      : ChatOtherWidget(chatRecord));
            }),
      );
    });
  }
}

class GiftRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              children: [
                Image.asset(
                  'assets/images/box.png',
                  height: 50,
                  width: 50,
                ),
                const Text(
                  'click',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/box.png',
                    height: 50,
                    width: 50,
                  ),
                  const Text(
                    'click',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/box.png',
                    height: 50,
                    width: 50,
                  ),
                  const Text(
                    'click',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/box.png',
                    height: 50,
                    width: 50,
                  ),
                  const Text(
                    'click',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Color(0x1affffff);
    final rect = Rect.fromLTWH(0, 0, size.width * 0.8, size.height);
    canvas.drawRect(rect, paint);

    final trianglePaint = Paint()..color = Color(0x1affffff);
    final x = size.width * 0.8;
    final y = size.height / 2;
    // final halfHeight = size.height * 0.5;
    final path1 = Path()
      ..moveTo(x, 0)
      ..lineTo(size.width, 0)
      ..lineTo(x, y)
      ..close();
    canvas.drawPath(path1, trianglePaint);

    final path2 = Path()
      ..moveTo(x, y)
      ..lineTo(size.width, size.height)
      ..lineTo(x, size.height)
      ..close();
    canvas.drawPath(path2, trianglePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RankBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        children: [
          Container(
            width: 150,
            height: 46,
            child: Stack(
              children: [
                Container(
                  width: 150,
                  height: 46,
                  child: CustomPaint(
                    painter: FlagPainter(),
                  ),
                ),
                Center(
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/cup.png',
                        width: 40,
                        height: 40,
                      ),
                      const Text(
                        '50.3K >',
                        style: TextStyle(color: Colors.yellow, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            height: 60,
            width: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Center(
                  child: ClipOval(
                    child: Container(
                      margin: EdgeInsets.only(right: 8),
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/default_avatar.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0x1affffff),
                  shape: BoxShape.circle,
                ),
                child: null,
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/people.svg',
                      width: 12,
                      height: 12,
                    ),
                    const Text(
                      '982',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class MicData {
  MicData(this.id, this.name, this.pic);

  String id = '0';
  String name = 'unknown';
  String pic = 'assets/images/default_avatar.jpg';
}

getMicContainer(int index, MicData micData) {
  String pic = micData.pic;
  if (pic == '') {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xccffffff),
                shape: BoxShape.circle,
              ),
              child: null,
            ),
            SvgPicture.asset(
              'assets/svgs/mic.svg',
              width: 22,
              height: 22,
            )
          ],
        ),
        Text(
          '$index',
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
      ],
    );
  } else {
    return Column(
      children: [
        ClipOval(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(pic),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Text(
          micData.name,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        )
      ],
    );
  }
}

class MicGrid extends StatelessWidget {
  List<MicData> list = [
    MicData('ali', 'unknown', 'assets/images/default_avatar.jpg'),
    MicData('1', 'unknown', ''),
    MicData('kaite', 'unknown', 'assets/images/default_avatar.jpg'),
    MicData('keyi', 'unknown', 'assets/images/default_avatar.jpg'),
    MicData('meisi', 'unknown', 'assets/images/default_avatar.jpg'),
    MicData('luxi', 'unknown', 'assets/images/default_avatar.jpg'),
    MicData('6', 'unknown', ''),
    MicData('7', 'unknown', ''),
    MicData('kexi', 'unknown', 'assets/images/default_avatar.jpg'),
    MicData('alio', 'unknown', 'assets/images/default_avatar.jpg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 5,
        children: <Widget>[
          for (int i = 0; i < list.length; i++) getMicContainer(i, list[i]),
        ],
      ),
    );
  }
}

class BottomToolBar extends StatelessWidget {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MicCubit, bool>(
      listener: (context, state) {
        RTCSDK.instance.switchAudioUpload(state);
      },
      builder: (context, state) {
        return Container(
          height: 70,
          padding: const EdgeInsets.only(left: 15, right: 15),
          decoration: const BoxDecoration(color: Colors.black),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: SvgPicture.asset(
                  state ? 'assets/svgs/voice.svg' : 'assets/svgs/silence.svg',
                  width: 22,
                  height: 22,
                ),
                onTap: () => context.read<MicCubit>().switchState(),
              ),
              SizedBox(
                width: 160,
                child: BlocBuilder<ChatRecordCubit, List<ChatRecord>>(
                  builder: (context, state) {
                    return TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                          prefixIconConstraints: const BoxConstraints(
                              maxWidth: 20,
                              maxHeight: 20,
                              minHeight: 20,
                              minWidth: 20),
                          prefixIcon: Image.asset(
                            'assets/images/message.png',
                            width: 20,
                            height: 20,
                          ),
                          hintText: 'Type..',
                          hintStyle: const TextStyle(
                              color: Colors.white, fontSize: 15)),
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                      onChanged: (text) {
                        logger.d('输入的文本是：$text');
                      },
                      onSubmitted: (value) {
                        logger.d('发送消息,$value');
                        IMSDK.instance.sendMsg(value);
                        _controller.clear();
                      },
                    );
                  },
                ),
              ),
              Image.asset(
                'assets/images/gift.png',
                width: 30,
                height: 30,
              ),
              SvgPicture.asset(
                'assets/svgs/options.svg',
                width: 22,
                height: 22,
              ),
              SvgPicture.asset(
                'assets/svgs/handup.svg',
                width: 22,
                height: 22,
              ),
              SvgPicture.asset(
                'assets/svgs/menu.svg',
                width: 22,
                height: 22,
              ),
            ],
          ),
        );
      },
    );
  }
}

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IntrinsicWidth(
          child: Container(
            padding:
                const EdgeInsets.only(left: 9, top: 12, bottom: 12, right: 13),
            decoration: const BoxDecoration(
                color: Color(0x1affffff),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(66),
                  bottomRight: Radius.circular(66),
                )),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/default_avatar.jpg',
                  width: 56,
                  height: 56,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Superyaya',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'ID:2023089',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )
                    ],
                  ),
                ),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xfff95c9b),
                        shape: BoxShape.circle,
                      ),
                      child: null,
                    ),
                    SvgPicture.asset(
                      'assets/svgs/heart.svg',
                      width: 22,
                      height: 22,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        Row(
          children: [
            SvgPicture.asset(
              'assets/svgs/quit.svg',
              width: 25,
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 16),
              child: SvgPicture.asset(
                'assets/svgs/shutdown.svg',
                width: 25,
                height: 25,
              ),
            ),
          ],
        )
      ],
    );
  }
}
