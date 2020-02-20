import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'stub.dart'
    if (dart.library.html) 'flutter_barcode_scanner_web.dart'
    if (dart.library.io) 'flutter_barcode_scanner_interface.dart';

class FlutterBarcodeScannerWrapper {
  static Future<String> scanBarcode(BuildContext context,
      [String cancelLabel]) async {
    if (kIsWeb) {
      //ignore: undefined_method
      return internalScanBarcode(context);
    } else {
      return FlutterBarcodeScanner.scanBarcode(
          "#ff0000", cancelLabel, false, null);
    }
  }
}
