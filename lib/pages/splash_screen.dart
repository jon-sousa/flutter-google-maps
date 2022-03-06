import 'package:entrega/pages/home_page.dart';
import 'package:entrega/pages/login_page.dart';
import 'package:entrega/providers/shared_preferences_helper.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _processaRequisicao();
  }

  _processaRequisicao() async {
    bool estaLogado = await SharedPreferencesHelper().getUsuario();

    await Future.delayed(const Duration(seconds: 3));

    if (estaLogado) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      return;
    }
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/img/icon.png'),
          ],
        ),
      ),
    );
  }
}
