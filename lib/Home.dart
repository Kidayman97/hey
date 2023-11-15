 // ignore_for_file: override_on_non_overriding_member, unused_field, unused_import, use_key_in_widget_constructors, unnecessary_null_comparison, non_constant_identifier_names, duplicate_import, unused_local_variable, file_names, deprecated_member_use

import 'dart:async';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:convert';
import 'Shipping.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:gsheets/gsheets.dart';
import 'package:login/login.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:login/googlesheetapi.dart';
//import 'package:login/scanner.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAppCheck.instance.activate();
  runApp( MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(username: ''),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  final String username;
  HomePage({required this.username});
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ZoomDrawerController _drawerController;
  get username => widget.username;
  String _currentPage = 'Home';

  @override
  void initState() {
    super.initState();
    _drawerController = ZoomDrawerController();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _drawerController,
      style: DrawerStyle.defaultStyle,
      menuScreen: MenuScreen(username: widget.username, onMenuItemTap: _onMenuItemTap),
      menuBackgroundColor: Colors.indigo,
      borderRadius: 40,
      angle: -5,
      slideWidth: MediaQuery.of(context).size.width * 0.8,
      showShadow: true,
      drawerShadowsBackgroundColor: Colors.orangeAccent,
      mainScreen: _buildMainContent(),
    );
  }

  Widget _buildMainContent() {
    switch (_currentPage) {
      case 'Home':
        return HomeContent(_drawerController, _onMenuIconTap);
      case 'Shipping':
        return ShippingContent(
          drawerController: _drawerController,
          onMenuItemTap: _onMenuIconTap, // Pass the callback here
        );
      case 'Workflow':
        return WorkflowContent(_drawerController, _onMenuIconTap, this.username);
      default:
        return HomeContent(_drawerController, _onMenuIconTap);
    }
  }

  void _onMenuItemTap(String menuItem) {
    setState(() {
      _currentPage = menuItem;
      _drawerController.toggle!();
    });
  }

  void _onMenuIconTap() {
    _drawerController.toggle!();
  }
}


class MenuScreen extends StatefulWidget {
  final ZoomDrawerController? drawerController;
  final String username;
  final Function(String) onMenuItemTap;

