import 'package:flutter/material.dart';

import '../api/beans/contribute_user.dart';

class CircleHeader extends StatelessWidget {
  /// 可能是网络头像或者是本地图片
  final String _imagePath;
  final double _sideLength;

  const CircleHeader(this._imagePath, this._sideLength, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
              CircleHeader(_contributeUserList[index].headImg, 50),
              Text(_contributeUserList[index].contributeNum),
              Text(_contributeUserList[index].userName),
            ]),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleHeader(_contributeUserList[index].headImg, 30),
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
