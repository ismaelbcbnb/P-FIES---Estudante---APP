import 'package:flutter/material.dart';
import '../screens/password_recovery_screen.dart';
import '../utils/cpf_formatter.dart';
import 'contagem_form.dart';
import 'custom_red_button.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final cpfController = TextEditingController();
  final senhaController = TextEditingController();
  bool senhaVisivel = false;

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
              CustomRedButton(
                text: "Acessar financiamento",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContagemForm()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
