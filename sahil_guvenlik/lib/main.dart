// ignore_for_file: deprecated_member_use, use_build_context_synchronously, duplicate_ignore, library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KONTROL LİSTELERİ UYGULAMASI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Color.fromRGBO(255, 255, 255, 0.95),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
      home: AuthCheckScreen(),
    );
  }
}

// AUTH CHECK SCREEN - Otomatik giriş kontrolü
class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('rememberMe') ?? false;
    final loginDate = prefs.getString('loginDate');

    if (rememberMe && loginDate != null) {
      final savedDate = DateTime.parse(loginDate);
      final now = DateTime.now();
      final difference = now.difference(savedDate).inDays;

      if (difference < 2) {
        // 2 gün geçmemişse direkt ana sayfaya yönlendir
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return;
      }
    }

    // Değilse splash screen'e git
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SplashScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

// A. AÇILIŞ EKRANI
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;

  bool _showButtons = false;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );

    _logoFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _textController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeIn,
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutCubic,
      ),
    );

    _progressController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(Duration(milliseconds: 300));
    await _logoController.forward();
    await Future.delayed(Duration(milliseconds: 200));
    await _textController.forward();
    _progressController.repeat();

    await Future.delayed(Duration(seconds: 4));
    if (mounted) {
      setState(() {
        _showButtons = true;
      });
      _progressController.stop();
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;

    final isSmallScreen = height < 700;
    final logoSize = isSmallScreen ? 130.0 : 160.0;
    final titleFontSize = isSmallScreen ? 20.0 : 24.0;
    final appNameFontSize = isSmallScreen ? 18.0 : 20.0;

    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/images/UNSUR(5).jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.blue.shade800,
                  );
                },
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.85),
                    ],
                    stops: [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: height * 0.08),
                    FadeTransition(
                      opacity: _logoFadeAnimation,
                      child: ScaleTransition(
                        scale: _logoScaleAnimation,
                        child: _buildLogo(logoSize),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                    FadeTransition(
                      opacity: _textFadeAnimation,
                      child: SlideTransition(
                        position: _textSlideAnimation,
                        child: _buildTitle(titleFontSize, appNameFontSize),
                      ),
                    ),
                    Spacer(),
                    if (!_showButtons)
                      _buildLoadingSection(isSmallScreen)
                    else
                      _buildLoginRegisterButtons(context),
                    SizedBox(height: height * 0.03),
                    _buildFooter(isSmallScreen),
                    SizedBox(height: height * 0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey.shade100,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.5),
            blurRadius: 30,
            spreadRadius: 5,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(6),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.orange.shade800.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/images.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.orange.shade700,
                        Colors.orange.shade900,
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.security,
                    size: size * 0.4,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(double titleSize, double appNameSize) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            'SAHİL GÜVENLİK',
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              letterSpacing: 6,
              shadows: [
                Shadow(
                  color: Colors.orange.shade800,
                  blurRadius: 20,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            'KOMUTANLIĞI',
            style: TextStyle(
              fontSize: titleSize,
              fontWeight: FontWeight.w300,
              color: Colors.white,
              letterSpacing: 6,
              shadows: [
                Shadow(
                  color: Colors.orange.shade800,
                  blurRadius: 20,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Container(
            width: 60,
            height: 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.orange.shade600,
                  Colors.transparent,
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.orange.shade600.withOpacity(0.5),
                width: 2,
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.orange.shade900.withOpacity(0.3),
                  Colors.orange.shade700.withOpacity(0.2),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.shade800.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              'KONTROL LİSTELERİ UYGULAMASI',
              style: TextStyle(
                fontSize: appNameSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2.5,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildLoadingSection(bool isSmall) {
    return Column(
      children: [
        Container(
          width: isSmall ? 50 : 55,
          height: isSmall ? 50 : 55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 255, 154, 38).withOpacity(0.3),
                const Color.fromARGB(255, 251, 154, 78).withOpacity(0.3),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade400),
              strokeWidth: 2.5,
            ),
          ),
        ),
        SizedBox(height: 14),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.black.withOpacity(0.3),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Yükleniyor',
                style: TextStyle(
                  fontSize: isSmall ? 13 : 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(width: 6),
              _buildDots(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoginRegisterButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        LoginPage(fromSplash: true),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    transitionDuration: Duration(milliseconds: 500),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 8,
                shadowColor: Colors.orange.shade800.withOpacity(0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.login, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Giriş Yap',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        RegisterPage(fromSplash: true),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    transitionDuration: Duration(milliseconds: 500),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 8,
                shadowColor: Colors.green.shade800.withOpacity(0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add, color: Colors.white, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Kayıt Ol',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDots() {
    return AnimatedBuilder(
      animation: _progressController,
      builder: (context, child) {
        return Row(
          children: List.generate(3, (index) {
            double delay = index * 0.2;
            double value = (_progressController.value - delay) % 1.0;
            double opacity = (value < 0.5) ? value * 2 : (1 - value) * 2;

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.5),
              child: Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(opacity.clamp(0.2, 1.0)),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildFooter(bool isSmall) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black.withOpacity(0.3),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.code,
                      size: 12,
                      color: Colors.orange.shade400,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Geliştirme Ekibi',
                      style: TextStyle(
                        fontSize: isSmall ? 9 : 10,
                        color: Colors.white.withOpacity(0.6),
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                _buildDeveloperName('SG Tegmen İbrahim Çabuk', isSmall),
                SizedBox(height: 5),
                _buildDeveloperName('SG Tegmen Tolga Kahraman', isSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperName(String name, bool isSmall) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade900.withOpacity(0.2),
            Colors.orange.shade700.withOpacity(0.1),
          ],
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange.shade400,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.shade400.withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          SizedBox(width: 6),
          Text(
            name,
            style: TextStyle(
              fontSize: isSmall ? 10 : 11,
              color: Colors.white,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.3,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 4,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ARAMA İÇİN VERİ SINIFI
class SearchableItem {
  final String title;
  final String category;
  final String path;
  final Widget? page;
  final IconData icon;
  final Color color;

  SearchableItem({
    required this.title,
    required this.category,
    required this.path,
    this.page,
    required this.icon,
    required this.color,
  });
}

// ANA SAYFA - GELİŞTİRİLMİŞ ARAMA
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showSearchResults = false;
  List<SearchableItem> _searchResults = [];

  late AnimationController _headerController;
  late AnimationController _cardsController;
  late AnimationController _bottomController;

  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  // GELİŞTİRİLMİŞ ARAMA VERİ TABANI - TÜM ALT MENÜLER DAHİL
  final List<SearchableItem> _allSearchableItems = [
    // Ana Menü Öğeleri
    SearchableItem(
      title: 'Yasal İşlem Tutanakları',
      category: 'Ana Menü',
      path: 'Ana Menü > Yasal İşlem Tutanakları',
      page: YasalIslemTutanaklariPage(),
      icon: Icons.assignment,
      color: Colors.blue,
    ),
    SearchableItem(
      title: 'Kontrol Listeleri',
      category: 'Ana Menü',
      path: 'Ana Menü > Kontrol Listeleri',
      page: KontrolListeleriAnaPage(),
      icon: Icons.assessment,
      color: Colors.orange,
    ),
    SearchableItem(
      title: 'Mevzuat',
      category: 'Ana Menü',
      path: 'Ana Menü > Mevzuat',
      page: MevzuatPage(),
      icon: Icons.gavel,
      color: Colors.purple,
    ),
    SearchableItem(
      title: 'Sıkça Yapılan Hatalar',
      category: 'Ana Menü',
      path: 'Ana Menü > Sıkça Yapılan Hatalar',
      page: SikcaYapilanHatalarPage(),
      icon: Icons.error_outline,
      color: Colors.red,
    ),

    // Kontrol Listeleri Alt Menüleri
    SearchableItem(
      title: 'Su Ürünleri Avcılığı Kontrolleri',
      category: 'Kontrol Listeleri',
      path: 'Kontrol Listeleri > Su Ürünleri Avcılığı Kontrolleri',
      page: SuUrunleriAvciligiKontrolPage(),
      icon: Icons.waves,
      color: Colors.teal,
    ),
    SearchableItem(
      title: 'Ticari Gemiler Kontrol Listesi',
      category: 'Kontrol Listeleri',
      path: 'Kontrol Listeleri > Ticari Gemiler Kontrol Listesi',
      page: TicariGemilerKontrolPage(),
      icon: Icons.directions_boat,
      color: Colors.blue,
    ),
    SearchableItem(
      title: 'Özel Tekne Kontrol Listesi',
      category: 'Kontrol Listeleri',
      path: 'Kontrol Listeleri > Özel Tekne Kontrol Listesi',
      page: OzelTekneKontrolPage(),
      icon: Icons.sailing,
      color: Colors.green,
    ),
    SearchableItem(
      title: 'Dalış Faaliyetleri Kontrolleri',
      category: 'Kontrol Listeleri',
      path: 'Kontrol Listeleri > Dalış Faaliyetleri Kontrolleri',
      page: DalisFaliyetleriKontrolPage(),
      icon: Icons.scuba_diving,
      color: Colors.purple,
    ),
    SearchableItem(
      title: 'Su Sporları İşletmeleri Kontrolleri',
      category: 'Kontrol Listeleri',
      path: 'Kontrol Listeleri > Su Sporları İşletmeleri Kontrolleri',
      page: SuSporlariIsletmeleriKontrolPage(),
      icon: Icons.sports_soccer,
      color: Colors.orange,
    ),
    SearchableItem(
      title: 'Balık Çiftlikleri Kontrolleri',
      category: 'Kontrol Listeleri',
      path: 'Kontrol Listeleri > Balık Çiftlikleri Kontrolleri',
      page: BalikCiftlikleriKontrolPage(),
      icon: Icons.agriculture,
      color: Colors.brown,
    ),
    SearchableItem(
      title: 'Çevre Kanunu Kontrol Listesi',
      category: 'Kontrol Listeleri',
      path: 'Kontrol Listeleri > Çevre Kanunu Kontrol Listesi',
      page: CevreKanunuKontrolPage(),
      icon: Icons.eco,
      color: Colors.lightGreen,
    ),
    SearchableItem(
      title: 'Kaçakçılıkla Mücadele Kontrolleri',
      category: 'Kontrol Listeleri',
      path: 'Kontrol Listeleri > Kaçakçılıkla Mücadele Kontrolleri',
      page: KacakciliklaMucadeleKontrolPage(),
      icon: Icons.security,
      color: Colors.red,
    ),

    // Su Ürünleri Avcılığı Alt Menüleri
    SearchableItem(
      title: 'Su Ürünleri Avcılığı Genel Kontrol Listesi',
      category: 'Su Ürünleri Avcılığı',
      path: 'Kontrol Listeleri > Su Ürünleri Avcılığı > Genel Kontrol',
      page: GenelKontrolPage(),
      icon: Icons.list_alt,
      color: Colors.blue,
    ),
    SearchableItem(
      title: 'Trol Yöntemi Kontrol Listesi',
      category: 'Su Ürünleri Avcılığı',
      path: 'Kontrol Listeleri > Su Ürünleri Avcılığı > Trol Yöntemi',
      page: TrolYontemiSecimPage(),
      icon: Icons.waves,
      color: Colors.blue,
    ),
    SearchableItem(
      title: 'Dip Trolü Kontrol Listesi',
      category: 'Su Ürünleri Avcılığı',
      path: 'Kontrol Listeleri > Su Ürünleri Avcılığı > Trol > Dip Trolü',
      page: DipTroluKontrolPage(),
      icon: Icons.arrow_downward,
      color: Colors.blue,
    ),
    SearchableItem(
      title: 'Orta Su Trolü Kontrol Listesi',
      category: 'Su Ürünleri Avcılığı',
      path: 'Kontrol Listeleri > Su Ürünleri Avcılığı > Trol > Orta Su',
      page: OrtaSuTroluKontrolPage(),
      icon: Icons.waves,
      color: Colors.teal,
    ),
    SearchableItem(
      title: 'Gırgır Yöntemi Kontrol Listesi',
      category: 'Su Ürünleri Avcılığı',
      path: 'Kontrol Listeleri > Su Ürünleri Avcılığı > Gırgır',
      page: GirgirYontemiKontrolPage(),
      icon: Icons.grid_on,
      color: Colors.orange,
    ),
    SearchableItem(
      title: 'Algarna Yöntemi Kontrol Listesi',
      category: 'Su Ürünleri Avcılığı',
      path: 'Kontrol Listeleri > Su Ürünleri Avcılığı > Algarna',
      page: AlgarnaYontemiKontrolPage(),
      icon: Icons.water_drop,
      color: Colors.teal,
    ),
    SearchableItem(
      title: 'Parakete Yöntemi Kontrol Listesi',
      category: 'Su Ürünleri Avcılığı',
      path: 'Kontrol Listeleri > Su Ürünleri Avcılığı > Parakete',
      page: ParaketeYontemiKontrolPage(),
      icon: Icons.filter_vintage,
      color: Colors.purple,
    ),
    SearchableItem(
      title: 'Uzatma Ağları Kontrol Listesi',
      category: 'Su Ürünleri Avcılığı',
      path: 'Kontrol Listeleri > Su Ürünleri Avcılığı > Uzatma Ağları',
      page: UzatmaAglariKontrolPage(),
      icon: Icons.web,
      color: Colors.green,
    ),
    SearchableItem(
      title: 'Avlanma Kotası Kontrolü',
      category: 'Su Ürünleri Avcılığı',
      path: 'Kontrol Listeleri > Su Ürünleri Avcılığı > Avlanma Kotası',
      page: AvlanmaKotasiKontrolPage(),
      icon: Icons.format_list_numbered,
      color: Colors.amber,
    ),

    // Genel Kontrol Listesi 19 Maddesi
    SearchableItem(
      title: 'Denize Elverişlilik Belgesi',
      category: 'Genel Kontrol',
      path: 'Su Ürünleri Genel Kontrol > Denize Elverişlilik Belgesi',
      icon: Icons.verified,
      color: Colors.blue,
    ),
    SearchableItem(
      title: 'Su Ürünleri Ruhsat Tezkereleri',
      category: 'Genel Kontrol',
      path: 'Su Ürünleri Genel Kontrol > Ruhsat Tezkereleri',
      icon: Icons.description,
      color: Colors.green,
    ),
    SearchableItem(
      title: 'Seyir Defteri',
      category: 'Genel Kontrol',
      path: 'Su Ürünleri Genel Kontrol > Seyir Defteri',
      icon: Icons.book,
      color: Colors.orange,
    ),
    SearchableItem(
      title: 'BAGİS Cihazı',
      category: 'Genel Kontrol',
      path: 'Su Ürünleri Genel Kontrol > BAGİS',
      icon: Icons.gps_fixed,
      color: Colors.purple,
    ),
    SearchableItem(
      title: 'Çevre Kontrolü',
      category: 'Genel Kontrol',
      path: 'Su Ürünleri Genel Kontrol > Çevre',
      icon: Icons.eco,
      color: Colors.green,
    ),
    SearchableItem(
      title: 'Tonilato',
      category: 'Genel Kontrol',
      path: 'Su Ürünleri Genel Kontrol > Tonilato',
      icon: Icons.scale,
      color: Colors.brown,
    ),
    SearchableItem(
      title: 'Gemi Adamı',
      category: 'Genel Kontrol',
      path: 'Su Ürünleri Genel Kontrol > Gemi Adamı',
      icon: Icons.person,
      color: Colors.indigo,
    ),
    SearchableItem(
      title: 'AİS Cihazı',
      category: 'Genel Kontrol',
      path: 'Su Ürünleri Genel Kontrol > AİS',
      icon: Icons.settings_input_antenna,
      color: Colors.teal,
    ),
    SearchableItem(
      title: 'Bağlama Kütüğü Ruhsatnamesi',
      category: 'Genel Kontrol',
      path: 'Su Ürünleri Genel Kontrol > Bağlama Kütüğü',
      icon: Icons.folder_special,
      color: Colors.amber,
    ),
    SearchableItem(
      title: 'Gemi Tasdiknamesi',
      category: 'Genel Kontrol',
      path: 'Su Ürünleri Genel Kontrol > Gemi Tasdiknamesi',
      icon: Icons.verified_user,
      color: Colors.cyan,
    ),
    SearchableItem(
      title: 'Bayrak Kontrolü',
      category: 'Genel Kontrol',
      path: 'Su Ürünleri Genel Kontrol > Bayrak',
      icon: Icons.flag,
      color: Colors.red,
    ),
    SearchableItem(
      title: 'Yakıt Kontrolü',
      category: 'Genel Kontrol',
      path: 'Su Ürünleri Genel Kontrol > Yakıt ÖTV',
      icon: Icons.local_gas_station,
      color: Colors.blue,
    ),
    SearchableItem(
      title: 'Telsiz Ruhsatnamesi',
      category: 'Genel Kontrol',
      path: 'Su Ürünleri Genel Kontrol > Telsiz',
      icon: Icons.radio,
      color: Colors.purple,
    ),
    SearchableItem(
      title: 'VHF Telsiz',
      category: 'Genel Kontrol',
      path: 'Su Ürünleri Genel Kontrol > VHF',
      icon: Icons.settings_remote,
      color: Colors.deepPurple,
    ),
    SearchableItem(
      title: 'Balıkçı Teknesi Ruhsatı',
      category: 'Genel Kontrol',
      path: 'Su Ürünleri Genel Kontrol > Balıkçı Ruhsatı',
      icon: Icons.sailing,
      color: Colors.indigo,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    _headerController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _cardsController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _bottomController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeIn),
    );

    _headerSlideAnimation = Tween<Offset>(
      begin: Offset(0, -0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(Duration(milliseconds: 100));
    _headerController.forward();
    await Future.delayed(Duration(milliseconds: 200));
    _cardsController.forward();
    await Future.delayed(Duration(milliseconds: 300));
    _bottomController.forward();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim(); // toLowerCase() kaldırıldı
    setState(() {
      _showSearchResults = query.isNotEmpty;
      if (query.isNotEmpty) {
        final lowerQuery =
            query.toLowerCase(); // Sadece karşılaştırma için lowercase

        _searchResults = _allSearchableItems.where((item) {
          return item.title.toLowerCase().contains(lowerQuery) ||
              item.category.toLowerCase().contains(lowerQuery) ||
              item.path.toLowerCase().contains(lowerQuery);
        }).toList();

        // AKILLI SIRALAMA - Tam eşleşme ve yakınlığa göre
        _searchResults.sort((a, b) {
          final aTitle = a.title.toLowerCase();
          final bTitle = b.title.toLowerCase();

          // 1. Tam baştan eşleşme en üstte
          final aStartsWith = aTitle.startsWith(lowerQuery);
          final bStartsWith = bTitle.startsWith(lowerQuery);
          if (aStartsWith && !bStartsWith) return -1;
          if (!aStartsWith && bStartsWith) return 1;

          // 2. Kelime başında eşleşme
          final aWordStart = aTitle.contains(' $lowerQuery');
          final bWordStart = bTitle.contains(' $lowerQuery');
          if (aWordStart && !bWordStart) return -1;
          if (!aWordStart && bWordStart) return 1;

          // 3. İçinde eşleşme - eşleşmenin konumuna göre
          final aIndex = aTitle.indexOf(lowerQuery);
          final bIndex = bTitle.indexOf(lowerQuery);
          if (aIndex != bIndex) return aIndex.compareTo(bIndex);

          // 4. Alfabetik sıralama
          return aTitle.compareTo(bTitle);
        });
      } else {
        _searchResults.clear();
      }
    });
  }

  void _onSearchItemTap(SearchableItem item) {
    if (item.page != null) {
      _navigateTo(context, item.page!);
    }

    setState(() {
      _showSearchResults = false;
      _searchController.clear();
      _searchFocusNode.unfocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _headerController.dispose();
    _cardsController.dispose();
    _bottomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blue.withOpacity(0.3),
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.withOpacity(0.4),
              Colors.blue.withOpacity(0.3),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.security, size: 20, color: Colors.white),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Ana Sayfa',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        // Ana resim - COVER ile tam ekran
        Positioned.fill(
          child: Image.asset(
            'assets/images/UNSUR(20)(yeni).png',
            fit: BoxFit
                .cover, // Resmi ekranı tamamen kaplar, kenarlardan kesebilir
            width: double.infinity,
            height: double.infinity,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.orange.shade50,
              );
            },
          ),
        ),
        // ... diğer kodlar aynı... diğer kodlarınız

        // Hafif overlay - daha az opaklık
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1), // Çok hafif overlay
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              FadeTransition(
                opacity: _headerFadeAnimation,
                child: SlideTransition(
                  position: _headerSlideAnimation,
                  child: _buildHeaderSection(),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      _buildAnimatedCards(),
                      SizedBox(height: 30),
                      _buildBottomSection(),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_showSearchResults && _searchResults.isNotEmpty)
          Positioned(
            top: 200,
            left: 16,
            right: 16,
            child: _buildSearchResults(),
          ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.shade200,
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/UNSUR(13).jpg',
                fit: BoxFit.cover,
                alignment: Alignment.center,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.orange.shade100,
                          Colors.orange.shade50,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.orange.shade100,
                    width: 2,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  // KONTROL LİSTELERİ UYGULAMASI yazısını düzenle - BEYAZ KUTUCUK KALDIRILDI
                  Container(
                    margin: EdgeInsets.only(bottom: 15),
                    child: Text(
                      'KONTROL LİSTELERİ UYGULAMASI',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(
                            255, 246, 2, 2), // Kırmızı yazı rengi
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.7),
                            blurRadius: 10,
                            offset: Offset(2, 2),
                          ),
                          Shadow(
                            color: Colors.orange.shade800.withOpacity(0.5),
                            blurRadius: 15,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Logoları sağda ve solda konumlandırıyoruz
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Sol Logo
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.shade400,
                              Colors.orange.shade600
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.shade300,
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/images.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.security,
                                size: 30,
                                color: Colors.white,
                              );
                            },
                          ),
                        ),
                      ),

                      // Sağ Logo
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.shade400,
                              Colors.orange.shade600
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.shade300,
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/images.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.security,
                                size: 30,
                                color: Colors.white,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Ara... (tüm menülerde arama yapılır)',
                        prefixIcon:
                            Icon(Icons.search, color: Colors.orange.shade800),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: Colors.grey),
                                onPressed: () {
                                  _searchController.clear();
                                  _searchFocusNode.unfocus();
                                },
                              )
                            : null,
                        hintStyle: TextStyle(
                            color: Colors.grey.shade500, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedCards() {
    final mainMenuItems = [
      {
        'title': 'Yasal İşlem Tutanakları',
        'icon': Icons.assignment,
        'color': Colors.blue,
        'page': YasalIslemTutanaklariPage(),
      },
      {
        'title': 'Kontrol Listeleri',
        'icon': Icons.assessment,
        'color': Colors.orange,
        'page': KontrolListeleriAnaPage(),
      },
      {
        'title': 'Mevzuat',
        'icon': Icons.gavel,
        'color': Colors.purple,
        'page': MevzuatPage(),
      },
      {
        'title': 'Sıkça Yapılan Hatalar',
        'icon': Icons.error_outline,
        'color': Colors.red,
        'page': SikcaYapilanHatalarPage(),
      },
    ];

    return AnimatedBuilder(
      animation: _cardsController,
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.0,
            ),
            itemCount: 4,
            itemBuilder: (context, index) {
              final item = mainMenuItems[index];
              final delay = index * 0.1;
              final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _cardsController,
                  curve: Interval(
                    delay,
                    delay + 0.5,
                    curve: Curves.easeOutBack,
                  ),
                ),
              );

              return ScaleTransition(
                scale: animation,
                child: FadeTransition(
                  opacity: animation,
                  child: _buildModernCard(item),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildModernCard(Map<String, dynamic> item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _navigateTo(context, item['page']),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: item['color'].withOpacity(0.2),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.6),
              width: 2,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              item['color'].withOpacity(0.8),
                              item['color'],
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: item['color'].withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          item['icon'],
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        item['title'],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: item['color'],
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return AnimatedBuilder(
      animation: _bottomController,
      builder: (context, child) {
        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _bottomController, curve: Curves.easeIn),
        );

        final slideAnimation = Tween<Offset>(
          begin: Offset(0, 0.3),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _bottomController, curve: Curves.easeOut),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Hızlı Erişim',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickAccessButton(
                          'Resmi Gazete',
                          Icons.article,
                          Colors.red,
                          () => _launchUrl('https://www.resmigazete.gov.tr'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickAccessButton(
                          'Mevzuat',
                          Icons.library_books,
                          Colors.blue,
                          () => _launchUrl('https://www.mevzuat.gov.tr'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildQuickAccessButton(
                          'Duyurular',
                          Icons.announcement,
                          Colors.green,
                          () => _navigateTo(context, DuyurularPage()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickAccessButton(
    String text,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.7),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.8), color],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Icon(icon, size: 24, color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                text,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        constraints: BoxConstraints(maxHeight: 400),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade700,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      '${_searchResults.length} sonuç bulundu',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(8),
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final item = _searchResults[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: item.color.withOpacity(0.2),
                        ),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: item.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(item.icon, color: item.color, size: 20),
                        ),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          item.path,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: item.color,
                        ),
                        onTap: () => _onSearchItemTap(item),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 300),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Link açılamadı: $url')),
        );
      }
    }
  }
}

// DUYURULAR SAYFASI
class DuyurularPage extends StatelessWidget {
  final List<Map<String, dynamic>> duyurular = [
    {
      'title': 'Yeni Mevzuat Güncellemesi',
      'date': '15.12.2023',
      'content': 'Su Ürünleri Avcılığı Tebliğinde değişiklik yapıldı.',
      'onem': 'Kritik',
    },
    {
      'title': 'Eğitim Programı Duyurusu',
      'date': '10.12.2023',
      'content': 'Yeni dönem eğitim programları açıklandı.',
      'onem': 'Orta',
    },
    {
      'title': 'Sistem Bakım Duyurusu',
      'date': '05.12.2023',
      'content': '15 Aralık tarihinde sistem bakım çalışması yapılacaktır.',
      'onem': 'Düşük',
    },
  ];

  DuyurularPage({super.key});

  Color _getOnemRengi(String onem) {
    switch (onem) {
      case 'Yüksek':
        return Colors.red;
      case 'Orta':
        return Colors.orange;
      case 'Düşük':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Duyurular', style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.green.shade800,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(34).jpeg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          itemCount: duyurular.length,
          itemBuilder: (context, index) {
            final duyuru = duyurular[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.8),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _getOnemRengi(duyuru['onem']).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.announcement,
                    color: _getOnemRengi(duyuru['onem']),
                    size: 22,
                  ),
                ),
                title: Text(
                  duyuru['title'],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text(
                      duyuru['content'],
                      style: TextStyle(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                _getOnemRengi(duyuru['onem']).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                                color: _getOnemRengi(duyuru['onem'])),
                          ),
                          child: Text(
                            duyuru['onem'],
                            style: TextStyle(
                              fontSize: 10,
                              color: _getOnemRengi(duyuru['onem']),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          duyuru['date'],
                          style: TextStyle(
                              fontSize: 10, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(duyuru['title']),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(duyuru['content']),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getOnemRengi(duyuru['onem'])
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: _getOnemRengi(duyuru['onem'])),
                                ),
                                child: Text(
                                  duyuru['onem'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _getOnemRengi(duyuru['onem']),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Tarih: ${duyuru['date']}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Kapat'),
                        ),
                      ],
                    ),
                  );
                },
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// VIDEO DIALOG WIDGET
class VideoDialog extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoDialog({super.key, required this.videoUrl, required this.title});

  @override
  _VideoDialogState createState() => _VideoDialogState();
}

class _VideoDialogState extends State<VideoDialog> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      if (kDebugMode) {
        print('🎬 Video yükleniyor: ${widget.videoUrl}');
        print('🌐 Web modu: $kIsWeb');
      }

      if (kIsWeb) {
        final webPath = widget.videoUrl.replaceFirst('assets/', '');

        if (kDebugMode) {
          print('📂 Web video path: $webPath');
        }

        _videoPlayerController = VideoPlayerController.networkUrl(
          Uri.parse(webPath),
          videoPlayerOptions: VideoPlayerOptions(
            mixWithOthers: false,
            allowBackgroundPlayback: false,
          ),
        );
      } else {
        _videoPlayerController = VideoPlayerController.asset(widget.videoUrl);
      }

      await _videoPlayerController.initialize();

      if (mounted) {
        setState(() {
          _chewieController = ChewieController(
            videoPlayerController: _videoPlayerController,
            autoPlay: true,
            looping: false,
            allowFullScreen: true,
            allowMuting: true,
            showControls: true,
            materialProgressColors: ChewieProgressColors(
              playedColor: Colors.orange.shade800,
              handleColor: Colors.orange.shade600,
              backgroundColor: Colors.grey.shade300,
              bufferedColor: Colors.grey.shade200,
            ),
            placeholder: Container(
              color: Colors.grey.shade300,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.orange.shade800,
                  ),
                ),
              ),
            ),
            autoInitialize: true,
          );
          _isLoading = false;
        });

        if (kDebugMode) {
          print('✅ Video başarıyla yüklendi!');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Video yüklenemedi: $e');
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.7,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${widget.title} - Video Eğitimi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    _chewieController?.pause();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            if (_isLoading)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.orange.shade800,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text('Video yükleniyor...'),
                    ],
                  ),
                ),
              )
            else if (_errorMessage != null)
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 50, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          'Video yüklenemedi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          kIsWeb
                              ? 'Video dosyası web/videos/ klasöründe bulunamadı.'
                              : 'Video dosyası assets/ klasöründe bulunamadı.',
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        if (kDebugMode) ...[
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Hata detayı:\n$_errorMessage',
                              style: TextStyle(fontSize: 10),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Kapat'),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (_chewieController != null)
              Expanded(child: Chewie(controller: _chewieController!))
            else
              Expanded(
                child: Center(child: Text('Beklenmeyen bir hata oluştu')),
              ),
            SizedBox(height: 16),
            if (_chewieController != null)
              Text(
                'Videoyu tam ekran izlemek için genişletme butonunu kullanabilirsiniz.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

// VIDEO SCREEN WIDGET
class VideoScreen extends StatefulWidget {
  final String videoPath;
  final String title;

  const VideoScreen({super.key, required this.videoPath, required this.title});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _isFullScreen = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _videoPlayerController = VideoPlayerController.asset(widget.videoPath);
      await _videoPlayerController.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        showControls: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: Colors.blue,
          handleColor: Colors.blue,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.grey.shade400,
        ),
        placeholder: Container(
          color: Colors.grey.shade900,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.blue),
                SizedBox(height: 16),
                Text('Video yükleniyor...',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        errorBuilder: (context, errorMessage) {
          return Container(
            color: Colors.grey.shade900,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 50),
                  SizedBox(height: 16),
                  Text('Video yüklenemedi',
                      style: TextStyle(color: Colors.white)),
                  SizedBox(height: 8),
                  Text(errorMessage,
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          );
        },
        allowPlaybackSpeedChanging: true,
        draggableProgressBar: true,
        showOptions: true,
        customControls: const CupertinoControls(
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.7),
          iconColor: Colors.white,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isFullScreen
          ? null
          : AppBar(
              title: Text(widget.title),
              backgroundColor: Colors.blue.shade800,
              actions: [
                IconButton(
                  icon: Icon(Icons.fullscreen),
                  onPressed: () {
                    setState(() {
                      _isFullScreen = true;
                    });
                    _chewieController?.enterFullScreen();
                  },
                ),
              ],
            ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.blue),
                  SizedBox(height: 16),
                  Text('Video hazırlanıyor...'),
                ],
              ),
            )
          : _chewieController != null
              ? Chewie(controller: _chewieController!)
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 50),
                      SizedBox(height: 16),
                      Text('Video oynatılamadı'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Geri Dön'),
                      ),
                    ],
                  ),
                ),
    );
  }
}

// B. YASAL İŞLEM TUTANAKLARI EKRANI
class YasalIslemTutanaklariPage extends StatefulWidget {
  const YasalIslemTutanaklariPage({super.key});

  @override
  State<YasalIslemTutanaklariPage> createState() =>
      _YasalIslemTutanaklariPageState();
}

class _YasalIslemTutanaklariPageState extends State<YasalIslemTutanaklariPage> {
  final List<Map<String, dynamic>> tutanaklar = [
    {
      'title': 'Arama Kararı Tutanağı',
      'icon': Icons.search,
      'color': Colors.blue,
      'videoUrl': 'assets/videos/arama_karari.mp4',
      'imageUrls': [
        'assets/images/aramakararı.png',
        'assets/images/arama_kararı_2.JPG',
      ],
    },
    {
      'title': 'Arama Tutanağı',
      'icon': Icons.find_in_page,
      'color': Colors.blue.shade700,
      'videoUrl': 'assets/videos/arama_tutanagi.mp4',
      'imageUrls': [
        'assets/images/aramatutanagı.JPG',
        'assets/images/arama_tutanagı_2.JPG',
      ],
    },
    {
      'title': 'Bilgi Alma Tutanağı',
      'icon': Icons.info,
      'color': Colors.green,
      'videoUrl': 'assets/videos/bilgi_alma_tutanagi.mp4',
      'imageUrls': [
        'assets/images/bılgı.alma.tutanagı.JPG',
        'assets/images/bılgı_alma_tutanagı_2.JPG',
      ],
    },
    {
      'title': 'Genel Amaçlı Zapt (Elkoyma) Tutanağı',
      'icon': Icons.security,
      'color': Colors.orange,
      'videoUrl': 'assets/videos/genel_amacli_zapt_elkoyma_tutanagi.mp4',
      'imageUrls': [
        'assets/images/genel.amaclı.zapt.elkoyma.tutanagı.JPG',
        'assets/images/genel_amaclı_zapt_tuanagı_2.JPG',
      ],
    },
    {
      'title': 'Elkoyma ve Sevk Tutanağı (Gerçek Kişi)',
      'icon': Icons.person,
      'color': Colors.orange.shade700,
      'videoUrl': 'assets/videos/elkoyma_ve_sevk_tutanagi_gercek_kisi.mp4',
      'imageUrls': [
        'assets/images/elkoymavesektutangı.gercek.kisi.JPG',
        'assets/images/elkoymavesektutangı_gercek.kisi_2.JPG',
      ],
    },
    {
      'title': 'Elkoyma ve Sevk Tutanağı (Tüzel Kişi)',
      'icon': Icons.business,
      'color': Colors.orange.shade800,
      'videoUrl': 'assets/videos/elkoyma_ve_sevk_tutanagi_tuzel_kisi.mp4',
      'imageUrls': [
        'assets/images/elkoyma_ve_sevk_tutanagı_tüzel.JPG',
        'assets/images/elkoyma_ve_sevk_tutanagı_tüzel_2.JPG',
      ],
    },
    {
      'title': 'Fezleke',
      'icon': Icons.description,
      'color': Colors.purple,
      'videoUrl': 'assets/videos/fezleke.mp4',
      'imageUrls': [
        'assets/images/FEZLEKE.JPG',
        'assets/images/FEZLEKE_2.JPG',
        'assets/images/FEZLEKE_3.JPG',
      ],
    },
    {
      'title': 'Gemi İdari Yaptırım Karar Tutanağı (Çevre)',
      'icon': Icons.directions_boat,
      'color': Colors.teal,
      'videoUrl': 'assets/videos/gemi_idari_yaptirim_karar_tutanagi_cevre.mp4',
      'imageUrls': [
        'assets/images/gemı_ıdarı_yaptırım_karar_tutanagı_cevre.JPG',
        'assets/images/gemı_ıdarı_yaptırım_karar_tutanagı_cevre_2.JPG',
      ],
    },
    {
      'title': 'Genel Amaçlı Yediemine Teslim Tutanağı',
      'icon': Icons.handshake,
      'color': Colors.brown,
      'videoUrl': 'assets/videos/genel_amacli_yediemine_teslim_tutanagi.mp4',
      'imageUrls': [
        'assets/images/genel_amaclı_yediemine_teslim_tuanagı.JPG',
        'assets/images/genel_amaclı_yediemine_teslim_tuanagı_2.JPG',
      ],
    },
    {
      'title': 'İdari Para Cezası Kararı (Su Ürünleri)',
      'icon': Icons.money_off,
      'color': Colors.red,
      'videoUrl': 'assets/videos/idari_para_cezasi_karari_su_urunleri.mp4',
      'imageUrls': [
        'assets/images/ıdarı_para_cezası_su_urunlerı.JPG',
        'assets/images/ıdarı_para_cezası_su_urunlerı_2.JPG',
        'assets/images/ıdarı_para_cezası_su_urunlerı_3.JPG',
      ],
    },
    {
      'title': 'İdari Yaptırım Karar Tutanağı',
      'icon': Icons.gavel,
      'color': Colors.red.shade700,
      'videoUrl': 'assets/videos/idari_yaptirim_karar_tutanagi.mp4',
      'imageUrls': [
        'assets/images/ıdarı_yaptırım_karar_tutanagı.JPG',
        'assets/images/ıdarı_yaptırım_karar_tutanagı_2.JPG',
      ],
    },
    {
      'title': 'Mağdur/Müşteki İfade Tutanağı',
      'icon': Icons.record_voice_over,
      'color': Colors.pink,
      'videoUrl': 'assets/videos/magdur_musteki_ifade_tutanagi.mp4',
      'imageUrls': [
        'assets/images/magdur_mustekı_ıfade_tatanagı.JPG',
        'assets/images/magdur_mustekı_ıfade_tatanagı_2.JPG',
      ],
    },
    {
      'title': 'Numune Tutanağı (Çevre)',
      'icon': Icons.science,
      'color': Colors.green.shade700,
      'videoUrl': 'assets/videos/numune_tutanagi_cevre.mp4',
      'imageUrls': [
        'assets/images/numune_tutanagı_cevre.JPG',
        'assets/images/numune_tutanagı_cevre_2.JPG',
      ],
    },
    {
      'title': 'Olay Tespit Tutanağı',
      'icon': Icons.warning,
      'color': Colors.amber,
      'videoUrl': 'assets/videos/olay_tespit_tutanagi.mp4',
      'imageUrls': [
        'assets/images/olay_tespıt_tutanagı.JPG',
        'assets/images/olay_tespıt_tutanagı_2.JPG',
      ],
    },
    {
      'title': 'Sanık Karar Takip Formu',
      'icon': Icons.track_changes,
      'color': Colors.deepOrange,
      'videoUrl': 'assets/videos/sanik_karar_takip_formu.mp4',
      'imageUrls': [
        'assets/images/sanık_karar_takıp_formu.JPG',
        'assets/images/sanık_karar_takıp_formu_2.JPG',
      ],
    },
    {
      'title': 'Savcılık Görüşme Tutanağı',
      'icon': Icons.people,
      'color': Colors.purple.shade700,
      'videoUrl': 'assets/videos/savcilik_gorusme_tutanagi.mp4',
      'imageUrls': [
        'assets/images/savcılık_gorusme_tutanagı.JPG',
        'assets/images/savcılık_gorusme_tutanagı_2.JPG',
      ],
    },
    {
      'title': 'Sevk Serbest Bırakma Tutanağı',
      'icon': Icons.exit_to_app,
      'color': Colors.green.shade800,
      'videoUrl': 'assets/videos/sevk_serbest_birakma_tutanagi.mp4',
      'imageUrls': [
        'assets/images/sevk_serbest_bırakma_tutanagı.JPG',
        'assets/images/sevk_serbest_bırakma_tutanagı_2.JPG',
      ],
    },
    {
      'title': 'Su Ürünleri Kanununa Aykırılıklara İlişkin Tespit Tutanağı',
      'icon': Icons.water_damage,
      'color': Colors.blue.shade900,
      'videoUrl':
          'assets/videos/su_urunleri_kanununa_aykirilik_tespit_tutanagi.mp4',
      'imageUrls': [
        'assets/images/su_urunlerı_kanununa_aykırılıklara_ılıskın_tespıt_tutanagı.JPG',
        'assets/images/su_urunlerı_kanununa_aykırılıklara_ılıskın_tespıt_tutanagı_2.JPG',
      ],
    },
    {
      'title': 'Şüpheli İfade Tutanağı (Müdafi Talep Edildiğinde)',
      'icon': Icons.person_pin,
      'color': Colors.red.shade900,
      'videoUrl':
          'assets/videos/supheli_ifade_tutanagi_mudafi_talep_edildiginde.mp4',
      'imageUrls': [
        'assets/images/suphelı_ıfade_tutanagı_mudafı_talep_edıldıgınde.JPG',
        'assets/images/suphelı_ıfade_tutanagı_mudafı_talep_edıldıgınde_2.JPG',
      ],
    },
    {
      'title': 'Şüpheli İfade Tutanağı (Müdafi Talep Edilmediğinde)',
      'icon': Icons.person_outline,
      'color': Colors.red.shade800,
      'videoUrl':
          'assets/videos/supheli_ifade_tutanagi_mudafi_talep_edilmediginde.mp4',
      'imageUrls': [
        'assets/images/suphelı_ıfade_tutanagı_mudafı_talep_edılmedıgınde.JPG',
        'assets/images/suphelı_ıfade_tutanagı_mudafı_talep_edılmedıgınde_2.JPG',
      ],
    },
    {
      'title': 'Tespit Tutanağı (Çevre)',
      'icon': Icons.eco,
      'color': Colors.lightGreen,
      'videoUrl': 'assets/videos/tespit_tutanagi_cevre.mp4',
      'imageUrls': [
        'assets/images/tespıt_tutanagı_cevre.JPG',
        'assets/images/tespıt_tutanagı_cevre_2.JPG',
      ],
    },
    {
      'title': 'Teşhis Tutanağı',
      'icon': Icons.visibility,
      'color': Colors.cyan,
      'videoUrl': 'assets/videos/teshis_tutanagi.mp4',
      'imageUrls': [
        'assets/images/teshıs_tutanagı.JPG',
        'assets/images/teshıs_tutanagı_2.JPG',
      ],
    },
    {
      'title': 'Tutanak ve Tebligat (Su Ürünleri)',
      'icon': Icons.notifications,
      'color': Colors.blueGrey,
      'videoUrl': 'assets/videos/tutanak_ve_tebligat_su_urunleri.mp4',
      'imageUrls': [
        'assets/images/tutanak_ve_teblıgat_su_urunlerı.JPG',
        'assets/images/tutanak_ve_teblıgat_su_urunlerı_2.JPG',
      ],
    },
    {
      'title': 'Üst Arama Tutanağı',
      'icon': Icons.person_search,
      'color': Colors.deepPurple,
      'videoUrl': 'assets/videos/ust_arama_tutanagi.mp4',
      'imageUrls': [
        'assets/images/ust_arama_tutanagı.JPG',
        'assets/images/ust_arama_tutanagı_2.JPG',
      ],
    },
    {
      'title': 'Yakalama ve Gözaltına Alma Tutanağı',
      'icon': Icons.lock,
      'color': Colors.red.shade600,
      'videoUrl': 'assets/videos/yakalama_ve_gozaltina_alma_tutanagi.mp4',
      'imageUrls': [
        'assets/images/yakalama_gozaltına_alma_tutanagı_suphelı_sanık_hakları_formu.JPG',
        'assets/images/yakalama_gozaltına_alma_tutanagı_suphelı_sanık_hakları_formu_2.JPG',
        'assets/images/yakalama_gozaltına_alma_tutanagı_suphelı_sanık_hakları_formu_3.JPG',
      ],
    },
    {
      'title': 'Zaptetme (Elkoyma) Tutanağı (Su Ürünleri)',
      'icon': Icons.beach_access,
      'color': Colors.lightBlue,
      'videoUrl': 'assets/videos/zaptetme_Elkoyma_tutanagi_su_urunleri.mp4',
      'imageUrls': [
        'assets/images/zapt_etme_elkoyma_tutanagı_suurunlerı.JPG',
        'assets/images/zapt_etme_elkoyma_tutanagı_suurunlerı_2.JPG',
      ],
    },
  ];
  void _showVideoScreen(BuildContext context, String videoUrl, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoScreen(videoPath: videoUrl, title: title),
      ),
    );
  }

  void _showImageDialog(
      BuildContext context, String title, List<String> imageUrls) {
    int currentIndex = 0;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(20),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade800,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '$title - Örnek Tutanak (${currentIndex + 1}/${imageUrls.length})',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: InteractiveViewer(
                        panEnabled: true,
                        minScale: 0.5,
                        maxScale: 3.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            imageUrls[currentIndex],
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.description,
                                      size: 50, color: Colors.grey.shade400),
                                  SizedBox(height: 8),
                                  Text('Görsel bulunamadı',
                                      style: TextStyle(fontSize: 12)),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.arrow_back, size: 14),
                          label: Text(
                            'Önceki',
                            style: TextStyle(fontSize: 12),
                          ),
                          onPressed: currentIndex > 0
                              ? () {
                                  setState(() {
                                    currentIndex--;
                                  });
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            minimumSize: Size(70, 30),
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${currentIndex + 1} / ${imageUrls.length}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.arrow_forward, size: 14),
                          label: Text(
                            'Sonraki',
                            style: TextStyle(fontSize: 12),
                          ),
                          onPressed: currentIndex < imageUrls.length - 1
                              ? () {
                                  setState(() {
                                    currentIndex++;
                                  });
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            minimumSize: Size(70, 30),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Yakınlaştırmak için iki parmakla zoom yapabilirsiniz',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showTutanakOptions(BuildContext context, Map<String, dynamic> tutanak) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              tutanak['title'],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            ListTile(
              leading: Icon(Icons.ondemand_video, color: Colors.blue, size: 22),
              title: Text('Video Eğitimi İzle', style: TextStyle(fontSize: 14)),
              onTap: () {
                Navigator.pop(context);
                _showVideoScreen(
                    context, tutanak['videoUrl'], tutanak['title']);
              },
            ),
            ListTile(
              leading: Icon(Icons.image, color: Colors.green, size: 22),
              title: Text(
                  'Örnek Tutanak Görüntüleri (${tutanak['imageUrls'].length} adet)',
                  style: TextStyle(fontSize: 14)),
              onTap: () {
                Navigator.pop(context);
                _showImageDialog(
                    context, tutanak['title'], tutanak['imageUrls']);
              },
            ),
            ListTile(
              leading: Icon(Icons.download, color: Colors.purple, size: 22),
              title:
                  Text('PDF Formatında İndir', style: TextStyle(fontSize: 14)),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${tutanak['title']} indiriliyor...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yasal İşlem Tutanakları', style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.blue.shade800,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(9).jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          itemCount: tutanaklar.length,
          itemBuilder: (context, index) {
            final tutanak = tutanaklar[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: Colors.white.withOpacity(0.7),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: tutanak['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child:
                      Icon(tutanak['icon'], color: tutanak['color'], size: 22),
                ),
                title: Text(
                  tutanak['title'],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${tutanak['imageUrls'].length} örnek görsel ve video',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.ondemand_video,
                          color: Colors.blue, size: 20),
                      onPressed: () {
                        _showVideoScreen(
                            context, tutanak['videoUrl'], tutanak['title']);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.collections,
                          color: Colors.green, size: 20),
                      onPressed: () {
                        _showImageDialog(
                            context, tutanak['title'], tutanak['imageUrls']);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  _showTutanakOptions(context, tutanak);
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            );
          },
        ),
      ),
    );
  }
}

