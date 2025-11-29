import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// PDF ve Görüntü İşleme Paketleri
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

// TTS (Sesli Okuma) Paketleri
import 'package:flutter_tts/flutter_tts.dart';
import 'package:read_pdf_text/read_pdf_text.dart';

// Diğer Yardımcı Paketler
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

// =========================================================================
// YARDIMCI SINIFLAR (PDF İşlemleri, TTS, Dosya Kaydetme)
// =========================================================================

/// Basit bir snackbar göstericisi
void _showSnackbar(BuildContext context, String message, {Color color = const Color(0xFFD32F2F)}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: const Duration(seconds: 3),
    ),
  );
}

/// PDF Dosya İşlemleri İçin Servis Sınıfı
class PdfService {
  final BuildContext context;

  PdfService(this.context);

  /// İzinleri kontrol eder ve Android 13+ için özel olarak ele alır.
  Future<bool> _requestPermission() async {
    // Android 13 (SDK 33) ve sonrası için özel izinler
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        // MANAGE_EXTERNAL_STORAGE iznini istemeden sadece MEDIA izinlerini istiyoruz.
        // Bu genellikle dosya kaydetme için yeterlidir.
        final status = await Permission.photos.request();
        final statusStorage = await Permission.storage.request();
        return status.isGranted && statusStorage.isGranted;
      }
    }
    // Diğer platformlar ve eski Android sürümleri için standart depolama izni
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  /// PDF dosyasını belirtilen klasöre kaydeder ve açar.
  Future<void> _saveAndOpenPdf(Uint8List bytes, String fileName) async {
    try {
      if (!await _requestPermission()) {
        _showSnackbar(context, "Dosya kaydetme izni verilmedi.", color: Colors.orange);
        return;
      }

      // 'Download/PDF Reader' klasör yolunu bulma
      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        _showSnackbar(context, "Cihaz depolama dizini bulunamadı.", color: Colors.red);
        return;
      }

      final appDir = Directory(p.join(dir.path, 'Download', 'PDF Reader'));
      if (!await appDir.exists()) {
        await appDir.create(recursive: true);
      }

      final file = File(p.join(appDir.path, fileName));
      await file.writeAsBytes(bytes);

      _showSnackbar(context, 'Başarılı: $fileName kaydedildi! Klasör: ${appDir.path}', color: Colors.green);
      
      // Kaydedilen dosyayı aç
      await OpenFile.open(file.path);

    } catch (e) {
      _showSnackbar(context, 'Hata: PDF kaydedilemedi veya açılamadı. Hata: $e', color: Colors.red);
    }
  }

  /// 1. ÖZELLİK: Görselleri Seçip PDF Oluşturur
  Future<void> createPdfFromImages() async {
    _showSnackbar(context, "Görseller seçiliyor...", color: Colors.blueGrey);
    try {
      final pickedFiles = await ImagePicker().pickMultiImage();
      if (pickedFiles == null || pickedFiles.isEmpty) {
        _showSnackbar(context, "Görsel seçimi iptal edildi.", color: Colors.orange);
        return;
      }

      final doc = pw.Document();

      for (var pickedFile in pickedFiles) {
        final imageFile = File(pickedFile.path);
        final imageBytes = await imageFile.readAsBytes();
        final image = img.decodeImage(imageBytes);

        if (image != null) {
          final pdfImage = pw.MemoryImage(imageBytes);
          
          doc.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (pw.Context context) {
                return pw.Center(
                  child: pw.Image(pdfImage),
                );
              },
            ),
          );
        }
      }

      if (doc.pages.isNotEmpty) {
        final bytes = await doc.save();
        final fileName = 'GorseldenPDF_${DateTime.now().millisecondsSinceEpoch}.pdf';
        await _saveAndOpenPdf(bytes, fileName);
      } else {
        _showSnackbar(context, "Seçilen görsellerden PDF oluşturulamadı.", color: Colors.red);
      }
    } catch (e) {
      _showSnackbar(context, 'Hata: Görselden PDF oluşturulurken bir sorun oluştu. $e', color: Colors.red);
    }
  }

  /// 2. ÖZELLİK: Birden Fazla PDF Dosyasını Birleştirir
  Future<void> mergePdfs() async {
    _showSnackbar(context, "Birleştirilecek PDF'ler seçiliyor...", color: Colors.blueGrey);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: true,
      );

      if (result == null || result.files.length < 2) {
        _showSnackbar(context, "Birleştirme için en az 2 PDF dosyası seçmelisiniz.", color: Colors.orange);
        return;
      }

      final doc = pw.Document();

      for (var file in result.files) {
        final pdfBytes = file.bytes;
        if (pdfBytes != null) {
          final sourcePdf = PdfDocument.open(pdfBytes);
          // Kaynak PDF'in tüm sayfalarını tek tek yeni dokümana ekle
          for (var page in sourcePdf.pages) {
            doc.addPage(pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (pw.Context context) {
                return pw.FullPage(
                  ignoreMargins: true,
                  child: pw.Container(
                    child: pw.Page.fromPage(sourcePdf, page.pageNumber),
                  ),
                );
              },
            ));
          }
        }
      }
      
      if (doc.pages.isNotEmpty) {
        final bytes = await doc.save();
        final fileName = 'BirlestirilmisPDF_${DateTime.now().millisecondsSinceEpoch}.pdf';
        await _saveAndOpenPdf(bytes, fileName);
      } else {
         _showSnackbar(context, "Seçilen dosyalardan sayfa alınamadı.", color: Colors.red);
      }

    } catch (e) {
      _showSnackbar(context, 'Hata: Dosyalar birleştirilirken bir sorun oluştu. $e', color: Colors.red);
    }
  }
}

