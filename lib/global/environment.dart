import 'dart:io';

class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'https://flutter-chat-backend.herokuapp.com/api'
      : 'https://flutter-chat-backend.herokuapp.com/api';
  static String socketUrl = Platform.isAndroid
      ? 'https://flutter-chat-backend.herokuapp.com'
      : 'https://flutter-chat-backend.herokuapp.com';
}
