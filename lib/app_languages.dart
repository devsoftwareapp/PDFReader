// lib/app_languages.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Dil veri modeli - Ayrı bir class olarak
class Language {
  final String code;
  final String name;
  final String nativeName;
  final String flag;

  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.flag,
  });
}

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  Map<String, String>? _localizedStrings;

  Future<bool> load() async {
    final String jsonString = await _loadJsonString();
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  Future<String> _loadJsonString() async {
    try {
      // ARB dosyasını yükle - assets/l10n/ klasöründen
      final String languageCode = locale.languageCode;
      final String countryCode = locale.countryCode ?? '';
      String fileName = 'intl_$languageCode';
      
      if (countryCode.isNotEmpty) {
        fileName = 'intl_${languageCode}_$countryCode';
      }
      
      return await rootBundle.loadString('assets/l10n/$fileName.arb');
    } catch (e) {
      // Fallback to English
      return await rootBundle.loadString('assets/l10n/intl_en_US.arb');
    }
  }

  String translate(String key) {
    return _localizedStrings?[key] ?? '**$key**';
  }

  // Convenience methods for common translations
  String get appTitle => translate('appTitle');
  String get appSubtitle => translate('appSubtitle');
  String get home => translate('home');
  String get tools => translate('tools');
  String get files => translate('files');
  String get searchPdfs => translate('searchPdfs');
  String get noResults => translate('noResults');
  String get noPdfFiles => translate('noPdfFiles');
  String get loading => translate('loading');
  String get scanAgain => translate('scanAgain');
  String get selectFile => translate('selectFile');
  String get permissionRequired => translate('permissionRequired');
  String get fileAccessPermission => translate('fileAccessPermission');
  String get grantPermission => translate('grantPermission');
  String get goToSettings => translate('goToSettings');
  String get cancel => translate('cancel');
  String get share => translate('share');
  String get rename => translate('rename');
  String get print => translate('print');
  String get delete => translate('delete');
  String get confirmDelete => translate('confirmDelete');
  String get deleteConfirmation => translate('deleteConfirmation');
  String get fileDeleted => translate('fileDeleted');
  String get deleteError => translate('deleteError');
  String get fileShared => translate('fileShared');
  String get fileShareError => translate('fileShareError');
  String get filePrinted => translate('filePrinted');
  String get printError => translate('printError');
  String get confirmRename => translate('confirmRename');
  String get newFileName => translate('newFileName');
  String get fileRenamed => translate('fileRenamed');
  String get renameError => translate('renameError');
  String get save => translate('save');
  String get searchHistory => translate('searchHistory');
  String get clearHistory => translate('clearHistory');
  String get recent => translate('recent');
  String get favorites => translate('favorites');
  String get noRecentFiles => translate('noRecentFiles');
  String get noFavorites => translate('noFavorites');
  String get onDevice => translate('onDevice');
  String get comingSoon => translate('comingSoon');
  String get cloudStorage => translate('cloudStorage');
  String get googleDrive => translate('googleDrive');
  String get oneDrive => translate('oneDrive');
  String get dropbox => translate('dropbox');
  String get emailIntegration => translate('emailIntegration');
  String get pdfsFromEmails => translate('pdfsFromEmails');
  String get gmail => translate('gmail');
  String get browseForMoreFiles => translate('browseForMoreFiles');
  String get about => translate('about');
  String get helpAndSupport => translate('helpAndSupport');
  String get languages => translate('languages');
  String get privacy => translate('privacy');
  String get aboutPdfReader => translate('aboutPdfReader');
  String get advancedPdfViewing => translate('advancedPdfViewing');
  String get close => translate('close');
  String get helpSupport => translate('helpSupport');
  String get describeIssue => translate('describeIssue');
  String get yourEmail => translate('yourEmail');
  String get yourMessage => translate('yourMessage');
  String get fillAllFields => translate('fillAllFields');
  String get send => translate('send');
  String get messageRedirecting => translate('messageRedirecting');
  String get searchLanguage => translate('searchLanguage');
  String get noLanguageFound => translate('noLanguageFound');
  String get fileSelection => translate('fileSelection');
  String get fileNotFound => translate('fileNotFound');
  String get pdfOpenError => translate('pdfOpenError');
  String get pdfLoading => translate('pdfLoading');
  String get pdfSavedSuccess => translate('pdfSavedSuccess');
  String get pdfSaveError => translate('pdfSaveError');
  String get privacyPolicy => translate('privacyPolicy');
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLanguages.supportedLocales.any((supportedLocale) =>
      supportedLocale.languageCode == locale.languageCode &&
      (supportedLocale.countryCode == null || 
       supportedLocale.countryCode == locale.countryCode)
    );
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

class AppLanguages {
  // Desteklenen diller listesi - VERİLEN DİLLER
  static final List<Language> supportedLanguages = [
    Language(code: 'en_US', name: 'English', nativeName: 'English', flag: '🇺🇸'),
    Language(code: 'tr_TR', name: 'Turkish', nativeName: 'Türkçe', flag: '🇹🇷'),
    Language(code: 'es_ES', name: 'Spanish', nativeName: 'Español', flag: '🇪🇸'),
    Language(code: 'fr_FR', name: 'French', nativeName: 'Français', flag: '🇫🇷'),
    Language(code: 'de_DE', name: 'German', nativeName: 'Deutsch', flag: '🇩🇪'),
    Language(code: 'zh_CN', name: 'Chinese', nativeName: '中文', flag: '🇨🇳'),
    Language(code: 'hi_IN', name: 'Hindi', nativeName: 'हिन्दी', flag: '🇮🇳'),
    Language(code: 'ar_AR', name: 'Arabic', nativeName: 'العربية', flag: '🇸🇦'),
    Language(code: 'ru_RU', name: 'Russian', nativeName: 'Русский', flag: '🇷🇺'),
    Language(code: 'pt_BR', name: 'Portuguese', nativeName: 'Português', flag: '🇧🇷'),
    Language(code: 'id_ID', name: 'Indonesian', nativeName: 'Bahasa Indonesia', flag: '🇮🇩'),
    Language(code: 'ur_PK', name: 'Urdu', nativeName: 'اردو', flag: '🇵🇰'),
    Language(code: 'ja_JP', name: 'Japanese', nativeName: '日本語', flag: '🇯🇵'),
    Language(code: 'sw_TZ', name: 'Swahili', nativeName: 'Kiswahili', flag: '🇹🇿'),
    Language(code: 'bn_BD', name: 'Bengali', nativeName: 'বাংলা', flag: '🇧🇩'),
    Language(code: 'fi_FI', name: 'Kurmanci', nativeName: 'Kurdî - Zarava Kurmancî', flag: '🇫🇮'),
    Language(code: 'cs_CS', name: 'Zazakî', nativeName: 'Kurdî - Zarava Zazakî', flag: '🇿🇼'),
  ];

  // SharedPreferences anahtarı
  static const String _selectedLanguageKey = 'selected_language';
  static const String _userHasSelectedLanguageKey = 'user_has_selected_language';

  // Mevcut dil kodunu al
  static Future<String> getCurrentLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Kullanıcı daha önce dil seçmiş mi kontrol et
    final bool userHasSelected = prefs.getBool(_userHasSelectedLanguageKey) ?? false;
    
    if (userHasSelected) {
      // Kullanıcı seçimi öncelikli
      final String? savedLanguage = prefs.getString(_selectedLanguageKey);
      if (savedLanguage != null && _isLanguageSupported(savedLanguage)) {
        return savedLanguage;
      }
    }
    
    // Sistem dilini al
    final String systemLanguage = _getSystemLanguage();
    if (_isLanguageSupported(systemLanguage)) {
      return systemLanguage;
    }
    
    // Varsayılan dil
    return 'en_US';
  }

  // Sistem dilini al
  static String _getSystemLanguage() {
    try {
      final String systemLocale = Platform.localeName;
      final String systemLanguageCode = systemLocale.split('_')[0];
      final String? systemCountryCode = systemLocale.contains('_') ? systemLocale.split('_')[1] : null;
      
      // Tam eşleşme kontrolü
      final String fullSystemLocale = systemCountryCode != null 
          ? '${systemLanguageCode}_$systemCountryCode'
          : systemLanguageCode;
          
      if (_isLanguageSupported(fullSystemLocale)) {
        return fullSystemLocale;
      }
      
      // Sadece dil kodu ile eşleşme kontrolü
      for (var lang in supportedLanguages) {
        if (lang.code.startsWith('${systemLanguageCode}_')) {
          return lang.code;
        }
      }
    } catch (e) {
      print('Sistem dili alınamadı: $e');
    }
    
    return 'en_US';
  }

  // Dil destekleniyor mu kontrol et
  static bool _isLanguageSupported(String languageCode) {
    return supportedLanguages.any((lang) => lang.code == languageCode);
  }

  // Dil değiştir
  static Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedLanguageKey, languageCode);
    await prefs.setBool(_userHasSelectedLanguageKey, true);
  }

  // Kullanıcı seçimini sıfırla (sistem diline dön)
  static Future<void> resetToSystemLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_selectedLanguageKey);
    await prefs.setBool(_userHasSelectedLanguageKey, false);
  }

  // Dil kodundan dil objesi al
  static Language getLanguageByCode(String code) {
    return supportedLanguages.firstWhere(
      (lang) => lang.code == code,
      orElse: () => supportedLanguages.first, // fallback
    );
  }

  // Mevcut dil objesini al
  static Future<Language> getCurrentLanguage() async {
    final String code = await getCurrentLanguageCode();
    return getLanguageByCode(code);
  }

  // Dil değişikliği dinleyicisi
  static ValueNotifier<String> languageNotifier = ValueNotifier<String>('en_US');

  // Dil değişikliğini bildir
  static Future<void> notifyLanguageChange() async {
    final String currentCode = await getCurrentLanguageCode();
    languageNotifier.value = currentCode;
  }

  // Locale dönüşümü için yardımcı metod
  static Locale getLocaleFromCode(String code) {
    if (code == 'en_US') return const Locale('en', 'US');
    if (code == 'tr_TR') return const Locale('tr', 'TR');
    if (code == 'es_ES') return const Locale('es', 'ES');
    if (code == 'fr_FR') return const Locale('fr', 'FR');
    if (code == 'de_DE') return const Locale('de', 'DE');
    if (code == 'zh_CN') return const Locale('zh', 'CN');
    if (code == 'hi_IN') return const Locale('hi', 'IN');
    if (code == 'ar_AR') return const Locale('ar', 'AR');
    if (code == 'ru_RU') return const Locale('ru', 'RU');
    if (code == 'pt_BR') return const Locale('pt', 'BR');
    if (code == 'id_ID') return const Locale('id', 'ID');
    if (code == 'ur_PK') return const Locale('ur', 'PK');
    if (code == 'ja_JP') return const Locale('ja', 'JP');
    if (code == 'sw_TZ') return const Locale('sw', 'TZ');
    if (code == 'bn_BD') return const Locale('bn', 'BD');
    if (code == 'fi_FI') return const Locale('fi', 'FI');
    if (code == 'cs_CS') return const Locale('cs', 'CS');
    
    if (code.contains('_')) {
      final parts = code.split('_');
      return Locale(parts[0], parts.length > 1 ? parts[1] : null);
    }
    return Locale(code);
  }

  // Desteklenen Locale listesi
  static List<Locale> get supportedLocales {
    return supportedLanguages.map((lang) => getLocaleFromCode(lang.code)).toList();
  }
}

