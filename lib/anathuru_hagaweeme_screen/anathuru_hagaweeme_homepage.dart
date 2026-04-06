// anathuru_hagaweeme_homepage.dart — Light/White Theme + Favourites + Creative Quiz
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Clipboard for copy actions

// -------- Model --------
class ImageDetails {
  final String imagePath;
  final String title;
  final String details;
  const ImageDetails(
      {required this.imagePath, required this.title, required this.details});
}

// -------- Data (42 signs) --------
List<ImageDetails> _images = const [
  ImageDetails(
      imagePath: 'images/an1.png',
      title: 'වම් පැත්තට වංගුව ඉදිරියෙනි',
      details: 'Left Bend Ahead'),
  ImageDetails(
      imagePath: 'images/an2.png',
      title: 'දකුණු පැත්තට වංගුව ඉදිරියෙනි',
      details: 'Right Bend Ahead'),
  ImageDetails(
      imagePath: 'images/an3.png',
      title: 'වම් පැත්තට ද්විත්ව වංගුව ඉදිරියෙනි',
      details: 'Double Bend to Left Ahead'),
  ImageDetails(
      imagePath: 'images/an4.png',
      title: 'දකුණු පැත්තට ද්විත්ව වංගුව ඉදිරියෙනි',
      details: 'Double Bend to Right Ahead'),
  ImageDetails(
      imagePath: 'images/an5.png',
      title: 'වම් පැත්තට වැලමිට වංගුව ඉදිරියෙනි',
      details: 'Hair Pin Bend to Left Ahead'),
  ImageDetails(
      imagePath: 'images/an6.png',
      title: 'දකුණු පැත්තට වැලමිට වංගුව ඉදිරියෙනි',
      details: 'Hair Pin Bend to Right Ahead'),
  ImageDetails(
      imagePath: 'images/an7.png',
      title: 'ද්විත්ව රථ මාර්ගය අවසානය ඉදිරියෙනි',
      details: 'Dual Carriage-way Ends'),
  ImageDetails(
      imagePath: 'images/an8.png',
      title: 'ද්විත්ව රථ මාර්ගය ආරම්භය ඉදිරියෙනි',
      details: 'Dual Carriage-way Starts Ahead'),
  ImageDetails(
      imagePath: 'images/an9.png',
      title: 'ඉදිරියෙන් මාර්ගය පටුය',
      details: 'Road Narrows Ahead'),
  ImageDetails(
      imagePath: 'images/an10.png',
      title: 'මාර්ගයේ වම්පස පටුවීම ඉදිරියෙනි ',
      details: 'Road Narrows on the Left Side Ahead'),
  ImageDetails(
      imagePath: 'images/an11.png',
      title: 'මාර්ගයේ දකුණුපස පටුවීම ඉදිරියෙනි',
      details: 'Road Narrows on the Right Side Ahead'),
  ImageDetails(
      imagePath: 'images/an12.png',
      title: 'එකිනෙකා හරහා ගමන් කරන මාර්ගය ඉදිරියෙනි',
      details: 'Cross Roads Ahead'),
  ImageDetails(
      imagePath: 'images/an13.png',
      title: 'පළමුවැනි පැති මාර්ගය වම් පැත්තට විහිදෙන විසම සන්ධිය ඉදිරියෙනි',
      details: 'Staggered Junction Ahead with First Side Road to Left'),
  ImageDetails(
      imagePath: 'images/an14.png',
      title: 'පළමුවැනි පැති මාර්ගය දකුණු පැත්තට විහිදෙන විසම සන්ධිය ඉදිරියෙනි',
      details: 'Staggered Junction Ahead with First Side Road to Right'),
  ImageDetails(
      imagePath: 'images/an15.png',
      title: 'Y හැඩයේ මංසන්ධිය ඉදිරියෙනි',
      details: 'Y Junction Ahead'),
  ImageDetails(
      imagePath: 'images/an16.png',
      title: 'T හැඩයේ මංසන්ධිය ඉදිරියෙනි',
      details: 'T Junction Ahead'),
  ImageDetails(
      imagePath: 'images/an17.png',
      title: 'වම් පැත්තෙන් රථවාහන ප්‍රධාන මාර්ගයට එක්වන සන්ධිය ඉදිරියෙනි',
      details: 'Traffic From Left Merges Ahead'),
  ImageDetails(
      imagePath: 'images/an18.png',
      title: 'දකුණු පැත්තෙන් රථවාහන ප්‍රධාන මාර්ගයට එක්වන සන්ධිය ඉදිරියෙනි',
      details: 'Traffic From Right Merges Ahead'),
  ImageDetails(
      imagePath: 'images/an19.png',
      title:
          'වම් පැත්තෙන් රථවාහන ප්‍රධාන මාර්ගයට සෘජුකෝණාකාරව එක්වන සන්ධිය ඉදිරියෙනි',
      details: 'Side Road From Left Intersects at Right Angle Ahead'),
  ImageDetails(
      imagePath: 'images/an20.png',
      title:
          'දකුණු පැත්තෙන් රථවාහන ප්‍රධාන මාර්ගයට සෘජුකෝණාකාරව එක්වන සන්ධිය ඉදිරියෙනි',
      details: 'Side Road From Right Intersects at Right Angle Ahead'),
  ImageDetails(
      imagePath: 'images/an21.png',
      title: 'පටු පාලම ඉදිරියෙනි',
      details: 'Narrow Bridge or Culvert Ahead'),
  ImageDetails(
      imagePath: 'images/an22.png',
      title: 'රථවාහන දෙපසට ගමන් කිරීම ඉදිරියෙනි',
      details: 'Two-way Traffic Ahead'),
  ImageDetails(
      imagePath: 'images/an23.png',
      title: 'වට රවුම ඉදිරියෙනි',
      details: 'Roundabout Ahead'),
  ImageDetails(
      imagePath: 'images/an24.png',
      title: 'රථ වාහන ආලෝක පුවරු ඉදිරියෙනි',
      details: 'Light Signals Ahead'),
  ImageDetails(
      imagePath: 'images/an25.png',
      title: 'පහතට අවදානම් බෑවුම ඉදිරියෙනි',
      details: 'Dangerous Descent Ahead'),
  ImageDetails(
      imagePath: 'images/an26.png',
      title: 'ඉහළට අවදානම් බෑවුම ඉදිරියෙනි',
      details: 'Dangerous Ascent Ahead'),
  ImageDetails(
      imagePath: 'images/an27.png',
      title: 'ලිස්සන සුළු මාර්ගය ඉදිරියෙනි',
      details: 'Slippery Road Ahead'),
  ImageDetails(
      imagePath: 'images/an28.png',
      title: 'ගල් පර්වත කැබලි වැටෙන ස්ථානය ඉදිරියෙනි',
      details: 'Falling Rocks Ahead'),
  ImageDetails(
      imagePath: 'images/an29.png',
      title: 'පදිකයන් මාරුවන ස්ථානය ඉදිරියෙනි',
      details: 'Pedestrian Crossing Ahead'),
  ImageDetails(
      imagePath: 'images/an30.png',
      title: 'ළමයින් මාරුවන ස්ථානය ඉදිරියෙනි',
      details: 'Children present/ crossing Ahead'),
  ImageDetails(
      imagePath: 'images/an31.png',
      title: 'මිනිසුන් වැඩෙහි යෙදෙන ස්ථානය ඉදිරියෙනි',
      details: 'Road Work Ahead'),
  ImageDetails(
      imagePath: 'images/an32.png',
      title: 'ගේට්ටු සහිත දුම්රිය හරස් මාර්ගය ඉදිරියෙනි',
      details: 'Level Crossing with Gates Ahead'),
  ImageDetails(
      imagePath: 'images/an33.png',
      title: 'අනාරක්ෂිත දුම්රිය හරස් මාර්ගය ඉදිරියෙනි',
      details: 'Unprotected Level Crossing Ahead'),
  ImageDetails(
      imagePath: 'images/an34.png',
      title: 'පාපැදිකරුවන් මාරුවන ස්ථානය ඉදිරියෙනි',
      details: 'Cyclist crossing Ahead'),
  ImageDetails(
      imagePath: 'images/an35.png',
      title:
          'ගවයන් හෝ වෙනත් සතුන් මාර්ගය හරහා ගමන් කිරීමට ඉඩ ඇති ස්ථානය ඉදිරියෙනි',
      details: 'Cattle Crossing Ahead'),
  ImageDetails(
      imagePath: 'images/an36.png',
      title: 'මාර්ගය හරහා ගැට්ටක් ඉදිරියෙනි',
      details: 'Road Hump Ahead'),
  ImageDetails(
      imagePath: 'images/an37.png',
      title: 'වළ ගොඩැලි ඇති මාර්ගය ඉදිරියෙනි',
      details: 'Uneven Road Ahead'),
  ImageDetails(
      imagePath: 'images/an38.png',
      title: 'බෑවුම් හෝ සපත්තු පාලම ඉදිරියෙනි',
      details: 'Dip or Causeway Ahead'),
  ImageDetails(
      imagePath: 'images/an39.png',
      title: 'ඉදිරියෙන් මාර්ගය ඉඩ දෙනු',
      details: 'Give Way Ahead'),
  ImageDetails(
      imagePath: 'images/an40.png',
      title: 'මාර්ගයේ අවධානම් කොටසට ඇති දුර ප්‍රමාණය',
      details: 'Distance to a Hazardous section of a road'),
  ImageDetails(
      imagePath: 'images/an41.png',
      title: 'මාර්ගයේ අවධානම් කොටසේ දුර ප්‍රමාණය',
      details: 'Length of a Hazardous section of a road'),
  ImageDetails(imagePath: 'images/an42.png', title: 'පාසල', details: 'School'),
];

