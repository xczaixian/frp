import 'package:flutter/material.dart';

class GiftBean {
  String image;
  String name;

  GiftBean(this.image, this.name);
}

class GiftClass {
  String label;
  List<GiftBean> list;

  GiftClass(this.label, this.list);
}

GiftClass classGift0 = GiftClass('class0', [
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test3.webp'),
  GiftBean('一号', 'assets/images/headers/head_test2.webp'),
  GiftBean('一号', 'assets/images/headers/head_test1.webp'),
  GiftBean('一号', 'assets/images/headers/head_test1.webp'),
  GiftBean('一号', 'assets/images/headers/head_test1.webp'),
]);

GiftClass classGift1 = GiftClass('class1', [
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test3.webp'),
  GiftBean('一号', 'assets/images/headers/head_test2.webp'),
  GiftBean('一号', 'assets/images/headers/head_test1.webp'),
  GiftBean('一号', 'assets/images/headers/head_test1.webp'),
  GiftBean('一号', 'assets/images/headers/head_test1.webp'),
]);

GiftClass classGift2 = GiftClass('class2', [
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test0.webp'),
  GiftBean('一号', 'assets/images/headers/head_test3.webp'),
  GiftBean('一号', 'assets/images/headers/head_test2.webp'),
  GiftBean('一号', 'assets/images/headers/head_test1.webp'),
  GiftBean('一号', 'assets/images/headers/head_test1.webp'),
  GiftBean('一号', 'assets/images/headers/head_test1.webp'),
]);

/// 获取礼物数据
Future<List<GiftClass>> queryGiftSet() async {
  List<GiftClass> list = List.empty(growable: true);
  list.add(classGift0);
  list.add(classGift1);
  list.add(classGift2);
  return list;
}

showGiftDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return GiftDialog();
    },
  );
}

class GiftDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GiftDialogState();
}

class GiftDialogState extends State<GiftDialog> {
  List<GiftClass> _giftList = List.empty();

  @override
  void initState() {
    super.initState();
    queryGiftSet().then((value) => setState(() => _giftList = value));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          Expanded(
            child: DefaultTabController(
                length: _giftList.length, // Tab 的数量
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorPadding: EdgeInsets.only(right: 10),
                        isScrollable: true,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey,
                        tabs: _giftList
                            .map(
                              (e) => Tab(
                                  child: SizedBox(
                                width: 50,
                                child: Text(e.label),
                              )),
                            )
                            .toList(),
                        indicator: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1, // 设置下划线宽度与Tab宽度一致
                              color: Colors.white, // 可自定义下划线颜色
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: _giftList
                            .map(
                              (e) => GiftPageView(),
                            )
                            .toList(),
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}

class GiftPageView extends StatefulWidget {
  const GiftPageView({super.key});

  @override
  State<StatefulWidget> createState() => GiftPageViewState();
}

class GiftPageViewState extends State<GiftPageView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              GridView.count(
                crossAxisCount: 4,
                children: List.generate(8, (index) {
                  return Container(
                    color: Colors.blue,
                    margin: EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        'Item ${index + 1}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }),
              ),
              GridView.count(
                crossAxisCount: 4,
                children: List.generate(8, (index) {
                  return Container(
                    color: Colors.green,
                    margin: EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        'Item ${index + 9}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }),
              ),
              GridView.count(
                crossAxisCount: 4,
                children: List.generate(8, (index) {
                  return Container(
                    color: Colors.red,
                    margin: EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        'Item ${index + 17}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              width: 10,
              height: 10,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.white : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}
