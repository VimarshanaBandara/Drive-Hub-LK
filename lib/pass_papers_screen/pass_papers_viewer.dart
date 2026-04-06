import 'package:flutter/material.dart';

class PassPapersViewer extends StatelessWidget {
  final String title;
  final int start;
  final int end;
  const PassPapersViewer(
      {super.key, required this.title, required this.start, required this.end});

  List<String> _paths() {
    // Files: assets/pass_papers/SL_Licence_paper (1).png ... (95).png
    return [
      for (int i = start; i <= end; i++)
        'assets/pass_papers/SL_Licence_paper ($i).png'
    ];
  }

  @override
  Widget build(BuildContext context) {
    final paths = _paths();
    final w = MediaQuery.of(context).size.width;
    final cross = w >= 1200
        ? 4
        : w >= 800
            ? 3
            : 2;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: .5,
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w900, color: Color(0xFF0F172A))),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
        itemCount: paths.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cross,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: .75,
        ),
        itemBuilder: (_, i) {
          final p = paths[i];
          return _ThumbTile(
            index: i,
            path: p,
            onTap: () => Navigator.push(
              _,
              MaterialPageRoute(
                builder: (_) => _FullScreenGallery(
                    paths: paths, initialIndex: i, title: title),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ThumbTile extends StatelessWidget {
  final int index;
  final String path;
  final VoidCallback onTap;
  const _ThumbTile(
      {required this.index, required this.path, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5EAF0)),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 8,
                    offset: Offset(0, 6))
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Hero(
                    tag: path,
                    child: Image.asset(path, fit: BoxFit.contain),
                  ),
                ),
                Container(
                  height: 36,
                  alignment: Alignment.center,
                  color: const Color(0xFFF1F5F9),
                  child: Text('Q${index + 1}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF334155))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FullScreenGallery extends StatefulWidget {
  final List<String> paths;
  final int initialIndex;
  final String title;
  const _FullScreenGallery(
      {required this.paths, required this.initialIndex, required this.title});

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  late PageController _pc = PageController(initialPage: widget.initialIndex);
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1220),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          '${widget.title}  •  ${_index + 1}/${widget.paths.length}',
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
      ),
      body: PageView.builder(
        controller: _pc,
        onPageChanged: (i) => setState(() => _index = i),
        itemCount: widget.paths.length,
        itemBuilder: (_, i) {
          final p = widget.paths[i];
          return InteractiveViewer(
            minScale: 0.8,
            maxScale: 4,
            child: Center(
              child: Hero(tag: p, child: Image.asset(p, fit: BoxFit.contain)),
            ),
          );
        },
      ),
    );
  }
}
