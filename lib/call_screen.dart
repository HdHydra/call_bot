import 'package:call_bot/image_scraping.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:word_generator/word_generator.dart';
import 'package:flutter/material.dart';
import 'text_to_speech.dart';
import 'speech_to_text.dart';
import 'login_page.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  CallScreenState createState() => CallScreenState();
}

class CallScreenState extends State<CallScreen> with TickerProviderStateMixin {
  HeadlessInAppWebView? headlessWebView;
  String url = "";
  String _result = '';
  double pad = 30;
  double bsize = 40;
  bool isLoading = true;
  String _recognizedSpeech = 'Good Morning';
  final SpeechRecognition _speechRecognition = SpeechRecognition();
  TextToSpeech tts = TextToSpeech();
  final wordGenerator = WordGenerator();
  List<IconData> loadingIcon = [
    Icons.circle,
    Icons.circle_outlined,
  ];
  int loading = 1;

  @override
  void initState() {
    super.initState();
    initScrape();
    headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(
          url: Uri.parse(
              "https://you.com/search?q=${_recognizedSpeech.replaceAll(' ', '+')}&tbm=youchat")),
      onWebViewCreated: (controller) async {},
      onConsoleMessage: (controller, consoleMessage) {
        if (consoleMessage.message.contains('[Report Only]')) {
          print('Error Found');
        } else {
          print(consoleMessage.message);
        }
        if (consoleMessage.message.contains('geolocation')) {
          isLoading = false;
          setState(() {
            loading = 1;
          });
          Future.delayed(const Duration(seconds: 8), () {
            getAnswer();
            print(_result);
          });
          // const snackBar = SnackBar(
          //   backgroundColor: Colors.black45,
          //   content: Text(
          //     'Please wait...',
          //     style: TextStyle(color: Colors.white),
          //   ),
          //   duration: Duration(seconds: 8),
          // );
          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      onLoadStart: (controller, url) async {},
      onLoadStop: (controller, url) async {},
    );
  }

  Future initScrape() async {
    isLoading = true;
    await headlessWebView?.dispose();
    await headlessWebView?.run();
  }

  Future recognizeSpeach() async {
    String recognizedSpeech = await _speechRecognition.recognizeSpeech();
    setState(() {
      _recognizedSpeech = recognizedSpeech;
    });
  }

  Future reloadUrl() async {
    isLoading = true;
    var url = Uri.parse(
        "https://you.com/search?q=${_recognizedSpeech.replaceAll(' ', '+')}&fromSearchBar=true&tbm=youchat");
    await headlessWebView?.webViewController
        .loadUrl(urlRequest: URLRequest(url: url));
  }

  Future reply() async {
    tts.stop();
    ScaffoldMessenger.of(context).clearSnackBars();
    await recognizeSpeach();
    print(_recognizedSpeech);
    await reloadUrl();
  }

  Future getAnswer() async {
    if (!isLoading) {
      if (headlessWebView?.isRunning() ?? false) {
        String? answer = await headlessWebView?.webViewController
            .evaluateJavascript(
                source:
                    'var elements = document.querySelectorAll("#chatHistory > * > * > * > p");var mergedText = "";for (var i = 0; i < elements.length; i++) {mergedText += elements[i].innerText.trim().replace(/\\s+/g, " ");}');

        // print(result);
        setState(() {
          _result = answer!;
          loading = 0;
        });
      }
      Future.delayed(const Duration(milliseconds: 50), () {
        tts.speak(_result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Call Bot'),
        actions: <Widget>[
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(loadingIcon[loading],),
              )
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              const CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.pink,
                  child:
                      Icon(Icons.person, size: 60, semanticLabel: 'Call Bot')),
              const SizedBox(
                height: 10,
              ),
              Text(_recognizedSpeech),
              Text(_result),
              const Text('calling via airtel'),
              const Text(
                'Call Bot',
                style: TextStyle(fontSize: 50),
              ),
              const Text('Mobile +91 10101 01010'),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        padding: EdgeInsets.all(pad),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageGet(_recognizedSpeech),
                            ),
                          );
                        },
                        icon: const Icon(Icons.mic_off_outlined),
                        tooltip: 'Mute',
                        iconSize: bsize,
                      ),
                      IconButton(
                        padding: EdgeInsets.all(pad),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MyWebView(_recognizedSpeech),
                            ),
                          );
                        },
                        icon: const Icon(Icons.dialpad),
                        tooltip: 'Keypad',
                        iconSize: bsize,
                      ),
                      IconButton(
                        padding: EdgeInsets.all(pad),
                        onPressed: () {
                          initScrape();
                          // await headlessWebView?.dispose();
                          // await headlessWebView?.run();
                        },
                        icon: const Icon(Icons.volume_up_outlined),
                        tooltip: 'Speaker',
                        iconSize: bsize,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.all(pad),
                    onPressed: () {
                      getAnswer();
                    },
                    icon: const Icon(Icons.add_ic_call_outlined),
                    tooltip: 'Add Call',
                    iconSize: bsize,
                  ),
                  IconButton(
                    padding: EdgeInsets.all(pad),
                    onPressed: () {
                      reloadUrl();
                    },
                    icon: const Icon(Icons.sim_card_outlined),
                    tooltip: 'Change SIM',
                    iconSize: bsize,
                  ),
                  IconButton(
                    padding: EdgeInsets.all(pad),
                    onPressed: () async {
                      setState(() {
                        _recognizedSpeech = wordGenerator.randomSentence(2);
                      });
                      await reloadUrl();
                    },
                    icon: const Icon(Icons.record_voice_over),
                    tooltip: 'Record',
                    iconSize: bsize,
                  ),
                ],
              ),
              const SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 40,
                      child: IconButton(
                        onPressed: () async {
                          await reply();
                        },
                        icon: const Icon(
                          Icons.call_outlined,
                          color: Colors.black,
                        ),
                        iconSize: bsize,
                        tooltip: 'End Call',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 40,
                        child: IconButton(
                          onPressed: () {
                            tts.stop();
                            ScaffoldMessenger.of(context).clearSnackBars();
                          },
                          icon: const Icon(
                            Icons.call_end_outlined,
                            color: Colors.black,
                          ),
                          iconSize: bsize,
                          tooltip: 'End Call',
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speechRecognition.cancelRecognition();
    super.dispose();
  }
}
