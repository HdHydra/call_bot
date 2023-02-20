import 'package:call_bot/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


class MyWebView extends StatefulWidget {
  String login_url = "https://you.com/api/auth/login?returnTo=%2F";
  String content_url = "https://you.com";
  @override
  _MyWebViewState createState() => _MyWebViewState();
}


class _MyWebViewState extends State<MyWebView> {
  InAppWebViewController? webViewController;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('In-App WebView'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(widget.login_url)),
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
          Positioned(
            child: FloatingActionButton(
              onPressed: () async {

              },
              child: Icon(Icons.data_object_sharp),
            ),
          ),
        ],
      ),
    );
  }
}
