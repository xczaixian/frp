import 'package:chat_room/api/beans/user_info.dart';

class ContributeUser extends UserInfo {
  int index;
  String contributeNum;

  ContributeUser(
      this.index, int id, String headImg, String userName, this.contributeNum)
      : super(id, headImg, userName);
}

List<ContributeUser> _testRank = [
  ContributeUser(
      1, 1, 'assets/images/headers/head_test0.webp', '西双版纳', '20.0K'),
  ContributeUser(
      2, 2, 'assets/images/headers/head_test1.webp', '可爱天使', '10.0K'),
  ContributeUser(3, 3, 'assets/images/headers/head_test2.webp', '魔力宝贝', '5.0K'),
  ContributeUser(4, 4, 'assets/images/headers/head_test3.webp', '夏娃', '5.0K'),
  ContributeUser(5, 5, 'assets/images/headers/head_test4.webp', '小小', '4.0K'),
  ContributeUser(6, 6, 'assets/images/headers/head_test0.webp', '西双版纳', '3.0K'),
  ContributeUser(7, 7, 'assets/images/headers/head_test1.webp', '可爱天使', '2.0K'),
  ContributeUser(8, 8, 'assets/images/headers/head_test2.webp', '魔力宝贝', '1.0K'),
  ContributeUser(9, 9, 'assets/images/headers/head_test3.webp', '夏娃', '500'),
  ContributeUser(10, 10, 'assets/images/headers/head_test4.webp', '小小', '200'),
];

Future<List<ContributeUser>> queryFakeContributeUser() async {
  List<ContributeUser> newList = _testRank.toList();
  for (var e in newList) {
    e.contributeNum = '1${e.contributeNum}';
  }
  return newList;
}

Future<List<ContributeUser>> queryFake24HoursContributeUser() async {
  return _testRank;
}