// C. KONTROL LİSTELERİ ANA EKRANI
class KontrolListeleriAnaPage extends StatelessWidget {
  final List<Map<String, dynamic>> kontrolKategorileri = [
    {
      'title': 'Su Ürünleri Avcılığı Kontrolleri',
      'icon': Icons.waves,
      'color': Colors.teal,
      'page': SuUrunleriAvciligiKontrolPage(),
    },
    {
      'title': 'Ticari Gemiler Kontrol Listesi',
      'icon': Icons.directions_boat,
      'color': Colors.blue,
      'page': TicariGemilerKontrolPage(),
    },
    {
      'title': 'Özel Tekne Kontrol Listesi',
      'icon': Icons.sailing,
      'color': Colors.green,
      'page': OzelTekneSecimPage(),
    },
    {
      'title': 'Dalış Faaliyetleri Kontrolleri',
      'icon': Icons.scuba_diving,
      'color': Colors.purple,
      'page': DalisFaliyetleriKontrolPage(),
    },
    {
      'title': 'Su Sporları İşletmeleri Kontrolleri',
      'icon': Icons.sports_soccer,
      'color': Colors.orange,
      'page': SuSporlariIsletmeleriKontrolPage(),
    },
    {
      'title': 'Balık Çiftlikleri Kontrolleri',
      'icon': Icons.agriculture,
      'color': Colors.brown,
      'page': BalikCiftlikleriKontrolPage(),
    },
    {
      'title': 'Çevre Kanunu Kontrol Listesi',
      'icon': Icons.eco,
      'color': Colors.lightGreen,
      'page': CevreKanunuKontrolPage(),
    },
    {
      'title': 'Kaçakçılıkla Mücadele Kontrolleri',
      'icon': Icons.security,
      'color': Colors.red,
      'page': KacakciliklaMucadeleKontrolPage(),
    },
  ];
  KontrolListeleriAnaPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kontrol Listeleri', style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.orange.shade800,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(4).jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          itemCount: kontrolKategorileri.length,
          itemBuilder: (context, index) {
            final kategori = kontrolKategorileri[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.7),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: kategori['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    kategori['icon'],
                    color: kategori['color'],
                    size: 22,
                  ),
                ),
                title: Text(
                  kategori['title'],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => kategori['page']),
                  );
                },
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} // GİRİŞ SAYFASI - BENİ HATIRLA ÖZELLİĞİ İLE