/// TTS (Sesli Okuma) İşlemleri İçin Servis Sınıfı
class TtsService {
  final FlutterTts flutterTts = FlutterTts();
  final BuildContext context;
  bool isPlaying = false;

  TtsService(this.context) {
    _initTts();
  }

  void _initTts() {
    flutterTts.setLanguage("tr-TR"); // Türkçe dilini varsayılan yap
    flutterTts.setSpeechRate(0.5); // Okuma hızını ayarla
    
    flutterTts.setCompletionHandler(() {
      isPlaying = false;
    });

    flutterTts.setErrorHandler((msg) {
      _showSnackbar(context, 'TTS Hatası: $msg', color: Colors.red);
      isPlaying = false;
    });
  }

  /// PDF'ten metni çeker ve okumaya başlar.
  Future<void> speakPdf() async {
    if (isPlaying) {
      await flutterTts.stop();
      isPlaying = false;
      _showSnackbar(context, "Sesli okuma durduruldu.", color: Colors.orange);
      return;
    }

    _showSnackbar(context, "Okunacak PDF dosyası seçiliyor...", color: Colors.blueGrey);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result == null || result.files.single.path == null) {
        _showSnackbar(context, "PDF seçimi iptal edildi.", color: Colors.orange);
        return;
      }

      final pdfPath = result.files.single.path!;
      _showSnackbar(context, "Metin PDF'ten çıkarılıyor, lütfen bekleyin...", color: Colors.blue);

      // Metni PDF'ten oku
      String text = await ReadPdfText.get=='Axtarışda metin tapılamadı.';

      if (text.trim().isEmpty) {
        _showSnackbar(context, "PDF'ten okunabilir metin çıkarılamadı.", color: Colors.orange);
        return;
      }
      
      // Metin okuma
      int resultTts = await flutterTts.speak(text);
      if (resultTts == 1) {
        isPlaying = true;
        _showSnackbar(context, "Sesli okuma başlatıldı.", color: Colors.green);
      } else {
        _showSnackbar(context, "Sesli okuma başlatılamadı.", color: Colors.red);
      }

    } catch (e) {
      _showSnackbar(context, 'Hata: Sesli okuma sırasında sorun oluştu. $e', color: Colors.red);
    }
  }

  /// Uygulama kapatılırken TTS motorunu durdurmak için
  void dispose() {
    flutterTts.stop();
  }
}

