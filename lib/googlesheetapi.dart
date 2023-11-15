// ignore_for_file: unused_field, prefer_const_declarations, await_only_futures, non_constant_identifier_names, dead_code, unused_import, camel_case_types, depend_on_referenced_packages, unnecessary_null_comparison, avoid_print, duplicate_import, unused_local_variable, prefer_final_fields
//import 'package:login/scanner.dart';//modifie
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'Shipping.dart';
import 'package:login/Home.dart';
import 'package:login/login.dart';
import 'package:gsheets/gsheets.dart';
import 'package:http/http.dart' as http;
import 'package:gsheets/gsheets.dart';


class googlesheetsapi{
  
  
static final _spreadsheetId= '1XNpaiKn4EYOvShUbHQiNmXMlfEHhBsw_qCxBUB49kKs';
static const _credentials=r'''

{
  "type": "service_account",
  "project_id": "outstanding-pen-396811",
  "private_key_id": "0b45d2d34a22bfbade6f8419346ea1c1138ffba7",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCqGf8dO0ymay4I\nf4guz4wmH2iuF/HE69OZCkyHuKqQVds+YY+i7pPMpFnVU1pE2xVUd0RpTJsuJ7wj\nlY1kXpm1nLHeDZwX4wJTA75jHFcSaq1yRcM5OpTh5XomRfHeTpoe4AVXy8LX9S9L\n+hi5lzwTD6jGzTDD3QvzshvEoEh3DLcw/GfvTTyFZ6RkT5s5HuPZQnG79hTnFlC3\nVYt3KVnpgboiN03Z0dKenz36g+A1lCHHQEHcqAg9nuOyWsRR+ENB/2ZmPXLv8YeP\ng6Uf47t8ovOkbx9I29F0ecygjhPEpGny69R4Wt9ogqNCm/OS1wH5Q5QHV+MfFbCX\n5gHt+Pw7AgMBAAECggEANdBapudTRRUEb7jVHyYXKxpltioqGUgYXcLl2kxAXcBj\nx7T6yaubw7K9HuGrXbxH37yJvpx3PZ9hhIp0PGw3Sb8EgIEiwGXXnubAzT8yhseM\nDupmLE1Nu7erML+RGOkaFil+VzvF7SeK6oj5WIGxhkA+f4J76oMcnGDdKxQgSNUP\naFa4mN6GhborWqqE6tY+wjU1OC4iiHcEdO9qdzxMEqyvczh5AoMoz1btiWHKZ06n\n0RSnT/GGVz8nv9wfiUHwadc7dlr1/5H5lxx+gzUapshLIAD2IzgHtXTbhjM9AnaJ\nnSO1fvCPWT7dAsIVrnofR3AhLFuv1vT53ZH/bE1agQKBgQDXJR6lFI4OzhQHvSJu\nDHOd2KoF5J91pS0q1lMEzbPrqAPSSue6laxcxp3BpsM0JnnxSGdoQPXAJPr8ENvt\nzykQyXnYmXQDKtfybbrjyO5LQcKQFyv69ntvuKfwL7c2i72gCvt82fBS4m4YCrkW\nB3jWcScJHdlxNoeatY/9Zyf/uwKBgQDKZywGQ0IERQ0bzM5Xz5/8qSWharpyQclh\nMgCwASt0eqmFPNxvYRxWhN6QLwpbQgcIAZdyysjLDZoYU/A0aaPU8AJ11UB1fHyP\nx0Wx12xki3eX6yx7q2qATJumrjUpvcmOSqzWsBcqOWOuCStkttnPuTxfS733/AqH\nUrpQVaPtgQKBgQDT2+HJfexF9/kRhdYZuHlBvtHu66t7FiTcQiGOYWIDdXgN5WU7\n/5ez5IIE6ErhV+JND5eEujNF+ySMg62PCKjPtxcdjD8Jv27Xc+bN2FeQFDmb2rWc\ndIwpABWgF9y7AfDBYQ81aweVFxSC6ExKvSDpSpO+Dn7JVYFDf/dC+goRcQKBgBGN\n6S+R3cPpCT4EAVF0XHfZY74gN5N5STH42D5rm406pkE8ChJO5dpLI9J1gfxwOZPk\nL3JxTADwaRD7FrY1A1SQjGYT3MdTyKnfqpfGC0ydG/49E1qWf2IpQsauDUZVg4mn\nyF3GX/v1hkOt3+mYQkPV2Pqa4xsC7RbXgfk9tD4BAoGAYaUynXHSKLtjp534skcm\nozQNx0CBVCnjcDUR2jH9TaeMx8mWpkR423/rZn1NKVcgNhUxSTll4NFgMBcVSJVi\n5NqqVuwHmM8I0ZLebvXB5to3PYj9WmCzAxwYGck7unxs1Bdy71X5k/vxxJcOkY4f\nFH8i2OM43StKmQ766D5k7Ew=\n-----END PRIVATE KEY-----\n",
  "client_email": "samli-73@outstanding-pen-396811.iam.gserviceaccount.com",
  "client_id": "117600432123701177146",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/samli-73%40outstanding-pen-396811.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}

''';
static final _testing = GSheets(_credentials);
static Worksheet? _userSheet;
static final String _sheetTitle = 'Operation';

/*static Future<void> init() async {
  try {
    final Spreadsheet = await _testing.spreadsheet(_spreadsheetId);
    _userSheet = await _getWorkSheet(Spreadsheet, title: 'Operation');

    final List<List<String>> rowsToInsert = [];

    for (var barcode in BarcodeScanner.barcodescannedList) {
      rowsToInsert.add([barcode]); // La première colonne est vide, la seconde contient le barcode
    }

    await _userSheet!.values.insertRows(2, rowsToInsert, fromColumn: 2);
  } catch (e) {
    print('error in sheet initialization $e');
  }
}*/

//barcode exist no insertion et sauter ligne suivante ET 
static int _lastEmptyRowIndex = 2; // Déclaration

static Future<void> init() async {
  try {
    final spreadsheet = await _testing.spreadsheet(_spreadsheetId);
    final userSheet = await _getWorkSheet(spreadsheet, title: 'Operation');

    final rowsToInsert = <List<Object>>[];

    for (var barcode in BarcodeScanner.barcodescannedList) {
      final barcodeExists = await _barcodeExistsInColumnB(userSheet, barcode);
      if (!barcodeExists) {
        rowsToInsert.add([barcode]);
      }
    }

    if (rowsToInsert.isNotEmpty) {
      final column = 2; // Column B

      // Find the next empty row in column B
      int nextRowIndex = await _findNextEmptyRow(userSheet, column);

      // Insert values starting from the calculated row index
      await userSheet.values.insertRows(nextRowIndex, rowsToInsert, fromColumn: column);
    }

  } catch (e) {
    print('error in sheet initialization $e');
  }
}

