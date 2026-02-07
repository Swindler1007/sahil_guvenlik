// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoTestPage extends StatefulWidget {
  const VideoTestPage({super.key});

  @override
  _VideoTestPageState createState() => _VideoTestPageState();
}

class _VideoTestPageState extends State<VideoTestPage> {
  final List<Map<String, String>> testVideos = [
    {'name': 'TEST VİDEO (Çalışan)', 'path': 'assets/videos/test_video.mp4'},
    {'name': 'Arama Kararı', 'path': 'assets/videos/arama_karari.mp4'},
    {'name': 'Bilgi Alma', 'path': 'assets/videos/bilgi_alma_tutanagi.mp4'},
  ];

  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  String _currentVideo = '';
  String _status = '';

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> _testVideo(String videoPath, String videoName) async {
    // Öncekileri temizle - await kaldırıldı
    _chewieController?.dispose();
    await _controller?.dispose();

    setState(() {
      _controller = null;
      _chewieController = null;
      _currentVideo = videoName;
      _status = 'Yükleniyor...';
    });

    try {
      print('🔄 Video yükleniyor: $videoPath');

      _controller = VideoPlayerController.asset(videoPath);
      await _controller!.initialize();

      print('✅ Video başarıyla yüklendi: $videoPath');

      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: _controller!,
          autoPlay: true,
          looping: false,
          showControls: true,
          // Error handling ekle
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                'Video oynatılamadı!\n$errorMessage',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        );
        _status = '✅ BAŞARILI! Video çalışıyor';
      });
    } catch (e) {
      print('❌ HATA: $e');
      setState(() {
        _status = '❌ HATA: ${e.toString()}';
      });

      // Hata durumunda controller'ları temizle
      _controller?.dispose();
      _chewieController?.dispose();
      setState(() {
        _controller = null;
        _chewieController = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Test Sayfası')),
      body: Column(
        children: [
          Container(
            height: 200,
            child: ListView.builder(
              itemCount: testVideos.length,
              itemBuilder: (context, index) {
                final video = testVideos[index];
                return Card(
                  margin: EdgeInsets.all(4),
                  child: ListTile(
                    leading: Icon(Icons.videocam, color: Colors.blue),
                    title: Text(video['name']!, style: TextStyle(fontSize: 14)),
                    subtitle:
                        Text(video['path']!, style: TextStyle(fontSize: 10)),
                    trailing: Icon(Icons.play_arrow),
                    onTap: () => _testVideo(video['path']!, video['name']!),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color:
                _status.contains('HATA') ? Colors.red[100] : Colors.green[100],
            child: Column(
              children: [
                Text('Şu anki video: $_currentVideo',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Durum: $_status',
                    style: TextStyle(
                      color:
                          _status.contains('HATA') ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
          ),
          Expanded(
            child: _chewieController != null &&
                    _controller != null &&
                    _controller!.value.isInitialized
                ? Chewie(controller: _chewieController!)
                : Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.videocam_off,
                              size: 50, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('Video seçiniz', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          if (_status.contains('HATA'))
                            Text(
                              'Not: Test videosu çalışıyorsa,\ndiğer videoların formatı bozuk',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: Colors.red),
                            ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
