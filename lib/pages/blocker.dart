import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle, rootBundle;

class BlockWebPageApp extends StatefulWidget {
  @override
  _BlockWebPageAppState createState() => _BlockWebPageAppState();
}

class _BlockWebPageAppState extends State<BlockWebPageApp> {
  final String _explicitWordsPath = 'assets/url.csv';
  final List<String> _explicitWords = [];

  String _accountabilityPartnerEmail = '';

  @override
  void initState() {
    super.initState();
    _loadExplicitWords();
    _loadAccountabilityPartnerEmail();
  }

  Future<void> _loadExplicitWords() async {
    final explicitWordsData = await rootBundle.loadString(_explicitWordsPath);
    final explicitWordsList = explicitWordsData.split(',');
    setState(() {
      _explicitWords.addAll(explicitWordsList);
    });
  }

  Future<void> _loadAccountabilityPartnerEmail() async {
    // Retrieve the accountability partner email from your storage or settings
    setState(() {
      _accountabilityPartnerEmail = 'set_accountability_partner@gmail.com';
    });
  }

  bool _shouldBlockUrl(String url, String content) {
    final uri = Uri.parse(url);

    // Check if the URL is a Google search page
    if (uri.host == 'www.google.com' &&
        uri.path == '/search' &&
        uri.queryParameters.containsKey('q')) {
      // Check if SafeSearch mode is already active
      if (uri.queryParameters.containsKey('safe') &&
          uri.queryParameters['safe'] == 'active') {
        return false;
      }

      // Check if the search query contains any explicit word
      final searchQuery = uri.queryParameters['q'];
      if (_explicitWords.any(
          (word) => searchQuery!.toLowerCase().contains(word.toLowerCase()))) {
        _sendEmail(searchQuery!);
        return true;
      }
    }

    return false;
  }

  void _sendEmail(String searchQuery) async {
    final emailSubject = 'Explicit content alert';
    final emailBody =
        'Your friend is trying to access nudity related content. Please contact him/her. Search query: $searchQuery';
    final url =
        'mailto:$_accountabilityPartnerEmail?subject=${Uri.encodeComponent(emailSubject)}&body=${Uri.encodeComponent(emailBody)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch email';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: InAppWebView(
          initialUrlRequest: URLRequest(
            url: Uri.parse('https://www.google.com'),
          ),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              javaScriptEnabled: true,
            ),
          ),
          onWebViewCreated: (controller) {},
          onLoadStop: (controller, url) async {
            final content = await controller.evaluateJavascript(
                source: 'document.body.innerText');
            if (_shouldBlockUrl(url.toString(), content)) {
              // Block the URL by loading the SafeSearch URL
              await controller.loadUrl(
                  urlRequest: URLRequest(
                      url: Uri.parse(url.toString() + '&safe=active')));
            }
          },
        ),
      ),
    );
  }
}