  static Future<List<List<dynamic>>> fetchData(String title) async {
    try {
      final Spreadsheet spreadsheet = await _testing.spreadsheet(_spreadsheetId);
      final userSheet = await _getWorkSheet(spreadsheet, title: title);
      final values = await userSheet.values.allRows();

      return values;
    } catch (e) {
      print('Erreur lors de la récupération des données depuis Google Sheets: $e');
      return []; // En cas d'erreur, retournez une liste vide
    }
  }
static Future<bool> _barcodeExistsInColumnB(Worksheet userSheet, String barcode) async {
  final column = 2; // Column B
  int rowIndex = 2;

  while (true) {
    final currentValue = await userSheet.values.value(column: column, row: rowIndex);
    if (currentValue == null || currentValue.isEmpty) {
      return false; // Barcode doesn't exist in column B
    }
    if (currentValue == barcode) {
      return true; // Barcode already exists in column B
    }
    rowIndex++;
  }
}

static Future<int> _findNextEmptyRow(Worksheet userSheet, int column) async {
  while (true) {
    final currentValue = await userSheet.values.value(column: column, row: _lastEmptyRowIndex);
    if (currentValue == null || currentValue.isEmpty) {
      return _lastEmptyRowIndex; // Found an empty cell, return the last known empty row index
    }
    _lastEmptyRowIndex++;
  }
}
Future<List<List<dynamic>>> fetchFromGoogleSheet() async {
  try {
    final Spreadsheet spreadsheet = await _testing.spreadsheet(_spreadsheetId);
    final userSheet = await _getWorkSheet(spreadsheet, title: _sheetTitle);
    final values = await userSheet.values.allRows();

    return values;
  } catch (e) {
    print('Erreur lors de la récupération des données depuis Google Sheets: $e');
    return []; // En cas d'erreur, retournez une liste vide
  }
}


static Future<Worksheet> _getWorkSheet(Spreadsheet spreadsheet, {required String title}) async {
  
  try{ 
    return await spreadsheet.addWorksheet(title);
  } catch (e) {
    return await spreadsheet.worksheetByTitle(title)!;
  }
}
static Future insert(List<Map<String, dynamic>> rowList)async  {
  if(_userSheet == null){ return ;
    _userSheet!.values.map.appendRows(rowList);
  }

}


}


