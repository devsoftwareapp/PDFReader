import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// Local HTTP server için paketler
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_static/shelf_static.dart';

// Global server URL
late String localServerUrl;

Future<void> startLocalServer() async {
  // PDF.js worker ve pdf.mjs dosyası assets/pdfjs klasöründe olmalı
  final handler = createStaticHandler(
    'assets/build', // 🔥 pdf.worker.mjs ve pdf.mjs buradan servis edilecek
    defaultDocument: 'index.html',
    serveFilesOutsidePath: true,
  );

  final server = await serve(
    handler,
    InternetAddress.loopbackIPv4,
    3333,
  );

  localServerUrl = "http://127.0.0.1:3333";
  debugPrint("🚀 Local PDF worker server started at: $localServerUrl");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Worker’ı serve eden local server’ı başlatıyoruz
  await startLocalServer();

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
      body: SafeArea(
        child: InAppWebView(
          initialFile: "assets/web/index.html",

          // PDF.js toolbar gesture fix
          gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },

          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              javaScriptEnabled: true,

              // Worker’ın local server’dan çağrılabilmesi için SHART!!
              allowFileAccessFromFileURLs: true,
              allowUniversalAccessFromFileURLs: true,
            ),
            android: AndroidInAppWebViewOptions(
              domStorageEnabled: true,
              allowContentAccess: true,
              useHybridComposition: true,
            ),
          ),

          // Flutter → WebView JS bridge (viewer.html worker URL görecek)
          onWebViewCreated: (controller) async {
            // viewer.html içinde worker URL’ini set edeceğiz
            await controller.evaluateJavascript(source: """
              window.PDF_WORKER = "$localServerUrl/pdf.worker.mjs";
            """);
          },
        ),
      ),
    );
  }
}
