import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat/services/auth_service.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/usuarios_service.dart';
import 'package:chat/services/socket_service.dart';

import 'package:chat/models/usuario.dart';

import '../services/customTheme_service.dart';

class UsuariosPage extends StatefulWidget {
  @override
  _UsuariosPageState createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final usuarioss = new UsuariosService();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Usuario> usuarios = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario;

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(usuario.nombre,
              style: TextStyle(color: Theme.of(context).accentColor)),
          elevation: 1,
          backgroundColor: Theme.of(context).hoverColor,
          leading: IconButton(
            icon: Icon(Icons.exit_to_app, color: Theme.of(context).accentColor),
            onPressed: () {
              socketService.disconnect();
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            },
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child: (socketService.serverStatus == ServerStatus.Online)
                  ? IconButton(
                      onPressed: () {
                        _mensaje("Todo anda bien :)");
                      },
                      icon: Icon(
                        Icons.check_circle,
                        color: Colors.blue[300],
                      ))
                  : InkWell(
                      child: Icon(
                        Icons.warning_rounded,
                        color: Colors.red[300],
                      ),
                      onTap: () {
                        _mensaje("No hay coneccion al servidor :(");
                      },
                    ),
            ),
            Container(
                margin: EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Icon(Icons.settings),
                  color: Theme.of(context).accentColor,
                  onPressed: () {
                    themeNotifier.setTheme();
                  },
                )),
          ],
        ),
        body: _crearlista());
  }

  FutureBuilder _crearlista() {
    return FutureBuilder(
      future: _onLoading(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            onRefresh: _cargarUsuarios,
            onLoading: _cargarUsuarios,
            header: WaterDropHeader(
              complete: Icon(Icons.check, color: Colors.blue[400]),
              waterDropColor: Colors.blue[400],
            ),
            child: _listViewUsuarios(),
          );
        } else {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("preparando todo para ti..."),
              Divider(),
              CircularProgressIndicator(),
            ],
          ));
        }
      },
    );
  }

  ListView _listViewUsuarios() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: usuarios.length - 1,
      itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(
        usuario.nombre,
        style: TextStyle(color: Theme.of(context).accentColor),
      ),
      subtitle: Text(usuario.email,
          style: TextStyle(color: Theme.of(context).accentColor)),
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _cargarUsuarios() async {
    this.usuarios = await usuarioss.getUsuarios();
    setState(() {});

    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  Future<List<Usuario>> _onLoading() async {
    // monitor network fetch
    this.usuarios = await usuarioss.getUsuarios();
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    return usuarios;
    // if (mounted) setState(() {});
    // _refreshController.loadComplete();
  }

  _mensaje(String mensaje) {
    final snackBar = SnackBar(
      content: Text(mensaje),
      backgroundColor: Colors.blue[400],
      duration: Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
