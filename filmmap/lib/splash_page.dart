import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:filmmap/home_page.dart';
import 'dart:io';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  VideoPlayerController? _controller;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset('assets/splashVideo.mp4');

    try {
      await _controller!.initialize();
      if (_isOffline) return;

      _controller!.play();
      _controller!.addListener(() {
        if (_controller!.value.position == _controller!.value.duration) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      });
      setState(() {});
    } catch (e) {
      // Handle initialization error if necessary
    }
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _isOffline = true;
      });
    } else {
      _initializeVideo();
    }
  }

  void _exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isOffline
            ? _buildNoInternetWarning()
            : (_controller?.value.isInitialized ?? false)
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : const CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildNoInternetWarning() {
    return AlertDialog(
      icon: const Icon(Icons.warning, color: Colors.red),
      title: const Text('Internet bağlantısı'),
      content: const Text(
          'Lütfen internet bağlantınızı kontrol edip yeniden deneyiniz.'),
      actions: [
        TextButton(
          onPressed: _exitApp,
          child: const Text('Tamam'),
        ),
      ],
    );
  }
}
