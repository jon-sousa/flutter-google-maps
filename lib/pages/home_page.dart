import 'dart:convert';

import 'package:entrega/pages/login_page.dart';
import 'package:entrega/pages/map_page.dart';
import 'package:entrega/providers/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _cepController = TextEditingController();
  final _numeroController = TextEditingController();
  Map<String, dynamic> endereco = {};
  String localizacao = '';
  bool requisicaoIncorreta = false;

  _cadastrarRequisicao() async {
    final cep = _cepController.text;
    final response =
        await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));

    _tratarRequisicao(response);
    if (requisicaoIncorreta == true) {
      setState(() {});
      return;
    }

    setState(() {
      endereco = jsonDecode(response.body);
    });
  }

  _tratarRequisicao(http.Response response) {
    if (response.statusCode >= 400 || response.body.isEmpty) {
      requisicaoIncorreta = true;
      return;
    }

    var enderecoResponse = jsonDecode(response.body);
    if (enderecoResponse['logradouro'] == null) {
      requisicaoIncorreta = true;
      return;
    }

    requisicaoIncorreta = false;
  }

  Widget _buildEnderecoWidget() {
    if (requisicaoIncorreta == false && endereco.isNotEmpty) {
      return Card(
        color: Colors.blue,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Logradouro: ${endereco['logradouro']}, número ${_numeroController.text}'),
              Text('Bairro: ${endereco['bairro']}'),
              Text('Municipio: ${endereco['localidade']}'),
              Text('Estado: ${endereco['uf']}'),
              const SizedBox(
                height: 16,
              ),
              _buildLocalizacao(),
            ],
          ),
        ),
      );
    }
    if (requisicaoIncorreta == true) {
      return const Center(
        child: Text('Erro na requisição ou requisição incorreta'),
      );
    } else {
      return Container();
    }
  }

  Widget _buildLocalizacao() {
    if (localizacao.isEmpty) {
      return Container();
    }
    return Card(
      color: Colors.white,
      child: ListTile(
          title: const Text('Localização'), subtitle: Text(localizacao)),
    );
  }

  @override
  void dispose() {
    _cepController.dispose();
    _numeroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrega'),
        actions: [
          GestureDetector(
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.logout),
              ),
              onTap: () {
                SharedPreferencesHelper().setUsuario(false);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginPage()));
              })
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: _cepController,
                    decoration: const InputDecoration(labelText: 'CEP'),
                  ),
                  TextFormField(
                    controller: _numeroController,
                    decoration: const InputDecoration(labelText: 'Número'),
                  ),
                ],
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.touch_app),
                title: const Text('Adicione a localização'),
                trailing: localizacao.isNotEmpty
                    ? const Icon(
                        Icons.check,
                        color: Colors.green,
                      )
                    : null,
                onTap: () async {
                  localizacao = await Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => MapPage()));
                  setState(() {});
                },
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              onPressed: _cadastrarRequisicao,
              child: const Text('Cadastrar'),
            ),
            const SizedBox(
              height: 24,
            ),
            _buildEnderecoWidget()
          ],
        ),
      ),
    );
  }
}
