import 'dart:async';
import 'dart:io';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

HeadlessInAppWebView? headlessWebView;
String url = "";
String? message;

void setupHeadlessWebView(query) {
  headlessWebView = HeadlessInAppWebView(
    initialUrlRequest: URLRequest(
        url: Uri.parse(
            "https://you.com/search?q=${query.replaceAll(' ', '+')}&fromSearchBar=true&tbm=youchat")),
    onWebViewCreated: (controller) {
      // final snackBar = SnackBar(
      //   content: Text('HeadlessInAppWebView created!'),
      //   duration: Duration(seconds: 1),
      // );
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    },
    onConsoleMessage: (controller, consoleMessage) {
      // final snackBar = SnackBar(
      //   content: Text('Console Message: ${consoleMessage.message}'),
      //   duration: Duration(seconds: 1),
      // );
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);
    },
    onLoadStart: (controller, url) async {
      // final snackBar = SnackBar(
      //   content: Text('onLoadStart $url'),
      //   duration: Duration(seconds: 1),
      // );
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // setState(() {
      //   this.url = url?.toString() ?? '';
      // });
    },
    onLoadStop: (controller, url) async {
      // final snackBar = SnackBar(
      //   content: Text('onLoadStop $url'),
      //   duration: Duration(seconds: 1),
      // );
      // ScaffoldMessenger.of(context).showSnackBar(snackBar);

      // setState(() {
      //   this.url = url?.toString() ?? '';
      // });
    },
  );
}

void disposeHeadlessWebView() {
  headlessWebView?.dispose();
}

Future runHeadlessWebView() async {
  await headlessWebView?.run();
}

Future getMessage() async {
  if (headlessWebView?.isRunning() ?? false) {
    message = await headlessWebView?.webViewController
        .evaluateJavascript(
        source:
        "document.querySelector('#chatHistory p').textContent");
    print(message);
  } else {
    // final snackBar = SnackBar(
    //   content: Text(
    //       'HeadlessInAppWebView is not running. Click on "Run HeadlessInAppWebView"!'),
    //   duration: Duration(milliseconds: 1500),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}