import 'dart:io';

import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';

void main() {
  ///Configure your debug options (settings used in development mode)
  CatcherOptions debugOptions = CatcherOptions(

      ///Show information about caught error in dialog
      SilentReportMode(),
      [
        DiscordHandler(
            "https://discord.com/api/webhooks/880254205762343012/GP-Dmk7wJn_f5rxnTVIVJ3Uaon585gD9JetwyqYt6YasK3xZB-muMICoxB6e55pQ8UuH",
            enableDeviceParameters: true,
            enableApplicationParameters: true,
            enableCustomParameters: true,
            enableStackTrace: true,
            printLogs: true)

        ///Send logs to HTTP server
        // HttpHandler(HttpRequestType.post,
        //     Uri.parse("https://jsonplaceholder.typicode.com/posts"),
        //     printLogs: true),

        // ///Print logs in console
        // ConsoleHandler()
      ],
      screenshotsPath: Directory.systemTemp.path);

  ///Configure your production options (settings used in release mode)
  CatcherOptions releaseOptions = CatcherOptions(
    ///Show new page with information about caught error
    PageReportMode(),
    [
      ///Send logs to Sentry

      ///Print logs in console
      ConsoleHandler(),
    ],
  );

  ///Start Catcher and then start App. Now Catcher will guard and report any
  ///error to your configured services!
  Catcher(
    runAppFunction: () {
      runApp(MyApp());
    },
    debugConfig: debugOptions,
    releaseConfig: releaseOptions,
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ///Last step: add navigator key of Catcher here, so Catcher can show
      ///page and dialog!
      navigatorKey: Catcher.navigatorKey,
      home: CatcherScreenshot(
        catcher: Catcher.getInstance(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Catcher example"),
          ),
          body: ChildWidget(),
        ),
      ),
    );
  }
}

class ChildWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        child: Text("Generate error"),
        onPressed: () => generateError(),
      ),
    );
  }

  ///Simply just trigger some error.
  void generateError() async {
    Catcher.sendTestException();
  }
}
