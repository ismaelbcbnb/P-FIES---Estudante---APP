import 'package:flutter/material.dart';
import '../utils/cpf_formatter.dart';
import '../widgets/custom_red_button.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final cpfController = TextEditingController();
  DateTime? nascimento;
  bool enviado = false;

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final largura = MediaQuery.of(context).size.width;
    const vermelho = Color(0xFFA6193C); // mesma cor do botão

    return Scaffold(
      appBar: AppBar(
        title: Text("Recuperar senha"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: largura > 600 ? 400 : largura * 0.9),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!enviado) ...[
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
                          nascimento = pickedDate;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      child: TextField(
                        controller: TextEditingController(
                          text: nascimento != null ? formatDate(nascimento!) : '',
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
                    text: "Enviar",
                    onPressed: () {
                      setState(() {
                        enviado = true;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Voltar"),
                  ),
                ] else ...[
                  Icon(Icons.check_circle, color: vermelho, size: 48),
                  SizedBox(height: 16),
                  Text(
                    "Enviamos um e-mail para:",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "ismaelbc@bnb.gov.br",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: vermelho,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  CustomRedButton(
                    text: "Voltar",
                    onPressed: () => Navigator.pop(context),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
