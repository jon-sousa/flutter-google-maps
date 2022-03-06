import 'package:entrega/pages/home_page.dart';
import 'package:entrega/providers/shared_preferences_helper.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usuarioController = TextEditingController();
  final _senhaController = TextEditingController();

  _login() {
    var _usuario = 'usuario';
    var _senha = '123456';

    SharedPreferencesHelper().setUsuario(true);

    if (_usuarioController.text == _usuario &&
        _senhaController.text == _senha) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Form(
              child: Column(
            children: [
              TextFormField(
                controller: _usuarioController,
                decoration: const InputDecoration(
                  label: Text('Usuário'),
                ),
              ),
              TextFormField(
                obscureText: true,
                controller: _senhaController,
                decoration: const InputDecoration(
                  label: Text('Senha'),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton(onPressed: _login, child: const Text('Login'))
            ],
          ))
        ],
      ),
    );
  }
}