  MenuScreen({
    Key? key,
    this.drawerController,
    required this.username,
    required this.onMenuItemTap,
  }) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final imageUrl = await _getImagePath(widget.username);
    setState(() {
      _imageUrl = imageUrl;
    });
  }

  Future<String> _getImagePath(String username) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    String imagePath = '';

    switch (username) {
      case 'admin':
        imagePath = 'images/admin.png'; // Le chemin dans Firebase Storage vers l'image 'admin'
        break;
      case 'Production':
        imagePath = 'images/production.png'; // Le chemin dans Firebase Storage vers l'image 'production'
        break;
      case 'Injection':
        imagePath = 'images/injection.png'; // Le chemin dans Firebase Storage vers l'image 'injection'
        break;
      case 'Magasin':
        imagePath = 'images/magasin.png'; // Le chemin dans Firebase Storage vers l'image 'magasin'
        break;
      default:
        imagePath = ''; // Par défaut, pas d'image
        break;
    }

    if (imagePath.isNotEmpty) {
      try {
        // Téléchargez l'image depuis Firebase Storage
        final Reference ref = storage.ref().child(imagePath);
        final downloadURL = await ref.getDownloadURL();
        return downloadURL;
      } catch (e) {
        print('Erreur lors du téléchargement de l\'image depuis Firebase Storage : $e');
        return '';
      }
    } else {
      return '';
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                BarcodeScannerT.barcodescannedListT.clear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyLogin()),
                );
              },

            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.indigo,
          border: Border.all(color: Colors.indigo),
        ),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: _imageUrl != null
                        ? Image.network(
                            _imageUrl!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : CircularProgressIndicator(),
                  ),
                  Text(
                    widget.username,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.local_shipping,
                color: Colors.white,
              ),
              title: Text(
                'Shipping',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                widget.onMenuItemTap('Shipping');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.work,
                color: Colors.white,
              ),
              title: Text(
                'Workflow',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                widget.onMenuItemTap('Workflow');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              title: Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  final ZoomDrawerController _drawerController;
  final Function() onMenuIconTap;

  HomeContent(this._drawerController, this.onMenuIconTap);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {
            onMenuIconTap();
          },
        ),
      ),
      body: Center(
        child: Text(
          'Welcome in MEVA App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


/*class ShippingContent extends StatelessWidget {
  final ZoomDrawerController drawerController;
  final VoidCallback onMenuItemTap;

  ShippingContent(this.drawerController, this.onMenuItemTap);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shipping',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.white,
          onPressed: onMenuItemTap,
        ),
      ),
      body: Center( // Utilisez le widget Center pour centrer verticalement les boutons
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16.0), // Ajoutez de l'espace en haut
            CustomButtonA(
              onPressed: () {
                // Action lorsque "Start Scanning" est appuyé
                // BarcodeScanner.startScanning(context);
              },
              text: 'Start Scanning',
            ),
            SizedBox(height: 16.0),
            CustomButtonA(
              onPressed: () {
                // Action lorsque "Save" est appuyé
              },
              text: 'Save',
            ),
            SizedBox(height: 16.0),
            CustomButtonA(
              onPressed: () {
                // Action lorsque "Clear" est appuyé
              },
              text: 'Clear',
            ),
            SizedBox(height: 16.0),
            CustomButtonA(
              onPressed: () {
                // Action lorsque "Launch" est appuyé
              },
              text: 'Launch',
            ),
          ],
        ),
      ),
    );
  }
}





class CustomButtonA extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  CustomButtonA({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          padding: EdgeInsets.all(0.0),
          primary: Colors.blue, // Set the background color to blue
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: 200.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/

class WorkflowContent extends StatefulWidget {
  final VoidCallback onMenuItemTap;
  final String username;

  WorkflowContent(ZoomDrawerController drawerController, this.onMenuItemTap, this.username);

  @override
  _WorkflowContentState createState() => _WorkflowContentState();
}

class _WorkflowContentState extends State<WorkflowContent> {
  TextEditingController searchController = TextEditingController();
  late DatabaseReference _database;
  String searchText = '';
  List? data;
  List? filteredData;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp();

    _database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://meva-app-a3b1f-default-rtdb.europe-west1.firebasedatabase.app/',
    ).reference().child("1XNpaiKn4EYOvShUbHQiNmXMlfEHhBsw_qCxBUB49kKs/Traitement");

    if (Firebase.apps.isNotEmpty) {
      print('Connexion Firebase établie avec succès');
    } else {
      print('Échec de la connexion Firebase');
    }

    _fetchDataFromFirebase();
  }

Future<void> _fetchDataFromFirebase() async {
  Firebase.initializeApp();
  try {
    final dataSnapshot = await _database.once();
    var values;
    if (dataSnapshot.snapshot.value != null) {
      values = await dataSnapshot.snapshot.value!;
    } else {
      values = [];
    }

if (widget.username != 'admin') {
  // Si ce n'est pas l'administrateur, filtre les données par nom d'utilisateur
  values = values.where((item) => item != null && item['username'] == widget.username).toList();
}

    setState(() {
      data = values;
      filteredData = values;
    });
  } catch (error) {
    print("Erreur lors de la récupération des données Firebase : $error");
  }
}


  List filterData(String query) {
    if (query.isEmpty || data == null) {
      return [];
    }

    return data!.where((item) {
      final nom = item?['Nom'] as String?;
      return nom != null && nom.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Workflow',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.white,
          onPressed: widget.onMenuItemTap,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Code for scanning here
                    BarcodeScannerT.startScanningT(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    textStyle: TextStyle(fontSize: 18.0),
                  ),
                  child: Text('Start Scanning'),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    //
                    CustomGoogleSheetsApi.init(widget.username);
                    final scriptUrl = 'https://script.google.com/macros/s/AKfycbxLq1ozntrKXwUheHUJvF_Mqyj6FLaVVovZLqc66BUbJSaTckTrisc8-_7qPsUJQvu6/exec';
                    await CustomGoogleSheetsApi.executeGoogleScript(scriptUrl);
                    if(BarcodeScannerT.barcodescannedListT.isNotEmpty){
                    BarcodeScannerT.showFlushbarT(context, 'Barcode added', Colors.green);
                      //BarcodeScannerT.barcodescannedListT.clear();
                    }
                    Future.delayed(Duration(seconds: 3), () {
                      BarcodeScannerT.showFlushbarT(
                        context,
                        'Total scanned barcodes: ${BarcodeScannerT.scannedCountT}',
                        Color.fromARGB(255, 50, 16, 170),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    textStyle: TextStyle(fontSize: 18.0),
                  ),
                  child: Text('Livrer'),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });

                _searchData(value);
              },
              decoration: InputDecoration(
                labelText: 'Rechercher',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),

          if (data == null)
            Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          if (searchText.isNotEmpty && (data == null || data!.isEmpty))
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Aucun résultat trouvé"),
            ),

          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredData == null ? 0 : filteredData!.length,
                    itemBuilder: (context, index) {
                      final item = filteredData != null ? filteredData![index] : null;
                      return item != null
                          ? ListTile(
                              title: Text(item['Nom'].toString(), style: TextStyle(fontSize: 18)),
                              subtitle: Text(
                                'Quantité: ${item['Quantite']} | Scanned Barcodes: ${item['ScannedBarcodes']} | Username: ${item['username']}',
                                style: TextStyle(fontSize: 14),
                              ),
                            )
                          : SizedBox.shrink();
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    _fetchDataFromFirebase();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

Future<void> _searchData(String query) async {
  try {
    if (data != null) {
      if (query.isEmpty) {
        setState(() {
          filteredData = data;
        });
      } else {
        setState(() {
          filteredData = filterData(query);
        });
      }
    }
  } catch (error) {
    print("Erreur lors de la recherche : $error");
  }
}

}

class BarcodeScannerT {
  static List<String> barcodescannedListT = [];
  static int scannedCountT = 0;
  static int mevaScannedCountT = 0;

  static Future<void> startScanningT(BuildContext context) async {
    try {
      String barcodeScanResT = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);

      if (barcodeScanResT != '-1') {
        if (barcodeScanResT.startsWith("MEVA")) {
          if (!barcodescannedListT.contains(barcodeScanResT)) {
            barcodescannedListT.add(barcodeScanResT);
            scannedCountT++;
            mevaScannedCountT++;
            showFlushbarT(context, 'Barcode added to index: $barcodeScanResT', Colors.green); 
          } else {
            showFlushbarT(context, 'Barcode already scanned: $barcodeScanResT', Colors.orange);
          }
        } else {
          showFlushbarT(context, 'Invalid barcode: $barcodeScanResT', Colors.red);
        }
      }
    } catch (e) {
      print('Error scanning barcode: $e');
    }
  }

  static void showFlushbarT(BuildContext context, String message, Color backgroundColor) {
    Flushbar(
      message: message,
      backgroundColor: backgroundColor,
      duration: Duration(seconds: 2),
    )..show(context);
  }
}




class CustomButtonT extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  CustomButtonT({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white, // Texte en blanc
          fontSize: 16.0, // Taille de la police
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue, // Couleur de fond bleue
        onPrimary: Colors.white, // Texte en blanc lorsque pressé
      ),
    );
  }
}