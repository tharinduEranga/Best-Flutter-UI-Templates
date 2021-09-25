import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  static String API_URL = '';

  static setEnvironment(String? env) async {
    // set default to dev if nothing was passed
    env = env ?? 'dev';

    // load the json file
    final contents = await rootBundle.loadString(
      'assets/config/$env.json',
    );

    // decode our json
    final json = jsonDecode(contents);

    // convert our JSON into an instance of our AppConfig class
    API_URL = json['apiUrl'];
  }
}
