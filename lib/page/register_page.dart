import 'package:flutter/material.dart';
import '../api/api.dart' as api;
import '../common/logger_util.dart';
import 'package:toast/toast.dart';

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
      Toast.show('请输入验证码', duration: Toast.lengthLong, gravity: Toast.bottom);
    }
    api.loginWithUserName(_userName, _pwd).then((value) => {
          if (value.isEmpty)
            {
              //登录成功
              logger.d('login success')
            }
          else
            {
              //登录失败
              logger.d('login failed')
            }
        });
  }

  void getCode() async {
    if (_phone.isEmpty) {
      Toast.show('请输入手机号', duration: Toast.lengthLong, gravity: Toast.bottom);
      return;
    }
    String code = await api.getVerificationCode(_phone);
    codeController.text = code;
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
                    hintText: '请输入账号', filled: true, fillColor: Colors.white),
                onChanged: (value) => {_userName = value},
              ),
              TextField(
                  decoration: const InputDecoration(
                      hintText: '请输入密码', filled: true, fillColor: Colors.white),
                  onChanged: (value) => {_pwd = value}),
              TextField(
                decoration: const InputDecoration(
                    hintText: '请输入手机号', filled: true, fillColor: Colors.white),
                onChanged: (value) => {_phone = value},
              ),
              TextField(
                  controller: codeController,
                  decoration: const InputDecoration(
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