class LoginPage extends StatefulWidget {
  final bool fromSplash;

  const LoginPage({super.key, this.fromSplash = false});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username');
    final savedPassword = prefs.getString('password');
    final rememberMe = prefs.getBool('rememberMe') ?? false;

    if (rememberMe && savedUsername != null && savedPassword != null) {
      setState(() {
        _usernameController.text = savedUsername;
        _passwordController.text = savedPassword;
        _rememberMe = true;
      });
    }
  }

  Future<void> _saveLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('password', _passwordController.text);
      await prefs.setBool('rememberMe', true);
      await prefs.setString('loginDate', DateTime.now().toIso8601String());
    } else {
      await prefs.remove('username');
      await prefs.remove('password');
      await prefs.setBool('rememberMe', false);
      await prefs.remove('loginDate');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(25).jpg'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade900.withOpacity(0.7),
                Colors.blue.shade700.withOpacity(0.7)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.orange.shade400,
                                Colors.orange.shade600
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.shade300,
                                blurRadius: 15,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/images.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.security,
                                  size: 40,
                                  color: Colors.white,
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Giriş Yap',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Hesabınıza erişmek için giriş yapın',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Kullanıcı Adı',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Lütfen kullanıcı adınızı giriniz'
                              : null,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Şifre',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen şifrenizi giriniz';
                            }
                            if (value.length < 6) {
                              return 'Şifre en az 6 karakter olmalıdır';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) =>
                                      setState(() => _rememberMe = value!),
                                ),
                                Text(
                                  'Beni Hatırla (2 gün)',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Şifre sıfırlama linki gönderildi',
                                      ),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Şifremi Unuttum',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await _saveLoginData();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Giriş başarılı! Hoş geldiniz ${_usernameController.text}',
                                    ),
                                    backgroundColor: Colors.green,
                                    duration: Duration(seconds: 2),
                                  ),
                                );

                                Future.delayed(Duration(seconds: 1), () {
                                  if (widget.fromSplash) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomePage(),
                                      ),
                                    );
                                  } else {
                                    Navigator.pop(context);
                                  }
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange.shade800,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Giriş Yap',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Hesabınız yok mu?',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                if (widget.fromSplash) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterPage(fromSplash: true),
                                    ),
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterPage(),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                'Kayıt Olun',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade800,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

// KAYIT SAYFASI
class RegisterPage extends StatefulWidget {
  final bool fromSplash;

  const RegisterPage({super.key, this.fromSplash = false});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lütfen kullanım koşullarını kabul edin'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Kayıt başarılı olunca giriş bilgilerini kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _usernameController.text);
      await prefs.setString('password', _passwordController.text);
      await prefs.setBool('rememberMe', true);
      await prefs.setString('loginDate', DateTime.now().toIso8601String());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Kayıt başarılı! Hoş geldiniz ${_usernameController.text}',
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(Duration(seconds: 1), () {
        if (widget.fromSplash) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(),
            ),
          );
        } else {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(26).jpeg'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green.shade900.withOpacity(0.7),
                Colors.green.shade700.withOpacity(0.7)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person_add,
                            size: 35,
                            color: Colors.green.shade800,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Kayıt Ol',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Yeni bir hesap oluşturun',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Kullanıcı Adı',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen kullanıcı adınızı giriniz';
                            }
                            if (value.length < 3) {
                              return 'Kullanıcı adı en az 3 karakter olmalıdır';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'E-posta',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen e-posta adresinizi giriniz';
                            }
                            if (!value.contains('@')) {
                              return 'Geçerli bir e-posta adresi giriniz';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Şifre',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen şifrenizi giriniz';
                            }
                            if (value.length < 6) {
                              return 'Şifre en az 6 karakter olmalıdır';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Şifre Tekrar',
                            prefixIcon: Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                () => _obscureConfirmPassword =
                                    !_obscureConfirmPassword,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Lütfen şifrenizi tekrar giriniz';
                            }
                            if (value != _passwordController.text) {
                              return 'Şifreler eşleşmiyor';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Checkbox(
                              value: _acceptTerms,
                              onChanged: (value) =>
                                  setState(() => _acceptTerms = value!),
                            ),
                            Expanded(
                              child: Text(
                                'Kullanım koşullarını ve gizlilik politikasını kabul ediyorum',
                                style: TextStyle(fontSize: 12),
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _register,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Kayıt Ol',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Zaten hesabınız var mı?',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                if (widget.fromSplash) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LoginPage(fromSplash: true),
                                    ),
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                'Giriş Yapın',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

// TİCARİ GEMİLER KONTROL SAYFASI
class TicariGemilerKontrolPage extends StatelessWidget {
  final List<String> kontrolMaddeleri = [
    '1. Gemi Genel Kontrol Listesi',
    '2. Güvenlik Ekipmanları Kontrol Listesi',
    '3. Seyir Dokümanları Kontrol Listesi',
    '4. İzin ve Lisanslar Kontrolü',
    '5. Mürettebat Evrakları Kontrolü',
    '6. Çevre Uygunluk Kontrolü',
    '7. Yangın Güvenlik Ekipmanları',
    '8. Can Kurtarma Ekipmanları',
    '9. Navigasyon Ekipmanları',
    '10. Haberleşme Ekipmanları',
  ];

  TicariGemilerKontrolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ticari Gemiler Kontrol Listeleri',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(25).jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          itemCount: kontrolMaddeleri.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              color: Colors.white.withOpacity(0.7),
              child: CheckboxListTile(
                title: Text(
                  kontrolMaddeleri[index],
                  style: TextStyle(fontSize: 14),
                ),
                value: false,
                onChanged: (bool? value) {},
                controlAffinity: ListTileControlAffinity.leading,
              ),
            );
          },
        ),
      ),
    );
  }
}

