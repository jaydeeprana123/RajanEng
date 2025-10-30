import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool> checkNet(BuildContext context) async {
  var connectivityResult = await Connectivity().checkConnectivity();

  // Check if any of the connectivity results indicate an active connection
  bool isConnected = connectivityResult.any((result) =>
      result == ConnectivityResult.mobile ||
      result == ConnectivityResult.wifi ||
      result == ConnectivityResult.ethernet);

  if (isConnected) {
    // Connected to internet
    return true;
  } else {
    // No internet connection
    if (context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Check Your Internet Connection"),
        ));
      });
    }
    return false;
  }
}

class InternetConnection extends StatefulWidget {
  const InternetConnection({Key? key}) : super(key: key);

  @override
  _InternetConnectionState createState() => _InternetConnectionState();
}

class _InternetConnectionState extends State<InternetConnection> {
  String _strConnectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Internet Connection Status'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getConnectionIcon(),
              size: 64,
              color: _getConnectionColor(),
            ),
            const SizedBox(height: 16),
            Text(
              'Connection Status:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              _strConnectionStatus,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: _getConnectionColor(),
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getConnectionIcon() {
    switch (_strConnectionStatus) {
      case 'Wi-Fi':
        return Icons.wifi;
      case 'Mobile':
        return Icons.signal_cellular_4_bar;
      case 'Ethernet':
        return Icons.settings_ethernet;
      case 'Bluetooth':
        return Icons.bluetooth;
      case 'No connection':
        return Icons.signal_wifi_off;
      default:
        return Icons.help_outline;
    }
  }

  Color _getConnectionColor() {
    switch (_strConnectionStatus) {
      case 'Wi-Fi':
      case 'Mobile':
      case 'Ethernet':
      case 'Bluetooth':
        return Colors.green;
      case 'No connection':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    _initConnectivity();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> resultList) {
        _updateConnectionStatus(resultList);
      },
      onError: (error) {
        setState(() {
          _strConnectionStatus = 'Connection error: $error';
        });
      },
    );
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Connectivity check failed: $e');
      result = [ConnectivityResult.none];
    }

    if (!mounted) {
      return;
    }

    return _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> resultList) {
    setState(() {
      if (resultList.isEmpty) {
        _strConnectionStatus = 'No connection';
        return;
      }

      // Handle multiple connection types - prioritize the "best" connection
      if (resultList.contains(ConnectivityResult.wifi)) {
        _strConnectionStatus = 'Wi-Fi';
      } else if (resultList.contains(ConnectivityResult.ethernet)) {
        _strConnectionStatus = 'Ethernet';
      } else if (resultList.contains(ConnectivityResult.mobile)) {
        _strConnectionStatus = 'Mobile';
      } else if (resultList.contains(ConnectivityResult.bluetooth)) {
        _strConnectionStatus = 'Bluetooth';
      } else if (resultList.contains(ConnectivityResult.none)) {
        _strConnectionStatus = 'No connection';
      } else {
        _strConnectionStatus = 'Unknown';
      }
    });
  }

  // Alternative method if you want to navigate back when connected
  void _updateConnectionStatusWithNavigation(
      List<ConnectivityResult> resultList) {
    bool hasConnection = resultList.any((result) =>
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet);

    if (hasConnection && mounted) {
      Navigator.pop(context);
    } else {
      setState(() {
        _strConnectionStatus = "Please Connect WiFi or Mobile Data";
      });
    }
  }
}
