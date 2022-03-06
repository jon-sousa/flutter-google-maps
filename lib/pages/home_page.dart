import 'dart:convert';

import 'package:entrega/pages/map_page.dart';
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
      return;
    }

    endereco = jsonDecode(response.body);
    print(endereco['logradouro']);
    setState(() {});
  }

  _tratarRequisicao(http.Response response) {
    if (response.statusCode >= 400 || response.body.isEmpty) {
      requisicaoIncorreta = true;
    }
  }

  Widget _buildEnderecoWidget() {
    if (requisicaoIncorreta == true) {
      return Text('Requisição Incorreta');
    }

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
              SizedBox(
                height: 16,
              ),
              _buildLocalizacao(),
            ],
          ),
        ),
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
