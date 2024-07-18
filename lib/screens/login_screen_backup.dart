import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/rest_service.dart';
import 'home_screen.dart';
import 'package:logger/logger.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static final Logger _logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            signInWithGoogle(context);
          },
          child: Text('Login with Google'),
        ),
      ),
    );
  }

  signInWithGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    await googleSignIn.signOut();
    try {
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return;
      }

      GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final String idToken = googleAuth.idToken ?? '';
      _logger.d('Google ID token $idToken');

      final String accessToken = googleAuth.accessToken ?? '';
      _logger.d('Google Access Token $accessToken');

      if (idToken.isNotEmpty && accessToken.isNotEmpty) {
        // Llamar al servicio REST para registrar el acceso a la aplicación profesor
        await RestService.access(idToken);

        // Aquí suponemos que el email es único para cada usuario y lo usaremos para la API de Transferencias
        final String email = googleUser.email;
        final String password = googleAuth.accessToken ?? '';

        // Intentar login en la API de Transferencias
        try {
          _logger.d('Intentando login en API de Transferencias...');
          await Provider.of<ApiAuthProvider>(context, listen: false).login(
            email,
            password,
          );
          _logger.d('Login en API de Transferencias exitoso.');
        } catch (loginError) {
          _logger.d('Login fallido, intentando registro: $loginError');

          // Si el login falla, intentar registrar al usuario
          try {
            _logger.d('Intentando registro en API de Transferencias...');
            await Provider.of<ApiAuthProvider>(context, listen: false).register(
              email,
              password,
            );
            _logger.d('Registro en API de Transferencias exitoso.');

            // Intentar login nuevamente después de registrar
            _logger.d('Intentando login nuevamente después de registro...');
            await Provider.of<ApiAuthProvider>(context, listen: false).login(
              email,
              password,
            );
            _logger.d('Login en API de Transferencias exitoso después de registro.');
          } catch (registerError) {
            _logger.e('Registro fallido: $registerError');
            return;
          }
        }
      }

      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);
      print(userCredential.user?.displayName);

      if (userCredential.user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } catch (error, stackTrace) {
      _logger.e(error);
      _logger.d(stackTrace.toString());
    }
  }
}

