import 'package:flutter/services.dart';

class CpfInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Remove tudo que não é número
    String numbersOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Aplica a máscara
    String formatted = '';
    for (int i = 0; i < numbersOnly.length && i < 11; i++) {
      if (i == 3 || i == 6) formatted += '.';
      if (i == 9) formatted += '-';
      formatted += numbersOnly[i];
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

bool isCpfValid(String cpf) {
  String numbers = cpf.replaceAll(RegExp(r'[^0-9]'), '');

  if (numbers.length != 11) return false;

  // Rejeita CPFs com todos os dígitos iguais
  if (RegExp(r'^(\d)\1{10}$').hasMatch(numbers)) return false;

  // Calcula dígito verificador 1
  int sum = 0;
  for (int i = 0; i < 9; i++) {
    sum += int.parse(numbers[i]) * (10 - i);
  }
  int firstDigit = (sum * 10 % 11) % 10;
  if (firstDigit != int.parse(numbers[9])) return false;

  // Calcula dígito verificador 2
  sum = 0;
  for (int i = 0; i < 10; i++) {
    sum += int.parse(numbers[i]) * (11 - i);
  }
  int secondDigit = (sum * 10 % 11) % 10;
  if (secondDigit != int.parse(numbers[10])) return false;

  return true;
}