// ÖZEL TEKNE SEÇİM SAYFASI (YENİ)
class OzelTekneSecimPage extends StatelessWidget {
  const OzelTekneSecimPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Özel Tekne Kontrol Listesi',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.green.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(26).jpeg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.8),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.sailing, color: Colors.green, size: 24),
                ),
                title: Text(
                  'Özel Tekne',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
                subtitle: Text(
                  'Özel tekne kontrol maddelerini görüntüle',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OzelTekneKontrolPage(),
                    ),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.8),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.flight, color: Colors.blue, size: 24),
                ),
                title: Text(
                  'Deniz Uçağı',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                subtitle: Text(
                  'Deniz uçağı kontrol maddelerini görüntüle',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DenizUcagiKontrolPage(),
                    ),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ÖZEL TEKNE KONTROL SAYFASI (GÜNCELLENMİŞ - 22 MADDE)
class OzelTekneKontrolPage extends StatelessWidget {
  final List<Map<String, dynamic>> kontrolMaddeleri = [
    {
      'title': 'ÖZEL TEKNELERİN SAHİBİ DIŞINDA KULLANILMASI KONTROLÜ',
      'icon': Icons.person_off,
      'color': Colors.red,
      'index': 0,
    },
    {
      'title': 'PERSONEL/YOLCU SAYISI KONTROLÜ',
      'icon': Icons.people,
      'color': Colors.blue,
      'index': 1,
    },
    {
      'title': 'TİCARİ MAKSATLI KULLANIM KONTROLÜ',
      'icon': Icons.business_center,
      'color': Colors.orange,
      'index': 2,
    },
    {
      'title': 'GEMİ, DENİZ VE İÇSU ARAÇLARININ ADI KONTROLÜ',
      'icon': Icons.text_fields,
      'color': Colors.purple,
      'index': 3,
    },
    {
      'title': 'SEYİR İZİN BELGESİ (TRANSİT-LOG BELGESİ) KONTROLÜ',
      'icon': Icons.description,
      'color': Colors.teal,
      'index': 4,
    },
    {
      'title': 'TÜRKİYE\'YE GİRİŞ VE TÜRKİYE\'DEN ÇIKIŞ KONTROLÜ',
      'icon': Icons.flight_takeoff,
      'color': Colors.indigo,
      'index': 5,
    },
    {
      'title':
          'TELSİZ RUHSATNAMESİ (TELSİZ CİHAZININ BULUNMASI HALİNDE) KONTROLÜ',
      'icon': Icons.radio,
      'color': Colors.brown,
      'index': 6,
    },
    {
      'title':
          'TELSİZ RUHSATNAMESİNDE BELİRTİLEN TEÇHİZAT (TELSİZ CİHAZININ BULUNMASI HALİNDE) KONTROLÜ',
      'icon': Icons.settings_remote,
      'color': Colors.cyan,
      'index': 7,
    },
    {
      'title': 'ASKERİ YASAK BÖLGE İHLALİ KONTROLÜ',
      'icon': Icons.block,
      'color': Colors.red,
      'index': 8,
    },
    {
      'title': 'TÜRK BAYRAĞI ÇEKİLMESİ KONTROLÜ',
      'icon': Icons.flag,
      'color': Colors.red,
      'index': 9,
    },
    {
      'title': 'BAYRAĞIN STANDART OLMAMASI KONTROLÜ',
      'icon': Icons.flag_outlined,
      'color': Colors.deepOrange,
      'index': 10,
    },
    {
      'title': 'BAĞLAMA KÜTÜĞÜ RUHSATNAMESİ KONTROLÜ',
      'icon': Icons.folder_special,
      'color': Colors.amber,
      'index': 11,
    },
    {
      'title': 'BAĞLAMA KÜTÜĞÜ RUHSATNAMESİ VİZESİ KONTROLÜ',
      'icon': Icons.verified_user,
      'color': Colors.grey,
      'index': 12,
    },
    {
      'title': 'BAĞLAMA KÜTÜĞÜ RUHSATNAMESİ İBRAZI KONTROLÜ',
      'icon': Icons.assignment,
      'color': Colors.green,
      'index': 13,
    },
    {
      'title': 'GEMİ ADAMI KONTROLÜ',
      'icon': Icons.person,
      'color': Colors.indigo,
      'index': 14,
    },
    {
      'title':
          'ASGARİ EMNİYET TEÇHİZATI KONTROLÜ (CAN YELEĞİ, YANGIN TÜPÜ VB.)',
      'icon': Icons.shield,
      'color': Colors.deepPurple,
      'index': 15,
    },
    {
      'title': 'ALKOL KONTROLÜ',
      'icon': Icons.local_drink,
      'color': Colors.red,
      'index': 16,
    },
    {
      'title': 'TEKNE KULLANIMI KONTROLÜ',
      'icon': Icons.speed,
      'color': Colors.orange,
      'index': 17,
    },
    {
      'title': 'PİS SU TANKI KONTROLÜ',
      'icon': Icons.water_damage,
      'color': Colors.brown,
      'index': 18,
    },
    {
      'title': 'ATIK TRANSFER FORMU',
      'icon': Icons.receipt,
      'color': Colors.green,
      'index': 19,
    },
    {
      'title': 'DEMİRLEME KONTROLÜ',
      'icon': Icons.anchor,
      'color': Colors.blue,
      'index': 20,
    },
    {
      'title': 'DEMİRLEME KONTROLÜ (HALATINI AĞACA BAĞLAMA)',
      'icon': Icons.park,
      'color': Colors.green,
      'index': 21,
    },
  ];

  OzelTekneKontrolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Özel Tekne Kontrol Listesi',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.green.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(26).jpeg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: kontrolMaddeleri.length,
          itemBuilder: (context, index) {
            final madde = kontrolMaddeleri[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.8),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: madde['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    madde['icon'],
                    color: madde['color'],
                    size: 22,
                  ),
                ),
                title: Text(
                  '${index + 1}. ${madde['title']}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OzelTekneDetayPage(
                        title: madde['title'],
                        color: madde['color'],
                        index: madde['index'],
                      ),
                    ),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================================
// ÖZEL TEKNE DETAY SAYFASI (YENİ) - WORD'DEN ALINAN BİLGİLER İLE
// OzelTekneKontrolPage sınıfından HEMEN SONRA ekleyin
// ============================================================================

class OzelTekneDetayPage extends StatelessWidget {
  final String title;
  final Color color;
  final int index;

  const OzelTekneDetayPage({
    super.key,
    required this.title,
    required this.color,
    required this.index,
  });

  String _getAciklamaMetni() {
    switch (index) {
      case 0:
        return 'ÖZEL TEKNELERİN DONATIMI VE KULLANACAK KİŞİLERİN YETERLİKLERİ HAKKINDA YÖNETMELİĞİN MADDE 5/6\'E İSTİNADEN KONTROL İCRA EDİLİR. YETKİ YAZISI NOTER VEYA LİMAN BAŞKANLIĞI ONAYLI OLMASI GEREKİR. (TEKNE SAHİBİ EŞİ VE ÇOCUKLARI İÇİN ARANMAZ)';
      case 1:
        return 'ÖZEL TEKNELERİN DONATIMI VE KULLANACAK KİŞİLERİN YETERLİKLERİ HAKKINDA YÖNETMELİĞİN MADDE 5/10\'A İSTİNADEN KONTROL İCRA EDİLİR. (KİŞİ SAYISI METRE BAŞINA BİR KİŞİ OLARAK BELİRLENİR VE BU SAYI ON İKİ KİŞİYİ GEÇEMEZ)';
      case 2:
        return 'ÖZEL TEKNELERİN DONATIMI VE KULLANACAK KİŞİLERİN YETERLİKLERİ HAKKINDA YÖNETMELİĞİN MADDE 5/11\'A İSTİNADEN KONTROL İCRA EDİLİR.';
      case 3:
        return 'BAĞLAMA KÜTÜĞÜ UYGULAMA YÖNETMELİĞİN MADDE 11\'E İSTİNADEN KONTROL İCRA EDİLİR.';
      case 4:
        return 'DENİZ TURİZMİ YÖNETMELİĞİN MADDE 4/1-J\'E İSTİNADEN KONTROL İCRA EDİLİR.';
      case 5:
        return 'YABANCILAR VE ULUSLARARASI KORUMA KANUNUN MADDE 5\'E İSTİNADEN KONTROL İCRA EDİLİR.';
      case 6:
        return 'TELSİZ İŞLEMLERİNE İLİŞKİN USUL VE ESASLAR HAKKINDA YÖNETMELİĞİN MADDE 8/1\'E İSTİNADEN KONTROL İCRA EDİLİR.';
      case 7:
        return 'TELSİZ İŞLEMLERİNE İLİŞKİN USUL VE ESASLAR HAKKINDA YÖNETMELİĞİN MADDE 8/2-3\'E İSTİNADEN KONTROL İCRA EDİLİR.';
      case 8:
        return '2565 SAYILI ASKERİ YASAK BÖLGELER VE GÜVENLİK BÖLGELERİ KANUNU MADDE 11,21 VE 26\'YA İSTİNADEN KONTROL İCRA EDİLİR.';
      case 9:
        return 'BAĞLAMA KÜTÜĞÜ UYGULAMA YÖNETMELİĞİN MADDE 11\'E İSTİNADEN KONTROL İCRA EDİLİR.';
      case 10:
        return '2893 SAYILI TÜRK BAYRAĞI KANUNUN MADDE 8/1,2\'E İSTİNADEN KONTROL İCRA EDİLİR. (BAYRAĞIN YIRTIK, FLEŞALANMASI VB.)';
      case 11:
        return 'BAĞLAMA KÜTÜĞÜ UYGULAMA YÖNETMELİĞİN MADDE 18\'E İSTİNADEN KONTROL İCRA EDİLİR. (2,5 METRE VE ÜZERİNDEKİ ÖZEL KULLANIMA MAHSUS DENİZ ARAÇLARI ZORUNLU OLARAK KAYDEDİLİR)\n\nRUHSATNAME, GEMİ, DENİZ VE İÇSU ARACININ KAYDEDİLDİĞİ BAĞLAMA KÜTÜĞÜNÜ TUTMAKLA GÖREVLİ BAŞKANLIK TARAFINDAN DÜZENLENİR. RUSATNAME 1(BİR) YIL VEYA KATLARI OLMAK ÜZERE EN FAZLA 5(BEŞ) YILA KADAR DÜZENLENİR. SÜRESİ BİTİMİNDE RUHSATNAMENİN YENİDEN DÜZENLENMESİ ZORUNLUDUR.';
      case 12:
        return 'BAĞLAMA KÜTÜĞÜ UYGULAMA YÖNETMELİĞİN MADDE 19\'A İSTİNADEN KONTROL İCRA EDİLİR. (BEŞ YILA KADAR VİZE EDİLEBİLİR)\n\nNOT: Ruhsatname vizesi 30/12/2023 yılında mülga edilmiştir.';
      case 13:
        return 'ÖZEL TEKNELERİN DONATIMI VE KULLANACAK KİŞİLERİN YETERLİKLERİ HAKKINDA YÖNETMELİĞİN MADDE 5/1\'E İSTİNADEN KONTROL İCRA EDİLİR. (ÇEVRİMİÇİ DOĞRULANABİLDİĞİ TAKDİRDE FİZİKİ İBRAZI ARANMAZ)';
      case 14:
        return 'ÖZEL TEKNELERİN DONATIMI VE KULLANACAK KİŞİLERİN YETERLİKLERİ HAKKINDA YÖNETMELİĞİN MADDE 5\'E İSTİNADEN KONTROL İCRA EDİLİR.\n\nTAM BOYU 10 METREYE KADAR (DÂHİL) OLAN ÖZEL TEKNELER BÖLGE, MESAFE VE ZAMAN SINIRI OLMAKSIZIN EN AZ ADB 10 SAHİBİ BİR KİŞİNİN SEVK VE İDARESİNDE SEYREDER.\n\n18 YAŞINDAN KÜÇÜK ADB 10 SAHİBİ KİŞİLER, YANLARINDA BULUNAN EN AZ ADB 10 SAHİBİ BİR YETİŞKİNİN GÖZETİMİNDE TAM BOYU 10 METREYE KADAR (DÂHİL) OLAN ÖZEL TEKNELERİ SEVK VE İDARE EDEBİLİR.\n\nGÖVDE BOYU 24 METREYE KADAR (DÂHİL) OLAN ÖZEL TEKNELER BÖLGE, MESAFE VE ZAMAN SINIRI OLMAKSIZIN EN AZ ADB 24 VEYA USTA GEMİCİ VE ÜSTÜ YETERLİK BELGESİ SAHİBİ BİR KİŞİNİN SEVK VE İDARESİNDE SEYREDER.\n\nÖZEL YATLAR, TİCARİ YAT GİBİ DONATILIR.\n\nMAKİNE GÜCÜ ON BEYGİR GÜCÜNDEN DÜŞÜK ÖZEL TEKNELERİ, SADECE KÜREKLE YÜRÜTÜLEN MAKİNESİZ TEKNELERİ, KANOLAR/KAYAKLAR İLE ULUSAL VE ULUSLARARASI SPORTİF AMAÇLI KÜREK SPORU TEKNELERİ İLE OPTİMİST, LASER, FİN, 420, 470, PİRAT, DRAGON, WİND SURF GİBİ YELKEN SPORU TEKNELERİ VE BENZERİ YARIŞ SINIFI TEKNELERİ KULLANANLARDAN ADB İSTENMEZ.';
      case 15:
        return 'ÖZEL TEKNELERİN DONATIMI VE KULLANACAK KİŞİLERİN YETERLİKLERİ HAKKINDA YÖNETMELİĞİN MADDE 5/9\'A İSTİNADEN EK-2\'DE YER ALAN ÖZEL TEKNELERDE BULUNMASI ZORUNLU ASGARİ EMNİYET TEÇHİZETLARI KONTROLÜ İCRA EDİLİR.';
      case 16:
        return 'ÖZEL TEKNELERİN DONATIMI VE KULLANACAK KİŞİLERİN YETERLİKLERİ HAKKINDA YÖNETMELİĞİN MADDE 18/6\'A İSTİNADEN KONTROL İCRA EDİLİR. (NEFESTE APTANAN KAN ALKOL SEVİYESİ (BAC) %0,05 YA DA 0,25 MG/ML ORANINDAN AZ OLABİLİR)';
      case 17:
        return 'ÖZEL TEKNELERİN DONATIMI VE KULLANACAK KİŞİLERİN YETERLİKLERİ HAKKINDA YÖNETMELİĞİN MADDE 18/7\'E İSTİNADEN KONTROL İCRA EDİLİR.\n\nYETKİLİ İDARE TARAFINDAN BELİRLENEN HIZ SINIRLARININ ÜZERİNDE SEFERDEN VEYA YÜZME SAHALARINA CAN EMNİYETİNİ TEHLİKEYE DÜŞÜRECEK MESAFEDE YAKLAŞAN VEYA SEYİR, CAN, MAL VE ÇEVRE EMNİYETİNİ TEHLİKEYE ATACAK ŞEKİLDE KULLANIM KONTROLÜ YAPILIR.';
      case 18:
        return 'GEMİLERİN TEKNİK YÖNETMELİĞİNE GÖRE KARİNA TAHLİYE ÇIKIŞI BULUNAN, TAM BOYU 5 METRE VE ÜZERİNDEKİ VE KARASULARIMIZ DIŞINDA SEFER YAPMA İZNİ OLMAYAN SADECE SABİT PİS SU TANKI İLE DONATILAN GEMİ VE SU ARAÇLARINDA PİS SU SİSTEMLERİNİN KARİNA ÇIKIŞLARINDAN BOŞALTIM YAPILMAYACAK ŞEKİLDE DÜZENLEMELER YAPILIR.';
      case 19:
        return 'GEMİLERDEN ATIK ALINMASI VE ATIKLARIN KONTROLÜ YÖNETMELİĞİNE GÖRE KONTROL İCRA EDİLİR.';
      case 20:
        return 'LİMANLAR YÖNETMELİĞİN MADDE 25\'E İSTİNADEN KONTROL İCRA EDİLİR.\n\nLİMANLAR YÖNETMELİĞİ MADDE 22/20\'E İSTİNADEN HER TÜRLÜ GEMİ VE DENİZ ARAÇLARI AYNI BÖLGEDEKİ KALIŞ SÜRESİ EN FAZLA 15 GÜNDÜR.';
      case 21:
        return '6831 SAYILI ORMAN KANUNUN MADDE 14\'E İSTİNADEN KONTROL İCRA EDİLİR. (YAŞ AĞAÇLARI BOĞMAK, YARALAMAK)';
      default:
        return '';
    }
  }

  Widget lawItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget lawTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _getYasalIslem() {
    switch (index) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            lawTitle("YASAL İŞLEM"),
            lawItem("GEMİ SEFERDEN ALIKONULUR"),
            lawItem(
                "EN YAKIN LİMANA İNTİKALİ İÇİN GEMİ KAPTANINA TUTANAK İLE BİLDİRİM YAPILIR."),
            lawItem(
                "OLAYA İLİŞKİN TÜM BİLGİ VE BELGELER AYKIRILIĞIN GERÇEKLEŞTİĞİ YERDEN SORUMLU LİMAN BAŞKANLIĞINA GÖNDERİLİR."),
            lawItem(
                "BAŞKASINA AİT ÖZEL TEKNEYİ YETKİ YAZISI OLMADAN KULLANLARIN AMATÖR DENİZCİ BELGELERİ 6 AY SÜREYLE ASKIYA ALINMASI AMACIYLA TÜM BİLGİ VE BELGELER AYKIRILIĞIN GERÇEKLEŞTİĞİ YERİN SORUMLU LİMAN BAŞKANLIĞINA GÖNDERİLİR."),
          ],
        );
      case 1:
      case 2:
      case 3:
      case 4:
      case 9:
      case 11:
      case 13:
      case 14:
      case 15:
      case 20:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            lawTitle("YASAL İŞLEM"),
            lawItem("GEMİ SEFERDEN ALIKONULUR"),
            lawItem(
                "EN YAKIN LİMANA İNTİKALİ İÇİN GEMİ KAPTANINA TUTANAK İLE BİLDİRİM YAPILIR."),
            lawItem(
                "OLAYA İLİŞKİN TÜM BİLGİ VE BELGELER AYKIRILIĞIN GERÇEKLEŞTİĞİ YERDEN SORUMLU LİMAN BAŞKANLIĞINA GÖNDERİLİR."),
          ],
        );
      case 5:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            lawTitle("YASAL İŞLEM"),
            lawItem(
                "6458 SAYILI YABANCILAR VE ULUSLARARASI KORUMA KANUNU MADDE 102/1-A GÖRE TÜRKİYE'YE YASA DIŞI GİREN VEYA TÜRKİYE'Yİ YASA DIŞI TERK EDEN YA DA BUNA TEŞEBBÜS EDEN YABANCILAR HAKKINDA MÜLKİ AMİR TARAFINDAN İDARİ PARA CEZASI UYGULANIR."),
            lawItem(
                "TÜRKİYE CUMHURİYETİ SINIRINDAN HER NASILSA PASAPORTSUZ GİRMİŞ VATANDAŞLARA 5682 SAYILI PASAPORT KANUNU MADDE 34'E GÖRE MÜLKİ AMİR TARAFINDAN İDARİ PARA CEZASI UYGULANIR."),
          ],
        );
      case 6:
      case 7:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            lawTitle("YASAL İŞLEM"),
            lawItem(
                "HAZIRLANACARE TUTANAKLAR İŞLEM YAPILMAK ÜZERE EN YAKIN KIYI EMNİYETİ GENEL MÜDÜRLÜĞÜNE GÖNDERİLİR."),
          ],
        );
      case 8:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            lawTitle("YASAL İŞLEM"),
            lawItem("CUMHURİYET BAŞSAVCILIĞINA SEVK EDİLİR."),
            lawItem(
                "LİMAN BAŞKANLIĞINA BİLGİ VERİLİR. TEKNE YASAK SAHA SINIRLARININ DIŞINA ÇIKARTILIR."),
            lawItem(
                "ASKERİ VEYA ÖZEL GÜVENLİK BÖLGESİNİN BULUNDUĞU EN BÜYÜK MÜLKİ AMİR VE SORUMLU ASKERİ BİRLİĞE BİLGİ VERİLİR."),
          ],
        );
      case 10:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            lawTitle("YASAL İŞLEM"),
            lawItem("BAYRAĞA SEVK-ELKOYMA TUTANAĞI İLE EL KONULUR."),
            lawItem(
                "MAHALLİ MÜLKİ AMİR TARAFINDAN KABAHATLER KANUNU MD.32 UYARINCA İDARİ PARA CEZA VERİLİR."),
          ],
        );
      case 12:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            lawTitle("YASAL İŞLEM"),
            lawItem(
                "NOT: Ruhsatname vizesi 30/12/2023 yılında mülga edilmiştir."),
            lawItem("GEMİ SEFERDEN ALIKONULUR"),
            lawItem(
                "EN YAKIN LİMANA İNTİKALİ İÇİN GEMİ KAPTANINA TUTANAK İLE BİLDİRİM YAPILIR."),
            lawItem(
                "OLAYA İLİŞKİN TÜM BİLGİ VE BELGELER AYKIRILIĞIN GERÇEKLEŞTİĞİ YERDEN SORUMLU LİMAN BAŞKANLIĞINA GÖNDERİLİR."),
          ],
        );
      case 16:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            lawTitle("YASAL İŞLEM"),
            lawItem("GEMİ SEFERDEN ALIKONULUR"),
            lawItem(
                "EN YAKIN LİMANA İNTİKALİ İÇİN GEMİ KAPTANINA TUTANAK İLE BİLDİRİM YAPILIR."),
            lawItem(
                "OLAYA İLİŞKİN TÜM BİLGİ VE BELGELER AYKIRILIĞIN GERÇEKLEŞTİĞİ YERDEN SORUMLU LİMAN BAŞKANLIĞINA GÖNDERİLİR."),
            lawItem(
                "AMATÖR DENİZCİ BELGELERİ 6 AY SÜREYLE ASKIYA ALINMASI AMACIYLA TÜM BİLGİ VE BELGELER AYKIRILIĞIN GERÇEKLEŞTİĞİ YERİN SORUMLU LİMAN BAŞKANLIĞINA GÖNDERİLİR."),
            lawItem(
                "İCRA EDİLEN DEBETİMDE ALKOL ORANINI 0,100 PROMİLDEN FAZLA OLMASI HALİNDE YUKARIDA BELİRTİLEN İŞLERE EK TCK 179 MADDESİ TRAFİK GÜVENLİĞİNİ TEHLİKEYE SOKMAK SUÇU İLE İLGİLİ CUMHURİYET SAVCISI TALİMATI ALINACAKTIR."),
          ],
        );
      case 17:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            lawTitle("YASAL İŞLEM"),
            lawItem("GEMİ SEFERDEN ALIKONULUR"),
            lawItem(
                "EN YAKIN LİMANA İNTİKALİ İÇİN GEMİ KAPTANINA TUTANAK İLE BİLDİRİM YAPILIR."),
            lawItem(
                "OLAYA İLİŞKİN TÜM BİLGİ VE BELGELER AYKIRILIĞIN GERÇEKLEŞTİĞİ YERDEN SORUMLU LİMAN BAŞKANLIĞINA GÖNDERİLİR."),
            lawItem(
                "AMATÖR DENİZCİ BELGELERİ 6 AY SÜREYLE ASKIYA ALINMASI AMACIYLA TÜM BİLGİ VE BELGELER AYKIRILIĞIN GERÇEKLEŞTİĞİ YERİN SORUMLU LİMAN BAŞKANLIĞINA GÖNDERİLİR."),
          ],
        );
      case 18:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            lawTitle("YASAL İŞLEM"),
            lawItem(
                "EN YAKIN LİMANA İNTİKAL İÇİN GEMİ KAPTANINA TUTANAK İLE BİLDİRİM YAPILI"),
            lawItem(
                "OLAYA İLİŞKİN TÜM BİLGİ VE BELGELER İDARİ PARA CEZASI KESİLMEK VE NETİCESİNİN ALINMASI İÇİN AYKIRILIĞIN GERÇEKLEŞTİĞİ YERDEN SORUMLU YETKİLİ LİMAN BAŞKANLIĞINA GÖNDERİLİR."),
          ],
        );
      case 19:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            lawTitle("YASAL İŞLEM"),
            lawItem(
                "YETKİ DEVRİ YAPILMIŞ ALANLARDA 2872 SAYILI ÇEVRE KANUNU 20 MADDESİNE GÖRE İDARİ PARA CEZASI UYGULANIR, YAPILMAMIŞ ALANLARDA YETKİLİ KURUMA SEVK EDİLİR"),
          ],
        );
      case 21:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            lawTitle("YASAL İŞLEM"),
            lawItem(
                "OLAYA İLİŞKİN TÜM BİLGİ VE BELGELER İDARİ PARA CEZASI KESİLMEK VE NETİCESİNİN ALINMASI İÇİN İLGİLİ İL/İLÇE TARIM VE ORMAN MÜDÜRLÜĞÜNE GÖNDERİLİR."),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            lawTitle("YASAL İŞLEM"),
            lawItem("GEMİ SEFERDEN ALIKONULUR"),
            lawItem(
                "EN YAKIN LİMANA İNTİKALİ İÇİN GEMİ KAPTANINA TUTANAK İLE BİLDİRİM YAPILIR."),
            lawItem(
                "OLAYA İLİŞKİN TÜM BİLGİ VE BELGELER AYKIRILIĞIN GERÇEKLEŞTİĞİ YERDEN SORUMLU LİMAN BAŞKANLIĞINA GÖNDERİLİR."),
          ],
        );
    }
  }

  Widget _buildAciklama() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getAciklamaMetni(),
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Özel Tekne Detayları',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: color,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/701a.jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.info_outline,
                                color: color, size: 24),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Açıklama',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: _buildAciklama(),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Yasal İşlem',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: _getYasalIslem(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// DENİZ UÇAĞI KONTROL SAYFASI (YENİ) - 8 MADDE
// OzelTekneDetayPage sınıfından HEMEN SONRA ekleyin
// ============================================================================

class DenizUcagiKontrolPage extends StatelessWidget {
  final List<Map<String, dynamic>> kontrolMaddeleri = [
    {
      'title': 'GEMİ ADAMI KONTROLÜ',
      'icon': Icons.person,
      'color': Colors.indigo,
      'index': 0,
    },
    {
      'title': 'DENİZDE ÇATIŞMA ÖNLEME YÖNETMELİĞİNE UYGUN SEYİR KONTROLÜ',
      'icon': Icons.warning_amber,
      'color': Colors.orange,
      'index': 1,
    },
    {
      'title': 'DENİZCİLİK KURALLARINA UYULMASI KONTROLÜ',
      'icon': Icons.rule,
      'color': Colors.blue,
      'index': 2,
    },
    {
      'title': 'YURT DIŞINDAN GELİŞ/GİDİŞ KONTROLÜ',
      'icon': Icons.flight_takeoff,
      'color': Colors.purple,
      'index': 3,
    },
    {
      'title': 'SEYİR HUSUSLARI KONTROLÜ',
      'icon': Icons.navigation,
      'color': Colors.teal,
      'index': 4,
    },
    {
      'title': 'GÜVENLİK TEDBİRLERİ KONTROLÜ',
      'icon': Icons.security,
      'color': Colors.red,
      'index': 5,
    },
    {
      'title': 'UÇUŞ KURALLARI KONTROLÜ',
      'icon': Icons.flight,
      'color': Colors.cyan,
      'index': 6,
    },
    {
      'title': 'UÇUŞ İZİNLERİ KONTROLÜ',
      'icon': Icons.approval,
      'color': Colors.green,
      'index': 7,
    },
  ];

  DenizUcagiKontrolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Deniz Uçağı Kontrol Listesi',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(25).jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: kontrolMaddeleri.length,
          itemBuilder: (context, index) {
            final madde = kontrolMaddeleri[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.8),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: madde['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    madde['icon'],
                    color: madde['color'],
                    size: 22,
                  ),
                ),
                title: Text(
                  '${index + 1}. ${madde['title']}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DenizUcagiDetayPage(
                        title: madde['title'],
                        color: madde['color'],
                        index: madde['index'],
                      ),
                    ),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            );
          },
        ),
      ),
    );
  }
}
// ============================================================================
// DENİZ UÇAĞI DETAY SAYFASI (YENİ) - WORD'DEN ALINAN BİLGİLER İLE
// DenizUcagiKontrolPage sınıfından HEMEN SONRA ekleyin
// ============================================================================

