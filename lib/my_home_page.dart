import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool isLoading;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  // _launchURL(String url) async {
  //   var uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Widget _isLoading() {
    return const Center(child: CircularProgressIndicator(color: Color(0xFF97C649)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WebView(
              initialUrl: 'https://voltservices.co/',
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (finish) {
                log("finished:: $finish");
                setState(() {
                  isLoading = false;
                });
              },
              navigationDelegate: (NavigationRequest request) async {
                if (request.url.startsWith('https://api.whatsapp.com/send?phone')) {
                  log('blocking navigation to $request}');
                  // List<String> urlSplitted = request.url.split("&text=");
                  // String message = urlSplitted.last.toString().replaceAll("%20", " ");

                  String phone = "+962791818935";
                  await _launchURL("https://wa.me/$phone/?text=");
                  return NavigationDecision.prevent;
                }
                log('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
            ),
            isLoading ? _isLoading() : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    log('Could not launch $url');
    throw 'Could not launch $url';
  }
}