/*
class CustomGoogleSheetsApi extends googlesheetsapi {
  static final String _customSheetTitle = 'Traitement';

  static Future<void> init() async {
    try {
      final spreadsheet = await googlesheetsapi._testing.spreadsheet(googlesheetsapi._spreadsheetId);
      final userSheet = await googlesheetsapi._getWorkSheet(spreadsheet, title: _customSheetTitle);

      final rowsToInsert = <List<Object>>[];

      for (var barcodeT in BarcodeScannerT.barcodescannedListT) {
        final barcodeExists = await _barcodeExistsInColumnC(userSheet, barcodeT);
        if (!barcodeExists) {
          rowsToInsert.add([barcodeT]);
        }
      }

      if (rowsToInsert.isNotEmpty) {
        final column = 3; // Column C

        int nextRowIndex = await _findNextEmptyRow(userSheet, column);

        await userSheet.values.insertRows(nextRowIndex, rowsToInsert, fromColumn: column);
      }
    } catch (e) {
      print('Erreur lors de l initialisation de la feuille : $e');
    }
  }

  static Future<bool> _barcodeExistsInColumnC(Worksheet userSheet, String barcodeT) async {
    final column = 3; // Column C
    int rowIndex = 2;

    while (true) {
      final currentValue = await userSheet.values.value(column: column, row: rowIndex);
      if (currentValue == null || currentValue.isEmpty) {
        return false;
      }
      if (currentValue == barcodeT) {
        return true;
      }
      rowIndex++;
    }
  }
  static int _lastEmptyRowIndexT = 2; // Déclaration


  static Future<int> _findNextEmptyRow(Worksheet userSheet, int column) async {
    int rowIndex = _lastEmptyRowIndexT;

    while (true) {
      final currentValue = await userSheet.values.value(column: column, row: rowIndex);
      if (currentValue == null || currentValue.isEmpty) {
        return rowIndex;
      }
      rowIndex++;
    }
  }
}
*/