class DenizUcagiDetayPage extends StatelessWidget {
  final String title;
  final Color color;
  final int index;

  const DenizUcagiDetayPage({
    super.key,
    required this.title,
    required this.color,
    required this.index,
  });

  String _getAciklamaMetni() {
    switch (index) {
      case 0:
        return 'DENİZ UÇAKLARI İLE HAVA TAŞIMA İŞLETMECİLİĞİ YÖNETMELİĞİN MADDE 7/1\'E İSTİNADEN KONTROL İCRA EDİLİR. (AMATÖR DENİZCİ BELGESİ OLMASI GEREKİR)';
      case 1:
        return 'DENİZ UÇAKLARI İLE HAVA TAŞIMA İŞLETMECİLİĞİ YÖNETMELİĞİN MADDE 7/2\'E İSTİNADEN KONTROL İCRA EDİLİR.';
      case 2:
        return 'DENİZ UÇAKLARI İLE HAVA TAŞIMA İŞLETMECİLİĞİ YÖNETMELİĞİN MADDE 8/1\'E İSTİNADEN KONTROL İCRA EDİLİR. (DENİZ UÇAĞI SUYA İNDİĞİ ANDAN İTİBAREN ULUSAL VE ULUSLARARASI DENİZCİLİK KURALLARINA TABİDİR.)';
      case 3:
        return 'DENİZ UÇAKLARI İLE HAVA TAŞIMA İŞLETMECİLİĞİ YÖNETMELİĞİN MADDE 9/1\'E İSTİNADEN KONTROL İCRA EDİLİR.\n\nTÜRKİYE-YURT DIŞI, YURT DIŞI-TÜRKİYE UÇUŞLARINDA HUDUT GİRİŞ/ÇIKIŞ İŞLEMLERİ BAKANLAR KURULUNCA TAYİN OLUNAN HUDUT KAPILARINDAN YAPILIR.';
      case 4:
        return 'DENİZ UÇAKLARI İLE HAVA TAŞIMA İŞLETMECİLİĞİ YÖNETMELİĞİN MADDE 10\'A İSTİNADEN KONTROL İCRA EDİLİR.\n\nHALKA AÇIK YÜZME ALANLARINDAN ASGARİ 500 M AÇIĞA İNEBİLİR.\n\nDENİZE İNİŞ BÖLGELERİ İLGİLİ KURUMLARLA KOORDİNE EDİLEREK BELİRLENİR.\n\nBELİRLENEN İNİŞ ALANLARI SEYİR HİDROGRAFİ VE OŞİNOGRAFİ DAİRESİ BAŞKANLIĞINCA YAYIMLANIR.\n\nİNİŞ VE KALKIŞ İÇİN BOĞAZLARDAKİ TRAFİK AYRIM DÜZENLERİ, DEMİR YERLERİ VE DENİZ TRAFİĞİNİN YOĞUN OLDUĞU DENİZ ALANLARI KULLANILMAZ.';
      case 5:
        return 'DENİZ UÇAKLARI İLE HAVA TAŞIMA İŞLETMECİLİĞİ YÖNETMELİĞİN MADDE 11\'E İSTİNADEN KONTROL İCRA EDİLİR.\n\nDENİZE İNİŞ YAPMADAN ÖNCE VHF KANAL 16\'DAN İLGİLİ LİMAN BAŞKANLIĞI VE SAHİL GÜVENLİK KOMUTANLIĞI BAĞLILARI İLE TEMAS KURULACAKTIR.\n\nDENİZ UÇAKLARI SU ÜZERİNDE AZAMİ 5 KNOT SÜRAT YAPABİLİR.';
      case 6:
        return 'DENİZ UÇAKLARI İLE HAVA TAŞIMA İŞLETMECİLİĞİ YÖNETMELİĞİN MADDE 12\'YE İSTİNADEN KONTROL İCRA EDİLİR.\n\nDENİZ UÇAĞINDA VHF DENİZ TELSİZ BANDINDA HABERLEŞME İMKÂNI SAĞLAYAN VHFDSC AYGITININ BULUNDURULMASI MECBURİDİR.\n\nDENİZ UÇAKLARINDA; SEYRÜSEFER YAPILAN BÖLGELERE AİT DENİZ HARİTALARI İLE ONAYLI CAN YELEĞİ, ELT CİHAZI VE GEREKLİ HABERLEŞME CİHAZLARI BULUNDURULUR. DENİZ UÇAĞI PİLOTU, SEYİR HİDROGRAFİ VE OŞİNOGRAFİ DAİRESİ BAŞKANLIĞINCA HAZIRLANAN VE İLAN EDİLEN DENİZCİLERE İLANLARI VE SEYİR DUYURULARINI KESİNTİSİZ TAKİP EDER.\n\nDENİZ VE İÇ SU ALANLARINDA AKINTI HIZININ SAATTE 5,5 KM\'Yİ GEÇTİĞİ YERLER İNİŞ KALKIŞ ALANI OLARAK KULLANILAMAZ.\n\nOTEL, TATİL KÖYÜ GİBİ YERLERİN ÖNLERİNE İNİŞ YAPILIRKEN, EMNİYET MANTARLARI İLE ÇEVRİLMİŞ ALANLARDAN YETERİ KADAR UZAĞA İNİLİR, TAKSİ HALİNDE İKEN DAHİ EMNİYET MANTARLARI İLE ÇEVRİLMİŞ YÜZME ALANLARI İHLAL EDİLEMEZ, OTELLERİN ÖNLERİNE YANAŞIRKEN MOTORLU DENİZ ARAÇLARI İÇİN MANTARLARLA İŞARETLENMİŞ KULVARLARDAN TAKSİ YAPILIR.\n\nDENİZ UÇAKLARI İLE HER TÜRLÜ ATIK, TEHLİKELİ MADDE VE KONUSU SUÇ TEŞKİL EDEN MADDENİN TAŞINMASI YASAKTIR.\n\nDENİZ UÇAĞI İNİŞ VE KALKIŞ MÜSAADESİ VERİLEN GÖL VE NEHİRLERE, İNİŞ VE KALKIŞLARDA FAALİYET HALİNDEKİ BALIKÇILAR İLE AV ARAÇLARINA 200 METRE MESAFE BIRAKILIR. KAFES YETİŞTİRİCİLİĞİ YAPILAN GÖL ALANLARINDA İNİŞ VE KALKIŞLARDA KAFESLERE 500 METRE MESAFE BIRAKILIR.';
      case 7:
        return 'DENİZ UÇAKLARI İLE HAVA TAŞIMA İŞLETMECİLİĞİ YÖNETMELİĞİN MADDE 13\'E İSTİNADEN KONTROL İCRA EDİLİR.\n\nİŞLETİCİ TARAFINDAN İNİŞ VE KALKIŞ YAPILACAK SAHANIN DENİZDEN EMNİYETİ VE GÜVENLİĞİ İÇİN UÇUŞ İZİNLERİ UÇUŞTAN YETERLİ SÜRE ÖNCE SAHİL GÜVENLİK KOMUTANLIĞI VE İLGİLİ DİĞER KURUMLARA BİLDİRİLİR.';
      default:
        return '';
    }
  }

  Widget lawItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget lawTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _getYasalIslem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        lawTitle("YASAL İŞLEM"),
        lawItem(
            "OLAYA İLİŞKİN TÜM BİLGİ VE BELGELER AYKIRILIĞIN GERÇEKLEŞTİĞİ YERDEN SORUMLU LİMAN BAŞKANLIĞINA GÖNDERİLİR."),
      ],
    );
  }

  Widget _buildAciklama() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getAciklamaMetni(),
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Deniz Uçağı Detayları',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: color,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/701a.jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.info_outline,
                                color: color, size: 24),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Açıklama',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: _buildAciklama(),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Yasal İşlem',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: _getYasalIslem(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// SU ÜRÜNLERİ AVCILIĞI KONTROL SAYFASI
class SuUrunleriAvciligiKontrolPage extends StatelessWidget {
  final List<Map<String, dynamic>> kontrolKategorileri = [
    {
      'title': 'Su Ürünleri Avcılığı Genel Kontrol Listesi',
      'icon': Icons.list_alt,
      'color': Colors.blue,
      'page': GenelKontrolPage(),
    },
    {
      'title': 'Trol Yöntemi Kontrol Listesi',
      'icon': Icons.waves,
      'color': Colors.blue,
      'page': TrolYontemiSecimPage(),
    },
    {
      'title': 'Gırgır Yöntemi Kontrol Listesi',
      'icon': Icons.grid_on,
      'color': Colors.orange,
      'page': GirgirYontemiKontrolPage(),
    },
    {
      'title': 'Algarna Yöntemi Kontrol Listesi',
      'icon': Icons.water_drop,
      'color': Colors.teal,
      'page': AlgarnaYontemiKontrolPage(),
    },
    {
      'title': 'Parakete Yöntemi Kontrol Listesi',
      'icon': Icons.filter_vintage,
      'color': Colors.purple,
      'page': ParaketeYontemiKontrolPage(),
    },
    {
      'title': 'Uzatma Ağları Kontrol Listesi',
      'icon': Icons.web,
      'color': Colors.green,
      'page': UzatmaAglariKontrolPage(),
    },
    {
      'title': 'Avlanma Kotası Kontrolü',
      'icon': Icons.format_list_numbered,
      'color': Colors.amber,
      'page': AvlanmaKotasiKontrolPage(),
    },
  ];

  SuUrunleriAvciligiKontrolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Su Ürünleri Avcılığı Kontrolleri',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.teal.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(14).jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          itemCount: kontrolKategorileri.length,
          itemBuilder: (context, index) {
            final kategori = kontrolKategorileri[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              color: Colors.white.withOpacity(0.7),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: kategori['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    kategori['icon'],
                    color: kategori['color'],
                    size: 20,
                  ),
                ),
                title: Text(
                  kategori['title'],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  if (kategori['page'] != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => kategori['page']),
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// GENEL KONTROL SAYFASI - 19 MADDELİ
class GenelKontrolPage extends StatelessWidget {
  final List<Map<String, dynamic>> kontrolMaddeleri = [
    {
      'title': 'Denize Elverişlilik Belgesi',
      'icon': Icons.verified,
      'color': Colors.blue,
      'hasSubItems': true,
    },
    {
      'title': 'Su Ürünleri Ruhsat Tezkereleri',
      'icon': Icons.description,
      'color': Colors.green,
      'hasSubItems': true,
    },
    {
      'title': 'Seyir Defteri',
      'icon': Icons.book,
      'color': Colors.orange,
      'hasSubItems': false,
    },
    {
      'title': 'Balıkçı Gemisi İzleme Sistemi (BAGİS) Cihazı',
      'icon': Icons.gps_fixed,
      'color': Colors.purple,
      'hasSubItems': false,
    },
    {
      'title':
          'Su Ürünlerinin Yurt Dışına Çıkarılması veya Canlı Olarak Yurt İçine Getirilmesi',
      'icon': Icons.import_export,
      'color': Colors.red,
      'hasSubItems': false,
    },
    {
      'title': 'Çevre Kontrolü',
      'icon': Icons.eco,
      'color': Colors.green,
      'hasSubItems': true,
    },
    {
      'title': 'Tonilato',
      'icon': Icons.scale,
      'color': Colors.brown,
      'hasSubItems': true,
    },
    {
      'title': 'Gemi Adamı',
      'icon': Icons.person,
      'color': Colors.indigo,
      'hasSubItems': true,
    },
    {
      'title': 'AİS Cihazı',
      'icon': Icons.settings_input_antenna,
      'color': Colors.teal,
      'hasSubItems': false,
    },
    {
      'title': 'Bağlama Kütüğü Ruhsatnamesi (Varsa)',
      'icon': Icons.folder_special,
      'color': Colors.amber,
      'hasSubItems': true,
    },
    {
      'title': 'Gemi Tasdiknamesi (Varsa)',
      'icon': Icons.verified_user,
      'color': Colors.cyan,
      'hasSubItems': true,
    },
    {
      'title': 'Bayrak Kontrolü',
      'icon': Icons.flag,
      'color': Colors.red,
      'hasSubItems': true,
    },
    {
      'title': 'D.Ç.Ö.Y Kontrolü',
      'icon': Icons.emergency,
      'color': Colors.deepOrange,
      'hasSubItems': false,
    },
    {
      'title': 'Yakıt Kontrolü (ÖTV\'siz Yakıt Alınıyorsa)',
      'icon': Icons.local_gas_station,
      'color': Colors.blue,
      'hasSubItems': true,
    },
    {
      'title': 'Telsiz Ruhsatnamesi',
      'icon': Icons.radio,
      'color': Colors.purple,
      'hasSubItems': false,
    },
    {
      'title': 'Fribord Belgesi (Yükleme Sınırı)',
      'icon': Icons.horizontal_rule,
      'color': Colors.blueGrey,
      'hasSubItems': false,
    },
    {
      'title': 'VHF Telsiz Kontrolü',
      'icon': Icons.settings_remote,
      'color': Colors.deepPurple,
      'hasSubItems': false,
    },
    {
      'title': 'Avlanma İzin Belgesi Kontrolü',
      'icon': Icons.assignment,
      'color': Colors.red,
      'hasSubItems': false,
    },
    {
      'title': 'Balıkçı Teknesi Ruhsatı',
      'icon': Icons.sailing,
      'color': Colors.indigo,
      'hasSubItems': false,
    },
  ];

  GenelKontrolPage({super.key});

  void _handleItemTap(
      BuildContext context, Map<String, dynamic> madde, int index) {
    if (madde['hasSubItems']) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenelKontrolAltMaddePage(
            title: madde['title'],
            color: madde['color'],
            mainIndex: index,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GenelKontrolDetayPage(
            title: madde['title'],
            color: madde['color'],
            altMadde: null,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Su Ürünleri Avcılığı Genel Kontrol Listesi',
          style: TextStyle(fontSize: 14),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(40).jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: kontrolMaddeleri.length,
          itemBuilder: (context, index) {
            final madde = kontrolMaddeleri[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.85),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: madde['color'].withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    madde['icon'],
                    color: madde['color'],
                    size: 24,
                  ),
                ),
                title: Text(
                  '${index + 1}. ${madde['title']}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: madde['color'],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.arrow_forward_ios,
                    size: 18, color: madde['color']),
                onTap: () => _handleItemTap(context, madde, index),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ALT MADDE SAYFASI
class GenelKontrolAltMaddePage extends StatelessWidget {
  final String title;
  final Color color;
  final int mainIndex;

  const GenelKontrolAltMaddePage({
    super.key,
    required this.title,
    required this.color,
    required this.mainIndex,
  });

  List<String> _getAltMaddeler() {
    switch (mainIndex) {
      case 0:
        return [
          'SÜRE KONTROLÜ',
          'YOLCU TAŞIMASI/FAZLASI',
          'CAN KURTARMA TEÇHİZATI VE YANGIN SÖNDÜRME',
          'SEFER BÖLGESİ',
          'LİMAN ÇIKIŞ BELGESİ KONTROLÜ',
          'BELGE KONTROLÜ',
        ];
      case 1:
        return [
          'RUHSAT TEZKERELERİNİN OLMAMASI',
          'SU ÜRÜNLERİ RUHSAT TEZKERELERİNİN YENİLENMESİ, SÜRESİ, RUHSAT KOD NUMARASININ GEMİYE YAZILIŞI VE İPTALİ',
          'RUHSAT TEZKERESİNİN VEYA İZİNLERİN YETKİLİLERCE TALEP EDİLMESİ HALİNDE GÖSTERİLMEMESİ',
        ];
      case 5:
        return [
          'PİS SU TANKI KONTROLÜ',
          'ATIK TRANSFER FORMU',
        ];
      case 6:
        return [
          'TONİLATA BELGESİ',
        ];
      case 7:
        return [
          'GEMİ ADAMI SAYISI VE YETERLİLİKLERİ',
          'GEMİ ADAMLARI STCW VE SERTİFİKA KONTROLÜ',
          'STAJER ÇALIŞTIRILMASI',
          'TELSİZ OPERATÖRÜ EHLİYETİ',
          'BELGE KONTROLÜ',
          'GEMİ SAĞLIK CÜZDANI',
        ];
      case 9:
        return [
          'BELGE KONTROLÜ',
          'TÜRK BAYRAĞI ÇEKMESİ',
        ];
      case 10:
        return [
          'GEMİ İSMİ VE BAĞLAMA LİMANI YAZILMASI',
          'BAYRAK ÇEKMEMEK',
        ];
      case 11:
        return [
          'BAYRAĞA GEREKEN ÖZENİ GÖSTERMEMEK',
        ];
      case 13:
        return [
          'GEMİ HAREKET KAYIT JURNALİ/ GEMİ JURNALİ VE YAKIT ALIM DEFTERİNİN İBRAZ EDİLMEMESİ',
          'ALINAN YAKITLARIN YAKIT ALIM DEFTERİNE, GEMİ JURNALİ VEYA GEMİ HAREKAT KAYIT JURNALİNE DOĞRU OLARAK İŞLENMESİ',
          'TEKNE TAKİP MODÜLÜNÜN FAAL VE ÇALIŞIR VAZİYETTE OLUP OLMADIĞI',
          'ALINAN ÖTV\'SİZ YAKITIN GEMİDE MEVCUT OLUP OLMADIĞININ TESPİTİ',
          'ÖTV\'SİZ YAKITIN KARARNAME KAPSAMINA AYKIRI OLARAK KABOTAJ HATTI DIŞINDA KULLANIMININ TESPİTİ',
          'TADİLAT YAPILAN DENİZ ARAÇLARININ YAKIT TANKLARINDA VE MAKİNELERİNDE DEĞİŞİKLİK YAPILDIĞININ BİLDİRİLMEMESİNİN TESPİTİ',
          'DENİZ ARACI İÇİN TAHSİS EDİLEN VE YAKIT ALIM DEFTERİNDE BELİRTİLEN BİR DEFADA YA DA YILLIK OLARAK ALINABİLECEK AZAMİ DENİZ YAKITI MİKTARININ AŞILMASININ TESPİTİ',
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final altMaddeler = _getAltMaddeler();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 14),
        ),
        backgroundColor: color,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/701a.jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: altMaddeler.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.85),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: color,
                    size: 22,
                  ),
                ),
                title: Text(
                  '${index + 1}. ${altMaddeler[index]}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GenelKontrolDetayPage(
                        title: title,
                        color: color,
                        altMadde: altMaddeler[index],
                      ),
                    ),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            );
          },
        ),
      ),
    );
  }
}

