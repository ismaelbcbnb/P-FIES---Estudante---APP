import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_register_screen.dart';

class Home extends StatefulWidget {
  final int pessoaId;

  const Home({Key? key, required this.pessoaId}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? nome;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    buscarNomeAluno();
  }

  Future<void> buscarNomeAluno() async {
    final url = Uri.parse(
      'https://s1iisp45.dmz.bnb/BN.S627.FIES.Web.Cliente.API/api/aluno/obtemAluno?id=${widget.pessoaId}',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          nome = data['Nome'];
          isLoading = false;
        });
      } else {
        setState(() {
          nome = 'Erro ao carregar nome';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        nome = 'Erro de conexão';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginRegisterScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Text(
          'Olá, $nome',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
