import 'dart:async';
import 'dart:io';

import 'package:check_connection/notifier.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

void main() async {
  final hasConnection = await InternetConnectionChecker().hasConnection;
  runApp(ConectionNotifier(
    notifier: ValueNotifier(hasConnection),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: false,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late final StreamSubscription<InternetConnectionStatus> listener;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  bool isConnected = false;
  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isConnected = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isConnected = false;
      });
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
    listener = InternetConnectionChecker().onStatusChange.listen((status) {
      final notifier = ConectionNotifier.of(context);
      notifier.value =
          status == InternetConnectionStatus.connected ? true : false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    listener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final hasConnection = ConectionNotifier.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(hasConnection.value ? Icons.wifi : Icons.wifi_off),
                const SizedBox(
                  width: 8,
                ),
                Text(hasConnection.value
                    ? 'Internet Coneccted'
                    : 'Internet not Conected')
              ],
            ),
            // ElevatedButton(
            //   onPressed: checkInternetConnection,
            //   child: const Text('Check Internet'),
            // )
          ],
        ),
      ),
    );
  }
}
