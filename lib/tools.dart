// lib/tools.dart
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// Tools için dil desteği - BASİT
class ToolsLocalizations {
  static final Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      'pdf_merge': 'دمج PDF',
      'pdf_sign': 'توقيع PDF',
      'pdf_compress': 'ضغط PDF',
      'image_to_pdf': 'صورة إلى PDF',
      'text_to_speech': 'قراءة بصوت',
      'ocr_extract': 'استخراج OCR',
      'pdf_to_image': 'PDF إلى صورة',
      'add_text': 'إضافة نص',
      'organize_pages': 'تنظيم الصفحات',
      'add_image': 'إضافة صورة',
      'tools_title': 'الأدوات',
      'tool_loading': 'جار تحميل الأداة...',
    },
    'bn': {
      'pdf_merge': 'PDF একত্রীকরণ',
      'pdf_sign': 'PDF স্বাক্ষর',
      'pdf_compress': 'PDF সংকোচন',
      'image_to_pdf': 'ছবি থেকে PDF',
      'text_to_speech': 'কথায় পড়া',
      'ocr_extract': 'OCR নিষ্কাশন',
      'pdf_to_image': 'PDF থেকে ছবি',
      'add_text': 'টেক্সট যোগ করুন',
      'organize_pages': 'পৃষ্ঠা সাজান',
      'add_image': 'ছবি যোগ করুন',
      'tools_title': 'টুলস',
      'tool_loading': 'টুল লোড হচ্ছে...',
    },
    'de': {
      'pdf_merge': 'PDF zusammenführen',
      'pdf_sign': 'PDF signieren',
      'pdf_compress': 'PDF komprimieren',
      'image_to_pdf': 'Bild zu PDF',
      'text_to_speech': 'Sprachausgabe',
      'ocr_extract': 'OCR-Text extrahieren',
      'pdf_to_image': 'PDF zu Bild',
      'add_text': 'Text hinzufügen',
      'organize_pages': 'Seiten organisieren',
      'add_image': 'Bild hinzufügen',
      'tools_title': 'Werkzeuge',
      'tool_loading': 'Werkzeug wird geladen...',
    },
    'en': {
      'pdf_merge': 'PDF Merge',
      'pdf_sign': 'PDF Sign',
      'pdf_compress': 'PDF Compress',
      'image_to_pdf': 'Image to PDF',
      'text_to_speech': 'Text to Speech',
      'ocr_extract': 'OCR Extract',
      'pdf_to_image': 'PDF to Image',
      'add_text': 'Add Text',
      'organize_pages': 'Organize Pages',
      'add_image': 'Add Image',
      'tools_title': 'Tools',
      'tool_loading': 'Tool Loading...',
    },
    'es': {
      'pdf_merge': 'Combinar PDF',
      'pdf_sign': 'Firmar PDF',
      'pdf_compress': 'Comprimir PDF',
      'image_to_pdf': 'Imagen a PDF',
      'text_to_speech': 'Texto a voz',
      'ocr_extract': 'Extraer OCR',
      'pdf_to_image': 'PDF a imagen',
      'add_text': 'Agregar texto',
      'organize_pages': 'Organizar páginas',
      'add_image': 'Agregar imagen',
      'tools_title': 'Herramientas',
      'tool_loading': 'Cargando herramienta...',
    },
    'fr': {
      'pdf_merge': 'Fusionner PDF',
      'pdf_sign': 'Signer PDF',
      'pdf_compress': 'Compresser PDF',
      'image_to_pdf': 'Image en PDF',
      'text_to_speech': 'Synthèse vocale',
      'ocr_extract': 'Extraire OCR',
      'pdf_to_image': 'PDF en image',
      'add_text': 'Ajouter du texte',
      'organize_pages': 'Organiser les pages',
      'add_image': 'Ajouter une image',
      'tools_title': 'Outils',
      'tool_loading': 'Chargement de l\'outil...',
    },
    'hi': {
      'pdf_merge': 'PDF विलय',
      'pdf_sign': 'PDF हस्ताक्षर',
      'pdf_compress': 'PDF संपीड़न',
      'image_to_pdf': 'छवि से PDF',
      'text_to_speech': 'पाठ से वाणी',
      'ocr_extract': 'OCR निष्कर्षण',
      'pdf_to_image': 'PDF से छवि',
      'add_text': 'पाठ जोड़ें',
      'organize_pages': 'पृष्ठ व्यवस्थित करें',
      'add_image': 'छवि जोड़ें',
      'tools_title': 'उपकरण',
      'tool_loading': 'उपकरण लोड हो रहा है...',
    },
    'id': {
      'pdf_merge': 'Gabungkan PDF',
      'pdf_sign': 'Tanda Tangan PDF',
      'pdf_compress': 'Kompres PDF',
      'image_to_pdf': 'Gambar ke PDF',
      'text_to_speech': 'Teks ke Suara',
      'ocr_extract': 'Ekstrak OCR',
      'pdf_to_image': 'PDF ke Gambar',
      'add_text': 'Tambahkan Teks',
      'organize_pages': 'Atur Halaman',
      'add_image': 'Tambahkan Gambar',
      'tools_title': 'Alat',
      'tool_loading': 'Memuat alat...',
    },
    'ja': {
      'pdf_merge': 'PDF結合',
      'pdf_sign': 'PDF署名',
      'pdf_compress': 'PDF圧縮',
      'image_to_pdf': '画像をPDFに',
      'text_to_speech': '音声読み上げ',
      'ocr_extract': 'OCR抽出',
      'pdf_to_image': 'PDFを画像に',
      'add_text': 'テキスト追加',
      'organize_pages': 'ページ整理',
      'add_image': '画像追加',
      'tools_title': 'ツール',
      'tool_loading': 'ツールを読み込み中...',
    },
    'ku': {
      'pdf_merge': 'PDF Têkirkirin',
      'pdf_sign': 'PDF Îmzekirin',
      'pdf_compress': 'PDF Pêçan',
      'image_to_pdf': 'Wêne bo PDF',
      'text_to_speech': 'Nivîs bo Deng',
      'ocr_extract': 'OCR Derxistin',
      'pdf_to_image': 'PDF bo Wêne',
      'add_text': 'Nivîsê zêde bike',
      'organize_pages': 'Rûpelan Saz bike',
      'add_image': 'Wêneyê zêde bike',
      'tools_title': 'Amûr',
      'tool_loading': 'Amûr tê barkirin...',
    },
    'pt': {
      'pdf_merge': 'Mesclar PDF',
      'pdf_sign': 'Assinar PDF',
      'pdf_compress': 'Comprimir PDF',
      'image_to_pdf': 'Imagem para PDF',
      'text_to_speech': 'Texto para Voz',
      'ocr_extract': 'Extrair OCR',
      'pdf_to_image': 'PDF para Imagem',
      'add_text': 'Adicionar Texto',
      'organize_pages': 'Organizar Páginas',
      'add_image': 'Adicionar Imagem',
      'tools_title': 'Ferramentas',
      'tool_loading': 'Carregando ferramenta...',
    },
    'ru': {
      'pdf_merge': 'Объединить PDF',
      'pdf_sign': 'Подписать PDF',
      'pdf_compress': 'Сжать PDF',
      'image_to_pdf': 'Изображение в PDF',
      'text_to_speech': 'Текст в речь',
      'ocr_extract': 'Извлечь OCR',
      'pdf_to_image': 'PDF в изображение',
      'add_text': 'Добавить текст',
      'organize_pages': 'Организовать страницы',
      'add_image': 'Добавить изображение',
      'tools_title': 'Инструменты',
      'tool_loading': 'Загрузка инструмента...',
    },
    'sw': {
      'pdf_merge': 'Unganisha PDF',
      'pdf_sign': 'Saini PDF',
      'pdf_compress': 'Bana PDF',
      'image_to_pdf': 'Picha hadi PDF',
      'text_to_speech': 'Maandishi hadi Sauti',
      'ocr_extract': 'Toa OCR',
      'pdf_to_image': 'PDF hadi Picha',
      'add_text': 'Ongeza Maandishi',
      'organize_pages': 'Panga Kurasa',
      'add_image': 'Ongeza Picha',
      'tools_title': 'Zana',
      'tool_loading': 'Inapakia zana...',
    },
    'tr': {
      'pdf_merge': 'PDF Birleştirme',
      'pdf_sign': 'PDF İmzala',
      'pdf_compress': 'PDF\'yi Sıkıştır',
      'image_to_pdf': 'Resimden PDF\'ye',
      'text_to_speech': 'Sesli Okuma',
      'ocr_extract': 'OCR Metin Çıkarma',
      'pdf_to_image': 'PDF\'den Resme',
      'add_text': 'PDF\'ye Metin Ekle',
      'organize_pages': 'PDF Sayfalarını Organize Et',
      'add_image': 'PDF\'ye Resim Ekle',
      'tools_title': 'Araçlar',
      'tool_loading': 'Araç Yükleniyor...',
    },
    'ur': {
      'pdf_merge': 'PDF ضم کریں',
      'pdf_sign': 'PDF دستخط',
      'pdf_compress': 'PDF سکیڑیں',
      'image_to_pdf': 'تصویر سے PDF',
      'text_to_speech': 'متن سے تقریر',
      'ocr_extract': 'OCR نکالیں',
      'pdf_to_image': 'PDF سے تصویر',
      'add_text': 'متن شامل کریں',
      'organize_pages': 'صفحات ترتیب دیں',
      'add_image': 'تصویر شامل کریں',
      'tools_title': 'ٹولز',
      'tool_loading': 'ٹول لوڈ ہو رہا ہے...',
    },
    'za': {
      'pdf_merge': 'PDF Pêk Anîn',
      'pdf_sign': 'PDF Îmze',
      'pdf_compress': 'PDF Pêçe',
      'image_to_pdf': 'Wêne bo PDF',
      'text_to_speech': 'Nivîs bo Deng',
      'ocr_extract': 'OCR Derxistin',
      'pdf_to_image': 'PDF bo Wêne',
      'add_text': 'Nivîsê zêde bike',
      'organize_pages': 'Rûpelan Saz bike',
      'add_image': 'Wêneyê zêde bike',
      'tools_title': 'Hacet',
      'tool_loading': 'Hacet tê barkirin...',
    },
    'zh': {
      'pdf_merge': 'PDF合并',
      'pdf_sign': 'PDF签名',
      'pdf_compress': 'PDF压缩',
      'image_to_pdf': '图片转PDF',
      'text_to_speech': '文字转语音',
      'ocr_extract': 'OCR提取',
      'pdf_to_image': 'PDF转图片',
      'add_text': '添加文本',
      'organize_pages': '整理页面',
      'add_image': '添加图片',
      'tools_title': '工具',
      'tool_loading': '工具加载中...',
    },
  };

  static String translate(String languageCode, String key) {
    final lang = languageCode.toLowerCase();
    return _localizedValues[lang]?[key] ?? _localizedValues['en']?[key] ?? key;
  }
}

