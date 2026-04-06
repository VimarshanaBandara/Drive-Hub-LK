import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Your real screens
import 'package:drive_hub_lk_srilanka/homePage.dart';
import 'package:drive_hub_lk_srilanka/pass_papers_screen/pass_papers_home.dart';
import 'package:drive_hub_lk_srilanka/syllabus_screen/syllabus_home.dart';
import 'package:drive_hub_lk_srilanka/map_screen/learners_map_screen.dart';

class HomeMenuScreen extends StatelessWidget {
  const HomeMenuScreen({super.key});

  static const _privacyUrl =
      'https://sites.google.com/view/drive-hub-lk-privacy-policy/home';
  static const _supportEmail =
      'mailto:vmmobilesolution@gmail.com?subject=Drive%20Hub%20LK%20Support';

  @override
  Widget build(BuildContext context) {
    final items = <_MenuItem>[
      _MenuItem('Road Signals', 'Learn • Quiz', Icons.traffic_rounded,
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => const HomePage()))),
      _MenuItem(
          'Pass Papers', 'Part 1 • Part 2 • Part 3', Icons.menu_book_rounded,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const PassPapersHome()))),
      _MenuItem('Syllabus', 'Gov. Gazette based', Icons.description_rounded,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SyllabusHome()))),
      _MenuItem('Centres Map', 'Licence & Medical', Icons.map_rounded,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => const LearnersMapScreen()))),
      _MenuItem('Privacy Policy', 'Read policy', Icons.privacy_tip_rounded,
          onTap: () => launchUrl(Uri.parse(_privacyUrl),
              mode: LaunchMode.externalApplication)),
      _MenuItem('Support', 'Contact us', Icons.support_agent_rounded,
          onTap: () => launchUrl(Uri.parse(_supportEmail),
              mode: LaunchMode.externalApplication)),
    ];

    // vivid gradients (cycled across cards)
    final grads = <List<Color>>[
      [const Color(0xFF6D28D9), const Color(0xFFDB2777)],
      [const Color(0xFF2563EB), const Color(0xFF22D3EE)],
      [const Color(0xFF14B8A6), const Color(0xFFA3E635)],
      [const Color(0xFFF97316), const Color(0xFFF59E0B)],
      [const Color(0xFFEC4899), const Color(0xFFEF4444)],
      [const Color(0xFF6366F1), const Color(0xFF10B981)],
    ];

    final w = MediaQuery.of(context).size.width;
    final cols = w >= 1100
        ? 4
        : w >= 820
            ? 3
            : 2;

    final topPad = MediaQuery.of(context).padding.top + 110; // space for header

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 46, // smaller app bar
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Drive Hub LK',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 16)),
            Text(
              '1.0.5+7',
              style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          // full gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF7C3AED),
                  Color(0xFF2563EB),
                  Color(0xFF06B6D4)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // soft blobs
          Positioned(top: -60, left: -30, child: _blob(200, Colors.white24)),
          Positioned(
              bottom: -70, right: -40, child: _blob(240, Colors.white24)),

          // header text (no white sheet)
          Positioned(
            left: 16,
            right: 16,
            top: MediaQuery.of(context).padding.top + 56,
            child: const _Header(),
          ),

          // colorful grid
          GridView.builder(
            padding: EdgeInsets.fromLTRB(16, topPad, 16, 22),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.02,
            ),
            itemBuilder: (_, i) =>
                _ColorCard(item: items[i], gradient: grads[i % grads.length]),
          ),
        ],
      ),
    );
  }

  Widget _blob(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      );
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Quick Menu',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 20)),
        SizedBox(height: 4),
        Text('Choose where you want to go',
            style: TextStyle(
                color: Color(0xFFE2E8F0), fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _MenuItem {
  final String title, subtitle;
  final IconData icon;
  final VoidCallback onTap;
  _MenuItem(this.title, this.subtitle, this.icon, {required this.onTap});
}

class _ColorCard extends StatefulWidget {
  final _MenuItem item;
  final List<Color> gradient;
  const _ColorCard({required this.item, required this.gradient});

  @override
  State<_ColorCard> createState() => _ColorCardState();
}

class _ColorCardState extends State<_ColorCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final g = widget.gradient;
    return AnimatedScale(
      scale: _pressed ? 0.98 : 1,
      duration: const Duration(milliseconds: 110),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: widget.item.onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: g,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: g.first.withOpacity(.28),
                blurRadius: 16,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(1.4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(.12),
                  Colors.white.withOpacity(.06)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.22),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(widget.item.icon, color: Colors.white, size: 30),
                ),
                const Spacer(),
                Text(widget.item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: Text(widget.item.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Color(0xFFF1F5F9),
                              fontWeight: FontWeight.w700,
                              fontSize: 12)),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.24),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Icon(Icons.chevron_right_rounded,
                          color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
