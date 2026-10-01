import 'package:flutter/material.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryPink = Color(0xFFD81B60);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C0B1E), Color(0xFF0F040A)],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: Text(
                'ALBUM',
                style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 2.0,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 260,
                  height: 260,
                  child: CircularProgressIndicator(
                    value: 0.65,
                    strokeWidth: 3,
                    color: Colors.white,
                    backgroundColor: Colors.white,
                  ),
                ),
                Container(
                  width: 210,
                  height: 210,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 15,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: 5,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: primaryPink,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Column(
              children: [
                Text(
                  'SONG TITLE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'ARTIST',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 30,
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.menu, color: Colors.black54),
                      const SizedBox(height: 15),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.skip_previous,
                            color: primaryPink,
                            size: 28,
                          ),
                          Icon(Icons.favorite, color: primaryPink, size: 28),
                          Icon(Icons.share, color: primaryPink, size: 28),
                          Icon(Icons.skip_next, color: primaryPink, size: 28),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SliderTheme(
                        data: SliderThemeData(
                          thumbColor: primaryPink,
                          activeTrackColor: primaryPink,
                          inactiveTrackColor: primaryPink.withOpacity(0.3),
                          trackHeight: 2.0,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 14,
                          ),
                        ),
                        child: Slider(value: 0.65, onChanged: (value) {}),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 50,
                  color: const Color(0xFF1E0A16),
                  child: const Center(
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white54,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
