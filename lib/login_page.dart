import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


class MyWebView extends StatefulWidget {
  String recognizedSpeech;
  MyWebView(this.recognizedSpeech);
  @override
  _MyWebViewState createState() => _MyWebViewState();
}


class _MyWebViewState extends State<MyWebView> {
  String returnString = 'good morning';
  late String loginUrl;

  InAppWebViewController? webViewController;
  @override
  void initState() {
    super.initState();


    setState(() {
      returnString = widget.recognizedSpeech;
      loginUrl = "https://you.com/api/auth/login?returnTo=%2Fsearch%3Fq%3D${returnString.replaceAll(' ', '%2B')}%26tbm%3Dyouchat";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Bot'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(loginUrl)),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStop: (controller, url) async {},
              initialOptions: InAppWebViewGroupOptions(
                android: AndroidInAppWebViewOptions(
                  useHybridComposition:
                      true, // Required for Android 11 or higher
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
