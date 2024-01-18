import 'package:chat_room/api/api.dart';
import 'package:chat_room/api/beans/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../api/beans/contribute_user.dart';
import 'room_state_manager.dart';

class CircleHeader extends StatelessWidget {
  /// 可能是网络头像或者是本地图片
  final String _imagePath;
  final double _sideLength;

  final UserInfo? userInfo;

  /// 如果是true，点击后弹出详情页
  final bool isToDeail;

  const CircleHeader(this._imagePath, this._sideLength,
      {super.key, this.userInfo, this.isToDeail = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isToDeail && userInfo != null) {
          showBottomPersonDialog(context, userInfo!);
        }
      },
      child: Center(
        child: ClipOval(
          child: Container(
            width: _sideLength,
            height: _sideLength,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(_imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RankUserList extends StatefulWidget {
  final bool is7Days;

  const RankUserList(this.is7Days, {super.key});

  @override
  State<StatefulWidget> createState() => RankUserListState();
}

class RankUserListState extends State<RankUserList> {
  List<ContributeUser> _contributeUserList = List.empty();

  @override
  void initState() {
    super.initState();
    if (widget.is7Days) {
      queryFakeContributeUser()
          .then((value) => setState(() => _contributeUserList = value));
    } else {
      queryFake24HoursContributeUser()
          .then((value) => setState(() => _contributeUserList = value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _contributeUserList.length,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              CircleHeader(
                _contributeUserList[index].headerImage,
                50,
                userInfo: _contributeUserList[index],
                isToDeail: true,
              ),
              Text(_contributeUserList[index].contributeNum),
              Text(_contributeUserList[index].userName),
            ]),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleHeader(
                  _contributeUserList[index].headerImage,
                  30,
                  userInfo: _contributeUserList[index],
                  isToDeail: true,
                ),
                Column(
                  children: [
                    Text(_contributeUserList[index].contributeNum),
                    Text(_contributeUserList[index].userName),
                  ],
                )
              ],
            ),
          );
        }
      },
    );
  }
}

showBottomPersonDialog(BuildContext buildContext, UserInfo userInfo) {
  showModalBottomSheet(
    context: buildContext,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return PersonDialog(userInfo);
    },
  );
}

class PersonDialog extends StatefulWidget {
  UserInfo userInfo;

  PersonDialog(this.userInfo, {super.key});

  @override
  State<StatefulWidget> createState() => PersonDialogState();
}

class PersonDialogState extends State<PersonDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 40),
            height: MediaQuery.of(context).size.height * 0.4 - 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0, bottom: 40),
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(widget.userInfo.id.toString()),
                      Text(widget.userInfo.userName),
                    ],
                  ),
                  Expanded(child: Container()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.lightBlue,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/send_gift.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Send Gift',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orangeAccent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/add_friend.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Add Friend',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: CircleHeader(
              widget.userInfo.headerImage,
              80,
            ),
          ),
        ],
      ),
    );
  }
}

showRankUserListDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return const RankUserListDialog();
    },
  );
}

showRoomUserListSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return const RoomUserListDialog();
    },
  );
}

class RoomUserListDialog extends StatelessWidget {
  const RoomUserListDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RoomUserCubit>(
      create: (context) => getRoomUserCubit,
      child:
          BlocBuilder<RoomUserCubit, List<UserInfo>>(builder: (context, state) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 16,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () => {Navigator.pop(context)},
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CustomPaint(
                              painter: CrossPainter(),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Online Users: ${state.length}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: state.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              CircleHeader(
                                state[index].headerImage,
                                30,
                                userInfo: state[index],
                                isToDeail: true,
                              ),
                              Column(
                                children: [
                                  Text(state[index].id.toString()),
                                  Text(state[index].userName),
                                ],
                              )
                            ],
                          ),
                        );
                      }))
            ]));
      }),
    );
  }
}

class RankUserListDialog extends StatelessWidget {
  const RankUserListDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 16,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => {Navigator.pop(context)},
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CustomPaint(
                          painter: CrossPainter(),
                        ),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Contribution',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          Expanded(
            child: DefaultTabController(
                length: 2, // Tab 的数量
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Last 24 Hours'),
                        Tab(text: 'Last 7 Days'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          RankUserList(false),
                          RankUserList(true),
                        ],
                      ),
                    )
                  ],
                )),
          ),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const CircleHeader('assets/images/headers/head_test0.webp', 40),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('userName'),
                      Text('0'),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.width, size.height),
      paint,
    );

    canvas.drawLine(
      Offset(size.width, 0),
      Offset(0, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(CrossPainter oldDelegate) => false;
}
