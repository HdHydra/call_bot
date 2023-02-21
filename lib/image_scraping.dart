import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:call_bot/detailed_image.dart';
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
  bool showImage = false;
  late List<dynamic> images = [];
  late List<dynamic> imageUrls = [];
  List<IconData> menuIcon = [
    Icons.grid_view_outlined,
    Icons.crop_square_outlined,
    Icons.layers_outlined
  ];
  List<IconData> loadingIcon = [
    Icons.circle,
    Icons.circle_outlined,
  ];
  int crossAxis = 3;
  int count = 1;
  int loading = 1;

  @override
  void initState() {
    super.initState();
    initScrape();
    headlessWebView = HeadlessInAppWebView(
        initialUrlRequest: URLRequest(
            url: Uri.parse(
                "https://www.bing.com/images/search?q=${widget.query.replaceAll(' ', '+')}&qft=+filterui:color2-color&form=IRFLTR&first=$count")),
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
          setState(() {
            loading=1;
          });
          Future.delayed(Duration(seconds: 3), () async {
            await getImages();    });
        });
  }

  Future initScrape() async {
    isLoading = true;
    await headlessWebView?.dispose();
    await headlessWebView?.run();
  }

  //&qft=+filterui:color2-color+filterui:photo-photo+filterui:aspect-square&form=IRFLTR&first=$_count
  Future reloadUrl(int _count) async {
    isLoading = true;
    var url = Uri.parse(
        "https://www.bing.com/images/search?q=${widget.query.replaceAll(' ', '+')}&qft=+filterui:color2-color&form=IRFLTR&first=$_count");
    await headlessWebView?.webViewController
        .loadUrl(urlRequest: URLRequest(url: url));
    setState(() {
      loading=1;
    });
    Future.delayed(
      Duration(seconds: 3),
      () async {
        await getImages();
      },
    );
  }

  Future loadMore() async {
    isLoading = true;
    await headlessWebView?.webViewController.evaluateJavascript(
        source: 'window.scrollTo(0, document.body.scrollHeight');
    Future.delayed(
      Duration(seconds: 3),
      () async {
        await getImages();
      },
    );
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
        imageUrls.addAll(images);
      });
      setState(() {
        loading=0;
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
        actions: <Widget>[
          Icon(loadingIcon[loading]),
          IconButton(
            icon: Icon(menuIcon[crossAxis % 3]),
            onPressed: () {
              setState(() {
                crossAxis = (crossAxis + 1) % 3 + 1;
              });
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: imageUrls.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxis,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    if (showImage) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return DetailScreen(imageUrls, index);
                      }));
                    }
                  },
                  child: Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: 30,
            child: Center(
              child: FloatingActionButton(
                onPressed: () {
                  showImage = true;
                  count = count + 1;
                  reloadUrl(count);
                },
                child: Icon(
                  Icons.expand_more,
                ),
                backgroundColor: Colors.grey,
                elevation: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
