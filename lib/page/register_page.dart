import 'package:chat_room/page/room_list_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../api/api.dart' as api;
import '../common/logger_util.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _userName = '';
  String _pwd = '';
  String _verificationCode = '';
  String _phone = '';

  TextEditingController codeController = TextEditingController();

  void register() {
    if (_verificationCode.isEmpty) {
      Fluttertoast.showToast(msg: '请输入验证码');
      return;
    }
    api.register(_userName, _pwd, _phone, _verificationCode).then((value) {
      if (value.isEmpty) {
        Fluttertoast.showToast(msg: '注册成功，已登录');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const RoomListPage()));
      } else {
        Fluttertoast.showToast(msg: '注册失败，$value');
      }
    });
  }

  void getCode() async {
    if (_phone.isEmpty) {
      Fluttertoast.showToast(msg: '请输入手机号');
      return;
    }
    String code = await api.getVerificationCode(_phone);
    codeController.text = code;
    _verificationCode = code;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: const InputDecoration(
                    labelText: '用户名',
                    hintText: '请输入账号',
                    filled: true,
                    fillColor: Colors.white),
                onChanged: (value) => {_userName = value},
              ),
              TextField(
                  decoration: const InputDecoration(
                      labelText: '密码',
                      hintText: '请输入密码',
                      filled: true,
                      fillColor: Colors.white),
                  onChanged: (value) => {_pwd = value}),
              TextField(
                decoration: const InputDecoration(
                    labelText: '手机号',
                    hintText: '请输入手机号',
                    filled: true,
                    fillColor: Colors.white),
                onChanged: (value) => {_phone = value},
              ),
              TextField(
                  controller: codeController,
                  decoration: const InputDecoration(
                      labelText: '验证码',
                      hintText: '请输入验证码',
                      filled: true,
                      fillColor: Colors.white),
                  onChanged: (value) => {_verificationCode = value}),
              TextButton(
                onPressed: () => {getCode()},
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                child: const Text('获取验证码'),
              ),
              TextButton(
                onPressed: () => {register()},
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                child: const Text('注册'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
