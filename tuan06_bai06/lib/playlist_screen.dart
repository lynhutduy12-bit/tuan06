import 'package:flutter/material.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryPink = Color(0xFFD81B60);
    const bgColor = Color(0xFF1F1F1F);

    return Container(
      color: bgColor,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF381028), Color(0xFF1F1F1F)],
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    'SONG TITLE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'ARTIST',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      letterSpacing: 2.0,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      thumbColor: primaryPink,
                      activeTrackColor: primaryPink,
                      inactiveTrackColor: primaryPink.withOpacity(0.3),
                      trackHeight: 2.0,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 5,
                      ),
                    ),
                    child: Slider(value: 0.4, onChanged: (value) {}),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.skip_previous, color: primaryPink, size: 28),
                      Icon(
                        Icons.play_circle_filled,
                        color: primaryPink,
                        size: 40,
                      ),
                      Icon(Icons.skip_next, color: primaryPink, size: 28),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                itemCount: 7,
                separatorBuilder: (context, index) => Divider(
                  color: primaryPink.withOpacity(0.5),
                  height: 1,
                  indent: 60,
                  endIndent: 20,
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30,
                          child: Text(
                            '${index + 1}.',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(width: 24, height: 24, color: primaryPink),
                        const SizedBox(width: 15),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Title',
                                style: TextStyle(
                                  color: primaryPink,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Artist',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          '3:00',
                          style: TextStyle(color: primaryPink, fontSize: 14),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.more_vert,
                          color: primaryPink,
                          size: 20,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
