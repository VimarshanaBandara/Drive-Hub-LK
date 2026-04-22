// lib/pass_papers_screen/pass_papers_home.dart
import 'dart:math' as math;
import 'package:drive_hub_lk_srilanka/widgets/banner_ad_widget.dart';
import 'package:flutter/material.dart';
import 'pass_papers_viewer.dart';

class PassPapersHome extends StatelessWidget {
  const PassPapersHome({super.key});

  @override
  Widget build(BuildContext context) {
    final parts = <_PartMeta>[
      _PartMeta(
        title: 'Part 1',
        rank: 1,
        start: 1,
        end: 32,
        gradient: const [Color(0xFF7C4DFF), Color(0xFF5B40E6)],
      ),
      _PartMeta(
        title: 'Part 2',
        rank: 2,
        start: 33,
        end: 64,
        gradient: const [Color(0xFFFF6DAF), Color(0xFFF44336)],
      ),
      _PartMeta(
        title: 'Part 3',
        rank: 3,
        start: 65,
        end: 95,
        gradient: const [Color(0xFF00BFA6), Color(0xFF009688)],
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
          'Pass Papers',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
        itemCount: parts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final p = parts[i];
          final total = p.end - p.start + 1;
          return _RankCard(
            gradient: p.gradient,
            rank: p.rank,
            title: p.title,
            subtitle: 'Click to open',
            stats: [
              _Stat(number: '$total', label: 'Questions'),
              _Stat(number: '${p.start}–${p.end}', label: 'Range'),
              _Stat(number: 'Images', label: 'Format'),
            ],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PassPapersViewer(
                      title: p.title, start: p.start, end: p.end),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _PartMeta {
  final String title;
  final int rank;
  final int start, end;
  final List<Color> gradient;
  const _PartMeta({
    required this.title,
    required this.rank,
    required this.start,
    required this.end,
    required this.gradient,
  });
}

/// ======================== Card ========================
class _RankCard extends StatelessWidget {
  final List<Color> gradient;
  final int rank;
  final String title;
  final String subtitle;
  final List<_Stat> stats;
  final VoidCallback onTap;

  const _RankCard({
    required this.gradient,
    required this.rank,
    required this.title,
    required this.subtitle,
    required this.stats,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, cons) {
      // Make the right bubble width responsive and safe on small screens
      final bubbleW = math.max(90.0, math.min(130.0, cons.maxWidth * 0.28));

      return InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Stack(
          children: [
            // base card
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: gradient.first.withValues(alpha: .28),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),

            // glossy dots on top-left for richness
            Positioned(
              left: 14,
              top: 12,
              child: Row(
                children: List.generate(
                  3,
                  (i) => Container(
                    width: 8,
                    height: 8,
                    margin: EdgeInsets.only(right: i == 2 ? 0 : 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .35),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),

            // right ranking bubble
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: bubbleW,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(22),
                    bottomRight: Radius.circular(22),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: .15),
                      Colors.white.withValues(alpha: .05)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Icon(Icons.more_horiz,
                          color: Colors.white.withValues(alpha: .9)),
                    ),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$rank',
                            style: const TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Ranking',
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // main content
            Positioned.fill(
              child: Padding(
                // leave room for the right bubble
                padding: EdgeInsets.only(left: 16, right: bubbleW + 12),
                child: Row(
                  children: [
                    // avatar
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: .35),
                            Colors.white.withValues(alpha: .15)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .18),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.menu_book_rounded,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 12),

                    // title + subtitle + stats
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Wrap instead of Row => no horizontal overflow
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: stats
                                .map((s) => _StatChip(
                                      number: s.number,
                                      label: s.label,
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

/// ======================== Small stat chip ========================
class _Stat {
  final String number;
  final String label;
  const _Stat({required this.number, required this.label});
}

class _StatChip extends StatelessWidget {
  final String number;
  final String label;
  const _StatChip({super.key, required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: .35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
