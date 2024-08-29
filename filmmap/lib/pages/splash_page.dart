import 'package:filmmap/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset('assets/splashVideo.mp4');

    try {
      await _controller!.initialize();
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

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: (_controller?.value.isInitialized ?? false)
            ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              )
            : const CircularProgressIndicator(
                color: Colors.blue,
              ),
      ),
    );
  }
}