class CustomGoogleSheetsApi extends googlesheetsapi {
  static final String _customSheetTitle = 'Traitement';
  static final String _user='';


static Future<void> init(String username) async {
  try {
    final spreadsheet = await googlesheetsapi._testing.spreadsheet(googlesheetsapi._spreadsheetId);
    final userSheet = await googlesheetsapi._getWorkSheet(spreadsheet, title: _customSheetTitle);

    for (var barcodeT in BarcodeScannerT.barcodescannedListT) {
      final columnC = 3; // Colonne C
      final valuesC = await userSheet.values.column(columnC);
      bool barcodeFound = false;

      for (var rowIndex = 1; rowIndex < valuesC.length; rowIndex++) {
        final cellValue = valuesC[rowIndex];
        if (cellValue.toString() == barcodeT) {
          // Le code-barres a été trouvé dans la colonne C, mettre à jour la colonne D avec '0'.
          final columnD = 4; // Colonne D
          final rowToUpdate = await userSheet.values.row(rowIndex + 1);
          rowToUpdate[columnD - 1] = username;
          await userSheet.values.insertRow(rowIndex + 1, rowToUpdate);
          barcodeFound = true;
          break; // Sortir de la boucle une fois que la correspondance a été trouvée
        }
      }

      if (!barcodeFound) {
        // Si le code-barres n'a pas été trouvé dans la colonne C, ajouter une nouvelle ligne
        var row = [barcodeT, username];
        await userSheet.values.insertRows(await _findNextEmptyRow(userSheet, columnC), [row], fromColumn: columnC);
      }
    }
    BarcodeScannerT.barcodescannedListT.clear();
  } catch (e) {
    print('Erreur lors de l initialisation de la feuille : $e');
  }
}



static Future<void> _updateUsernameInColumnD(Worksheet userSheet, String barcodeT) async {
  final columnC = 3; // Colonne C
  final columnD = 4; // Colonne D
  final values = await userSheet.values.allColumns();

  for (var rowIndex = 1; rowIndex < values.length; rowIndex++) {
    final row = values[rowIndex];
    if (row[columnC - 1] == barcodeT) {
      // Le code-barres a été trouvé dans la colonne C, mettre à jour le contenu de la cellule dans la colonne D avec '0'.
      row[columnD - 1] = '0';

      // Mettre à jour la feuille de calcul en insérant la ligne mise à jour
      await userSheet.values.insertRow(rowIndex + 1, row);
      return;
    }
  }
}


  static Future<bool> _barcodeExistsInColumnC(Worksheet userSheet, String barcodeT) async {
    final column = 3; // Column C
    int rowIndex = 2;

    while (true) {
      final currentValue = await userSheet.values.value(column: column, row: rowIndex);
      if (currentValue == null || currentValue.isEmpty) {
        return false;
      }
      if (currentValue == barcodeT) {
        return true;
      }
      rowIndex++;
    }
  }
  
  static Future<bool> _barcodeExistsInColumnD(Worksheet userSheet, String barcodeT) async {
    final column = 4; // Column D
    int rowIndex = 2;

    while (true) {
      final currentValue = await userSheet.values.value(column: column, row: rowIndex);
      if (currentValue == null || currentValue.isEmpty) {
        return false;
      }
      if (currentValue == barcodeT) {
        return true;
      }
      rowIndex++;
    }
  }

  static int _lastEmptyRowIndexT = 2;
  static int _lastEmptyRowIndexTD = 2; // For column D

  static Future<int> _findNextEmptyRow(Worksheet userSheet, int column) async {
    int rowIndex = (column == 3) ? _lastEmptyRowIndexT : _lastEmptyRowIndexTD;

    while (true) {
      final currentValue = await userSheet.values.value(column: column, row: rowIndex);
      if (currentValue == null || currentValue.isEmpty) {
        return rowIndex;
      }
      rowIndex++;
    }
  }

   static Future<String> executeGoogleScript(String scriptUrl) async {
  // Définir l'URL de l'API Google Apps Script Execution
  final apiUrl = '$scriptUrl/exec';

  // Définir le corps de la requête POST (si nécessaire)
  // Par exemple, pour envoyer des données au script, vous pouvez utiliser :
  // final requestBody = {'param1': 'value1', 'param2': 'value2'};

  try {
    // Envoyer la requête HTTP POST
    final response = await http.post(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // La requête a réussi, vous pouvez traiter la réponse ici
      return response.body;
    } else {
      // La requête a échoué
      throw Exception('Échec de la requête HTTP: ${response.statusCode}');
    }
  } catch (e) {
    // Gérer les erreurs ici
    print('Erreur lors de l\'exécution du script Google : $e');
    return '';
  }
}
}