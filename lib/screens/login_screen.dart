import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = _currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign-In Example'),
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