// DETAY SAYFASI (AÇIKLAMA VE YASAL İŞLEM)
class GenelKontrolDetayPage extends StatelessWidget {
  final String title;
  final Color color;
  final String? altMadde;

  const GenelKontrolDetayPage({
    super.key,
    required this.title,
    required this.color,
    this.altMadde,
  });

  Widget _buildLinkWidget(String url, String text) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (!await launchUrl(uri)) {
          throw Exception('Could not launch $url');
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildAciklama() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'İlgili mevzuat maddelerine istinaden kontrol icra edilir.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 16),
        _buildLinkWidget(
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=4988&MevzuatTur=7&MevzuatTertip=5',
          'Su Ürünleri Yönetmeliği',
        ),
        SizedBox(height: 8),
        _buildLinkWidget(
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=40948&MevzuatTur=9&MevzuatTertip=5',
          '6/1 NUMARALI TİCARİ AMAÇLI SU ÜRÜNLERİ AVCILIĞININ DÜZENLENMESİ HAKKINDA TEBLİĞ',
        ),
      ],
    );
  }

  Widget lawItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget lawTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _getYasalIslem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        lawTitle("YASAL İŞLEM"),
        lawItem(
            "Aykırı hareket edenlere ve kullanılan gemiler için sahip veya donatanlarına idarî para cezası uygulanır."),
        lawItem(
            "İstihsal olunan su ürünlerine el konularak mülkiyetin kamuya geçirilmesine karar verilir."),
        lawItem(
            "Kabahatin işlenmesinde kullanılan gemiler ile ruhsat tezkereleri ilk defada 1 ay, ikinci defada 3 ay süre ile geri alınır; tekrarı halinde iptal edilir."),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle = altMadde ?? title;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detaylar',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: color,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/701a.jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.info_outline,
                                color: color, size: 24),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              displayTitle,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Açıklama',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: _buildAciklama(),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Yasal İşlem',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: _getYasalIslem(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// TROL YÖNTEMİ SEÇİM SAYFASI
class TrolYontemiSecimPage extends StatelessWidget {
  const TrolYontemiSecimPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trol Yöntemi Kontrol Listesi',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/1.JPEG'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.8),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child:
                      Icon(Icons.arrow_downward, color: Colors.blue, size: 24),
                ),
                title: Text(
                  'Dip Trolü',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                subtitle: Text(
                  'Dip trolü kontrol maddelerini görüntüle',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DipTroluKontrolPage(),
                    ),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.8),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.waves, color: Colors.teal, size: 24),
                ),
                title: Text(
                  'Orta Su Trolü',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade900,
                  ),
                ),
                subtitle: Text(
                  'Orta su trolü kontrol maddelerini görüntüle',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrtaSuTroluKontrolPage(),
                    ),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// DİP TROLÜ KONTROL SAYFASI
class DipTroluKontrolPage extends StatelessWidget {
  final List<Map<String, dynamic>> kontrolMaddeleri = [
    {
      'title': 'HER TÜRLÜ TROL YASAĞI',
      'icon': Icons.block,
      'color': Colors.red,
    },
    {
      'title': 'DİP TROLÜNE BÖLGE VE ZAMAN BAKIMINDAN KONULAN YASAKLAR',
      'icon': Icons.location_off,
      'color': Colors.orange,
    },
    {
      'title': 'DİP TROLÜNE VASIFLAR BAKIMINDAN KONULAN YASAKLAR',
      'icon': Icons.settings,
      'color': Colors.purple,
    },
    {
      'title': 'TÜR KONTROLÜ',
      'icon': Icons.category,
      'color': Colors.blue,
    },
    {
      'title': 'BOY VE AĞIRLIK YASAKLARI',
      'icon': Icons.straighten,
      'color': Colors.green,
    },
  ];

  DipTroluKontrolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dip Trolü Kontrol Listesi',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/5.JPEG'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: kontrolMaddeleri.length,
          itemBuilder: (context, index) {
            final madde = kontrolMaddeleri[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.8),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: madde['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    madde['icon'],
                    color: madde['color'],
                    size: 22,
                  ),
                ),
                title: Text(
                  '${index + 1}. ${madde['title']}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DipTroluDetayPage(
                        title: madde['title'],
                        color: madde['color'],
                      ),
                    ),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ORTA SU TROLÜ KONTROL SAYFASI
class OrtaSuTroluKontrolPage extends StatelessWidget {
  final List<Map<String, dynamic>> kontrolMaddeleri = [
    {
      'title': 'BÖLGE VE YER YASAKLARI',
      'icon': Icons.location_off,
      'color': Colors.red,
    },
    {
      'title':
          'ORTASU TROLÜNÜN ÇİFT GEMİ İLE ÇEKİLME ŞARTI / AVLANMA İZİN BELGESİ',
      'icon': Icons.directions_boat,
      'color': Colors.blue,
    },
    {
      'title': 'ORTASU TROLÜNE İLİŞKİN VASIFLAR BAKIMINDAN KONULAN YASAKLAR',
      'icon': Icons.settings,
      'color': Colors.orange,
    },
  ];

  OrtaSuTroluKontrolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orta Su Trolü Kontrol Listesi',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.teal.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/3.JPEG'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: kontrolMaddeleri.length,
          itemBuilder: (context, index) {
            final madde = kontrolMaddeleri[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.8),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: madde['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    madde['icon'],
                    color: madde['color'],
                    size: 22,
                  ),
                ),
                title: Text(
                  '${index + 1}. ${madde['title']}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrtaSuTroluDetayPage(
                        title: madde['title'],
                        color: madde['color'],
                      ),
                    ),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            );
          },
        ),
      ),
    );
  }
}

// DİP TROLÜ DETAY SAYFASI
class DipTroluDetayPage extends StatelessWidget {
  final String title;
  final Color color;

  const DipTroluDetayPage({
    super.key,
    required this.title,
    required this.color,
  });

  Widget _buildLinkWidget(String url, String text) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (!await launchUrl(uri)) {
          throw Exception('Could not launch $url');
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildAciklama() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TİCARİ AMAÇLI SU ÜRÜNLERİ AVCILIĞININ DÜZENLENMESİ HAKKINDA TEBLİĞ MADDE 9\'A İSTİNADEN KONTROL İCRA EDİLİR.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 16),
        _buildLinkWidget(
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=4988&MevzuatTur=7&MevzuatTertip=5',
          'Su Ürünleri Yönetmeliği',
        ),
        SizedBox(height: 8),
        _buildLinkWidget(
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=40948&MevzuatTur=9&MevzuatTertip=5',
          '6/1 NUMARALI TİCARİ AMAÇLI SU ÜRÜNLERİ AVCILIĞININ DÜZENLENMESİ HAKKINDA TEBLİĞ',
        ),
      ],
    );
  }

  Widget lawItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget lawTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _getYasalIslem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        lawTitle("YASAL İŞLEM"),
        lawItem(
            "24 Üncü maddeye göre aykırı hareket edenlere ve kullanılan gemiler için sahip veya donatanlarına idarî para cezası uygulanır."),
        lawItem(
            "İstihsal olunan su ürünlerine el konularak mülkiyetin kamuya geçirilmesine karar verilir."),
        lawItem(
            "Kabahatin işlenmesinde kullanılan gemiler ile ruhsat tezkereleri ilk defada 1 ay, ikinci defada 3 ay süre ile geri alınır; tekrarı halinde iptal edilir."),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dip Trolü Detayları',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: color,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/701a.jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.info_outline,
                                color: color, size: 24),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Açıklama',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: _buildAciklama(),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Yasal İşlem',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: _getYasalIslem(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ORTA SU TROLÜ DETAY SAYFASI
class OrtaSuTroluDetayPage extends StatelessWidget {
  final String title;
  final Color color;

  const OrtaSuTroluDetayPage({
    super.key,
    required this.title,
    required this.color,
  });

  Widget _buildLinkWidget(String url, String text) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (!await launchUrl(uri)) {
          throw Exception('Could not launch $url');
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildAciklama() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TİCARİ AMAÇLI SU ÜRÜNLERİ AVCILIĞININ DÜZENLENMESİ HAKKINDA TEBLİĞ MADDE 11\'E İSTİNADEN KONTROL İCRA EDİLİR.',
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 16),
        _buildLinkWidget(
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=4988&MevzuatTur=7&MevzuatTertip=5',
          'Su Ürünleri Yönetmeliği',
        ),
        SizedBox(height: 8),
        _buildLinkWidget(
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=40948&MevzuatTur=9&MevzuatTertip=5',
          '6/1 NUMARALI TİCARİ AMAÇLI SU ÜRÜNLERİ AVCILIĞININ DÜZENLENMESİ HAKKINDA TEBLİĞ',
        ),
      ],
    );
  }

  Widget lawItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget lawTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _getYasalIslem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        lawTitle("YASAL İŞLEM"),
        lawItem(
            "23 üncü maddenin birinci fıkrasının (B) bendine göre aykırı hareket edenlere ve kullanılan gemiler için sahip veya donatanlarına idarî para cezası uygulanır."),
        lawItem(
            "İstihsal olunan su ürünlerine el konularak mülkiyetin kamuya geçirilmesine karar verilir."),
        lawItem(
            "Kabahatin işlenmesinde kullanılan gemiler ile ruhsat tezkereleri; ilk defada bir ay, ikinci defada üç ay süre ile geri alınır, tekrarı halinde iptal edilir."),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orta Su Trolü Detayları',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: color,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/FOTO.JPEG'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.info_outline,
                                color: color, size: 24),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Açıklama',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: _buildAciklama(),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Yasal İşlem',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: _getYasalIslem(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ALGARNA YÖNTEMİ KONTROL SAYFASI - GÜNCELLENMİŞ
class AlgarnaYontemiKontrolPage extends StatelessWidget {
  final List<Map<String, dynamic>> kontrolMaddeleri = [
    {
      'title': 'BÖLGE YASAKLARI',
      'icon': Icons.location_off,
      'color': Colors.red,
    },
    {
      'title': 'KARİDES AVCILIĞINDA BÖLGE VE YER YASAKLARI',
      'icon': Icons.water,
      'color': Colors.orange,
    },
    {
      'title': 'KARİDES AVCILIĞINDA ALGARNA İLE İLGİLİ VASIFLAR',
      'icon': Icons.settings,
      'color': Colors.purple,
    },
    {
      'title':
          'ÇİFT KABUKLU YUMUŞAKÇA (BEYAZ KUM MİDYESİ, CARDIUM SP., AKİVADES, KİDONYA, TARAK, İSTİRİDYE, KARA-KILLI MİDYE VE KUM ŞİRLANI) AVCILIĞINA İLİŞKİN VASIFLAR',
      'icon': Icons.eco,
      'color': Colors.blue,
    },
    {
      'title':
          'ÇİFT KABUKLU YUMUŞAKÇALARIN AVCILIĞINDA BÖLGE, YER VE ZAMAN YASAKLARI',
      'icon': Icons.schedule,
      'color': Colors.green,
    },
    {
      'title': 'DENİZ SALYANGOZU AVCILIĞINDA BÖLGE, YER VE ZAMAN YASAKLARI',
      'icon': Icons.block,
      'color': Colors.pink,
    },
    {
      'title': 'DENİZ SALYANGOZU AVCILIĞINDA ALGARNAYA ILİŞKİN VASIFLAR',
      'icon': Icons.tune,
      'color': Colors.brown,
    },
    {
      'title': 'ALGARNA GEMİLERİNE İLİŞKİN YASAKLAR',
      'icon': Icons.directions_boat,
      'color': Colors.indigo,
    },
    {
      'title':
          'ALGARNA GEMİLERİNDE BAGİS CİHAZI BULUNDURMA ZORUNLULUĞU (01 EYLÜL 2026 TARİHİNDEN İTİBAREN)',
      'icon': Icons.gps_fixed,
      'color': Colors.teal,
    },
    {
      'title': 'TÜR KONTROLÜ',
      'icon': Icons.category,
      'color': Colors.amber,
      'hasSubItem': true,
    },
  ];

  AlgarnaYontemiKontrolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Algarna Yöntemi Kontrol Listesi',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.teal.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(28).jpeg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: kontrolMaddeleri.length,
          itemBuilder: (context, index) {
            final madde = kontrolMaddeleri[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.8),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: madde['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    madde['icon'],
                    color: madde['color'],
                    size: 22,
                  ),
                ),
                title: Text(
                  '${index + 1}. ${madde['title']}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  if (madde['hasSubItem'] == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlgarnaAltMaddePage(
                          title: madde['title'],
                          color: madde['color'],
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AlgarnaDetayPage(
                          title: madde['title'],
                          color: madde['color'],
                          index: index,
                        ),
                      ),
                    );
                  }
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ALGARNA ALT MADDE SAYFASI (TÜR KONTROLÜ İÇİN)
class AlgarnaAltMaddePage extends StatelessWidget {
  final String title;
  final Color color;

  const AlgarnaAltMaddePage({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 14),
        ),
        backgroundColor: color,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/701a.jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.85),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.dangerous,
                    color: Colors.red,
                    size: 22,
                  ),
                ),
                title: Text(
                  'AVLANMASI YASAK TÜRLERİN AVLANMASI',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AlgarnaDetayPage(
                        title: 'AVLANMASI YASAK TÜRLERİN AVLANMASI',
                        color: Colors.red,
                        index: 10, // Özel index
                      ),
                    ),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ALGARNA DETAY SAYFASI
class AlgarnaDetayPage extends StatelessWidget {
  final String title;
  final Color color;
  final int index;

  const AlgarnaDetayPage({
    super.key,
    required this.title,
    required this.color,
    required this.index,
  });

  Widget _buildLinkWidget(String url, String text) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (!await launchUrl(uri)) {
          throw Exception('Could not launch $url');
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontSize: 14,
        ),
      ),
    );
  }

  String _getAciklamaMetni() {
    switch (index) {
      case 0: // BÖLGE YASAKLARI
        return 'Denizlerde karides avcılığı, çift kabuklu yumuşakça avcılığı ve deniz salyangozu avcılığı yapılırken algarna kullanımı için belirlenmiş bölge yasakları kontrol edilir.';

      case 1: // KARİDES AVCILIĞINDA BÖLGE VE YER YASAKLARI
        return 'Karides avcılığı yapılan bölgelerde algarna kullanımına ilişkin özel yasak bölgeler ve mesafe sınırlamaları kontrol edilir. Milli park ve özel koruma alanlarında yasak vardır.';

      case 2: // KARİDES AVCILIĞINDA ALGARNA İLE İLGİLİ VASIFLAR
        return 'Karides avcılığında kullanılan algarnaların teknik özellikleri, ağız genişliği, torba göz açıklığı ve diğer vasıfları kontrol edilir.';

      case 3: // ÇİFT KABUKLU YUMUŞAKÇA AVCILIĞINA İLİŞKİN VASIFLAR
        return 'Beyaz kum midyesi, Cardium sp., akivades, kidonya, tarak, istiridye, kara-kıllı midye ve kum şirlanı avcılığında kullanılan algarnaların teknik özellikleri kontrol edilir.';

      case 4: // ÇİFT KABUKLU YUMUŞAKÇALARIN AVCILIĞINDA BÖLGE, YER VE ZAMAN YASAKLARI
        return 'Çift kabuklu yumuşakça avcılığında bölge, yer ve zaman yasakları ile üreme dönemleri kontrol edilir.';

      case 5: // DENİZ SALYANGOZU AVCILIĞINDA BÖLGE, YER VE ZAMAN YASAKLARI
        return 'Deniz salyangozu avcılığında bölge, yer ve zaman yasakları kontrol edilir. Milli park ve özel koruma alanlarında yasak vardır.';

      case 6: // DENİZ SALYANGOZU AVCILIĞINDA ALGARNAYA ILİŞKİN VASIFLAR
        return 'Deniz salyangozu avcılığında kullanılan algarnaların teknik özellikleri, ağız genişliği ve diğer vasıfları kontrol edilir.';

      case 7: // ALGARNA GEMİLERİNE İLİŞKİN YASAKLAR
        return 'Algarna gemilerinin boy, tonaj ve motor gücü sınırlamaları kontrol edilir. Ruhsatsız algarna kullanımı yasaktır.';

      case 8: // BAGİS CİHAZI BULUNDURMA ZORUNLULUĞU
        return '01 Eylül 2026 tarihinden itibaren tüm algarna gemilerinde BAGİS (Balıkçı Gemisi İzleme Sistemi) cihazı bulundurma zorunluluğu kontrol edilir.';

      case 9: // TÜR KONTROLÜ
        return 'Avlanan türlerin mevzuata uygun olup olmadığı, yasak türlerin bulunup bulunmadığı kontrol edilir.';

      case 10: // AVLANMASI YASAK TÜRLERİN AVLANMASI
        return 'Mevzuatta belirtilen avlanması yasak türlerin gemide bulunup bulunmadığı kontrol edilir.';

      default:
        return 'TİCARİ AMAÇLI SU ÜRÜNLERİ AVCILIĞININ DÜZENLENMESİ HAKKINDA TEBLİĞ MADDE 15\'E İSTİNADEN KONTROL İCRA EDİLİR.';
    }
  }

  Widget _buildAciklama() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getAciklamaMetni(),
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 16),
        _buildLinkWidget(
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=4988&MevzuatTur=7&MevzuatTertip=5',
          'Su Ürünleri Yönetmeliği',
        ),
        SizedBox(height: 8),
        _buildLinkWidget(
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=40948&MevzuatTur=9&MevzuatTertip=5',
          '6/1 NUMARALI TİCARİ AMAÇLI SU ÜRÜNLERİ AVCILIĞININ DÜZENLENMESİ HAKKINDA TEBLİĞ',
        ),
      ],
    );
  }

  Widget lawItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget lawTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _getYasalIslem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        lawTitle("YASAL İŞLEM"),
        lawItem(
            "Aykırı hareket edenlere ve kullanılan gemiler için sahip veya donatanlarına idarî para cezası uygulanır."),
        lawItem(
            "İstihsal olunan su ürünlerine el konularak mülkiyetin kamuya geçirilmesine karar verilir."),
        lawItem(
            "Kabahatin işlenmesinde kullanılan gemiler ile ruhsat tezkereleri ilk defada 1 ay, ikinci defada 3 ay süre ile geri alınır; tekrarı halinde iptal edilir."),
        lawItem(
            "Avlanması yasak türlerin avlanması durumunda ağır yaptırımlar uygulanır ve ruhsat iptali söz konusu olabilir."),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Algarna Detayları',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: color,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/701a.jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.info_outline,
                                color: color, size: 24),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Açıklama',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: _buildAciklama(),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Yasal İşlem',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: _getYasalIslem(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// GIRGIR YÖNTEMİ KONTROL SAYFASI - GÜNCELLENMİŞ
class GirgirYontemiKontrolPage extends StatelessWidget {
  final List<Map<String, dynamic>> kontrolMaddeleri = [
    {
      'title': 'GIRGIR AĞI ÖLÇÜM BELGESİ',
      'icon': Icons.straighten,
      'color': Colors.blue,
    },
    {
      'title': 'BÖLGE VE ZAMAN BAKIMINDAN KONULAN YASAKLAR',
      'icon': Icons.location_off,
      'color': Colors.red,
    },
    {
      'title': 'ÇEVİRME AĞLARINA İLİŞKİN YASAKLAR',
      'icon': Icons.web,
      'color': Colors.purple,
    },
    {
      'title': 'IŞIKLA SU ÜRÜNLERİ AVCILIĞINA İLİŞKİN YASAKLARI',
      'icon': Icons.lightbulb,
      'color': Colors.amber,
    },
    {
      'title':
          'IŞIKLA SU ÜRÜNLERİ AVCILIĞINA İLİŞKİN BÖLGE, YER VE ZAMAN YASAKLARI',
      'icon': Icons.schedule,
      'color': Colors.orange,
    },
    {
      'title': 'IŞIKLA AVCILIK İZİN BELGESİ',
      'icon': Icons.description,
      'color': Colors.green,
    },
    {
      'title': 'SONARIN SU ÜRÜNLERİ AVCILIĞINDA KULLANILMASI',
      'icon': Icons.radar,
      'color': Colors.indigo,
    },
    {
      'title': 'GIRGIR GEMİLERİNE İLİŞKİN YASAKLAR',
      'icon': Icons.directions_boat,
      'color': Colors.teal,
    },
    {
      'title': 'TÜR KONTROLÜ',
      'icon': Icons.category,
      'color': Colors.pink,
      'hasSubItem': true,
    },
    {
      'title': 'BOY VE AĞIRLIK YASAKLARI',
      'icon': Icons.fitness_center,
      'color': Colors.brown,
    },
  ];

  GirgirYontemiKontrolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gırgır Yöntemi Kontrol Listesi',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.orange.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(27).jpeg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: kontrolMaddeleri.length,
          itemBuilder: (context, index) {
            final madde = kontrolMaddeleri[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.8),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: madde['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    madde['icon'],
                    color: madde['color'],
                    size: 22,
                  ),
                ),
                title: Text(
                  '${index + 1}. ${madde['title']}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  if (madde['hasSubItem'] == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GirgirAltMaddePage(
                          title: madde['title'],
                          color: madde['color'],
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GirgirDetayPage(
                          title: madde['title'],
                          color: madde['color'],
                          index: index,
                        ),
                      ),
                    );
                  }
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            );
          },
        ),
      ),
    );
  }
}