// =========================================================================
// WIDGET
// =========================================================================

class ToolsScreen extends StatefulWidget {
  final VoidCallback onPickFile;

  const ToolsScreen({
    super.key, 
    required this.onPickFile,
  });

  @override
  State<ToolsScreen> createState() => _ToolsScreenState();
}

class _ToolsScreenState extends State<ToolsScreen> {
  late PdfService _pdfService;
  late TtsService _ttsService;

  @override
  void initState() {
    super.initState();
    _pdfService = PdfService(context);
    _ttsService = TtsService(context);
  }

  @override
  void dispose() {
    _ttsService.dispose();
    super.dispose();
  }

  // PDF Doldur & İmzala için geçici yer tutucu (UI'ı gösterir)
  void _showSignaturePad() {
    _showSnackbar(context, "İmza atma paneli yükleniyor...", color: Colors.blueGrey);
    // Bu kısım normalde bir dialog içinde HandSignature widget'ı açardı.
    // Şimdilik sadece uyarı gösteriliyor.
    _showSnackbar(context, "Bu özellik için özel bir imza ekranı gereklidir. (Yakında) ✍️", color: Colors.orange);
  }

  // Yakında Eklenecek Özellikler için geçici uyarı
  void _showComingSoon(String feature) {
    _showSnackbar(context, '$feature - Yakında eklenecek! 🚀', color: const Color(0xFFD32F2F));
  }

  @override
  Widget build(BuildContext context) {
    final tools = [
      {
        'icon': Icons.edit,
        'name': 'PDF Düzenle',
        'color': const Color(0xFFFFEBEE),
        'onTap': () => _showComingSoon('PDF Düzenleme (Annotasyon)')
      },
      {
        'icon': Icons.volume_up,
        'name': 'Sesli okuma',
        'color': const Color(0xFFF3E5F5),
        'onTap': () => _ttsService.speakPdf(), // İŞLEVSEL
      },
      {
        'icon': Icons.edit_document,
        'name': 'PDF Doldur & İmzala',
        'color': const Color(0xFFE8F5E8),
        'onTap': () => _showSignaturePad(), // Yarı İŞLEVSEL (Uyarı gösterir)
      },
      {
        'icon': Icons.picture_as_pdf,
        'name': 'Görselden PDF Oluştur',
        'color': const Color(0xFFE3F2FD),
        'onTap': () => _pdfService.createPdfFromImages(), // İŞLEVSEL
      },
      {
        'icon': Icons.layers,
        'name': 'Sayfaları organize et',
        'color': const Color(0xFFFFF3E0),
        'onTap': () => _showComingSoon('Sayfa Organizasyonu')
      },
      {
        'icon': Icons.merge,
        'name': 'Dosyaları birleştirme',
        'color': const Color(0xFFE0F2F1),
        'onTap': () => _pdfService.mergePdfs(), // İŞLEVSEL
      },
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: tools.length,
      itemBuilder: (context, index) {
        final tool = tools[index];
        return Card(
          elevation: 4, // Gölgeyi artırdım
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Köşeleri yuvarladım
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: tool['onTap'] as Function(),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64, // Boyutu büyüttüm
                    height: 64,
                    decoration: BoxDecoration(
                      color: tool['color'] as Color,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: (tool['color'] as Color).withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(tool['icon'] as IconData, color: const Color(0xFFD32F2F), size: 36), // İkonu büyüttüm
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tool['name'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w700, // Daha kalın
                      color: Color(0xFFD32F2F),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    (tool['name'] as String).contains('Yakında') ? 'Geliştiriliyor' : 'Çalışıyor',
                    style: TextStyle(
                      fontSize: 12,
                      color: (tool['name'] as String).contains('Yakında') ? Colors.red.shade400 : Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
