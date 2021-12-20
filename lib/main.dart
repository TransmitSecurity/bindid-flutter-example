import 'dart:developer';

import 'package:bindid_flutter/bindid_flutter_bridge.dart';
import 'package:bindid_flutter/token_passport.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'env.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BindID Flutter Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(title: 'Transmit BindID Example'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Disable authentication button until SDK init is done
  bool _isButtonDisabled = true;

  // snackbar error message parameters
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isErrorEnabled = false;
  String _errorMsg = "";

  _LoginPageState(){
    super.initState();
    // Init BindId only once when the class is instantiated
    _initBindID();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initBindID() async {
    String status;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // Configure the BindID SDK with your client ID, and to work with the BindID sandbox environment
      status = await BindidFlutterBridge.initBindID(Strings.bindid_host, Strings.bindid_client_id);
    } on PlatformException catch (error){
      status = error.message != null? error.message.toString() : 'PlatformException: init BindID Failed' ;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if(status == BindidFlutterBridge.bindid_init_done){
        // Enable the authentication button once BindID is initialized
        _isButtonDisabled = false;
      } else{
        _errorMsg = status;
        _isErrorEnabled = true;
      }
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void _authenticate() async {
    // JWT parsed data to display in token_passport once the authentication is successful
    Map<dynamic, dynamic> tokenItems;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // Authenticate the user
      tokenItems = await BindidFlutterBridge.authenticate(Strings.bindid_redirect_uri);

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;

      setState(() {
        if(tokenItems.isEmpty){
          _errorMsg = 'Authentication error tokenItems isEmpty';
          _isErrorEnabled = true;
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TokenPassport(tokenItems: tokenItems)),
          );
        }
      });

    } on PlatformException catch (error){
      setState(() {
        _errorMsg = error.message != null? error.message.toString() : 'PlatformException: Authentication failed' ;
        _isErrorEnabled = true;
      });
    }
  }

  void showSnackBar() {
    if(_isErrorEnabled) {
      _isErrorEnabled = false;
      log(_errorMsg);

      final snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(_errorMsg),
      );

      _scaffoldKey.currentState?.showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    showSnackBar();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30),
              child: Image.asset(
                  "assets/images/transmit-logo.png"),
            ),
            Container(
              height: 30,
            ),
            ElevatedButton(
                onPressed: _isButtonDisabled? null : _authenticate,
                child: SizedBox(
                  height: 40,
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Text(
                            _isButtonDisabled ? 'BindID Init...' : 'Biometric Login', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
