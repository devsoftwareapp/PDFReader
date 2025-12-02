import 'dart:ui';
import 'package:flutter/foundation.dart';     
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PdfTestPage(),
    );
  }
}

class PdfTestPage extends StatefulWidget {
  @override
  State<PdfTestPage> createState() => _PdfTestPageState();
}

class _PdfTestPageState extends State<PdfTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialFile: "assets/web/index.html",

        // 🔥 Flutter'ın dokunma engellemesini kaldırır → toolbar çalışır!
        gestureRecognizers: {
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },

        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,

            // PDF.js worker + blob: URL için şart
            allowFileAccessFromFileURLs: true,
            allowUniversalAccessFromFileURLs: true,
          ),
          android: AndroidInAppWebViewOptions(
            domStorageEnabled: true,
            allowContentAccess: true,
            useHybridComposition: true,
          ),
        ),
      ),
    );
  }
}
