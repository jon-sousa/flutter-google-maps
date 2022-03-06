import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  Future<SharedPreferences> get _instance => SharedPreferences.getInstance();

  getUsuario() async {
    SharedPreferences instance = await _instance;
    bool? usuario = instance.getBool('usuario');

    return usuario ?? false;
  }

  setUsuario(bool estaLogado) async {
    SharedPreferences instance = await _instance;
    instance.setBool('usuario', estaLogado);
  }
}