// Dil değişikliği için provider
class LanguageProvider with ChangeNotifier {
  Language? _currentLanguage;

  Language? get currentLanguage => _currentLanguage;

  Future<void> loadLanguage() async {
    final String code = await AppLanguages.getCurrentLanguageCode();
    _currentLanguage = AppLanguages.getLanguageByCode(code);
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    await AppLanguages.setLanguage(languageCode);
    _currentLanguage = AppLanguages.getLanguageByCode(languageCode);
    AppLanguages.languageNotifier.value = languageCode;
    notifyListeners();
  }

  Future<void> resetToSystem() async {
    await AppLanguages.resetToSystemLanguage();
    await loadLanguage();
    AppLanguages.languageNotifier.value = _currentLanguage?.code ?? 'en_US';
  }

  // Locale getter
  Locale get currentLocale {
    return AppLanguages.getLocaleFromCode(_currentLanguage?.code ?? 'en_US');
  }
}

// Dil seçim dialogu
class LanguageDialog {
  static void show(BuildContext context, LanguageProvider languageProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          AppLocalizations.of(context).languages,
          style: TextStyle(
            color: Color(0xFFD32F2F),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Container(
          width: double.maxFinite,
          height: 400,
          child: _LanguageList(languageProvider: languageProvider),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context).close,
              style: TextStyle(color: Color(0xFFD32F2F)),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageList extends StatefulWidget {
  final LanguageProvider languageProvider;

  const _LanguageList({required this.languageProvider});

  @override
  State<_LanguageList> createState() => _LanguageListState();
}

class _LanguageListState extends State<_LanguageList> {
  String _currentLanguage = 'en_US';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentLanguage();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  Future<void> _loadCurrentLanguage() async {
    _currentLanguage = await AppLanguages.getCurrentLanguageCode();
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredLanguages = _searchQuery.isEmpty
        ? AppLanguages.supportedLanguages
        : AppLanguages.supportedLanguages.where((lang) =>
            lang.name.toLowerCase().contains(_searchQuery) ||
            lang.nativeName.toLowerCase().contains(_searchQuery) ||
            lang.code.toLowerCase().contains(_searchQuery))
        .toList();

    return Column(
      children: [
        // Arama kutusu
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).searchLanguage,
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              isDense: true,
            ),
          ),
        ),
        Expanded(
          child: filteredLanguages.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context).noLanguageFound,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView(
                  children: [
                    // Sistem Dili Seçeneği
                    ListTile(
                      leading: Icon(Icons.language, color: Color(0xFFD32F2F)),
                      title: Text(
                        'Sistem Dili (Tavsiye)',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text('Cihaz dilinizle aynı'),
                      trailing: _currentLanguage == 'system' 
                          ? Icon(Icons.check, color: Color(0xFFD32F2F))
                          : null,
                      onTap: () async {
                        await widget.languageProvider.resetToSystem();
                        Navigator.pop(context);
                        _showRestartMessage(context);
                      },
                    ),
                    Divider(),
                    
                    // Desteklenen Diller
                    ...filteredLanguages.map((language) => ListTile(
                      leading: Text(
                        language.flag,
                        style: TextStyle(fontSize: 24),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            language.nativeName,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            language.name,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: _currentLanguage == language.code
                          ? Icon(Icons.check, color: Color(0xFFD32F2F))
                          : null,
                      onTap: () async {
                        await widget.languageProvider.changeLanguage(language.code);
                        Navigator.pop(context);
                        _showRestartMessage(context);
                      },
                    )).toList(),
                  ],
                ),
        ),
      ],
    );
  }

  void _showRestartMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info, color: Colors.white),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Dil değişikliği uygulama yeniden başlatılınca etkili olacak',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFD32F2F),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Yeniden Başlat',
          textColor: Colors.white,
          onPressed: () {
            SystemNavigator.pop();
          },
        ),
      ),
    );
  }
}
