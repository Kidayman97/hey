// ignore_for_file: unused_import, unused_local_variable, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/Home.dart';
import 'package:login/googlesheetapi.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = (details) {
    if (kReleaseMode) {
      print("Erreur non gérée : ${details.exception}");
    } else {
      FlutterError.dumpErrorToConsole(details);
    }
  };
  FirebaseAppCheck.instance.activate();
  getFirebaseToken();
  runApp(MyApp());
}

  Future<void> getFirebaseToken() async {
    try {
      await Firebase.initializeApp();
      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
      await _firebaseMessaging.requestPermission();
      //FirebaseMessaging.onBackgroundMessage();
      String? token = await _firebaseMessaging.getToken();
      print('Firebase Token: $token');
    } catch (e) {
      print('Erreur lors de la récupération du token Firebase : $e');
    }
  }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyLogin(),
    );
  }
}

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late StreamSubscription<InternetConnectionStatus> connectionSubscription;
  InternetConnectionStatus? lastConnectionStatus;
  bool isButtonDisabled = false; // Ajout de la variable pour désactiver le bouton

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    // Annulez l'abonnement à la surveillance de la connexion
    connectionSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
    getFirebaseToken();
    _updateConnectionStatus(lastConnectionStatus ?? InternetConnectionStatus.disconnected);
    //getFirebaseToken();
    // Écouter les changements de statut de la connexion Internet
    connectionSubscription = InternetConnectionChecker().onStatusChange.listen((status) {
      _updateConnectionStatus(status);
    });
  }
  Future<void> handleBackgroundMessage(RemoteMessage message)async{
    print('${message.messageId}');

  }


  /*void getFirebaseToken() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    await _firebaseMessaging.requestPermission();
        FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    String? token = await _firebaseMessaging.getToken();
    print('Firebase Token: $token');

  }*/

  void _updateConnectionStatus(InternetConnectionStatus connectionStatus) {
    try {
      setState(() {
        lastConnectionStatus = connectionStatus;
      });


      if (usernameController.text.isNotEmpty && connectionStatus == InternetConnectionStatus.disconnected) {
        Fluttertoast.showToast(
          msg: "PLEASE CONNECT TO THE INTERNET",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red[400],
          textColor: Colors.white,
          fontSize: 14.0,
        );
        setState(() {
          isButtonDisabled = true; // Désactiver le bouton en cas de déconnexion
        });
      } else {
        Fluttertoast.cancel();
        setState(() {
          isButtonDisabled = false; // Réactiver le bouton lorsque la connexion est rétablie
        });
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }

  void _showToast(BuildContext context, String message) {
    Color? backgroundColor;
    double fontSize = 16.0;
    double imageSize = 32.0;
    double paddingValue = 8.0;

    if (message == "Success") {
      backgroundColor = Colors.green; // Couleur verte pour "Success"
    } else if (message == "Nom d'utilisateur ou\n mot de passe incorrect" || message == "Une erreur s'est produite") {
      backgroundColor = Colors.red; // Couleur rouge pour les autres messages
    } else {
      backgroundColor = Color.fromARGB(255, 128, 128, 128); // Couleur par défaut
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: AlertDialog(
                  contentPadding: EdgeInsets.symmetric(horizontal: paddingValue, vertical: paddingValue),
                  backgroundColor: backgroundColor,
                  content: Container(
                    padding: EdgeInsets.all(paddingValue),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/meva.png', width: imageSize, height: imageSize),
                        SizedBox(width: 8.0),
                        Text(
                          message,
                          style: TextStyle(fontSize: fontSize, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _login(BuildContext context) async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('utilisateur')
          .where('username', isEqualTo: username)
          .where('password', isEqualTo: password)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Connexion réussie
        _showToast(context, "Success");
        final userDoc = querySnapshot.docs.first;
        final userData = userDoc.data() as Map<String, dynamic>;

        await userDoc.reference.update({
          'derniere_connexion': FieldValue.serverTimestamp(),
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(username: username),
          ),
        );
      } else {
        // Nom d'utilisateur ou mot de passe incorrect
        _showToast(context, "Nom d'utilisateur ou\n mot de passe incorrect");
      }
    } catch (e) {
      print(e.toString());
      _showToast(context, "Une erreur s'est produite");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Container(),
              Container(
                padding: EdgeInsets.only(left: 32, top: 90),
                child: Text(
                  '    Welcome\n          To\n   MEVA App',
                  style: TextStyle(
                    color: Color.fromARGB(255, 48, 184, 238),
                    fontSize: 37,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 35, right: 35),
                        child: Column(
                          children: [
                            TextField(
                              style: TextStyle(color: Colors.black),
                              controller: usernameController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                hintText: "Nom d'utilisateur",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: Icon(Icons.person),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            TextField(
                              style: TextStyle(),
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                hintText: "Mot de passe",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                prefixIcon: Icon(Icons.lock),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: isButtonDisabled ? Colors.grey : Color(0xff4c505b),
                              child: IconButton(
                                color: Colors.white,
                                onPressed: isButtonDisabled ? null : () => _login(context), // Désactiver le bouton si isButtonDisabled est vrai
                                icon: Icon(
                                  Icons.arrow_forward,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

