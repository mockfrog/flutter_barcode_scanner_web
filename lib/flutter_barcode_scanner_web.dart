import 'dart:html' show VideoElement;
import 'dart:js' as JS;
import 'dart:ui' as UI;
import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

Future<String> internalScanBarcode(BuildContext context) async {
  FlutterBarcodeScannerWeb._initBarcodeScanner();
  return await showDialog(
    context: context,
    child: FlutterBarcodeScannerWeb(),
  );
}

class FlutterBarcodeScannerWeb extends StatefulWidget {
  static void registerWith(Registrar registrar) {}
  static VideoElement videoElement = VideoElement()..autoplay = true;
  static bool _inited = false;

  @override
  _FlutterBarcodeScannerWebState createState() =>
      _FlutterBarcodeScannerWebState();
  static void _initBarcodeScanner() {
    if (_inited) {
      return;
    }
    //ignore: undefined_prefixed_name
    UI.platformViewRegistry.registerViewFactory(
        "webcamVideoElement", (int viewId) => videoElement);
    _inited = true;
  }
}

class _FlutterBarcodeScannerWebState extends State<FlutterBarcodeScannerWeb> {
  JS.JsObject _reader;
  bool _mirror = true;
  VideoElement get _webcamVideoElement => FlutterBarcodeScannerWeb.videoElement;
  @override
  void initState() {
    super.initState();
    _reader = JS.JsObject(
        (JS.context['ZXing'] as JS.JsObject)['BrowserQRCodeReader']);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // Access the webcam stream
      /*window.navigator.getUserMedia(video: true).then((MediaStream stream) {
        _webcamVideoElement.srcObject = stream;
      });*/

      _reader.callMethod('decodeFromVideoDevice', [
        null,
        _webcamVideoElement,
        (result, error) {
          if (result != null) {
            _reader.callMethod("stopContinuousDecode");
            Navigator.of(context).pop("$result");
          }
        }
      ]);
    });
  }

  @override
  void dispose() {
    if (_reader != null) {
      _reader.callMethod("stopContinuousDecode");
      print("reader stopped");
    }
    if (_webcamVideoElement != null && _webcamVideoElement.srcObject != null) {
      _webcamVideoElement.pause();
      _webcamVideoElement.srcObject
          .getTracks()
          .forEach((track) => track.stop());
      _webcamVideoElement.srcObject = null;
      print("webcam freed");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.compare_arrows),
                    onPressed: () => setState(() => _mirror = !_mirror),
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: 800,
                      maxWidth: 800,
                    ),
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(_mirror ? Math.pi : 0),
                      child: HtmlElementView(viewType: 'webcamVideoElement'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
