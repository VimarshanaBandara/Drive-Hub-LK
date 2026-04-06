// vividha_home.dart — Light/White Theme + Favourite filter + Search + Quick filters
// + Smart Bottom Sheet + Smart Share + Creative Quiz (same pattern as anekuth_home)
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart'; // kIsWeb, defaultTargetPlatform
import 'package:flutter/rendering.dart'; // RenderBox
import 'package:share_plus/share_plus.dart';

// -------- Model --------
class ImageDetails {
  final String imagePath;
  final String title;
  final String details;
  const ImageDetails({
    required this.imagePath,
    required this.title,
    required this.details,
  });
}

// -------- Data (8 misc. signs) --------
List<ImageDetails> _images = const [
  ImageDetails(
      imagePath: 'images/w1.png',
      title: 'මාර්ග අලුත්වැඩියා කිරීමේ බාධක පුවරුව',
      details: 'Barricade Board for road works'),
  ImageDetails(
      imagePath: 'images/w2.png',
      title: 'මාර්ග අලුත්වැඩියා කිරීමේ බාධක පුවරුව හා ගමන් කළයුතු දිශාව',
      details: 'Road repair barrier and direction of travel'),
  ImageDetails(
      imagePath: 'images/w3.png',
      title: 'පැති අවහිරය සලකුණ',
      details: 'Side Obstacle Markers'),
  ImageDetails(
      imagePath: 'images/w4.png',
      title: 'ස්ථීර භාවිතය සඳහා දිශා පෙන්නුම් පුවරුව',
      details: 'Direction Board for permanent use'),
  ImageDetails(
      imagePath: 'images/w5.png',
      title: 'වංගුවක දිශාව දක්වන පුවරුව',
      details: 'Bend direction board'),
  ImageDetails(
      imagePath: 'images/w6.png',
      title: 'තාවකාලික බාධකයක් නිසා මාර්ගය මත තබන කේතුව',
      details: 'Traffic Cone'),
  ImageDetails(
      imagePath: 'images/w7.png',
      title: 'රථවාහන නවතා තැබීම තහනම් බව දක්ක්වන කේතුව',
      details: 'Traffic Cone for No Parking'),
  ImageDetails(
      imagePath: 'images/w8.png',
      title: 'අක්‍රීය වාහන සලකුණු',
      details: 'Disabled Vehicle Sign'),
];

// -------- Screen --------
class VividhaHome extends StatefulWidget {
  const VividhaHome({super.key});
  @override
  State<VividhaHome> createState() => _VividhaHomeState();
}

class _VividhaHomeState extends State<VividhaHome> {
  final _search = TextEditingController();
  // 0 All | 1 Barriers | 2 Direction | 3 Cones | 4 Special
  int _chip = 0;
  final Set<int> _faves = {};
  bool _onlyFavs = false;

