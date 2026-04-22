import 'package:drive_hub_lk_srilanka/widgets/banner_ad_widget.dart';
import 'package:flutter/material.dart';
import 'syllabus_viewer.dart';

class SyllabusHome extends StatelessWidget {
  const SyllabusHome({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cross = w >= 1000
        ? 3
        : w >= 700
            ? 2
            : 1;

    const parts = [
      _Part(
        title: 'Syllabus • Part 1',
        subtitle: 'Syllabus required for the driving exam',
        start: 1,
        end: 25,
        rank: 1,
        c1: Color(0xFF6EB9FF),
        c2: Color(0xFF5E8DFF),
      ),
      _Part(
        title: 'Syllabus • Part 2',
        subtitle: 'Syllabus required for the driving exam',
        start: 26,
        end: 50,
        rank: 2,
        c1: Color(0xFFFF6D8D),
        c2: Color(0xFFFF7B54),
      ),
      _Part(
        title: 'Syllabus • Part 3',
        subtitle: 'Syllabus required for the driving exam',
        start: 51,
        end: 75,
        rank: 3,
        c1: Color(0xFF8E7BFF),
        c2: Color(0xFF6C58E6),
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8),
      bottomNavigationBar: const BannerAdWidget(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: .5,
        centerTitle: true,
        title: const Text(
          'Syllabus - required for the driving exam',
          style:
              TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
        child: GridView.builder(
          itemCount: parts.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cross,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.25, // wide pill-like card
          ),
          itemBuilder: (ctx, i) {
            final p = parts[i];
            return _RankCard(
              title: p.title,
              subtitle: p.subtitle,
              pages: p.end - p.start + 1,
              start: p.start,
              end: p.end,
              rank: p.rank,
              c1: p.c1,
              c2: p.c2,
              onTap: () {
                Navigator.push(
                  ctx,
                  MaterialPageRoute(
                    builder: (_) => SyllabusViewer(
                      title: p.title,
                      start: p.start,
                      end: p.end,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _Part {
  final String title, subtitle;
  final int start, end, rank;
  final Color c1, c2;
  const _Part({
    required this.title,
    required this.subtitle,
    required this.start,
    required this.end,
    required this.rank,
    required this.c1,
    required this.c2,
  });
}

/// ======= Card styled like the screenshot (avatar, metrics, right rank) =======
class _RankCard extends StatelessWidget {
  final String title, subtitle;
  final int pages, start, end, rank;
  final Color c1, c2;
  final VoidCallback onTap;

  const _RankCard({
    required this.title,
    required this.subtitle,
    required this.pages,
    required this.start,
    required this.end,
    required this.rank,
    required this.c1,
    required this.c2,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const white70 = Colors.white70;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: 128,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [c1, c2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x26000000),
                    blurRadius: 18,
                    offset: Offset(0, 10)),
              ],
            ),
            child: Stack(
              children: [
                // Tiny shine at top
                Positioned(
                  left: 20,
                  top: 8,
                  child: Container(
                    width: 36,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .35),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),

                // Right "ranking" panel
                Positioned.fill(
                  right: 0,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _RightRankBlob(
                      rank: rank,
                      height: double.infinity,
                    ),
                  ),
                ),

                // Top-right "more"
                const Positioned(
                  top: 10,
                  right: 12,
                  child: Icon(Icons.more_horiz_rounded, color: Colors.white70),
                ),

                // Main row
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      14, 14, 92, 14), // keep space for right rank
                  child: Row(
                    children: [
                      // circular avatar
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.white24, Colors.white12],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.menu_book_rounded,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 12),

                      // Texts + metrics
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: white70,
                                fontWeight: FontWeight.w700,
                                fontSize: 12.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // metrics row – use Expanded children to avoid overflow
                            Row(
                              children: [
                                _metric('pages', '$pages'),
                                _dividerDot(),
                                _metric('range', 's$start–s$end'),
                                _dividerDot(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _metric(String label, String value) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w900)),
          const SizedBox(width: 4),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w700,
                  fontSize: 12)),
        ],
      ),
    );
  }

  Widget _dividerDot() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Icon(Icons.circle, color: Colors.white38, size: 6),
      );
}

/// Curved right-side blob with ranking number (like screenshot)
class _RightRankBlob extends StatelessWidget {
  final int rank;
  final double height;
  const _RightRankBlob({required this.rank, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .10),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(48),
          bottomLeft: Radius.circular(48),
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // decorative dashed arcs (fake with dots)
          Positioned(
            top: 18,
            right: 22,
            child: Row(
              children: List.generate(
                3,
                (i) => Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(left: 6),
                  decoration: const BoxDecoration(
                    color: Colors.white30,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$rank',
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 26)),
              const SizedBox(height: 2),
              const Text('Ranking',
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w700,
                      fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}
