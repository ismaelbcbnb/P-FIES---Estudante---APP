import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'login_register_screen.dart';
import '../constants.dart';

class Home extends StatefulWidget {
  final int pessoaId;

  const Home({Key? key, required this.pessoaId}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, dynamic>? alunoData;
  bool isLoading = true;
  bool _isDataVisible = false;

  @override
  void initState() {
    super.initState();
    buscarDadosAluno();
  }

  Future<void> buscarDadosAluno() async {
    final url = Uri.parse(
      '$baseUrl/aluno/obtemAluno?id=${widget.pessoaId}',
    );

    // bool isApproved = ( alunoData!['StatusRegistro'] == "\u0000") ? true : false;

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            alunoData = data;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            alunoData = null;
            isLoading = false;
          });
        }
        print('Erro na API: ${response.statusCode}');
        print('Corpo da resposta: ${response.body}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          alunoData = null;
          isLoading = false;
        });
      }
      print('Erro de conexão: $e');
    }
  }

  String? _formatDate(String? dateString) {
    if (dateString == null) return null;
    try {
      final dateTime = DateTime.parse(dateString);
      return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildInfoRow(String label, String? value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (icon != null) ...[
            Icon(icon, size: 20.0, color: Theme.of(context).colorScheme.primary),
            SizedBox(width: 12),
          ],
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value ?? 'N/A',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String appBarTitle;
    if (isLoading) {
      appBarTitle = 'Carregando...';
    } else if (alunoData != null && alunoData!['Nome'] != null) {
      appBarTitle = 'Olá, ${alunoData!['Nome']}';
    } else if (alunoData != null && alunoData!['Nome'] == null) {
      appBarTitle = 'Aluno(a)';
    } else {
      appBarTitle = 'Detalhes do Aluno';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : alunoData == null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Não foi possível carregar os dados do aluno. Verifique sua conexão ou tente novamente mais tarde.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Informações Pessoais',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isDataVisible ? Icons.find_in_page_outlined : Icons.find_in_page,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      tooltip: _isDataVisible ? 'Ocultar Dados' : 'Mostrar Dados',
                      onPressed: () {
                        setState(() {
                          _isDataVisible = !_isDataVisible;
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 16),
                if (_isDataVisible) ...[
                  _buildInfoRow('Sequencial:', alunoData!['Id']?.toString(), icon: Icons.perm_identity),
                  _buildInfoRow('SICAD:', alunoData!['Sicad']?.toString(), icon: Icons.badge_outlined),
                  _buildInfoRow('CPF:', alunoData!['Cpf'], icon: Icons.description_outlined),
                  _buildInfoRow('Nome da Mãe:', alunoData!['NomeMae'], icon: Icons.person_outline),
                  _buildInfoRow('Nome do Cônjuge:', alunoData!['NomeConjuge'], icon: Icons.people_alt_outlined),
                  _buildInfoRow('CPF do Cônjuge:', alunoData!['CpfConjuge'], icon: Icons.description_outlined),
                  _buildInfoRow('Data de Nascimento:', _formatDate(alunoData!['DataNascimento']), icon: Icons.cake_outlined),
                  _buildInfoRow('Email:', alunoData!['Email'], icon: Icons.email_outlined),
                  _buildInfoRow('Fase:', alunoData!['Fase']?.toString(), icon: Icons.school_outlined),
                  _buildInfoRow('Celular:', alunoData!['NumeroCelular']?.toString(), icon: Icons.phone_android_outlined),
                  _buildInfoRow('Telefone:', alunoData!['NumeroTelefone']?.toString(), icon: Icons.phone_outlined),
                ]
                // else ...[
                //   Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 10.0),
                //     child: Center(
                //       child: Text(
                //         '',
                //         style: TextStyle(
                //           fontSize: 16,
                //           fontStyle: FontStyle.italic,
                //           color: Theme.of(context).colorScheme.onSurfaceVariant,
                //         ),
                //       ),
                //     ),
                //   ),
                // ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}