// GIRGIR ALT MADDE SAYFASI (TÜR KONTROLÜ İÇİN)
class GirgirAltMaddePage extends StatelessWidget {
  final String title;
  final Color color;

  const GirgirAltMaddePage({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 14),
        ),
        backgroundColor: color,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/701a.jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.85),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.dangerous,
                    color: Colors.red,
                    size: 22,
                  ),
                ),
                title: Text(
                  'AVLANMASI YASAK TÜRLERİN AVCILIĞI',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GirgirDetayPage(
                        title: 'AVLANMASI YASAK TÜRLERİN AVCILIĞI',
                        color: Colors.red,
                        index: 100, // Özel index
                      ),
                    ),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// GIRGIR DETAY SAYFASI
class GirgirDetayPage extends StatelessWidget {
  final String title;
  final Color color;
  final int index;

  const GirgirDetayPage({
    super.key,
    required this.title,
    required this.color,
    required this.index,
  });

  Widget _buildLinkWidget(String url, String text) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (!await launchUrl(uri)) {
          throw Exception('Could not launch $url');
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontSize: 14,
        ),
      ),
    );
  }

  String _getAciklamaMetni() {
    switch (index) {
      case 0: // GIRGIR AĞI ÖLÇÜM BELGESİ
        return 'Gırgır ağlarının teknik özelliklerinin (göz açıklığı, ağ uzunluğu vb.) ölçüm belgesi ile uygunluğu kontrol edilir. Ölçüm belgesi güncel olmalı ve gemide bulundurulmalıdır.';

      case 1: // BÖLGE VE ZAMAN BAKIMINDAN KONULAN YASAKLAR
        return 'Gırgır yöntemiyle avlanmanın yasak olduğu bölgeler, zamanlar ve mevsimler kontrol edilir. Yasaklı bölgelerde veya zamanlarda avlanma tespit edilirse işlem yapılır.';

      case 2: // ÇEVİRME AĞLARINA İLİŞKİN YASAKLAR
        return 'Çevirme ağlarının (voli) kullanımına ilişkin yasaklar kontrol edilir. Yasaklı bölgelerde veya uygunsuz özelliklere sahip çevirme ağı kullanımı tespit edilirse işlem yapılır.';

      case 3: // IŞIKLA SU ÜRÜNLERİ AVCILIĞINA İLİŞKİN YASAKLARI
        return 'İçsular, Karadeniz, Marmara Denizi, İstanbul ve Çanakkale Boğazlarında gemilerdeki faaliyetlerin yürütülmesinde gerekli olan aydınlatma hariç, ağlarla avlanma amaçlı ışık kullanımı veya bu amaca uygun ışık donanımı bulundurulması yasaktır.';

      case 4: // IŞIKLA SU ÜRÜNLERİ AVCILIĞINA İLİŞKİN BÖLGE, YER VE ZAMAN YASAKLARI
        return 'Işıkla avlanmaya ilişkin bölge, yer ve zaman yasakları kontrol edilir. Yasak bölgelerde veya zamanlarda ışık kullanılarak avlanma yapılması tespit edilirse ağır yaptırımlar uygulanır.';

      case 5: // IŞIKLA AVCILIK İZİN BELGESİ
        return 'Işıkla avlanmaya izin verilmiş bölgelerde faaliyet gösteren gemilerin ışıkla avcılık izin belgesi bulundurması zorunludur. İzin belgesi güncel olmalı ve gemide bulundurulmalıdır.';

      case 6: // SONARIN SU ÜRÜNLERİ AVCILIĞINDA KULLANILMASI
        return 'Sonar cihazlarının su ürünleri avcılığında kullanımına ilişkin düzenlemeler kontrol edilir. İzinsiz veya yasak bölgelerde sonar kullanımı tespit edilirse işlem yapılır.';

      case 7: // GIRGIR GEMİLERİNE İLİŞKİN YASAKLAR
        return 'Gırgır gemilerinin boy, tonaj ve motor gücü sınırlamaları ile teknik özelliklerine ilişkin yasaklar kontrol edilir. Ruhsatsız veya uygunsuz özelliklere sahip gırgır gemisi tespit edilirse işlem yapılır.';

      case 8: // TÜR KONTROLÜ
        return 'Avlanan türlerin mevzuata uygun olup olmadığı kontrol edilir. Yasak türlerin bulunup bulunmadığı, izin verilen türlerin avlanıp avlanmadığı denetlenir.';

      case 9: // BOY VE AĞIRLIK YASAKLARI
        return 'Avlanan su ürünlerinin minimum boy ve ağırlık sınırlarına uygunluğu kontrol edilir. Minimum boy veya ağırlığın altındaki bireylerin avlanması yasaktır.';

      case 10: // MEVSİMSEL YASAK KONTROLÜ
        return 'Su ürünlerinin üreme dönemlerinde avlanmasının önlenmesi için belirlenen mevsimsel yasaklar kontrol edilir. Her tür için farklı yasaklama dönemleri bulunmaktadır.';

      case 11: // BOY YASAĞI KONTROLÜ
        return 'Avlanan su ürünlerinin minimum boy sınırlarına uygunluğu kontrol edilir. Minimum boy sınırının altındaki bireylerin avlanması yasaktır ve gemide bulundurulması da yasaklanmıştır.';

      case 100: // AVLANMASI YASAK TÜRLERİN AVCILIĞI
        return 'Mevzuatta belirtilen avlanması yasak türlerin gemide bulunup bulunmadığı kontrol edilir. Yasak türlerin avlanması ağır yaptırımlar gerektirir.';

      default:
        return 'TİCARİ AMAÇLI SU ÜRÜNLERİ AVCILIĞININ DÜZENLENMESİ HAKKINDA TEBLİĞ MADDE 12\'YE İSTİNADEN KONTROL İCRA EDİLİR.';
    }
  }

  Widget _buildAciklama() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getAciklamaMetni(),
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 16),
        _buildLinkWidget(
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=4988&MevzuatTur=7&MevzuatTertip=5',
          'Su Ürünleri Yönetmeliği',
        ),
        SizedBox(height: 8),
        _buildLinkWidget(
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=40948&MevzuatTur=9&MevzuatTertip=5',
          '6/1 NUMARALI TİCARİ AMAÇLI SU ÜRÜNLERİ AVCILIĞININ DÜZENLENMESİ HAKKINDA TEBLİĞ',
        ),
      ],
    );
  }

  Widget lawItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget lawTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _getYasalIslem() {
    // Işıkla avcılık yasakları için özel yasal işlem
    if (index == 3 || index == 4) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          lawTitle("YASAL İŞLEM"),
          lawItem(
              "İçsular, Karadeniz, Marmara Denizi, İstanbul ve Çanakkale Boğazlarında, gemilerdeki faaliyetlerin yürütülmesinde gerekli olan aydınlatma hariç, ağlarla avlanma amaçlı ışık kullanan veya bu amaca uygun ışık donanımı bulunduran gemiler için sahip veya donatanlarına idarî para cezası uygulanır."),
          lawItem(
              "İstihsal edilen su ürünlerine ve gemi hariç, av gemisine bağlı olup olmadığına bakılmaksızın avcılık amacıyla ışık sağlayan her türlü su vasıtalarına ve edevatına el konularak mülkiyetin kamuya geçirilmesine karar verilir."),
          lawItem(
              "Kabahatin işlenmesinde kullanılan gemiler ile gerçek veya tüzel kişilerin ruhsat tezkereleri; kabahatin ilk defa işlenmesi halinde bir ay, ikinci defa işlenmesi halinde üç ay süre ile geri alınır, tekrarlanması halinde iptal edilir."),
        ],
      );
    }

    // Genel yasal işlem
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        lawTitle("YASAL İŞLEM"),
        lawItem(
            "23 üncü maddenin birinci fıkrasına göre aykırı hareket edenlere ve kullanılan gemiler için sahip veya donatanlarına idarî para cezası uygulanır. Aykırılığın gırgır ağları ile avlanan balıkçı gemileri kullanılarak yapılması halinde, bu gemiler için sahip veya donatanlarına ceza üç katı olarak uygulanır."),
        lawItem(
            "İstihsal olunan su ürünlerine el konularak mülkiyetin kamuya geçirilmesine karar verilir."),
        lawItem(
            "Kabahatin işlenmesinde kullanılan gemiler ile gerçek veya tüzel kişilerin ruhsat tezkereleri; kabahatin ilk defa işlenmesi halinde bir ay, ikinci defa işlenmesi halinde üç ay süre ile geri alınır, tekrarlanması halinde iptal edilir ve gemi hariç istihsal vasıtalarına el konularak mülkiyetin kamuya geçirilmesine karar verilir."),
        lawItem(
            "Aykırılığın bölgeler, mevsimler ve zamanlar veya istihsal vasıtalarının haiz olmaları gereken asgari vasıf ve şartlar ile bunların kullanma usul ve esasları bakımından yapılan düzenlemelere uyulmayarak işlenmesi halinde, gemiler haricindeki istihsal vasıtalarına da el konularak mülkiyetin kamuya geçirilmesine karar verilir."),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gırgır Detayları',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: color,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/701a.jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.info_outline,
                                color: color, size: 24),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Açıklama',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: _buildAciklama(),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Yasal İşlem',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: _getYasalIslem(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// PARAKETE YÖNTEMİ KONTROL SAYFASI - GÜNCELLENMİŞ
class ParaketeYontemiKontrolPage extends StatelessWidget {
  final List<Map<String, dynamic>> kontrolMaddeleri = [
    {
      'title': 'PARAKETE İLE AVCILIĞA İLİŞKİN YASAKLAR',
      'icon': Icons.filter_vintage,
      'color': Colors.purple,
    },
    {
      'title': 'TÜR KONTROLÜ',
      'icon': Icons.category,
      'color': Colors.pink,
      'hasSubItem': true,
    },
    {
      'title': 'BOY VE AĞIRLIK YASAKLARI',
      'icon': Icons.fitness_center,
      'color': Colors.brown,
    },
  ];

  ParaketeYontemiKontrolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Parakete Yöntemi Kontrol Listesi',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.purple.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(29).jpeg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: kontrolMaddeleri.length,
          itemBuilder: (context, index) {
            final madde = kontrolMaddeleri[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.8),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: madde['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    madde['icon'],
                    color: madde['color'],
                    size: 22,
                  ),
                ),
                title: Text(
                  '${index + 1}. ${madde['title']}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  if (madde['hasSubItem'] == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ParaketeAltMaddePage(
                          title: madde['title'],
                          color: madde['color'],
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ParaketeDetayPage(
                          title: madde['title'],
                          color: madde['color'],
                          index: index,
                        ),
                      ),
                    );
                  }
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            );
          },
        ),
      ),
    );
  }
}

// PARAKETE ALT MADDE SAYFASI (TÜR KONTROLÜ İÇİN)
class ParaketeAltMaddePage extends StatelessWidget {
  final String title;
  final Color color;

  const ParaketeAltMaddePage({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 14),
        ),
        backgroundColor: color,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/701a.jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.85),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.dangerous,
                    color: Colors.red,
                    size: 22,
                  ),
                ),
                title: Text(
                  'AVLANMASI YASAK TÜRLERİN AVLANMASI',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParaketeDetayPage(
                        title: 'AVLANMASI YASAK TÜRLERİN AVLANMASI',
                        color: Colors.red,
                        index: 100, // Özel index
                      ),
                    ),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// PARAKETE DETAY SAYFASI
class ParaketeDetayPage extends StatelessWidget {
  final String title;
  final Color color;
  final int index;

  const ParaketeDetayPage({
    super.key,
    required this.title,
    required this.color,
    required this.index,
  });

  Widget _buildLinkWidget(String url, String text) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (!await launchUrl(uri)) {
          throw Exception('Could not launch $url');
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontSize: 14,
        ),
      ),
    );
  }

  String _getAciklamaMetni() {
    switch (index) {
      case 0: // PARAKETE İLE AVCILIĞA İLİŞKİN YASAKLAR
        return 'Parakete ile avcılığa ilişkin teknik özellikler, ip uzunluğu, iğne sayısı, kullanım yerleri ve zamanları kontrol edilir. Parakete oltası ile avlanmanın yasak olduğu bölgeler, mevsimler ve zamanlar ile paraketede bulunması gereken teknik özellikler denetlenir.';

      case 1: // TÜR KONTROLÜ
        return 'Parakete ile avlanan türlerin mevzuata uygun olup olmadığı kontrol edilir. Yasak türlerin bulunup bulunmadığı, izin verilen türlerin avlanıp avlanmadığı denetlenir.';

      case 2: // BOY VE AĞIRLIK YASAKLARI
        return 'Parakete ile avlanan su ürünlerinin minimum boy ve ağırlık sınırlarına uygunluğu kontrol edilir. Minimum boy veya ağırlığın altındaki bireylerin avlanması ve gemide bulundurulması yasaktır.';

      case 3: // MEVSİMSEL YASAK KONTROLÜ
        return 'Su ürünlerinin üreme dönemlerinde parakete ile avlanmasının önlenmesi için belirlenen mevsimsel yasaklar kontrol edilir. Her tür için farklı yasaklama dönemleri bulunmaktadır ve bu dönemlerde parakete ile avlanma yapılması yasaktır.';

      case 4: // BOY YASAĞI KONTROLÜ
        return 'Parakete ile avlanan su ürünlerinin minimum boy sınırlarına uygunluğu kontrol edilir. Minimum boy sınırının altındaki bireylerin avlanması yasaktır ve gemide bulundurulması da yasaklanmıştır.';

      case 100: // AVLANMASI YASAK TÜRLERİN AVLANMASI
        return 'Mevzuatta belirtilen avlanması yasak türlerin parakete ile avlanıp avlanmadığı, gemide bulunup bulunmadığı kontrol edilir. Yasak türlerin avlanması ağır yaptırımlar gerektirir ve ruhsat iptali söz konusu olabilir.';

      default:
        return 'TİCARİ AMAÇLI SU ÜRÜNLERİ AVCILIĞININ DÜZENLENMESİ HAKKINDA TEBLİĞ MADDE 15\'E İSTİNADEN KONTROL İCRA EDİLİR.';
    }
  }

  Widget _buildAciklama() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getAciklamaMetni(),
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 16),
        _buildLinkWidget(
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=4988&MevzuatTur=7&MevzuatTertip=5',
          'Su Ürünleri Yönetmeliği',
        ),
        SizedBox(height: 8),
        _buildLinkWidget(
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=40948&MevzuatTur=9&MevzuatTertip=5',
          '6/1 NUMARALI TİCARİ AMAÇLI SU ÜRÜNLERİ AVCILIĞININ DÜZENLENMESİ HAKKINDA TEBLİĞ',
        ),
      ],
    );
  }

  Widget lawItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget lawTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _getYasalIslem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        lawTitle("YASAL İŞLEM"),
        lawItem(
            "23 üncü maddenin birinci fıkrasının (A,B) bendine göre aykırı hareket edenlere ve kullanılan gemiler için sahip veya donatanlarına idarî para cezası uygulanır."),
        lawItem(
            "İstihsal olunan su ürünlerine el konularak mülkiyetin kamuya geçirilmesine karar verilir."),
        lawItem(
            "Kabahatin işlenmesinde kullanılan gemiler ile gerçek veya tüzel kişilerin ruhsat tezkereleri; kabahatin ilk defa işlenmesi halinde bir ay, ikinci defa işlenmesi halinde üç ay süre ile geri alınır, tekrarlanması halinde iptal edilir ve gemi hariç istihsal vasıtalarına el konularak mülkiyetin kamuya geçirilmesine karar verilir."),
        lawItem(
            "Aykırılığın bölgeler, mevsimler ve zamanlar veya istihsal vasıtalarının haiz olmaları gereken asgari vasıf ve şartlar ile bunların kullanma usul ve esasları bakımından yapılan düzenlemelere uyulmayarak işlenmesi halinde, gemiler haricindeki istihsal vasıtalarına da el konularak mülkiyetin kamuya geçirilmesine karar verilir."),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Parakete Detayları',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: color,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/701a.jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.info_outline,
                                color: color, size: 24),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Açıklama',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: _buildAciklama(),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Yasal İşlem',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: _getYasalIslem(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// UZATMA AĞLARI KONTROL SAYFASI - GÜNCELLENMİŞ
class UzatmaAglariKontrolPage extends StatelessWidget {
  final List<Map<String, dynamic>> kontrolMaddeleri = [
    {
      'title': 'UZATMA AĞLARI İLE AVCILIĞA İLİŞKİN YASAKLAR',
      'icon': Icons.web,
      'color': Colors.green,
    },
    {
      'title': 'YER YASAKLARI',
      'icon': Icons.location_off,
      'color': Colors.red,
    },
    {
      'title':
          'MONOFİLAMENT/ MULTİMONOFİLAMENT MİSİNA AĞLARI VE DRİFT-NET KULLANIMI',
      'icon': Icons.grid_on,
      'color': Colors.orange,
    },
    {
      'title': 'TÜR KONTROLÜ',
      'icon': Icons.category,
      'color': Colors.pink,
      'hasSubItem': true,
    },
    {
      'title': 'BOY VE AĞIRLIK YASAKLARI',
      'icon': Icons.fitness_center,
      'color': Colors.brown,
    },
  ];

  UzatmaAglariKontrolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Uzatma Ağları Kontrol Listesi',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.green.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(31).jpeg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: kontrolMaddeleri.length,
          itemBuilder: (context, index) {
            final madde = kontrolMaddeleri[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.8),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: madde['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    madde['icon'],
                    color: madde['color'],
                    size: 22,
                  ),
                ),
                title: Text(
                  '${index + 1}. ${madde['title']}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  if (madde['hasSubItem'] == true) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UzatmaAglariAltMaddePage(
                          title: madde['title'],
                          color: madde['color'],
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UzatmaAglariDetayPage(
                          title: madde['title'],
                          color: madde['color'],
                          index: index,
                        ),
                      ),
                    );
                  }
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            );
          },
        ),
      ),
    );
  }
}