class ToolsScreen extends StatelessWidget {
  final VoidCallback onPickFile;
  final dynamic languageManager;

  const ToolsScreen({
    super.key, 
    required this.onPickFile,
    required this.languageManager,
  });

  void _openToolWebView(BuildContext context, String toolName, String htmlFile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ToolWebViewScreen(
          toolName: toolName,
          htmlFile: htmlFile,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // languageManager'dan dil kodunu al
    String currentLanguage = 'en';
    try {
      if (languageManager != null && languageManager.currentLanguage != null) {
        currentLanguage = languageManager.currentLanguage.toString().toLowerCase();
      }
    } catch (e) {
      print('Dil yöneticisi hatası: $e');
    }

    final tools = [
      {
        'icon': Icons.merge,
        'key': 'pdf_merge',
        'color': const Color(0xFFFFEBEE),
        'htmlFile': 'birlestirme.html',
      },
      {
        'icon': Icons.edit,
        'key': 'pdf_sign',
        'color': const Color(0xFFE8F5E8),
        'htmlFile': 'imza.html',
      },
      {
        'icon': Icons.compress,
        'key': 'pdf_compress',
        'color': const Color(0xFFE3F2FD),
        'htmlFile': 'sikistirma.html',
      },
      {
        'icon': Icons.photo_library,
        'key': 'image_to_pdf',
        'color': const Color(0xFFFFF3E0),
        'htmlFile': 'res_pdf.html',
      },
      {
        'icon': Icons.volume_up,
        'key': 'text_to_speech',
        'color': const Color(0xFFF3E5F5),
        'htmlFile': 'sesli_okuma.html',
      },
      {
        'icon': Icons.text_fields,
        'key': 'ocr_extract',
        'color': const Color(0xFFE0F2F1),
        'htmlFile': 'ocr.html',
      },
      {
        'icon': Icons.picture_as_pdf,
        'key': 'pdf_to_image',
        'color': const Color(0xFFFCE4EC),
        'htmlFile': 'pdf_res.html',
      },
      {
        'icon': Icons.text_snippet,
        'key': 'add_text',
        'color': const Color(0xFFE8EAF6),
        'htmlFile': 'pdf_metin_ekle.html',
      },
      {
        'icon': Icons.layers,
        'key': 'organize_pages',
        'color': const Color(0xFFE8F5E8),
        'htmlFile': 'organize.html',
      },
      {
        'icon': Icons.image,
        'key': 'add_image',
        'color': const Color(0xFFE3F2FD),
        'htmlFile': 'pdf_resim_ekle.html',
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
        final toolName = ToolsLocalizations.translate(currentLanguage, tool['key'] as String);
        
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _openToolWebView(
              context, 
              toolName, 
              tool['htmlFile'] as String,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: tool['color'] as Color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(tool['icon'] as IconData, color: const Color(0xFFD32F2F), size: 30),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    toolName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14, 
                      fontWeight: FontWeight.w600, 
                      color: Color(0xFFD32F2F),
                    ),
                    maxLines: 2,
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

class ToolWebViewScreen extends StatefulWidget {
  final String toolName;
  final String htmlFile;

  const ToolWebViewScreen({
    super.key,
    required this.toolName,
    required this.htmlFile,
  });

  @override
  State<ToolWebViewScreen> createState() => _ToolWebViewScreenState();
}

class _ToolWebViewScreenState extends State<ToolWebViewScreen> {
  InAppWebViewController? _controller;
  bool _isLoading = true;

  String _getWebViewUrl() {
    // HTML dosyalarına dil parametresi EKLEMİYORUZ
    return 'file:///android_asset/flutter_assets/assets/web/${widget.htmlFile}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.toolName),
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(_getWebViewUrl())),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              allowFileAccess: true,
              allowFileAccessFromFileURLs: true,
              allowUniversalAccessFromFileURLs: true,
              supportZoom: true,
              clearCache: true,
              cacheMode: CacheMode.LOAD_DEFAULT,
            ),
            onWebViewCreated: (controller) {
              _controller = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                _isLoading = true;
              });
            },
            onLoadStop: (controller, url) {
              setState(() {
                _isLoading = false;
              });
            },
            onLoadError: (controller, url, code, message) {
              setState(() {
                _isLoading = false;
              });
            },
          ),
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color(0xFFD32F2F)),
                  SizedBox(height: 20),
                  Text(
                    'Araç Yükleniyor...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFD32F2F),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
