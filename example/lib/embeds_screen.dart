import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'main.dart';

class EmbedsScreen extends StatefulWidget {
  @override
  _EmbedsScreenState createState() => new _EmbedsScreenState();
}

class _EmbedsScreenState extends State<EmbedsScreen> {
  InAppWebViewController _youTubeWebView;
  InAppWebViewController _twitterWebView;
  String url = "";
  Key _key = UniqueKey();

  double _height = 300;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _updateKey() {
    setState(() {
      _key = UniqueKey();
    });
  }

  void _setHeight() async {
    final value = await _twitterWebView.evaluateJavascript(
      source: '''(() => {
        return document.getElementById("tweet").clientHeight;
      })()''',
    );
    if (value == null || value == '') {
      return;
    }
    final docHeight = double.parse('$value');
    print('Tweet height: $docHeight');

    setState(() {
      _height = docHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Embeds",
        ),
      ),
      drawer: myDrawer(context: context),
      body: SafeArea(
        key: _key,
        child: Column(
          children: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _updateKey,
                    icon: Icon(Icons.refresh),
                  ),
                  IconButton(
                    onPressed: _setHeight,
                    icon: Icon(Icons.crop),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: InAppWebView(
                        initialData: InAppWebViewInitialData(
                          data: '''
                          <!DOCTYPE html>
                          <html lang="en">

                          <head>
                              <meta charset="UTF-8">
                              <meta name="viewport"
                                  content="width=device-width, user-scalable=no, initial-scale=0.5, maximum-scale=0.5, minimum-scale=0.5">
                              <meta http-equiv="X-UA-Compatible" content="ie=edge">

                              <style>
                                  * {
                                      padding: 0;
                                      margin: 0;
                                      height: 100%;
                                      line-height: 0;
                                      font-size: 0;
                                  }
                              </style>
                          </head>

                          <body>
                              <iframe
                                fs="1"
                                hl="ar"
                                rel="0"
                                width="100%"
                                height="100%"
                                controls="0"
                                frameborder="0"
                                modestbranding="1"
                                playsinline="1"
                                autoplay="1"
                                allowfullscreen
                                src="https://www.youtube.com/embed/HZtc5-syeAk"
                                allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
                                  />
                          </body>

                          </html>
                          ''',
                        ),
                        initialOptions: InAppWebViewGroupOptions(
                          ios: IOSInAppWebViewOptions(
                            allowsInlineMediaPlayback: false,
                            allowsBackForwardNavigationGestures: false,
                            disallowOverScroll: true,
                          ),
                          crossPlatform: InAppWebViewOptions(
                            debuggingEnabled: true,
                            disableContextMenu: true,
                            mediaPlaybackRequiresUserGesture: false,
                            useShouldOverrideUrlLoading: true,
                          ),
                        ),
                        shouldOverrideUrlLoading: (controller, request) async {
                          // return ShouldOverrideUrlLoadingAction.CANCEL;
                          if (Platform.isIOS &&
                              request.iosWKNavigationType == IOSWKNavigationType.LINK_ACTIVATED &&
                              request.url.contains("youtube")) {
                            return ShouldOverrideUrlLoadingAction.CANCEL;
                          }
                          return ShouldOverrideUrlLoadingAction.ALLOW;
                        },
                        onWebViewCreated: (InAppWebViewController controller) {
                          _youTubeWebView = controller;
                        },
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(20.0),
                      height: _height + 40.0,
                      child: InAppWebView(
                        initialData: InAppWebViewInitialData(
                          data: '''
                          <!DOCTYPE html>
                          <html>

                          <head>
                              <meta charset="UTF-8">
                              <meta name="viewport"
                                  content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
                              <meta http-equiv="X-UA-Compatible" content="ie=edge">

                              <style>
                                  html,
                                  body {
                                      background-color: white;
                                      padding: 0;
                                      margin: 0;
                                      height: 100%;
                                      line-height: 0;
                                      font-size: 0;
                                  }

                                  .twitter-tweet {
                                      margin: 0 auto !important;
                                  }
                              </style>
                          </head>

                          <body>
                              <div id="tweet"></div>

                              <script src="https://cdn.jsdelivr.net/npm/twitter-widgets@2.0.0/index.min.js"></script>

                              <script>
                                  console.log('Hello!');

                                  function init() {

                                      TwitterWidgetsLoader.load(function (err, twttr) {
                                          twttr.widgets.createTweet(
                                              "1285569646624739331",
                                              // "20",
                                              document.getElementById("tweet"),
                                              {
                                                  lang: 'ar',
                                                  conversation: 'none',
                                                  linkColor: '#319795',
                                                  theme: 'light' === 'dark' ? 'dark' : 'light',
                                                  dnt: true,
                                                  align: 'center',
                                                  size: 'large',
                                              }
                                          );
                                      });
                                  }
                                  (function () {
                                      init();
                                  })();
                              </script>
                          </body>

                          </html>
                          ''',
                        ),
                        initialOptions: InAppWebViewGroupOptions(
                          ios: IOSInAppWebViewOptions(
                            allowsInlineMediaPlayback: false,
                            allowsBackForwardNavigationGestures: false,
                            disallowOverScroll: true,
                          ),
                          android: AndroidInAppWebViewOptions(
                            builtInZoomControls: false,
                          ),
                          crossPlatform: InAppWebViewOptions(
                            debuggingEnabled: true,
                            disableContextMenu: true,
                            mediaPlaybackRequiresUserGesture: false,
                            useShouldOverrideUrlLoading: true,
                          ),
                        ),
                        shouldOverrideUrlLoading: (controller, request) async {
                          // return ShouldOverrideUrlLoadingAction.CANCEL;
                          if (!request.url.contains("twitter")) {
                            return ShouldOverrideUrlLoadingAction.CANCEL;
                          }
                          return ShouldOverrideUrlLoadingAction.ALLOW;
                        },
                        onWebViewCreated: (InAppWebViewController controller) {
                          _twitterWebView = controller;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
