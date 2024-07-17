// login_screen.dart
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
        if (_currentUser != null) {
          _navigateToHomeScreen();
        }
      });
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.disconnect();
  }

  void _navigateToHomeScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          totalBalance: 1000.00, // Example balance
          recentTransactions: [
            {'title': 'Groceries', 'amount': 50.75, 'date': '2024-07-15', 'type': 'expense'},
            {'title': 'Salary', 'amount': 1500.00, 'date': '2024-07-14', 'type': 'income'},
            {'title': 'Electricity Bill', 'amount': 75.25, 'date': '2024-07-13', 'type': 'expense'},
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = _currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar sesión'),
        actions: <Widget>[
          user != null
              ? IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _handleSignOut,
          )
              : Container()
        ],
      ),
      body: Center(
        child: user != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              leading: GoogleUserCircleAvatar(
                identity: user,
              ),
              title: Text(user.displayName ?? ''),
              subtitle: Text(user.email),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _handleSignOut,
              child: Text('SIGN OUT'),
            ),
          ],
        )
            : ElevatedButton(
          onPressed: _handleSignIn,
          child: Text('SIGN IN WITH GOOGLE'),
        ),
      ),
    );
  }
}

