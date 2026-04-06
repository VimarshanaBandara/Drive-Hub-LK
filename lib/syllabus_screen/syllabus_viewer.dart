// lib/syllabus_screen/syllabus_viewer.dart
import 'dart:ui';
import 'package:flutter/material.dart';

class SyllabusViewer extends StatefulWidget {
  final String title;
  final int start;
  final int end; // inclusive
  const SyllabusViewer({
    super.key,
    required this.title,
    required this.start,
    required this.end,
  });

  @override
  State<SyllabusViewer> createState() => _SyllabusViewerState();
}

class _SyllabusViewerState extends State<SyllabusViewer> {
  late final PageController _pc = PageController(initialPage: 0);

  // Keep your folder and naming as-is
  late final List<String> _assets = List.generate(
    widget.end - widget.start + 1,
    (i) => 'assets/syllabous/s${widget.start + i}.jpg',
  );

  final TransformationController _tc = TransformationController();
  int _index = 0;
  bool _uiVisible = true; // tap to show/hide chrome
  bool _fitWidth = false; // toggle fit mode

  static const _ink = Color(0xFF0B1220); // deep navy bg

  // ====== helpers ======
  void _prev() {
    if (_index > 0) {
      _pc.previousPage(
          duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    }
  }

  void _next() {
    if (_index < _assets.length - 1) {
      _pc.nextPage(
          duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    }
  }

  void _resetZoom() {
    _tc.value = Matrix4.identity();
  }

  void _toggleFit() {
    setState(() => _fitWidth = !_fitWidth);
  }

  // double-tap zoom to ~2.5x centered near the tap point
  void _handleDoubleTapDown(TapDownDetails d, BoxConstraints c) {
    final currentScale = _tc.value.getMaxScaleOnAxis();
    if (currentScale > 1.01) {
      _resetZoom();
      return;
    }
    // zoom into the tapped position
    final position = d.localPosition;
    final zoom = 2.5;
    final x = -position.dx * (zoom - 1);
    final y = -position.dy * (zoom - 1);
    _tc.value = Matrix4.identity()
      ..translate(
          x.clamp(-c.maxWidth, c.maxWidth), y.clamp(-c.maxHeight, c.maxHeight))
      ..scale(zoom);
    setState(() {});
  }

  @override
  void dispose() {
    _pc.dispose();
    _tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = _assets.length;

    return Scaffold(
      backgroundColor: _ink,
      body: SafeArea(
        child: Stack(
          children: [
            // ================== Page Area ==================
            LayoutBuilder(
              builder: (ctx, cons) {
                return GestureDetector(
                  onTap: () => setState(() => _uiVisible = !_uiVisible),
                  onDoubleTapDown: (d) => _handleDoubleTapDown(d, cons),
                  child: PageView.builder(
                    controller: _pc,
                    onPageChanged: (i) {
                      setState(() {
                        _index = i;
                        _resetZoom();
                      });
                    },
                    itemCount: total,
                    itemBuilder: (_, i) {
                      return Center(
                        child: InteractiveViewer(
                          transformationController: _tc,
                          minScale: 1,
                          maxScale: 4,
                          child: Image.asset(
                            _assets[i],
                            fit: _fitWidth ? BoxFit.fitWidth : BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Image missing',
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            // Big invisible tap zones (prev/next)
            if (_uiVisible) ...[
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                          behavior: HitTestBehavior.translucent, onTap: _prev),
                    ),
                    Expanded(
                      child: GestureDetector(
                          behavior: HitTestBehavior.translucent, onTap: _next),
                    ),
                  ],
                ),
              ),
            ],

            // ================== Top Glass Bar ==================
            AnimatedPositioned(
              duration: const Duration(milliseconds: 180),
              top: _uiVisible ? 12 : -80,
              left: 12,
              right: 12,
              child: _Glass(
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Back',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 2),
                          Text('Page ${_index + 1} of $total',
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: _fitWidth ? 'Fit screen' : 'Fit width',
                      onPressed: _toggleFit,
                      icon: Icon(
                        _fitWidth
                            ? Icons.fit_screen_rounded
                            : Icons.width_full_rounded,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Reset zoom',
                      onPressed: _resetZoom,
                      icon: const Icon(Icons.center_focus_strong_rounded,
                          color: Colors.white),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),

            // ================== Bottom Controls (Glass) ==================
            AnimatedPositioned(
              duration: const Duration(milliseconds: 180),
              bottom: _uiVisible ? 16 : -120,
              left: 12,
              right: 12,
              child: _Glass(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'Previous',
                        onPressed: _index > 0 ? _prev : null,
                        icon: const Icon(Icons.chevron_left_rounded,
                            color: Colors.white, size: 28),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 3,
                            overlayShape: SliderComponentShape.noOverlay,
                            thumbShape: const RoundSliderThumbShape(
                                enabledThumbRadius: 7),
                          ),
                          child: Slider(
                            value: (_index + 1).toDouble(),
                            min: 1,
                            max: total.toDouble(),
                            divisions: total - 1,
                            activeColor: Colors.white,
                            inactiveColor: Colors.white24,
                            onChanged: (v) {
                              final to = v.round() - 1;
                              if (to != _index) _pc.jumpToPage(to);
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Next',
                        onPressed: _index < total - 1 ? _next : null,
                        icon: const Icon(Icons.chevron_right_rounded,
                            color: Colors.white, size: 28),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====== Simple frosted glass container ======
class _Glass extends StatelessWidget {
  final Widget child;
  const _Glass({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(.18)),
          ),
          child: child,
        ),
      ),
    );
  }
}
