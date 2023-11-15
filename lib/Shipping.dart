// ignore_for_file: file_names, duplicate_import, unused_import

import 'Home.dart';
import 'googlesheetapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:another_flushbar/flushbar.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:provider/provider.dart';
import 'googlesheetapi.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Meva_app Notification',
        channelDescription: "Let's scan the Barcodes.",
        defaultColor: Color.fromARGB(255, 50, 16, 170),
        ledColor: Colors.green,
      ),
    ],
  );
  runApp(
    ZoomDrawerApp(onMenuItemTap: () {}, username: ''),
  );
}

class ZoomDrawerApp extends StatelessWidget {
  final VoidCallback onMenuItemTap;
  final String username;
  final ZoomDrawerController drawerController = ZoomDrawerController();

  ZoomDrawerApp({
    required this.onMenuItemTap,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Save Button Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ZoomDrawer(
        controller: drawerController,
        menuScreen: MenuScreen(
          drawerController: drawerController,
          onMenuItemTap: onMenuItemTap,
          username: username,
        ),
        mainScreen: ShippingContent(
          drawerController: drawerController,
          onMenuItemTap: onMenuItemTap,
        ),
      ),
    );
  }
}

class MenuScreen extends StatelessWidget {
  final ZoomDrawerController drawerController;
  final VoidCallback onMenuItemTap;
  final String username;

  MenuScreen({
    required this.drawerController,
    required this.onMenuItemTap,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text('Menu Item 1'),
            onTap: () {
              drawerController.toggle!();
              onMenuItemTap();
            },
          ),
        ],
      ),
    );
  }
}

class ShippingContent extends StatefulWidget {
  final ZoomDrawerController drawerController;
  final VoidCallback onMenuItemTap;

  ShippingContent({
    required this.drawerController,
    required this.onMenuItemTap,
  });

  @override
  _ShippingContentState createState() => _ShippingContentState();
}

class _ShippingContentState extends State<ShippingContent> {
  int initialCount = 0; // Compteur initial de codes-barres scannés
  int scannedCount = 0; // Compteur de codes-barres scannés
  int scannedCount2 = 0; // Nouveau compteur


  void clearScannedBarcodes() {
    setState(() {
      BarcodeScanner.scannedCount2 = 0;
      scannedCount2=BarcodeScanner.scannedCount2;
    });
  }

  void updateScannedCount(int newCount) {
    setState(() {
      BarcodeScanner.scannedCount2 = newCount;
      scannedCount2=BarcodeScanner.scannedCount2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shipping',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.white,
          onPressed: widget.onMenuItemTap,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Barcode Scanned:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8.0),
            Text(
              '$scannedCount2',
              style: TextStyle(fontSize: 32),
            ),
            SizedBox(height: 8.0),
            CustomButton(
              onPressed: () async {
                await BarcodeScanner.startScanning(context, updateScannedCount);
                setState(() {
                  scannedCount = BarcodeScanner.scannedCount;
                  initialCount = scannedCount;
                });
              },
              text: 'Start Scanning',
            ),
            SizedBox(height: 16.0),
            SaveButton(
              scannedCount: scannedCount,
            ),
            SizedBox(height: 16.0),
            ClearButton(
              onClearPressed: clearScannedBarcodes,
              updateScannedCount: updateScannedCount       
            ),
            SizedBox(height: 16.0),
            LaunchButton(),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  CustomButton({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
          padding: EdgeInsets.all(0.0),
          primary: Colors.blue,
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
}

class SaveButton extends StatelessWidget {
  final int scannedCount; // Compteur de codes-barres scannés

  SaveButton({required this.scannedCount});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () async {
        await googlesheetsapi.init();
        if(BarcodeScanner.barcodescannedList.isNotEmpty){
        showFlushbar(context, 'Barcode added', Colors.green);
        await Future.delayed(Duration(seconds: 3));}
        showFlushbar(
          context,
          'Total scanned barcodes: $scannedCount',
          Color.fromARGB(255, 50, 16, 170),
        );
        await _showNotification();
      },
      text: 'Save',
    );
  }

  Future<void> _showNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'basic_channel',
        title: 'Meva_app Notification',
        body: "Let's scan the Barcodes.",
        bigPicture: 'assets/logo.png',
      ),
      schedule: NotificationCalendar(
        weekday: DateTime.monday,
        hour: 10,
        minute: 0,
        second: 0,
        millisecond: 0,
        repeats: true,
      ),
    );
  }
}

class LaunchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () {
        Launch._launchGoogleSheets('https://docs.google.com/spreadsheets/d/1XNpaiKn4EYOvShUbHQiNmXMlfEHhBsw_qCxBUB49kKs/edit?pli=1#gid=0');
      },
      text: 'Launch',
    );
  }
}

class ClearButton extends StatelessWidget {
  final VoidCallback onClearPressed; // Callback pour vider la liste
  final Function(int) updateScannedCount; // Fonction de mise à jour du compteur


  ClearButton({required this.onClearPressed, required this.updateScannedCount});
  
  

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressed: () {
        onClearPressed();
        updateScannedCount(0);
      },
      text: 'Clear',
    );
  }
}



class BarcodeScanner {
  static List<String> barcodescannedList = [];
  static int scannedCount = 0; // Un seul compteur
  static int scannedCount2 = 0;

  static Future<void> startScanning(BuildContext context, Function(int) updateScannedCount) async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);

      if (barcodeScanRes != '-1') {
        if (barcodeScanRes.length == 18 && barcodeScanRes.startsWith("10000000000")) {
          if (!barcodescannedList.contains(barcodeScanRes)) {
            barcodescannedList.add(barcodeScanRes);
            scannedCount++;
            scannedCount2++;
            showFlushbar(context, 'Barcode added to index : $barcodeScanRes', Colors.green);
            updateScannedCount(scannedCount2);
          } else {
            showFlushbar(context, 'Barcode already scanned: $barcodeScanRes', Colors.orange);
          }
        } else {
          showFlushbar(context, 'Invalid barcode: $barcodeScanRes', Colors.red);
        }
      }
    } catch (e) {
      print('Error scanning barcode: $e');
    }
  }
}

class Launch {
  static Future<void> _launchGoogleSheets(String url) async {
    bool canOpen = await url_launcher.canLaunch(url);
    if (canOpen) {
      await url_launcher.launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

void showFlushbar(BuildContext context, String message, Color backgroundColor) {
  Flushbar(
    message: message,
    backgroundColor: backgroundColor,
    duration: Duration(seconds: 2),
  )..show(context);
}
