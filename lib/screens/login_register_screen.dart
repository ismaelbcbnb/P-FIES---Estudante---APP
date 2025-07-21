import 'package:flutter/material.dart';
import '../widgets/login_form.dart';
import '../widgets/register_form.dart';

class LoginRegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Container(child: Text("P-FIES - Estudante"), alignment: Alignment.center,),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: "Login"),
              Tab(text: "Cadastro"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(child: LoginForm()),
            SingleChildScrollView(child: RegisterForm()),
          ],
        ),
      ),
    );
  }
}