  // ------ Light Theme Palette ------
  static const bg = Color(0xFFFFFFFF);
  static const border = Color(0xFFE5EAF0);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF475569);
  static const accent = Color(0xFF7C4DFF); // purple

  // ---------- Share (smart: iPad/web popover origin) ----------
  bool _needsOrigin(BuildContext ctx) {
    final platform = defaultTargetPlatform;
    final shortest = MediaQuery.of(ctx).size.shortestSide;
    final isTablet = shortest >= 600;
    final isIOSiPad = platform == TargetPlatform.iOS && isTablet;
    return kIsWeb || isIOSiPad;
  }

  Rect _originFrom(BuildContext ctx) {
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return const Rect.fromLTWH(0, 0, 1, 1);
    final offset = box.localToGlobal(Offset.zero);
    final size = box.size.isEmpty ? const Size(1, 1) : box.size;
    return offset & size;
  }

  void _shareSmart(BuildContext ctx, String text, {String? subject}) {
    try {
      if (_needsOrigin(ctx)) {
        Share.share(
          text,
          subject: subject,
          sharePositionOrigin: _originFrom(ctx),
        );
      } else {
        Share.share(text, subject: subject);
      }
    } catch (_) {
      Share.share(text, subject: subject);
    }
  }
  // ------------------------------------------------------------

  List<ImageDetails> get _filtered {
    Iterable<ImageDetails> src = _images;

    switch (_chip) {
      case 1: // Barriers / Obstacles
        src = src.where((e) =>
            e.details.toLowerCase().contains('barrier') ||
            e.details.toLowerCase().contains('barricade') ||
            e.details.toLowerCase().contains('obstacle') ||
            e.title.contains('බාධක') ||
            e.title.contains('අවහිර'));
        break;
      case 2: // Direction boards
        src = src.where((e) =>
            e.details.toLowerCase().contains('direction') ||
            e.title.contains('දිශා') ||
            e.title.contains('වංගුව'));
        break;
      case 3: // Cones
        src = src.where((e) =>
            e.details.toLowerCase().contains('cone') ||
            e.title.contains('කේතුව'));
        break;
      case 4: // Special (Disabled sign)
        src = src.where((e) =>
            e.details.toLowerCase().contains('disabled') ||
            e.title.contains('අක්‍රීය'));
        break;
    }

    final q = _search.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      src = src.where((e) =>
          e.title.toLowerCase().contains(q) ||
          e.details.toLowerCase().contains(q));
    }

    if (_onlyFavs) {
      src = src.where((e) => _faves.contains(_images.indexOf(e)));
    }

    return src.toList();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cross = w >= 1100
        ? 5
        : w >= 820
            ? 4
            : w >= 560
                ? 3
                : 2;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0.5,
        shadowColor: Colors.black12,
        centerTitle: true,
        title: const Text('විවිධ සලකුණු',
            style: TextStyle(fontWeight: FontWeight.w900, color: textPrimary)),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // >>> FAB: open quiz (same style as anekuth)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VividhaQuizScreen(items: _images),
            ),
          );
        },
        icon: const Icon(Icons.quiz_rounded),
        label: const Text('Quiz'),
        backgroundColor: accent,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          // Top purple summary card + Favourite toggle
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
            child: Container(
              height: 94,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 14,
                      offset: Offset(0, 8))
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.18),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.construction_rounded,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_onlyFavs ? 'Favourites' : 'Total Signs',
                            style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Text(
                            _onlyFavs
                                ? '${_faves.length}'
                                : '${_images.length}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 24)),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (!_onlyFavs) {
                          if (_faves.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    const Text('You have no favourites yet'),
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.black87,
                                duration: const Duration(milliseconds: 1200),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                margin: const EdgeInsets.all(12),
                              ),
                            );
                          } else {
                            _onlyFavs = true;
                          }
                        } else {
                          _onlyFavs = false;
                        }
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          Colors.white.withOpacity(_onlyFavs ? .32 : .20),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(_onlyFavs ? 'All' : 'Favourite'),
                  ),
                  const SizedBox(width: 12),
                ],
              ),
            ),
          ),

          // Search field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: border)),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.search, color: textSecondary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _search,
                      onChanged: (_) => setState(() {}),
                      style: const TextStyle(
                          color: textPrimary, fontWeight: FontWeight.w600),
                      decoration: const InputDecoration(
                        hintText: 'සලකුණක්/පදයක් සොයන්න…',
                        hintStyle: TextStyle(
                            color: textSecondary, fontWeight: FontWeight.w600),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (_search.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _search.clear();
                        setState(() {});
                      },
                      child: const Icon(Icons.close,
                          color: textSecondary, size: 18),
                    ),
                ],
              ),
            ),
          ),

          // Quick Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Quick Actions',
                    style: TextStyle(
                        color: textPrimary, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _quickAction(
                  icon: Icons.apps_rounded,
                  label: 'All',
                  selected: _chip == 0,
                  onTap: () => setState(() => _chip = 0),
                ),
                _quickAction(
                  icon: Icons.safety_divider_rounded,
                  label: 'Barriers',
                  selected: _chip == 1,
                  onTap: () => setState(() => _chip = 1),
                ),
                _quickAction(
                  icon: Icons.directions_rounded,
                  label: 'Direction',
                  selected: _chip == 2,
                  onTap: () => setState(() => _chip = 2),
                ),
                _quickAction(
                  icon: Icons.change_circle_outlined,
                  label: 'Cones',
                  selected: _chip == 3,
                  onTap: () => setState(() => _chip = 3),
                ),
                _quickAction(
                  icon: Icons.star_half_rounded,
                  label: 'Special',
                  selected: _chip == 4,
                  onTap: () => setState(() => _chip = 4),
                ),
              ],
            ),
          ),

          // Grid / Empty-state
          const SizedBox(height: 10),
          Expanded(
            child: _filtered.isEmpty
                ? const Center(
                    child: Text(
                      'කිසිදු සිතියමක්/සලකුණක් හමු නොවුණා',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: textSecondary,
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
                    itemCount: _filtered.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cross,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.98,
                    ),
                    itemBuilder: (_, i) {
                      final idx = _images.indexOf(_filtered[i]);
                      final fav = _faves.contains(idx);
                      return _LightCard(
                        index: idx,
                        data: _filtered[i],
                        isFav: fav,
                        onFav: () => setState(
                            () => fav ? _faves.remove(idx) : _faves.add(idx)),
                        onTap: () => _showDetailsSheet(idx),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ---------- Bottom Sheet ----------
  void _showDetailsSheet(int initialIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black45,
      builder: (ctx) {
        int current = initialIndex;

        return StatefulBuilder(builder: (ctx, setSheet) {
          final item = _images[current];
          final fav = _faves.contains(current);

          return DraggableScrollableSheet(
            initialChildSize: 0.56,
            minChildSize: 0.44,
            maxChildSize: 0.90,
            expand: false,
            builder: (c, scrollCtrl) {
              return Container(
                decoration: const BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: CustomScrollView(
                  controller: scrollCtrl,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          Container(
                            width: 44,
                            height: 4,
                            decoration: BoxDecoration(
                                color: Color(0xFFE2E8F0),
                                borderRadius: BorderRadius.circular(4)),
                          ),

                          // Header
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
                            child: Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'විවිධ සලකුණු',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: textPrimary,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16),
                                  ),
                                ),
                                Text('${current + 1}/${_images.length}',
                                    style: const TextStyle(
                                        color: textSecondary,
                                        fontWeight: FontWeight.w700)),
                                IconButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  icon: const Icon(Icons.close_rounded,
                                      color: textSecondary),
                                  splashRadius: 18,
                                ),
                              ],
                            ),
                          ),

                          // Image
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Container(
                              height: 180,
                              decoration: BoxDecoration(
                                color: Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: border),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 180),
                                child: Image.asset(
                                  item.imagePath,
                                  key: ValueKey(item.imagePath),
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                          ),

                          // Details
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                Text(item.title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: textPrimary,
                                        fontWeight: FontWeight.w900)),
                                const SizedBox(height: 6),
                                Text(item.details,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: textSecondary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13)),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _miniPill('#${_images.indexOf(item) + 1}'),
                                    const SizedBox(width: 6),
                                    _miniPill('Misc Sign',
                                        bg: const Color(0xFFEDE7FF)),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // Actions
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                            child: Row(
                              children: [
                                _miniRoundBtn(
                                  icon: Icons.chevron_left_rounded,
                                  onTap: current > 0
                                      ? () => setSheet(() => current--)
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                _miniRoundBtn(
                                  icon: Icons.chevron_right_rounded,
                                  onTap: current < _images.length - 1
                                      ? () => setSheet(() => current++)
                                      : null,
                                ),
                                const Spacer(),
                                _smartIcon(
                                  icon: Icons.content_copy_rounded,
                                  tooltip: 'Copy Sinhala',
                                  onTap: () => _copyToClipboard(
                                      item.title, 'Sinhala copied'),
                                ),
                                const SizedBox(width: 6),

                                // Share button with smart origin (iPad/web)
                                Builder(
                                  builder: (btnCtx) => _smartIcon(
                                    icon: Icons.share_rounded,
                                    tooltip: 'Share',
                                    onTap: () => _shareSmart(
                                      btnCtx,
                                      '${item.title}\n${item.details}',
                                      subject: item.title,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 6),
                                _smartIcon(
                                  icon: fav
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: fav ? Colors.pinkAccent : textPrimary,
                                  tooltip: fav ? 'Saved' : 'Save',
                                  onTap: () {
                                    setState(() {
                                      fav
                                          ? _faves.remove(current)
                                          : _faves.add(current);
                                    });
                                    setSheet(() {}); // refresh icon
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
      },
    );
  }

  // ---------- Helpers ----------
  void _copyToClipboard(String text, String msg) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(milliseconds: 900),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _miniPill(String text, {Color bg = const Color(0xFFEFF3F9)}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: const DefaultTextStyle(
        style: TextStyle(
            color: textPrimary, fontWeight: FontWeight.w800, fontSize: 11),
        child: Text.rich(TextSpan(text: ''), softWrap: true),
      ),
    );
  }

  Widget _miniRoundBtn({required IconData icon, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: onTap == null ? const Color(0xFFF3F6FA) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Icon(icon,
            color: onTap == null ? Colors.black26 : textPrimary, size: 24),
      ),
    );
  }

  Widget _smartIcon(
      {required IconData icon,
      required VoidCallback onTap,
      String? tooltip,
      Color color = textPrimary}) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      icon: Icon(icon, color: color, size: 20),
      splashRadius: 18,
    );
  }

  Widget _quickAction({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 74,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            color: selected ? accent : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: selected ? accent : border),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: selected ? Colors.white : const Color(0xFF475569)),
              const SizedBox(height: 6),
              Text(label,
                  style: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF475569),
                      fontWeight: FontWeight.w800,
                      fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

// -------- Light Grid Card --------
class _LightCard extends StatelessWidget {
  final int index;
  final ImageDetails data;
  final bool isFav;
  final VoidCallback onFav, onTap;
  const _LightCard(
      {required this.index,
      required this.data,
      required this.isFav,
      required this.onFav,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    const surface = Colors.white;
    const border = Color(0xFFE5EAF0);
    const textPrimary = Color(0xFF0F172A);
    const textSecondary = Color(0xFF475569);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: surface,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                // FULL image (no crop)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: border),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      data.imagePath,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      filterQuality: FilterQuality.high,
                      width: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: textPrimary, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  data.details,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: const Color(0xFFEFF3F9),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text('#${index + 1}',
                          style: const TextStyle(
                              color: textPrimary,
                              fontWeight: FontWeight.w900,
                              fontSize: 11.5)),
                    ),
                    IconButton(
                      icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.pinkAccent : textSecondary,
                          size: 18),
                      onPressed: onFav,
                      splashRadius: 18,
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

// ===================== CREATIVE QUIZ (VIVIDHA) =====================
class VividhaQuizScreen extends StatefulWidget {
  final List<ImageDetails> items;
  const VividhaQuizScreen({super.key, required this.items});

  @override
  State<VividhaQuizScreen> createState() => _VividhaQuizScreenState();
}

class _VividhaQuizScreenState extends State<VividhaQuizScreen> {
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF475569);
  static const border = Color(0xFFE5EAF0);
  static const accent = Color(0xFF7C4DFF);

  late final List<_Q> _questions;
  int _current = 0;
  int _score = 0;
  bool _answered = false;
  int? _picked;
  bool _showHint = false;

  @override
  void initState() {
    super.initState();
    _questions = _buildQuestions(widget.items);
  }

  List<_Q> _buildQuestions(List<ImageDetails> items) {
    final rng = Random();
    final pool = List<ImageDetails>.from(items)..shuffle(rng);
    final total = min(10, pool.length);
    final qs = <_Q>[];

    final slots = List<int>.generate(total, (i) => i % 4)..shuffle(rng);

    for (int i = 0; i < total; i++) {
      final correct = pool[i];

      final others = List<ImageDetails>.from(items)
        ..remove(correct)
        ..shuffle(rng);
      final distractorTitles = <String>{};
      for (final it in others) {
        distractorTitles.add(it.title);
        if (distractorTitles.length == 3) break;
      }

      final opts = distractorTitles.toList();
      final slot = slots[i].clamp(0, 3);
      opts.insert(slot, correct.title);
      while (opts.length > 4) opts.removeLast();
      if (opts.length < 4) {
        for (final it in items) {
          if (opts.length == 4) break;
          if (!opts.contains(it.title) && it.title != correct.title) {
            opts.add(it.title);
          }
        }
      }

      qs.add(_Q(
        item: correct,
        options: opts,
        correct: opts.indexOf(correct.title),
      ));
    }
    return qs;
  }

  void _onPick(int index) async {
    if (_answered) return;
    setState(() {
      _answered = true;
      _picked = index;
      if (index == _questions[_current].correct) _score++;
    });

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    if (_current < _questions.length - 1) {
      setState(() {
        _current++;
        _answered = false;
        _picked = null;
        _showHint = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VividhaQuizResult(
            score: _score,
            total: _questions.length,
            items: widget.items,
          ),
        ),
      );
    }
  }

  void _skip() async {
    if (_answered) return;
    setState(() {
      _answered = true;
      _picked = null;
    });
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    if (_current < _questions.length - 1) {
      setState(() {
        _current++;
        _answered = false;
        _picked = null;
        _showHint = false;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VividhaQuizResult(
            score: _score,
            total: _questions.length,
            items: widget.items,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_current];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .5,
        iconTheme: const IconThemeData(color: textPrimary),
        title: Text(
          'Quiz • Q${_current + 1}/${_questions.length}',
          style:
              const TextStyle(color: textPrimary, fontWeight: FontWeight.w900),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: () => setState(() => _showHint = !_showHint),
              style: TextButton.styleFrom(
                backgroundColor: _showHint
                    ? const Color(0xFFEDE7FF)
                    : const Color(0xFFF1F5F9),
                foregroundColor: textPrimary,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999)),
              ),
              icon: const Icon(Icons.lightbulb_rounded, size: 18),
              label: Text(_showHint ? 'Hide' : 'Hint'),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // soft blobs
          Positioned(
            top: -60,
            left: -40,
            child: _blob(160, [accent.withOpacity(.17), Colors.transparent]),
          ),
          Positioned(
            bottom: -80,
            right: -40,
            child: _blob(220,
                [const Color(0xFF00D1FF).withOpacity(.16), Colors.transparent]),
          ),

          // content
          Column(
            children: [
              // progress & chips
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8E67FF), Color(0xFF6C4BFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 14,
                          offset: Offset(0, 8)),
                    ],
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: LinearProgressIndicator(
                          value: (_current + 1) / _questions.length,
                          minHeight: 8,
                          backgroundColor: Colors.white.withOpacity(.3),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _pill('Score: $_score',
                              bg: Colors.white.withOpacity(.18),
                              fg: Colors.white),
                          const Spacer(),
                          _pill('Q ${_current + 1}/${_questions.length}',
                              bg: Colors.white.withOpacity(.18),
                              fg: Colors.white),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // question card (compact image + hint)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: border),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      // small image
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: border),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          q.item.imagePath,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // question text + (optional) hint
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'මෙම සංඥාවේ සිංහල නම තෝරන්න:',
                              style: TextStyle(
                                  color: textPrimary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16),
                            ),
                            const SizedBox(height: 6),
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 200),
                              crossFadeState: _showHint
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              firstChild: Text(
                                'Hint: ${q.item.details}',
                                style: const TextStyle(
                                    color: textSecondary,
                                    fontWeight: FontWeight.w700),
                              ),
                              secondChild: const SizedBox.shrink(),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                _tinyTag('Misc'),
                                _tinyTag('Signs'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // answers
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                  itemCount: q.options.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, i) => _AnswerTile(
                    index: i,
                    text: q.options[i],
                    isCorrect: _answered && i == q.correct,
                    isWrong: _answered && _picked == i && i != q.correct,
                    onTap: () => _onPick(i),
                  ),
                ),
              ),

              // footer actions
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _answered ? null : _skip,
                      icon: const Icon(Icons.fast_forward_rounded),
                      label: const Text('Skip'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textPrimary,
                        side: const BorderSide(color: border),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const Spacer(),
                    _pill('Score $_score',
                        bg: const Color(0xFFEEF2FF), fg: textPrimary),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- UI helpers ---
  Widget _blob(double size, List<Color> colors) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }

  Widget _pill(String text,
      {Color bg = const Color(0xFFEFF3F9),
      Color fg = const Color(0xFF0F172A)}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(
        text,
        style: TextStyle(color: fg, fontWeight: FontWeight.w900),
      ),
    );
  }

  Widget _tinyTag(String t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3F9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        t,
        style: const TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w800,
            fontSize: 11),
      ),
    );
  }
}

