import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:login/Home.dart';

class WorkflowPage extends StatefulWidget {
  final String username;

  WorkflowPage({required this.username});

  @override
  _WorkflowPageState createState() => _WorkflowPageState();
}

class _WorkflowPageState extends State<WorkflowPage> {
  late ZoomDrawerController _drawerController;

  @override
  void initState() {
    super.initState();
    _drawerController = ZoomDrawerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workflow Page', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {
            _onMenuIconTap();
          },
        ),
      ),
      drawer: MenuScreen( // Utilisez le MenuScreen ici
        username: widget.username,
        onMenuItemTap: _onMenuItemTap,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.username == 'admin')
              TextField(
                decoration: InputDecoration(
                  labelText: 'Search',
                ),
              ),
            SizedBox(height: 16.0),
            DataTable(
              columns: [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Surname')),
                DataColumn(label: Text('Email')),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text('John')),
                  DataCell(Text('Doe')),
                  DataCell(Text('johndoe@gmail.com')),
                ]),
                DataRow(cells: [
                  DataCell(Text('Jane')),
                  DataCell(Text('Doe')),
                  DataCell(Text('janedoe@gmail.com')),
                ]),
              ],
            ),
            // Le reste du contenu de votre page de workflow peut être ajouté ici.
          ],
        ),
      ),
    );
  }

  void _onMenuIconTap() {
    _drawerController.toggle!();
  }

  void _onMenuItemTap(String menuItem) {
    // Gérez la navigation vers d'autres pages ici en fonction de menuItem si nécessaire.
  }
}
