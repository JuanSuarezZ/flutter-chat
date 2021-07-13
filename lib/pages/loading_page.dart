import 'package:chat/pages/test_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/services/socket_service.dart';
import 'package:chat/services/auth_service.dart';

import 'package:chat/pages/login_page.dart';
import 'package:chat/pages/usuarios_page.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: Text('Espere...'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    // final authService = Provider.of<AuthService>(context, listen: false);
    // final socketService = Provider.of<SocketService>(context, listen: false);

    // final autenticado = await authService.isLoggedIn();

    // if (autenticado) {
    //   socketService.connect();
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Navigator.of(context).pushNamed("usuarios");
    //   });
    // } else {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Navigator.of(context).pushNamed("login");
    //   });
    // }

    Future.delayed(Duration(seconds: 1));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushNamed("login");
    });
  }
}
