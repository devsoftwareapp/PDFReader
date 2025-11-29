import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Gerekli Olan Ancak Eksik Olan Import
import 'package:device_info_plus/device_info_plus.dart'; 

// PDF ve Görüntü İşleme Paketleri
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

// TTS (Sesli Okuma) Paketleri
import 'package:flutter_tts/flutter_tts.dart';
import 'package:read_pdf_text/read_pdf_text.dart'; // HATA DÜZELTİLDİ: Metin çekme fonksiyonu

// Diğer Yardımcı Paketler
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

// =========================================================================
// YARDIMCI SINIFLAR (PDF İşlemleri, TTS, Dosya Kaydetme)
// =========================================================================

/// Basit bir snackbar göstericisi
void _showSnackbar(BuildContext context, String message, {Color color = const Color(0xFFD32F2F)}) {
  // SnackBar'ın BuildContext dışından çağrılması ihtimaline karşı kontrol
  if (context.mounted) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

/// PDF Dosya İşlemleri İçin Servis Sınıfı
class PdfService {
  final BuildContext context;

  PdfService(this.context);

  /// İzinleri kontrol eder ve Android 13+ için özel olarak ele alır.
  Future<bool> _requestPermission() async {
    // Android 13 (SDK 33) ve sonrası için özel izinler
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo; // HATA DÜZELTİLDİ: DeviceInfoPlugin eklendi.
      if (androidInfo.version.sdkInt >= 33) {
        // Android 13+ için sadece fotoğraf ve medya izni yeterli
        final status = await Permission.photos.request();
        final statusVideos = await Permission.videos.request();
        return status.isGranted && statusVideos.isGranted;
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

      // 'Download/PDF Reader' klasör yolunu bulma (Main.dart'ın oluşturduğu yol)
      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        _showSnackbar(context, "Cihaz depolama dizini bulunamadı.", color: Colors.red);
        return;
      }

      // İstenen klasör yolu: Download/PDF Reader
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
        
        // Görüntüyü boyutlandırmak için img paketini kullanmak (isteğe bağlı ama önerilir)
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

      // HATA DÜZELTİLDİ: pdf paketi Document sınıfının pages özelliği yoktur.
      // Sadece sayfa ekleme işlemini kontrol etmek yeterlidir.
      if (pickedFiles.isNotEmpty) { 
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
      int pageCount = 0;

      for (var file in result.files) {
        final pdfBytes = file.bytes;
        if (pdfBytes != null) {
          // HATA DÜZELTİLDİ: PdfDocument.open yerine PdfDocument.load(bytes) kullanılır
          final sourcePdf = PdfDocument.load(pdfBytes); 
          
          // Kaynak PDF'in tüm sayfalarını tek tek yeni dokümana ekle
          for (var i = 0; i < sourcePdf.pdfPageList.pages.length; i++) {
            final page = sourcePdf.pdfPageList.pages[i];

            doc.addPage(pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (pw.Context context) {
                return pw.FullPage(
                  ignoreMargins: true,
                  child: pw.Container(
                    // HATA DÜZELTİLDİ: Page.fromPage metodu yerine doğru yapı kullanılıyor
                    child: pw.Page.fromDocument(sourcePdf, i + 1),
                  ),
                );
              },
            ));
            pageCount++;
          }
        }
      }
      
      if (pageCount > 0) { // En az bir sayfa eklendi mi?
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
      if (context.mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    });

    flutterTts.setErrorHandler((msg) {
      _showSnackbar(context, 'TTS Hatası: $msg', color: Colors.red);
      if (context.mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  // setState'i kullanabilmek için context.mounted kontrolü ve setState fonskiyonu
  void setState(VoidCallback fn) {
    if (context.mounted && (context as State).mounted) {
      (context as State).setState(fn);
    }
  }


  /// PDF'ten metni çeker ve okumaya başlar.
  Future<void> speakPdf() async {
    if (isPlaying) {
      await flutterTts.stop();
      setState(() {
        isPlaying = false;
      });
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

      final pdfPath = result?.files.single.path;

      if (pdfPath == null) {
        _showSnackbar(context, "PDF seçimi iptal edildi.", color: Colors.orange);
        return;
      }

      _showSnackbar(context, "Metin PDF'ten çıkarılıyor, lütfen bekleyin...", color: Colors.blue);

      // HATA DÜZELTİLDİ: Metin çekme fonksiyonu doğru kullanılıyor.
      String text = await ReadPdfText.getPDFtext(pdfPath); 
      
      if (text.trim().isEmpty) {
        _showSnackbar(context, "PDF'ten okunabilir metin çıkarılamadı. Dosya şifreli olabilir veya sadece resim içerebilir.", color: Colors.orange);
        return;
      }
      
      // Metin okuma
      int resultTts = await flutterTts.speak(text);
      if (resultTts == 1) {
        setState(() {
          isPlaying = true;
        });
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
    // TtsService, setState yapabilmek için stateful widget'ın context'ini alır.
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
    // Burada HandSignature paketi kullanılarak imzalanacak.
    _showSnackbar(context, "Bu özellik için özel bir imza ekranı ve imzanın PDF üzerine yerleştirilmesi mantığı gereklidir. (Yakında) ✍️", color: Colors.orange);
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
        'onTap': () => _showComingSoon('PDF Düzenleme (Annotasyon)'),
        'status': 'Geliştiriliyor',
      },
      {
        'icon': Icons.volume_up,
        'name': 'Sesli okuma',
        'color': const Color(0xFFF3E5F5),
        'onTap': () => _ttsService.speakPdf(), 
        'status': _ttsService.isPlaying ? 'Durdur' : 'Çalışıyor', // TTS durumunu göster
      },
      {
        'icon': Icons.edit_document,
        'name': 'PDF Doldur & İmzala',
        'color': const Color(0xFFE8F5E8),
        'onTap': () => _showSignaturePad(), 
        'status': 'Geliştiriliyor',
      },
      {
        'icon': Icons.picture_as_pdf,
        'name': 'Görselden PDF Oluştur',
        'color': const Color(0xFFE3F2FD),
        'onTap': () => _pdfService.createPdfFromImages(), 
        'status': 'Çalışıyor',
      },
      {
        'icon': Icons.layers,
        'name': 'Sayfaları organize et',
        'color': const Color(0xFFFFF3E0),
        'onTap': () => _showComingSoon('Sayfa Organizasyonu'),
        'status': 'Geliştiriliyor',
      },
      {
        'icon': Icons.merge,
        'name': 'Dosyaları birleştirme',
        'color': const Color(0xFFE0F2F1),
        'onTap': () => _pdfService.mergePdfs(), 
        'status': 'Çalışıyor',
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
        bool isWorking = tool['status'] == 'Çalışıyor' || tool['status'] == 'Durdur';
        
        return Card(
          elevation: 4, 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: tool['onTap'] as Function(),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64, 
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
                    child: Icon(
                      tool['icon'] as IconData, 
                      color: isWorking ? const Color(0xFFD32F2F) : Colors.grey, // Çalışmayanlara gri ton
                      size: 36
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    tool['name'] as String,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16, 
                      fontWeight: FontWeight.w700, 
                      color: isWorking ? const Color(0xFFD32F2F) : Colors.grey.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tool['status'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: isWorking ? Colors.green.shade600 : Colors.red.shade400,
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
