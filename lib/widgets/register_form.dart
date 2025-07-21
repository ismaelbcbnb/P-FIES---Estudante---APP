import 'package:flutter/material.dart';
import '../utils/cpf_formatter.dart';
import 'custom_red_button.dart';

class RegisterForm extends StatefulWidget {
  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final emailController = TextEditingController();
  DateTime? dataNascimento;

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  bool isEmailValid(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: largura > 600 ? 400 : largura * 0.9,
          ),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                "Prossiga com o cadastro para liberar a sua solicitação de financiamento.",
                style: TextStyle(color: Color(0xFF646464)),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              TextField(
                controller: nomeController,
                decoration: InputDecoration(labelText: "Nome"),
              ),
              SizedBox(height: 10),
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
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText:
                      !isEmailValid(emailController.text) &&
                          emailController.text.isNotEmpty
                      ? "Email inválido"
                      : null,
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      dataNascimento = pickedDate;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(
                      text: dataNascimento != null
                          ? formatDate(dataNascimento!)
                          : '',
                    ),
                    decoration: InputDecoration(
                      labelText: "Data de nascimento",
                      hintText: "DD/MM/AAAA",
                    ),
                    keyboardType: TextInputType.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomRedButton(
                text: "Realizar cadastro",
                onPressed: () {
                  print("Nome: ${nomeController.text}");
                  print("CPF: ${cpfController.text}");
                  print("Email: ${emailController.text}");
                  print(
                    "Nascimento: ${dataNascimento != null ? formatDate(dataNascimento!) : 'Não selecionada'}",
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