// -------- Screen --------
class AnathuruHagaweema extends StatefulWidget {
  const AnathuruHagaweema({super.key});
  @override
  State<AnathuruHagaweema> createState() => _AnathuruHagaweemaState();
}

class _AnathuruHagaweemaState extends State<AnathuruHagaweema> {
  final _search = TextEditingController();
  int _chip = 0; // 0 All 1 Curves 2 Junctions 3 People
  final Set<int> _faves = {};
  bool _onlyFavs = false; // show only favourites?

  List<ImageDetails> get _filtered {
    Iterable<ImageDetails> src = _images;

    switch (_chip) {
      case 1:
        src = src.where((e) =>
            e.details.toLowerCase().contains('bend') ||
            e.title.contains('වංගු'));
        break;
      case 2:
        src = src.where((e) =>
            e.details.toLowerCase().contains('junction') ||
            e.title.contains('සන්ධි'));
        break;
      case 3:
        src = src
            .where((e) => e.title.contains('පදික') || e.title.contains('ළමයි'));
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

    // ------ Light Theme Palette ------
    const bg = Color(0xFFFFFFFF); // page
    const border = Color(0xFFE5EAF0); // subtle border
    const textPrimary = Color(0xFF0F172A);
    const textSecondary = Color(0xFF475569);
    const accent = Color(0xFF7C4DFF); // purple

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0.5,
        shadowColor: Colors.black12,
        centerTitle: true,
        title: const Text('අනතුරු හැඟවීමේ සංඥා',
            style: TextStyle(fontWeight: FontWeight.w900, color: textPrimary)),
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios_new_rounded, color: textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 6),
            child: Icon(Icons.settings_rounded, color: textSecondary),
          ),
        ],
      ),

      // >>> Start Quiz button (navigate to quiz)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AnathuruQuizScreen(items: _images),
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
                    child: const Icon(Icons.warning_amber_rounded,
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
                  // Favourite toggle button
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
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                margin: const EdgeInsets.all(12),
                              ),
                            );
                            _onlyFavs = false;
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

          // Search field (body)
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
                        hintText: 'සංඥාවක් සොයන්න…',
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
              children: [
                const Text('Quick Actions',
                    style: TextStyle(
                        color: textPrimary, fontWeight: FontWeight.w900)),
                if (_onlyFavs)
                  const Text('Showing favourites',
                      style: TextStyle(
                          color: textSecondary, fontWeight: FontWeight.w700)),
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
                    onTap: () => setState(() => _chip = 0)),
                _quickAction(
                    icon: Icons.alt_route_rounded,
                    label: 'Curves',
                    selected: _chip == 1,
                    onTap: () => setState(() => _chip = 1)),
                _quickAction(
                    icon: Icons.merge_rounded,
                    label: 'Junctions',
                    selected: _chip == 2,
                    onTap: () => setState(() => _chip = 2)),
                _quickAction(
                    icon: Icons.directions_walk_rounded,
                    label: 'People',
                    selected: _chip == 3,
                    onTap: () => setState(() => _chip = 3)),
              ],
            ),
          ),

          // Grid
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
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
                  onTap: () => _showDetailsSheet(idx), // popup
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Small & Smart Bottom Sheet (Light) ----------
  void _showDetailsSheet(int initialIndex) {
    const surface = Colors.white;
    const border = Color(0xFFE5EAF0);
    const textPrimary = Color(0xFF0F172A);
    const textSecondary = Color(0xFF475569);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black45,
      builder: (ctx) {
        int current = initialIndex;

        return StatefulBuilder(
          builder: (ctx, setSheet) {
            return DraggableScrollableSheet(
              initialChildSize: 0.56,
              minChildSize: 0.44,
              maxChildSize: 0.90,
              expand: false,
              builder: (c, scrollCtrl) {
                final item = _images[current];
                final fav = _faves.contains(current);

                return Container(
                  decoration: const BoxDecoration(
                    color: surface,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
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
                                  color: const Color(0xFFE2E8F0),
                                  borderRadius: BorderRadius.circular(4)),
                            ),

                            // Header
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
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

                            // Image (compact)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                              child: Container(
                                height: 180,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC),
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

                            // Details (short & centered)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
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
                                      _miniPill('#${current + 1}'),
                                      const SizedBox(width: 6),
                                      _miniPill('Danger Sign',
                                          bg: const Color(0xFFEDE7FF)),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Smart Actions (compact) — copy + fav only
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
                                  // Copy Sinhala title only
                                  _smartIcon(
                                    icon: Icons.content_copy_rounded,
                                    tooltip: 'Copy Sinhala',
                                    onTap: () => _copyToClipboard(
                                        item.title, 'Sinhala copied'),
                                  ),
                                  const SizedBox(width: 6),
                                  // Favorite
                                  _smartIcon(
                                    icon: fav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color:
                                        fav ? Colors.pinkAccent : textPrimary,
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
          },
        );
      },
    );
  }

  // ---------- Helpers (inside State) ----------
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
    const textPrimary = Color(0xFF0F172A);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Text(text,
          style: const TextStyle(
              color: textPrimary, fontWeight: FontWeight.w800, fontSize: 11)),
    );
  }

  Widget _miniRoundBtn({required IconData icon, VoidCallback? onTap}) {
    const border = Color(0xFFE5EAF0);
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
            color: onTap == null ? Colors.black26 : const Color(0xFF0F172A),
            size: 24),
      ),
    );
  }

  Widget _smartIcon(
      {required IconData icon,
      required VoidCallback onTap,
      String? tooltip,
      Color color = const Color(0xFF0F172A)}) {
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
    const border = Color(0xFFE5EAF0);
    const accent = Color(0xFF7C4DFF);
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

// -------- Light Grid Card (tap -> popup) --------
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
          onTap: onTap, // open popup
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

// ===================== CREATIVE QUIZ SCREENS =====================

class AnathuruQuizScreen extends StatefulWidget {
  final List<ImageDetails> items;
  const AnathuruQuizScreen({super.key, required this.items});

  @override
  State<AnathuruQuizScreen> createState() => _AnathuruQuizScreenState();
}

class _AnathuruQuizScreenState extends State<AnathuruQuizScreen> {
  // theme
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

    // balance correct slot 0..3
    final slots = List<int>.generate(total, (i) => i % 4)..shuffle(rng);

    for (int i = 0; i < total; i++) {
      final correct = pool[i];
      // unique distractors
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
      // ensure 4
      if (opts.length < 4) {
        for (final it in items) {
          if (opts.length == 4) break;
          if (!opts.contains(it.title) && it.title != correct.title) {
            opts.add(it.title);
          }
        }
      }

      qs.add(_Q(
          item: correct, options: opts, correct: opts.indexOf(correct.title)));
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
          builder: (_) => AnathuruQuizResult(
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
      _picked = null; // skipped
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
          builder: (_) => AnathuruQuizResult(
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
          // hint toggle
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
              // progress + score chips on a gradient card
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

              // question card: compact image + (optional) hint English meaning
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
                      // small image tile
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
                      // question text + hint
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
                                _tinyTag('Danger'),
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

              // footer actions: skip + tiny score
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
      child: const Text(
        'Tag',
        style: TextStyle(
            color: Color(0xFF0F172A),
            fontWeight: FontWeight.w800,
            fontSize: 11),
      ).copyWith(Text(t)),
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

// ----------------- Result Screen (funny) -----------------
class AnathuruQuizResult extends StatelessWidget {
  final int score;
  final int total;
  final List<ImageDetails> items;
  const AnathuruQuizResult(
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
            // Emoji + title
            Text(
              emoji,
              style: const TextStyle(fontSize: 72),
            ),
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

            // Big score chip
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

            // Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AnathuruQuizScreen(items: items),
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

            // Small tip
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

// -------- tiny extension to help copy Text with different label (for _tinyTag above) ----
extension _TextCopy on Text {
  Text copyWith(Text other) => Text(
        other.data ?? '',
        key: key,
        style: style,
        strutStyle: strutStyle,
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        maxLines: maxLines,
        semanticsLabel: semanticsLabel,
        textWidthBasis: textWidthBasis,
        textHeightBehavior: textHeightBehavior,
        selectionColor: selectionColor,
      );
}
