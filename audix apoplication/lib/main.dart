import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0F172A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const AudixApp());
}

class AudixApp extends StatelessWidget {
  const AudixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AUDIX Tech & Audio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0F17),
        primaryColor: const Color(0xFF00E5FF),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),
          secondary: Color(0xFF38BDF8),
          surface: Color(0xFF111827),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ----------------------------------------------------
// SPLASH SCREEN WITH LUXURY LOGO ANIMATION
// ----------------------------------------------------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // Transition to main webview screen after 2.2 seconds
    Timer(const Duration(milliseconds: 2300), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const WebViewScreen(),
            transitionDuration: const Duration(milliseconds: 600),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080C14),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00E5FF).withOpacity(0.35),
                        blurRadius: 40,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset(
                      'assets/app_icon.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF1E293B),
                          child: const Icon(
                            Icons.headphones,
                            size: 64,
                            color: Color(0xFF00E5FF),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'AUDIX',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 6.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'TECH • AUDIO • PAKISTAN',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3.5,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 36),
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00E5FF)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// MAIN WEBVIEW SCREEN (AUDIXSTORETECH.ONLINE)
// ----------------------------------------------------
class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  static const String initialUrl = 'https://audixstoretech.online/';
  late final WebViewController _controller;

  int _loadingProgress = 0;
  bool _isLoading = true;
  bool _hasError = false;
  bool _isOffline = false;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _initWebViewController();
  }

  void _initConnectivity() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final bool isOffline = results.every(
          (result) => result == ConnectivityResult.none,
        );
        setState(() {
          _isOffline = isOffline;
        });
        if (!isOffline && _hasError) {
          _reloadPage();
        }
      },
    );
  }

  void _initWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0B0F17))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress;
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });

            // Automatically hide Karan Aujla video banner while keeping all other videos and features active
            _controller.runJavaScript('''
              (function() {
                var style = document.createElement('style');
                style.innerHTML = '#mobAudixChampionBanner, .audix-champion-banner-card, .audix-champion-banner-wrap, iframe[src*="x9RC77Oc-0Q"] { display: none !important; }';
                document.head.appendChild(style);

                var mobBanner = document.getElementById('mobAudixChampionBanner');
                if (mobBanner) mobBanner.remove();

                var iframes = document.querySelectorAll('iframe[src*="x9RC77Oc-0Q"], #audixChampionIframe, #mobAudixChampionIframe');
                iframes.forEach(function(el) {
                  var parentCard = el.closest('.audix-champion-banner-card') || el.closest('.audix-champion-banner-wrap') || el;
                  parentCard.remove();
                });
              })();
            ''');
          },
          onWebResourceError: (WebResourceError error) {
            // Main frame failure
            if (error.isForMainFrame ?? true) {
              setState(() {
                _hasError = true;
                _isLoading = false;
              });
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            final uri = Uri.tryParse(request.url);
            if (uri == null) return NavigationDecision.navigate;

            // Handle WhatsApp, Telephone, Email, External Apps
            if (request.url.startsWith('whatsapp://') ||
                request.url.contains('wa.me') ||
                request.url.startsWith('tel:') ||
                request.url.startsWith('mailto:') ||
                request.url.startsWith('sms:') ||
                request.url.contains('instagram.com') ||
                request.url.contains('tiktok.com')) {
              _launchExternalApp(uri);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(initialUrl));
  }

  Future<void> _launchExternalApp(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  void _reloadPage() {
    setState(() {
      _hasError = false;
      _isLoading = true;
    });
    _controller.reload();
  }

  Future<bool> _handleWillPop() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return false; // Handled internally
    }
    return true; // Allow exiting app
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        final bool shouldExit = await _handleWillPop();
        if (shouldExit && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0B0F17),
        body: SafeArea(
          child: Stack(
            children: [
              // Main WebView with Pull-To-Refresh
              RefreshIndicator(
                color: const Color(0xFF00E5FF),
                backgroundColor: const Color(0xFF1E293B),
                onRefresh: () async {
                  await _controller.reload();
                },
                child: WebViewWidget(controller: _controller),
              ),

              // Sleek Cyan Progress Bar
              if (_isLoading && _loadingProgress < 100)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: LinearProgressIndicator(
                    value: _loadingProgress / 100.0,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF00E5FF),
                    ),
                    minHeight: 2.8,
                  ),
                ),

              // Offline / Error Screen Overlay
              if (_isOffline || _hasError)
                Container(
                  color: const Color(0xFF0B0F17),
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF1E293B),
                          border: Border.all(
                            color: const Color(0xFF00E5FF).withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          _isOffline ? Icons.wifi_off_rounded : Icons.cloud_off_rounded,
                          size: 54,
                          color: const Color(0xFF00E5FF),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _isOffline
                            ? 'No Internet Connection'
                            : 'Failed to Connect to AUDIX',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _isOffline
                            ? 'Please check your Wi-Fi or mobile data connection to continue browsing.'
                            : 'Could not reach audixstoretech.online. Please verify your connection and tap retry.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.65),
                          fontSize: 14,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      ElevatedButton.icon(
                        onPressed: _reloadPage,
                        icon: const Icon(Icons.refresh_rounded, color: Colors.black),
                        label: const Text(
                          'Retry Connection',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00E5FF),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                          shadowColor: const Color(0xFF00E5FF).withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
