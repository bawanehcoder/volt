import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WebView(
        initialUrl: 'https://voltservices.co/',
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) async {
          if (request.url.startsWith('https://api.whatsapp.com/send?phone')) {
            print('blocking navigation to $request}');
            List<String> urlSplitted = request.url.split("&text=");

            String phone = "+962791818935";
            String message = urlSplitted.last.toString().replaceAll("%20", " ");

            await _launchURL("https://wa.me/$phone/?text=");
            return NavigationDecision.prevent;
          }
          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
