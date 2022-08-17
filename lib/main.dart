import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final plugin = FacebookLogin(debug: true);

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHome(plugin: plugin),
    );
  }
}

class MyHome extends StatefulWidget {
  final FacebookLogin plugin;

  const MyHome({Key? key, required this.plugin}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  FacebookAccessToken? _token;
  FacebookUserProfile? _profile;
  String? _email;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _updateLoginInfo();
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = _token != null && _profile != null;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login via Facebook'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (isLogin)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildUserInfo(context, _profile!, _token!, _email),
                ),
              isLogin
                  ? ElevatedButton(
                      child: const Text('Log Out'),
                      onPressed: _onPressedLogOutButton,
                    )
                  : ElevatedButton(
                      child: const Text('Log In'),
                      onPressed: _onPressedLogInButton,
                    ),
              if (!isLogin && Platform.isAndroid)
                ElevatedButton(
                  child: const Text('Express Log In'),
                  onPressed: () => _onPressedExpressLogInButton(context),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, FacebookUserProfile profile,
      FacebookAccessToken accessToken, String? email) {
    final avatarUrl = _imageUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (avatarUrl != null)
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: SizedBox(
                child: Image.network(avatarUrl,fit: BoxFit.fitHeight,),
              ),
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('User: '),
            ),

            Text(
              '${profile.firstName} ${profile.lastName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        if (email != null) Text('Email: $email'),
      ],
    );
  }

  ///this method for Log In
  Future<void> _onPressedLogInButton() async {
    await widget.plugin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    ///this is call another method
    await _updateLoginInfo();
  }

  Future<void> _onPressedExpressLogInButton(BuildContext context) async {
    final res = await widget.plugin.expressLogin();
    if (res.status == FacebookLoginStatus.success) {
      await _updateLoginInfo();
    } else {
      await showDialog<Object>(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text("Can't make express log in. Try regular log in."),
        ),
      );
    }
  }

  Future<void> _onPressedLogOutButton() async {
    await widget.plugin.logOut();
    await _updateLoginInfo();
  }

  ///this method is setting the data into the global variable
  Future<void> _updateLoginInfo() async {
    final plugin = widget.plugin;
    final token = await plugin.accessToken;
    FacebookUserProfile? profile;
    String? email;
    String? imageUrl;

    if (token != null) {
      profile = await plugin.getUserProfile();
      if (token.permissions.contains(FacebookPermission.email.name)) {
        email = await plugin.getUserEmail();
      }
      imageUrl = await plugin.getProfileImageUrl(width: 100);
    }

    setState(() {
      _token = token;
      _profile = profile;
      _email = email;
      _imageUrl = imageUrl;
    });
  }
}