// UZATMA AĞLARI ALT MADDE SAYFASI (TÜR KONTROLÜ İÇİN)
class UzatmaAglariAltMaddePage extends StatelessWidget {
  final String title;
  final Color color;

  const UzatmaAglariAltMaddePage({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(fontSize: 14),
        ),
        backgroundColor: color,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/701a.jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(12),
          children: [
            Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.85),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.dangerous,
                    color: Colors.red,
                    size: 22,
                  ),
                ),
                title: Text(
                  'AVLANMASI YASAK TÜRLERİN AVLANMASI',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UzatmaAglariDetayPage(
                        title: 'AVLANMASI YASAK TÜRLERİN AVLANMASI',
                        color: Colors.red,
                        index: 100, // Özel index
                      ),
                    ),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// UZATMA AĞLARI DETAY SAYFASI
class UzatmaAglariDetayPage extends StatelessWidget {
  final String title;
  final Color color;
  final int index;

  const UzatmaAglariDetayPage({
    super.key,
    required this.title,
    required this.color,
    required this.index,
  });

  Widget _buildLinkWidget(String url, String text) {
    return GestureDetector(
      onTap: () async {
        final Uri uri = Uri.parse(url);
        if (!await launchUrl(uri)) {
          throw Exception('Could not launch $url');
        }
      },
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue,
          decoration: TextDecoration.underline,
          fontSize: 14,
        ),
      ),
    );
  }

  String _getAciklamaMetni() {
    switch (index) {
      case 0: // UZATMA AĞLARI İLE AVCILIĞA İLİŞKİN YASAKLAR
        return 'Uzatma ağlarının teknik özellikleri, göz açıklığı, ağ uzunluğu, su altında kalış süresi ve kullanım şartları kontrol edilir. Uzatma ağları ile avlanmaya ilişkin bölgesel, zamansal ve teknik kısıtlamalar denetlenir.';

      case 1: // YER YASAKLARI
        return 'Uzatma ağları ile avlanmanın yasak olduğu yerler, bölgeler ve sahalar kontrol edilir. Kıyıdan itibaren belirli mesafe sınırlamaları, milli parklar, özel koruma alanları ve diğer yasak bölgeler denetlenir.';

      case 2: // MONOFİLAMENT/ MULTİMONOFİLAMENT MİSİNA AĞLARI VE DRİFT-NET KULLANIMI
        return 'Monofilament (tek telli) ve multimonofilament (çok telli) misina ağlarının kullanımı kontrol edilir. Drift-net (sürüklenme ağı) kullanımının yasak olduğu bölgeler ve şartlar denetlenir. Bu ağ türlerinin teknik özellikleri ve kullanım kurallarına uygunluk kontrol edilir.';

      case 3: // TÜR KONTROLÜ
        return 'Uzatma ağları ile avlanan türlerin mevzuata uygun olup olmadığı kontrol edilir. Yasak türlerin bulunup bulunmadığı, izin verilen türlerin avlanıp avlanmadığı denetlenir.';

      case 4: // BOY VE AĞIRLIK YASAKLARI
        return 'Uzatma ağları ile avlanan su ürünlerinin minimum boy ve ağırlık sınırlarına uygunluğu kontrol edilir. Minimum boy veya ağırlığın altındaki bireylerin avlanması ve gemide bulundurulması yasaktır.';

      case 5: // MEVSİMSEL YASAK KONTROLÜ
        return 'Su ürünlerinin üreme dönemlerinde uzatma ağları ile avlanmasının önlenmesi için belirlenen mevsimsel yasaklar kontrol edilir. Her tür için farklı yasaklama dönemleri bulunmaktadır ve bu dönemlerde uzatma ağları ile avlanma yapılması yasaktır.';

      case 6: // BOY YASAĞI KONTROLÜ
        return 'Uzatma ağları ile avlanan su ürünlerinin minimum boy sınırlarına uygunluğu kontrol edilir. Minimum boy sınırının altındaki bireylerin avlanması yasaktır ve gemide bulundurulması da yasaklanmıştır.';

      case 100: // AVLANMASI YASAK TÜRLERİN AVLANMASI
        return 'Mevzuatta belirtilen avlanması yasak türlerin uzatma ağları ile avlanıp avlanmadığı, gemide bulunup bulunmadığı kontrol edilir. Yasak türlerin avlanması ağır yaptırımlar gerektirir ve ruhsat iptali söz konusu olabilir.';

      default:
        return 'TİCARİ AMAÇLI SU ÜRÜNLERİ AVCILIĞININ DÜZENLENMESİ HAKKINDA TEBLİĞ MADDE 14\'E İSTİNADEN KONTROL İCRA EDİLİR.';
    }
  }

  Widget _buildAciklama() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getAciklamaMetni(),
          style: TextStyle(fontSize: 14, height: 1.5),
        ),
        SizedBox(height: 16),
        _buildLinkWidget(
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=4988&MevzuatTur=7&MevzuatTertip=5',
          'Su Ürünleri Yönetmeliği',
        ),
        SizedBox(height: 8),
        _buildLinkWidget(
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=40948&MevzuatTur=9&MevzuatTertip=5',
          '6/1 NUMARALI TİCARİ AMAÇLI SU ÜRÜNLERİ AVCILIĞININ DÜZENLENMESİ HAKKINDA TEBLİĞ',
        ),
      ],
    );
  }

  Widget lawItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget lawTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _getYasalIslem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        lawTitle("YASAL İŞLEM"),
        lawItem(
            "23 üncü maddenin birinci fıkrasının (A,B) bendine göre aykırı hareket edenlere ve kullanılan gemiler için sahip veya donatanlarına idarî para cezası uygulanır."),
        lawItem(
            "İstihsal olunan su ürünlerine el konularak mülkiyetin kamuya geçirilmesine karar verilir."),
        lawItem(
            "Kabahatin işlenmesinde kullanılan gemiler ile gerçek veya tüzel kişilerin ruhsat tezkereleri; kabahatin ilk defa işlenmesi halinde bir ay, ikinci defa işlenmesi halinde üç ay süre ile geri alınır, tekrarlanması halinde iptal edilir ve gemi hariç istihsal vasıtalarına el konularak mülkiyetin kamuya geçirilmesine karar verilir."),
        lawItem(
            "Aykırılığın bölgeler, mevsimler ve zamanlar veya istihsal vasıtalarının haiz olmaları gereken asgari vasıf ve şartlar ile bunların kullanma usul ve esasları bakımından yapılan düzenlemelere uyulmayarak işlenmesi halinde, gemiler haricindeki istihsal vasıtalarına da el konularak mülkiyetin kamuya geçirilmesine karar verilir."),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Uzatma Ağları Detayları',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: color,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/701a.jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white.withOpacity(0.9),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.info_outline,
                                color: color, size: 24),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Açıklama',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: _buildAciklama(),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Yasal İşlem',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade900,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: _getYasalIslem(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// AVLANMA KOTASI KONTROL SAYFASI
class AvlanmaKotasiKontrolPage extends StatelessWidget {
  final List<Map<String, dynamic>> kontrolMaddeleri = [
    {
      'title': 'KOTA KONTROLÜ',
      'icon': Icons.format_list_numbered,
      'color': Colors.blue,
    },
    {
      'title': 'TÜR BAZLI KOTALAR',
      'icon': Icons.category,
      'color': Colors.green,
    },
  ];

  AvlanmaKotasiKontrolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Avlanma Kotası Kontrolü',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.amber.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(32).jpeg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: kontrolMaddeleri.length,
          itemBuilder: (context, index) {
            final madde = kontrolMaddeleri[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.8),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: madde['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    madde['icon'],
                    color: madde['color'],
                    size: 22,
                  ),
                ),
                title: Text(
                  '${index + 1}. ${madde['title']}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Detay sayfasına yönlendirme
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${madde['title']} kontrol maddesi'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            );
          },
        ),
      ),
    );
  }
}

// DİĞER KONTROL SAYFALARI
class DalisFaliyetleriKontrolPage extends StatelessWidget {
  final List<String> kontrolMaddeleri = [
    '1. Ticari Dalış İşletmeleri Kontrol Listesi',
    '2. Amatör Dalış Faaliyetleri Kontrol Listesi',
    '3. Dalış Ekipmanları Kontrol Listesi',
    '4. Dalış İzin Belgesi Kontrolü',
    '5. Dalış Eğitmen Sertifikası',
    '6. Dalış Planı ve Güvenlik Önlemleri',
    '7. Dalış Tüpü ve Regülatör Kontrolü',
    '8. Dalış Bilgisayarı ve Derinlik Ölçer',
    '9. Acil Durum Ekipmanları',
    '10. Dalış Bölgesi Güvenlik Kontrolü',
  ];

  DalisFaliyetleriKontrolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dalış Faaliyetleri Kontrolleri',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.purple.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(33).jpeg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          itemCount: kontrolMaddeleri.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              color: Colors.white.withOpacity(0.7),
              child: CheckboxListTile(
                title: Text(
                  kontrolMaddeleri[index],
                  style: TextStyle(fontSize: 14),
                ),
                value: false,
                onChanged: (bool? value) {},
                controlAffinity: ListTileControlAffinity.leading,
              ),
            );
          },
        ),
      ),
    );
  }
}

class SuSporlariIsletmeleriKontrolPage extends StatelessWidget {
  final List<String> kontrolMaddeleri = [
    '1. Su Kayağı İşletmeleri Kontrol Listesi',
    '2. Jet Ski İşletmeleri Kontrol Listesi',
    '3. Yat İşletmeleri Kontrol Listesi',
    '4. İşletme Ruhsatı ve İzinleri',
    '5. Ekipman Bakım ve Kontrol Kayıtları',
    '6. Personel Sertifikaları',
    '7. Güvenlik Talimatları ve Eğitim',
    '8. Acil Durum Planları',
    '9. Müşteri Güvenlik Donanımları',
    '10. Çevresel Etki Değerlendirmesi',
  ];

  SuSporlariIsletmeleriKontrolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Su Sporları İşletmeleri Kontrolleri',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.orange.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/10.JPEG'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          itemCount: kontrolMaddeleri.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              color: Colors.white.withOpacity(0.7),
              child: CheckboxListTile(
                title: Text(
                  kontrolMaddeleri[index],
                  style: TextStyle(fontSize: 14),
                ),
                value: false,
                onChanged: (bool? value) {},
                controlAffinity: ListTileControlAffinity.leading,
              ),
            );
          },
        ),
      ),
    );
  }
}

class BalikCiftlikleriKontrolPage extends StatelessWidget {
  final List<String> kontrolMaddeleri = [
    '1. Balık Çiftliği Genel Kontrol Listesi',
    '2. Çevresel Etki Kontrol Listesi',
    '3. Üretim ve İşletme Kontrol Listesi',
    '4. Su Kalitesi Kontrolü',
    '5. Yem ve Besleme Kontrolü',
    '6. Hastalık Kontrol ve Önlemleri',
    '7. Atık Yönetim Sistemi',
    '8. İş Sağlığı ve Güvenliği',
    '9. Kayıt ve İzlenebilirlik Sistemi',
    '10. Çevre İzin ve Lisansları',
  ];

  BalikCiftlikleriKontrolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Balık Çiftlikleri Kontrolleri',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.brown.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(30).jpeg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          itemCount: kontrolMaddeleri.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              color: Colors.white.withOpacity(0.7),
              child: CheckboxListTile(
                title: Text(
                  kontrolMaddeleri[index],
                  style: TextStyle(fontSize: 14),
                ),
                value: false,
                onChanged: (bool? value) {},
                controlAffinity: ListTileControlAffinity.leading,
              ),
            );
          },
        ),
      ),
    );
  }
}

class CevreKanunuKontrolPage extends StatelessWidget {
  final List<String> kontrolMaddeleri = [
    '1. Çevre Mevzuatı Uyum Kontrol Listesi',
    '2. Atık Yönetimi Kontrol Listesi',
    '3. Kirlilik Önleme Kontrol Listesi',
    '4. Atık Kabul Tesisleri Kontrolü',
    '5. Sintine ve Atık Yağ Kontrolü',
    '6. Atık Su Arıtma Sistemi',
    '7. Hava Kirliliği Kontrolü',
    '8. Gürültü Kirliliği Kontrolü',
    '9. Tehlikeli Madde Depolama',
    '10. Çevresel Acil Durum Planı',
  ];

  CevreKanunuKontrolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Çevre Kanunu Kontrol Listesi',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.lightGreen.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/9.JPEG'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          itemCount: kontrolMaddeleri.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              color: Colors.white.withOpacity(0.7),
              child: CheckboxListTile(
                title: Text(
                  kontrolMaddeleri[index],
                  style: TextStyle(fontSize: 14),
                ),
                value: false,
                onChanged: (bool? value) {},
                controlAffinity: ListTileControlAffinity.leading,
              ),
            );
          },
        ),
      ),
    );
  }
}

class KacakciliklaMucadeleKontrolPage extends StatelessWidget {
  final List<String> kontrolMaddeleri = [
    '1. Gemi Kaçakçılık Kontrol Listesi',
    '2. Kara Bağlantılı Kaçakçılık Kontrol Listesi',
    '3. Önleyici Kontrol Listesi',
    '4. Gemi Kayıt ve Kimlik Kontrolü',
    '5. Yük ve Manifesto Kontrolü',
    '6. Mürettebat ve Yolcu Listeleri',
    '7. Gümrük Beyannameleri',
    '8. Elektronik Takip Sistemleri',
    '9. Şüpheli Faaliyet İzleme',
    '10. İşbirliği Protokolleri Kontrolü',
  ];

  KacakciliklaMucadeleKontrolPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kaçakçılıkla Mücadele Kontrolleri',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.red.shade800,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/8.JPEG'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          itemCount: kontrolMaddeleri.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              color: Colors.white.withOpacity(0.7),
              child: CheckboxListTile(
                title: Text(
                  kontrolMaddeleri[index],
                  style: TextStyle(fontSize: 14),
                ),
                value: false,
                onChanged: (bool? value) {},
                controlAffinity: ListTileControlAffinity.leading,
              ),
            );
          },
        ),
      ),
    );
  }
}

// D. MEVZUAT EKRANI
class MevzuatPage extends StatelessWidget {
  final List<Map<String, dynamic>> mevzuatListesi = [
    {
      'title': 'Türk Ceza Kanunu',
      'url':
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=5237&MevzuatTur=1&MevzuatTertip=5',
    },
    {
      'title': 'Ceza Muhakemesi Kanunu',
      'url':
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=5271&MevzuatTur=1&MevzuatTertip=5',
    },
    {
      'title': 'Kabahatler Kanunu',
      'url':
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=5326&MevzuatTur=1&MevzuatTertip=5',
    },
    {
      'title': 'Sahil Güvenlik Komutanlığı Kanunu',
      'url':
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=2692&MevzuatTur=1&MevzuatTertip=5',
    },
    {
      'title': 'Çevre Kanunu',
      'url':
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=2872&MevzuatTur=1&MevzuatTertip=5',
    },
    {
      'title': 'Su Ürünleri Kanunu',
      'url':
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=1380&MevzuatTur=1&MevzuatTertip=5',
    },
    {
      'title': 'Türk Bayrağı Kanunu',
      'url':
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=2893&MevzuatTur=1&MevzuatTertip=5',
    },
    {
      'title': 'Sahil Güvenlik Yönetmeliği',
      'url':
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=20169743&MevzuatTur=3&MevzuatTertip=5',
    },
    {
      'title': 'Denizde Can ve Mal Koruma Hakkında Kanun',
      'url':
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=4922&MevzuatTur=1&MevzuatTertip=3',
    },
    {
      'title': 'Deniz Turizmi Yönetmeliği',
      'url':
          'https://mevzuat.gov.tr/mevzuat?MevzuatNo=200915212&MevzuatTur=21&MevzuatTertip=5',
    },
  ];

  MevzuatPage({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mevzuat', style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.purple.shade800,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(16).jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          itemCount: mevzuatListesi.length,
          itemBuilder: (context, index) {
            final mevzuat = mevzuatListesi[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.7),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.gavel, color: Colors.purple, size: 22),
                ),
                title: Text(
                  mevzuat['title'],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                trailing: Icon(Icons.open_in_new, color: Colors.blue, size: 18),
                onTap: () => _launchUrl(mevzuat['url']),
                tileColor: Colors.white.withOpacity(0.9),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// E. SIKÇA YAPILAN HATALAR EKRANI
class SikcaYapilanHatalarPage extends StatelessWidget {
  final List<Map<String, dynamic>> hatalar = [
    {
      'title': 'Eksik Kimlik Bilgileri',
      'description':
          'Tutanaklarda kimlik bilgilerinin eksik veya yanlış doldurulması',
      'cozum':
          'TCKN, adres ve iletişim bilgileri dikkatlice kontrol edilmelidir.',
      'onem': 'Yüksek',
    },
    {
      'title': 'Zaman ve Tarih Hataları',
      'description': 'Tutanaklarda zaman ve tarih bilgilerinin tutarsız olması',
      'cozum': 'Tutanak başlangıç ve bitiş saatleri tutarlı olmalıdır.',
      'onem': 'Orta',
    },
    {
      'title': 'Mevzuat Maddelerinin Eksikliği',
      'description':
          'İşlemin dayanağı olan mevzuat maddelerinin belirtilmemesi',
      'cozum':
          'Her işlem için ilgili kanun ve madde numaraları belirtilmelidir.',
      'onem': 'Yüksek',
    },
    {
      'title': 'İmza Eksiklikleri',
      'description': 'Tutanaklarda gerekli imzaların atılmaması',
      'cozum': 'Tüm ilgili tarafların imzaları mutlaka alınmalıdır.',
      'onem': 'Kritik',
    },
    {
      'title': 'Delil Zinciri İhlali',
      'description': 'El konulan eşyalarda delil zincirinin bozulması',
      'cozum':
          'El konulan her eşya için ayrı tutanak düzenlenmeli ve zincir korunmalıdır.',
      'onem': 'Kritik',
    },
    {
      'title': 'Hakların Hatırlatılmaması',
      'description': 'Şüphelilere haklarının hatırlatılmaması',
      'cozum':
          'Her şüpheliye hakları yazılı ve sözlü olarak hatırlatılmalıdır.',
      'onem': 'Yüksek',
    },
  ];

  SikcaYapilanHatalarPage({super.key});

  Color _getOnemRengi(String onem) {
    switch (onem) {
      case 'Kritik':
        return Colors.red;
      case 'Yüksek':
        return Colors.orange;
      case 'Orta':
        return Colors.yellow.shade700;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sıkça Yapılan Hatalar', style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.red.shade800,
        elevation: 4,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/UNSUR(6).jpg'),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: ListView.builder(
          itemCount: hatalar.length,
          itemBuilder: (context, index) {
            final hata = hatalar[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.white.withOpacity(0.9),
              child: ExpansionTile(
                leading: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _getOnemRengi(hata['onem']).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.error_outline,
                    color: _getOnemRengi(hata['onem']),
                    size: 22,
                  ),
                ),
                title: Text(
                  hata['title'],
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                subtitle: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getOnemRengi(hata['onem']).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: _getOnemRengi(hata['onem'])),
                      ),
                      child: Text(
                        hata['onem'],
                        style: TextStyle(
                          fontSize: 11,
                          color: _getOnemRengi(hata['onem']),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hata:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          hata['description'],
                          style: TextStyle(fontSize: 13),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Çözüm:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(hata['cozum'], style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
