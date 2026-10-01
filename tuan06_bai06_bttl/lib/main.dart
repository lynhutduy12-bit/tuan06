import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const SimpleAudioPlayer());
}

class SimpleAudioPlayer extends StatelessWidget {
  const SimpleAudioPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Audio Player',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const AudioPlayerHome(),
    );
  }
}

class AudioPlayerHome extends StatefulWidget {
  const AudioPlayerHome({super.key});

  @override
  State<AudioPlayerHome> createState() => _AudioPlayerHomeState();
}

class _AudioPlayerHomeState extends State<AudioPlayerHome> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentSongIndex = 0;
  bool _isPlaying = false;
  bool _isStopped =
      true; // true = đang dừng hẳn (lần play tiếp theo phát từ đầu)

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  // Danh sách bài hát: đường dẫn TÍNH TỪ thư mục assets/ (AssetSource tự thêm "assets/")
  final List<String> _songs = ['audios/sample1.mp4', 'audios/sample2.mp4'];

  // Tên bài hát để hiển thị
  final List<String> _songTitles = ['sample1', 'sample2', 'sample3'];

  @override
  void initState() {
    super.initState();

    // Lắng nghe trạng thái phát để cập nhật icon Play/Pause
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (!mounted) return;
      setState(() => _isPlaying = state == PlayerState.playing);
    });

    // Thời lượng bài hát
    _audioPlayer.onDurationChanged.listen((d) {
      if (!mounted) return;
      setState(() => _duration = d);
    });

    // Vị trí đang phát
    _audioPlayer.onPositionChanged.listen((p) {
      if (!mounted) return;
      setState(() => _position = p);
    });

    // Hết bài thì tự chuyển bài tiếp theo
    _audioPlayer.onPlayerComplete.listen((event) {
      _nextSong();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Phát bài hiện tại từ đầu
  Future<void> _playFromStart() async {
    await _audioPlayer.stop();
    setState(() {
      _position = Duration.zero;
      _duration = Duration.zero;
    });
    await _audioPlayer.play(AssetSource(_songs[_currentSongIndex]));
    _isStopped = false;
  }

  // Play: nếu đang tạm dừng thì phát tiếp, nếu đã Stop thì phát lại từ đầu
  Future<void> _playSong() async {
    if (_isStopped) {
      await _playFromStart();
    } else {
      await _audioPlayer.resume();
    }
  }

  // Pause: tạm dừng, giữ nguyên vị trí
  Future<void> _pauseSong() async {
    await _audioPlayer.pause();
  }

  // Stop: dừng hẳn, đưa về đầu bài
  Future<void> _stopSong() async {
    await _audioPlayer.stop();
    setState(() {
      _isStopped = true;
      _position = Duration.zero;
    });
  }

  // Next: chuyển sang bài tiếp theo (hết danh sách thì quay về bài đầu)
  Future<void> _nextSong() async {
    setState(() {
      _currentSongIndex = (_currentSongIndex + 1) % _songs.length;
    });
    await _playFromStart();
  }

  // Previous: quay lại bài trước (đang ở bài đầu thì về bài cuối)
  Future<void> _previousSong() async {
    setState(() {
      _currentSongIndex =
          (_currentSongIndex - 1 + _songs.length) % _songs.length;
    });
    await _playFromStart();
  }

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    final maxMs = _duration.inMilliseconds.toDouble();
    final posMs = _position.inMilliseconds.toDouble().clamp(0.0, maxMs);

    return Scaffold(
      appBar: AppBar(title: const Text('Simple Audio Player')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Tên bài hát
              Text(
                _songTitles[_currentSongIndex],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Bài ${_currentSongIndex + 1}/${_songs.length}'),
              const SizedBox(height: 12),

              // Thanh tiến trình, kéo để tua
              Slider(
                min: 0,
                max: maxMs > 0 ? maxMs : 1,
                value: maxMs > 0 ? posMs : 0,
                onChanged: maxMs > 0
                    ? (v) =>
                          _audioPlayer.seek(Duration(milliseconds: v.toInt()))
                    : null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(_format(_position)), Text(_format(_duration))],
              ),
              const SizedBox(height: 12),

              // Nút điều khiển: Previous – Play/Pause – Stop – Next
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous, size: 40),
                    tooltip: 'Previous',
                    onPressed: _previousSong,
                  ),
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40,
                    ),
                    tooltip: _isPlaying ? 'Pause' : 'Play',
                    onPressed: _isPlaying ? _pauseSong : _playSong,
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop, size: 40),
                    tooltip: 'Stop',
                    onPressed: _stopSong,
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next, size: 40),
                    tooltip: 'Next',
                    onPressed: _nextSong,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
