import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class MediaPickerHome extends StatefulWidget {
  const MediaPickerHome({super.key});
  @override
  State<MediaPickerHome> createState() => _MediaPickerHomeState();
}

class _MediaPickerHomeState extends State<MediaPickerHome> {
  File? _mediaFile;
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();

  Future<void> _requestPermission(Permission permission) async {
    if (await permission.isDenied) {
      await permission.request();
    }
  }

  void _showImage(XFile xfile) {
    _videoController?.dispose();
    setState(() {
      _mediaFile = File(xfile.path);
      _videoController = null;
    });
  }

  Future<void> _showVideo(XFile xfile) async {
    _videoController?.dispose();
    final controller = VideoPlayerController.file(File(xfile.path));
    setState(() {
      _mediaFile = File(xfile.path);
      _videoController = controller;
    });
    await controller.initialize();
    if (!mounted) return;
    setState(() {});
    controller.play();
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _pickImageFromGallery() async {
    await _requestPermission(Permission.photos);
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      _showImage(file);
    } else {
      _showMessage('Chưa chọn ảnh');
    }
  }

  Future<void> _capturePhoto() async {
    await _requestPermission(Permission.camera);
    final XFile? file = await _picker.pickImage(source: ImageSource.camera);
    if (file != null) {
      _showImage(file);
    } else {
      _showMessage('Chưa chụp ảnh');
    }
  }

  Future<void> _pickVideoFromGallery() async {
    await _requestPermission(Permission.photos);
    final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
    if (file != null) {
      await _showVideo(file);
    } else {
      _showMessage('Chưa chọn video');
    }
  }

  Future<void> _recordVideo() async {
    await _requestPermission(Permission.camera);
    await _requestPermission(Permission.microphone);
    final XFile? file = await _picker.pickVideo(source: ImageSource.camera);
    if (file != null) {
      await _showVideo(file);
    } else {
      _showMessage('Chưa quay video');
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget preview;
    if (_mediaFile == null) {
      preview = const Text('Chưa chọn ảnh hoặc video.');
    } else if (_videoController != null) {
      preview = _videoController!.value.isInitialized
          ? AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            )
          : const CircularProgressIndicator();
    } else {
      preview = Image.file(_mediaFile!, height: 300);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Media Picker App')),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              preview,
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImageFromGallery,
                child: const Text('Chọn ảnh từ Gallery'),
              ),
              ElevatedButton(
                onPressed: _capturePhoto,
                child: const Text('Chụp ảnh từ Camera'),
              ),
              ElevatedButton(
                onPressed: _pickVideoFromGallery,
                child: const Text('Chọn video từ Gallery'),
              ),
              ElevatedButton(
                onPressed: _recordVideo,
                child: const Text('Quay video từ Camera'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
