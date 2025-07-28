import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'custom_red_button.dart';

class ContagemForm extends StatefulWidget {
  @override
  _ContagemFormState createState() => _ContagemFormState();
}

class _ContagemFormState extends State<ContagemForm> {
  final idContagemController = TextEditingController();
  final numCardController = TextEditingController();
  final numContagemController = TextEditingController();
  final pontosDeFuncaoController = TextEditingController();
  final sistemaController = TextEditingController();
  final validadoController = TextEditingController();
  final entregueController = TextEditingController();
  final linkController = TextEditingController();
  final mesController = TextEditingController();

  bool isLoading = false;
  String? error;

  void limparCampos() {
    idContagemController.clear();
    numCardController.clear();
    numContagemController.clear();
    pontosDeFuncaoController.clear();
    sistemaController.clear();
    validadoController.clear();
    entregueController.clear();
    linkController.clear();
    mesController.clear();
    setState(() {
      error = null;
    });
  }

  Future<void> buscarContagem() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    final idText = idContagemController.text;
    final id = int.tryParse(idText);
    if (id == null) {
      setState(() {
        isLoading = false;
        error = 'Digite um ID inteiro válido';
      });
      return;
    }
    try {

      final response = await http.get(Uri.parse('https://contagemapi.onrender.com/contagem/$id'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        numCardController.text = data['numCard'].toString();
        numContagemController.text = data['numContagem'].toString();
        pontosDeFuncaoController.text = data['pontosDeFuncao'].toString();
        sistemaController.text = data['sistema'] ?? '';
        validadoController.text = data['validado'] ? 'Sim' : 'Não';
        entregueController.text = data['entregue'] ? 'Sim' : 'Não';
        linkController.text = data['link'] ?? '';
        mesController.text = data['mes'] ?? '';
      } else {
        error = 'Contagem não encontrada';
      }
    } catch (e) {
      error = 'Erro ao buscar dados';
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Contagem'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: largura > 600 ? 400 : largura * 0.9),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: idContagemController,
                          decoration: InputDecoration(
                            labelText: "Buscar por ID da Contagem",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.grey),
                        tooltip: "Limpar campos",
                        onPressed: limparCampos,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  CustomRedButton(
                    text: isLoading ? "Buscando..." : "Buscar",
                    onPressed: isLoading ? (){} : buscarContagem,
                  ),
                  if (error != null) ...[
                    SizedBox(height: 10),
                    Text(error!, style: TextStyle(color: Colors.red)),
                  ],
                  SizedBox(height: 20),
                  TextField(
                    enabled: false,
                    controller: numCardController,
                    decoration: InputDecoration(
                      labelText: "Número do Card",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    enabled: false,
                    controller: numContagemController,
                    decoration: InputDecoration(
                      labelText: "Número da Contagem",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    enabled: false,
                    controller: pontosDeFuncaoController,
                    decoration: InputDecoration(
                      labelText: "Pontos de Função",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    enabled: false,
                    controller: sistemaController,
                    decoration: InputDecoration(
                      labelText: "Sistema",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    enabled: false,
                    controller: validadoController,
                    decoration: InputDecoration(
                      labelText: "Validado",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    enabled: false,
                    controller: entregueController,
                    decoration: InputDecoration(
                      labelText: "Entregue",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    enabled: false,
                    controller: linkController,
                    decoration: InputDecoration(
                      labelText: "Link",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    enabled: false,
                    controller: mesController,
                    decoration: InputDecoration(
                      labelText: "Mês",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}