// Fancy answer tile with letter badge + subtle animation
class _AnswerTile extends StatelessWidget {
  final int index;
  final String text;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;
  const _AnswerTile({
    required this.index,
    required this.text,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
    super.key,
  });

  String get _letter => const ['A', 'B', 'C', 'D'][0 + (index % 4)];

  @override
  Widget build(BuildContext context) {
    const textPrimary = Color(0xFF0F172A);
    const textSecondary = Color(0xFF475569);
    const border = Color(0xFFE5EAF0);

    Color outline = border;
    Color fill = Colors.white;
    Color badge = const Color(0xFFF1F5F9);
    Color badgeText = textSecondary;
    IconData? icon;

    if (isCorrect) {
      outline = const Color(0xFF22C55E);
      fill = const Color(0xFFEFFBF1);
      badge = const Color(0xFF22C55E);
      badgeText = Colors.white;
      icon = Icons.check_circle_rounded;
    } else if (isWrong) {
      outline = const Color(0xFFEF4444);
      fill = const Color(0xFFFFF1F2);
      badge = const Color(0xFFEF4444);
      badgeText = Colors.white;
      icon = Icons.cancel_rounded;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: fill,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: outline, width: 1.6),
          boxShadow: [
            if (isCorrect)
              const BoxShadow(
                  color: Color(0x3322C55E),
                  blurRadius: 10,
                  offset: Offset(0, 6)),
            if (isWrong)
              const BoxShadow(
                  color: Color(0x33EF4444),
                  blurRadius: 10,
                  offset: Offset(0, 6)),
          ],
        ),
        child: Row(
          children: [
            // letter badge
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: badge, borderRadius: BorderRadius.circular(10)),
              child: Text(_letter,
                  style:
                      TextStyle(color: badgeText, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                    color: textPrimary, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              icon ?? Icons.circle_outlined,
              color: icon != null ? outline : textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _Q {
  final ImageDetails item;
  final List<String> options;
  final int correct;
  _Q({required this.item, required this.options, required this.correct});
}

// ----------------- Result Screen -----------------
class VividhaQuizResult extends StatelessWidget {
  final int score;
  final int total;
  final List<ImageDetails> items;
  const VividhaQuizResult(
      {super.key,
      required this.score,
      required this.total,
      required this.items});

  (String emoji, String title, String sub) _grade() {
    final pct = score / total;
    if (pct >= .9) {
      return ('🎉', 'Legendary!', 'Full tank of knowledge - excellent!');
    } else if (pct >= .7) {
      return ('😎', 'Road Pro', 'You know the rules really well.');
    } else if (pct >= .5) {
      return (
        '🙂',
        'Good Start',
        'On the right track. A bit more practice and you\'ll be great.'
      );
    } else if (pct >= .3) {
      return ('😅', 'Almost There', 'Keep going - more practice will help.');
    } else {
      return (
        '🤪',
        'U-turn Time!',
        'No worries. Switch to study mode and try again.'
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const textPrimary = Color(0xFF0F172A);
    const textSecondary = Color(0xFF475569);
    const accent = Color(0xFF7C4DFF);

    final (emoji, title, sub) = _grade();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .5,
        iconTheme: const IconThemeData(color: textPrimary),
        title: const Text('Your Result',
            style: TextStyle(color: textPrimary, fontWeight: FontWeight.w900)),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 72)),
            const SizedBox(height: 8),
            Text(title,
                style: const TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 24)),
            const SizedBox(height: 6),
            Text(sub,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: textSecondary, fontWeight: FontWeight.w600)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFEDE7FF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '$score / $total',
                style: const TextStyle(
                    color: textPrimary,
                    fontWeight: FontWeight.w900,
                    fontSize: 22),
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VividhaQuizScreen(items: items),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try Again'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Back to Signs'),
            ),
            const Spacer(),
            const Text(
              'Tip: Images change randomly, keep practicing!',
              style:
                  TextStyle(color: textSecondary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
