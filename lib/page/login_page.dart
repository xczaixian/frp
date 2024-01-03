import 'package:flutter/material.dart';
import '../api/api.dart' as api;
import '../common/logger_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _userName = '';
  String _pwd = '';

  void login() {
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
              TextButton(
                onPressed: () => {login()},
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                child: const Text('登录'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
