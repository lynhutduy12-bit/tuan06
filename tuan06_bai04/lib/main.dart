import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const VideoRecorderApp());
}

class VideoRecorderApp extends StatelessWidget {
  const VideoRecorderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Recorder & Playback',
      theme: ThemeData(colorSchemeSeed: Colors.purple, useMaterial3: true),
      home: const VideoRecorderHome(),
    );
  }
}

class VideoRecorderHome extends StatefulWidget {
  const VideoRecorderHome({super.key});

  @override
  State<VideoRecorderHome> createState() => _VideoRecorderHomeState();
}

class _VideoRecorderHomeState extends State<VideoRecorderHome> {
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // Yêu cầu quyền, trả về true nếu được cấp
  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted || status.isLimited;
  }

  // Thông báo ngắn
  void _showMessage(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  // Chọn video từ gallery
  // image_picker dùng trình chọn ảnh của hệ thống nên không cần xin quyền bộ nhớ
  Future<void> _pickVideoFromGallery() async {
    final XFile? pickedFile = await _picker.pickVideo(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      await _loadVideo(File(pickedFile.path));
    } else {
      _showMessage('Chưa chọn video nào');
    }
  }

  // Quay video từ camera (cần quyền camera + micro để ghi âm)
  Future<void> _recordVideoFromCamera() async {
    final cameraOk = await _requestPermission(Permission.camera);
    final micOk = await _requestPermission(Permission.microphone);
    if (!cameraOk || !micOk) {
      _showMessage('Vui lòng cấp quyền Camera và Micro để quay video');
      return;
    }

    final XFile? recordedFile = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 30),
    );
    if (recordedFile != null) {
      await _loadVideo(File(recordedFile.path));
    } else {
      _showMessage('Chưa quay video nào');
    }
  }

  // Tải và khởi tạo video
  Future<void> _loadVideo(File videoFile) async {
    setState(() => _isLoading = true);

    // Giải phóng controller cũ trước khi tạo mới
    final oldController = _videoController;
    _videoController = null;
    await oldController?.dispose();

    final controller = VideoPlayerController.file(videoFile);
    try {
      await controller.initialize();
    } catch (e) {
      await controller.dispose();
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showMessage('Không phát được video: $e');
      return;
    }

    // Lắng nghe thay đổi (đang phát / dừng / hết video) để cập nhật icon
    controller.addListener(() {
      if (mounted) setState(() {});
    });

    if (!mounted) {
      await controller.dispose();
      return;
    }
    setState(() {
      _videoController = controller;
      _isLoading = false;
    });
    controller.play();
  }

  // Play / Pause (nếu video đã hết thì phát lại từ đầu)
  void _togglePlayPause() {
    final c = _videoController;
    if (c == null) return;

    if (c.value.isPlaying) {
      c.pause();
    } else {
      final ended = c.value.position >= c.value.duration;
      if (ended) c.seekTo(Duration.zero);
      c.play();
    }
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  Widget _buildVideoArea() {
    if (_isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final c = _videoController;
    if (c == null || !c.value.isInitialized) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text('Chưa có video nào được chọn.')),
      );
    }

    return Column(
      children: [
        AspectRatio(
          aspectRatio: c.value.aspectRatio,
          child: GestureDetector(
            onTap: _togglePlayPause, // chạm vào video cũng play/pause được
            child: VideoPlayer(c),
          ),
        ),
        // Thanh tiến trình, có thể kéo để tua
        VideoProgressIndicator(c, allowScrubbing: true),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatDuration(c.value.position)),
              Text(_formatDuration(c.value.duration)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = _videoController;
    final isPlaying = c?.value.isPlaying ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Video Recorder & Playback')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildVideoArea(),
            const SizedBox(height: 12),

            // Nút play/pause chỉ hiện khi đã có video
            if (c != null && c.value.isInitialized)
              ElevatedButton(
                onPressed: _togglePlayPause,
                child: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickVideoFromGallery,
              icon: const Icon(Icons.video_library),
              label: const Text('Chọn video từ Gallery'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _recordVideoFromCamera,
              icon: const Icon(Icons.videocam),
              label: const Text('Quay video từ Camera'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
