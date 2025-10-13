import 'package:flutter/material.dart';
import 'package:proximaride_app/consts/constFileLink.dart';
import 'package:proximaride_app/consts/const_api.dart';
import 'package:proximaride_app/pages/widgets/second_appbar_widget.dart';
import 'package:proximaride_app/services/service.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CoffeeOnWall extends StatefulWidget {
  const CoffeeOnWall({super.key});

  @override
  State<CoffeeOnWall> createState() => _CoffeeOnWallState();
}

class _CoffeeOnWallState extends State<CoffeeOnWall> {
  late final WebViewController controller;
  final serviceController = Get.find<Service>();
  @override

  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {

          },
          onPageStarted: (String url) {

          },
          onPageFinished: (String url) {
            controller.runJavaScriptReturningResult(
                'document.querySelector(".hideheader").style.setProperty("display", "none", "important");'
                    'document.querySelector(".hidefooter").style.setProperty("display", "none", "important");'
                    'document.querySelector(".hideLanguageIcon").style.setProperty("display", "none", "important");'
                    'document.querySelector(".hideTopIcon").style.setProperty("display", "none", "important");'
            );
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.startsWith('https://www.youtube.com/')) {
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('$url/${serviceController.lang.value}/coffee-on-the-wall'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: secondAppBarWidget(
            title:
            serviceController.coffeeOnWallLabel.value,
            context: context),
        leading: const BackButton(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
