import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';

class ImageGet extends StatefulWidget {
  String query = 'cars';
  ImageGet(this.query);
  @override
  ImageGetState createState() => ImageGetState();
}

class ImageGetState extends State<ImageGet> {
  HeadlessInAppWebView? headlessWebView;
  bool isLoading = true;
  late List<dynamic> images = [];
  late List<dynamic> imageUrls = [];

  @override
  void initState() {
    super.initState();
    initScrape();
    headlessWebView = HeadlessInAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse(
                "https://www.bing.com/images/search?q=${widget.query.replaceAll(' ', '+')}&qft=+filterui:color2-color+filterui:photo-photo+filterui:aspect-square&form=IRFLTR&first=1")),
        onWebViewCreated: (controller) async {},
        onConsoleMessage: (controller, consoleMessage) {
          if (consoleMessage.message.contains('[Report Only]')) {
            print('Error Found');
          } else {
            print(consoleMessage.message);
          }
        },
        onLoadStop: (controller, url) async {
          controller.evaluateJavascript(
              source: 'window.scrollTo(0, document.body.scrollHeight)');
          Future.delayed(Duration(seconds: 4), () async {
            await getImages();
          });
        });
  }

  Future initScrape() async {
    isLoading = true;
    await headlessWebView?.dispose();
    await headlessWebView?.run();
  }

  Future reloadUrl() async {
    isLoading = true;
    var url = Uri.parse(
        "https://www.bing.com/images/search?q=${widget.query.replaceAll(' ', '+')}&qft=+filterui:color2-color+filterui:photo-photo+filterui:aspect-square&form=IRFLTR&first=1");
    await headlessWebView?.webViewController
        .loadUrl(urlRequest: URLRequest(url: url));
    Future.delayed(Duration(seconds: 1), () async {
      await getImages();
    });
  }

  Future reply() async {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  Future getImages() async {
    if (headlessWebView?.isRunning() ?? false) {
      print('object');

      images = await headlessWebView?.webViewController.evaluateJavascript(
          source:
              'let count = 0; let imageURLs = [];let imageElements = document.querySelectorAll(\'.mimg:not([id])\');imageElements.forEach(function(imageElement) {imageURLs.push(imageElement.src);});imageURLs;');


      // for (int i = 0; i < 4; i++) {
      //   await headlessWebView?.webViewController.evaluateJavascript(
      //       source: 'window.scrollTo(0, document.body.scrollHeight;');
      //   Future.delayed(Duration(seconds: 4), () async {
      //     images = await headlessWebView?.webViewController.evaluateJavascript(
      //         source:
      //             'imageElements = document.querySelectorAll(\'.mimg:not([id])\');imageElements.forEach(function(imageElement) {imageURLs.push(imageElement.src);});imageURLs;');
      //
      //   });
      // }
      setState(() {
        imageUrls = images;
      });
      // images = await headlessWebView?.webViewController.evaluateJavascript(
      //       source:
      //           'let count = 0;let imgUrls = [];for (let names of document.querySelectorAll(\'.mimg\')) {imgUrls.push(names.src.toString());}imgUrls;');
      print(images);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Call Bot'),
        ),
        body: GridView.builder(
          itemCount: imageUrls.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            return Image.network(
              imageUrls[index],
              fit: BoxFit.cover,
            );
          },
        ));
  }
}
