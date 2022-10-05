import 'dart:io';

import 'package:browser/Screens/webapp/provider/browserProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({Key? key}) : super(key: key);

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  BrowserProvider? _browserProvidertrue;
  BrowserProvider? _browserProviderfalse;
  InAppWebViewController? _inAppWebViewController;
  TextEditingController _search = TextEditingController();
  FocusNode _focusNode = FocusNode();
  late PullToRefreshController _pullToRefreshController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _search = TextEditingController(
        text: Provider.of<BrowserProvider>(context, listen: false).url);
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _search.selection =
            TextSelection(baseOffset: 0, extentOffset: _search.text.length);
      }
    });
  }

  Widget build(BuildContext context) {
    _browserProvidertrue = Provider.of<BrowserProvider>(context, listen: true);
    _browserProviderfalse =
        Provider.of<BrowserProvider>(context, listen: false);
    _pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Color(0xff000000),
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          _inAppWebViewController?.reload();
        }
      },
    );

    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: dialog,
          child: Center(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: TextField(
                        focusNode: _focusNode,
                        onSubmitted: (value) {
                          HapticFeedback.mediumImpact();
                          _inAppWebViewController!.loadUrl(
                            urlRequest: URLRequest(
                              url: Uri.parse(
                                  'https://www.google.com/search?q=${_search.text}'),
                            ),
                          );
                        },
                        textInputAction: TextInputAction.search,
                        controller: _search,
                        decoration: InputDecoration(
                          fillColor: Color(0xffe8e8e8),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff888888), width: 1.5),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          hintText: 'Type Url Here',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xff888888), width: 1.5),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        cursorColor: Color(0xff000000),
                      )),
                      IconButton(
                          onPressed: () {
                            _inAppWebViewController!.loadUrl(
                              urlRequest: URLRequest(
                                url: Uri.parse(
                                    'https://www.google.com/search?q=${_search.text}'),
                              ),
                            );
                          },
                          icon: Icon(Icons.search)),
                      PopupMenuButton(
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                                onTap: () {
                                  _inAppWebViewController!.reload();
                                },
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.refresh),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Reload'),
                                  ],
                                )),
                            PopupMenuItem(
                                onTap: () {
                                  _inAppWebViewController!.goBack();
                                },
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.arrow_left),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('Back'),
                                  ],
                                )),
                            PopupMenuItem(
                              onTap: () {
                                _inAppWebViewController!.goForward();
                              },
                              child: Row(
                                children: [
                                  Icon(CupertinoIcons.arrow_right),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text('Previous'),
                                ],
                              ),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: InAppWebView(
                      initialUrlRequest: URLRequest(
                        url: Uri.parse(_browserProvidertrue!.url),
                      ),
                      initialOptions: options,
                      pullToRefreshController: _pullToRefreshController,
                      androidOnPermissionRequest:
                          (controller, origin, resources) async {
                        return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT);
                      },
                      onLoadError: (controller, url, code, message) {
                        _browserProviderfalse!.changeurl(url.toString());
                        _inAppWebViewController = controller;
                        setState(() {
                          _search = TextEditingController(text: url.toString());
                        });
                      },
                      onLoadStart: (controller, url) {
                        _browserProviderfalse!.changeurl(url.toString());
                        _inAppWebViewController = controller;
                        setState(() {
                          _search = TextEditingController(text: url.toString());
                        });
                      },
                      onLoadStop: (controller, url) {
                        _browserProviderfalse!.changeurl(url.toString());
                        _inAppWebViewController = controller;
                        setState(() {
                          _search = TextEditingController(text: url.toString());
                        });
                      },

                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> dialog() async {
    back();
    return await false;
  }

  void back() {
    if (_search.text == 'https://www.google.com/') {
      showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              content: Text(
                '!! You Want to Quit Browser ? !!',
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                CupertinoButton(
                    child: Text(
                      'Yes',
                      style: TextStyle(color: Color(0xffff0000)),
                    ),
                    onPressed: () {
                      exit(0);
                    }),
                CupertinoButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            );
          });
    } else {
      _inAppWebViewController!.goBack();
    }
  }
}
