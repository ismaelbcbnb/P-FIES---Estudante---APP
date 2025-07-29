import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../screens/password_recovery_screen.dart';
import '../utils/cpf_formatter.dart';
import '../screens/home.dart';
import 'custom_red_button.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final cpfController = TextEditingController();
  final senhaController = TextEditingController();
  bool senhaVisivel = false;
  bool isLoading = false;

  bool isCpfValid(String cpf) {
    // Aqui você pode usar sua lógica de validação de CPF
    return cpf.length == 14; // Exemplo com máscara
  }

  Future<void> autenticarUsuario() async {
    final cpf = cpfController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final senha = senhaController.text;

    if (!isCpfValid(cpfController.text) || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha CPF e senha válidos.')),
      );
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse('https://s1iisp45.dmz.bnb/BN.S627.FIES.Web.Cliente.API/api/acesso');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "CPF": cpf,
        "CodAcesso": senha,
        "TipoPessoa": "A",
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final pessoaId = data['PessoaId'];

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home(pessoaId: pessoaId)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CPF ou senha inválidos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: largura > 600 ? 400 : largura * 0.9),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                "Acesse a conta e acompanhe a sua solicitação.",
                style: TextStyle(color: Color(0xFF646464)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              TextField(
                controller: cpfController,
                decoration: InputDecoration(
                  labelText: "CPF",
                  errorText: !isCpfValid(cpfController.text) && cpfController.text.isNotEmpty
                      ? "CPF inválido"
                      : null,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [CpfInputFormatter()],
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: 10),
              TextField(
                controller: senhaController,
                obscureText: !senhaVisivel,
                decoration: InputDecoration(
                  labelText: "Senha",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(senhaVisivel ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => senhaVisivel = !senhaVisivel),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PasswordRecoveryScreen()),
                    );
                  },
                  child: Text("Esqueceu a senha?"),
                ),
              ),
              SizedBox(height: 10),
              isLoading
                  ? CircularProgressIndicator()
                  : CustomRedButton(
                text: "Acessar financiamento",
                onPressed: autenticarUsuario,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
