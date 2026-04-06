import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show rootBundle, Clipboard, ClipboardData;
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

enum CenterType { licence, medical }

class LearnersMapScreen extends StatefulWidget {
  const LearnersMapScreen({super.key});

  @override
  State<LearnersMapScreen> createState() => _LearnersMapScreenState();
}

class _LearnersMapScreenState extends State<LearnersMapScreen> {
  final MapController _map = MapController();

  // Sri Lanka bounds
  final _slCenter = const LatLng(7.8731, 80.7718);
  final _slBounds = LatLngBounds.fromPoints(const [
    LatLng(5.70, 79.60),
    LatLng(9.90, 81.90),
  ]);

  // ---- state
  final _search = TextEditingController();
  CenterType _filter = CenterType.licence; // SINGLE selection

  List<_Place> _all = [];

  List<_Place> get _filtered {
    final q = _search.text.trim().toLowerCase();
    return _all.where((p) {
      final byType = p.type == _filter;
      final byText = q.isEmpty ||
          p.name.toLowerCase().contains(q) ||
          (p.addr ?? '').toLowerCase().contains(q);
      return byType && byText;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    Future<List<_Place>> loadFile(String path, CenterType t) async {
      final raw = await rootBundle.loadString(path);
      final List data = json.decode(raw);
      return data
          .map((e) => _Place.fromJson(Map<String, dynamic>.from(e), t))
          .toList();
    }

    try {
      final results = await Future.wait([
        loadFile('assets/centers/dl_centers.json', CenterType.licence),
        loadFile('assets/centers/medical_centers.json', CenterType.medical),
      ]);
      _all = [...results[0], ...results[1]];
    } catch (_) {
      _all = [
        _Place('DMT – Werahera (ODS)', 6.84094, 79.92202, 'Werahera, Colombo',
            CenterType.licence),
        _Place(
            'NTMI – Nugegoda', 6.8721, 79.8886, 'Nugegoda', CenterType.medical),
      ];
    }

    if (!mounted) return;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) => _recenterSL());
  }

  // ---- map helpers
  void _recenterSL() {
    _map.fitCamera(
      CameraFit.bounds(bounds: _slBounds, padding: const EdgeInsets.all(60)),
    );
  }

  void _zoomToMarker(_Place p, {double targetZoom = 15}) {
    _map.move(LatLng(p.lat, p.lng), targetZoom);
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) _showPlaceSheet(p);
    });
  }

  Future<void> _openExternalMaps(_Place p) async {
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${p.lat},${p.lng}');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  // ---- sheets
  void _openListSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 12,
            right: 12,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 12,
            top: 6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  _typeChip(CenterType.licence, 'Licence', Icons.badge_rounded),
                  const SizedBox(width: 6),
                  _typeChip(CenterType.medical, 'Medical',
                      Icons.medical_services_rounded),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5EAF0)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    const Icon(Icons.search,
                        color: Color(0xFF475569), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _search,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText: 'Search a centre…',
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
                            size: 18, color: Color(0xFF475569)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final p = _filtered[i];
                    return ListTile(
                      leading: Icon(_iconFor(p.type), color: _colorFor(p.type)),
                      title: Text(p.name,
                          style: const TextStyle(fontWeight: FontWeight.w800)),
                      subtitle: p.addr == null
                          ? null
                          : Text(p.addr!,
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.pop(context);
                        _zoomToMarker(p);
                      },
                      onLongPress: () => _showPlaceSheet(p),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPlaceSheet(_Place p) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(p.name,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            if (p.addr != null) ...[
              const SizedBox(height: 6),
              Text(p.addr!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF475569))),
            ],
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.directions),
              title: const Text('Open in Google Maps'),
              onTap: () {
                Navigator.pop(context);
                _openExternalMaps(p);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy_rounded),
              title: const Text('Copy coordinates'),
              onTap: () async {
                await Clipboard.setData(
                    ClipboardData(text: '${p.lat}, ${p.lng}'));
                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Copied')));
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---- chips (single select)
  Widget _typeChip(CenterType t, String label, IconData icon) {
    final selected = _filter == t;
    return Expanded(
      child: ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 16,
                color: selected ? Colors.white : const Color(0xFF475569)),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: selected ? Colors.white : const Color(0xFF475569),
                )),
          ],
        ),
        selected: selected,
        onSelected: (_) => setState(() => _filter = t),
        backgroundColor: const Color(0xFFF1F5F9),
        selectedColor: _colorFor(t),
        side: const BorderSide(color: Color(0xFFE5EAF0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static Color _colorFor(CenterType t) => t == CenterType.licence
      ? const Color(0xFF5B40E6)
      : const Color(0xFF00B894);

  static IconData _iconFor(CenterType t) => t == CenterType.licence
      ? Icons.badge_rounded
      : Icons.medical_services_rounded;

  @override
  Widget build(BuildContext context) {
    // dynamic title by filter
    final titleText =
        _filter == CenterType.licence ? 'Licence Centres' : 'Medical Centres';

    // markers from filtered list (only one type shown at a time)
    final markers = _filtered
        .map(
          (p) => Marker(
            point: LatLng(p.lat, p.lng),
            width: 44,
            height: 44,
            child: GestureDetector(
              onTap: () => _zoomToMarker(p),
              child: Container(
                decoration: BoxDecoration(
                  color: _colorFor(p.type),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x44000000),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(_iconFor(p.type), color: Colors.white, size: 22),
              ),
            ),
          ),
        )
        .toList();

    final useCluster = markers.length >= 18;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 64,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(
                _filter == CenterType.licence
                    ? Icons.badge_rounded
                    : Icons.medical_services_rounded,
                color: _colorFor(_filter),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                titleText,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _colorFor(_filter),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_filtered.length}',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 6),
            IconButton(
              tooltip: 'List',
              onPressed: _openListSheet,
              icon:
                  const Icon(Icons.list_alt_rounded, color: Color(0xFF475569)),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF7451FF), Color(0xFF5B40E6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 14,
                    offset: Offset(0, 8))
              ],
            ),
            child: Row(
              children: [
                _typeChip(CenterType.licence, 'Licence', Icons.badge_rounded),
                const SizedBox(width: 8),
                _typeChip(CenterType.medical, 'Medical',
                    Icons.medical_services_rounded),
              ],
            ),
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: _all.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              mapController: _map,
              options: MapOptions(
                initialCenter: _slCenter,
                initialZoom: 7.2,
                minZoom: 5,
                maxZoom: 19,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.vmmobile.drivehublk',
                  retinaMode: true,
                ),
                if (useCluster)
                  MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                      maxClusterRadius: 45,
                      size: const Size(42, 42),
                      markers: markers,
                      builder: (ctx, clusterMarkers) => GestureDetector(
                        onTap: () {
                          final b = LatLngBounds.fromPoints(
                            clusterMarkers.map((m) => m.point).toList(),
                          );
                          _map.fitCamera(
                            CameraFit.bounds(
                              bounds: b,
                              padding: const EdgeInsets.all(60),
                            ),
                          );
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color(0xFF7C4DFF),
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color(0x33000000), blurRadius: 8)
                                ],
                              ),
                              child: const Icon(Icons.layers_rounded,
                                  color: Colors.white, size: 20),
                            ),
                            Positioned(
                              right: -4,
                              top: -4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.75),
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                ),
                                child: Text(
                                  '${clusterMarkers.length}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  MarkerLayer(markers: markers),
              ],
            ),
      // 🔻 Sri Lanka -> bottom floating button
      floatingActionButton: _all.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _recenterSL,
              backgroundColor: _colorFor(_filter),
              icon: const Icon(
                Icons.my_location_rounded,
                color: Colors.white,
              ),
              label: const Text('Sri Lanka',
                  style: TextStyle(
                      fontWeight: FontWeight.w900, color: Colors.white)),
              tooltip: 'Recenter to Sri Lanka',
            ),
    );
  }
}

// -------------------- model --------------------
class _Place {
  final String name;
  final double lat;
  final double lng;
  final String? addr;
  final CenterType type;

  _Place(this.name, this.lat, this.lng, this.addr, this.type);

  factory _Place.fromJson(Map<String, dynamic> j, CenterType type) => _Place(
        j['name'] as String,
        (j['lat'] as num).toDouble(),
        (j['lng'] as num).toDouble(),
        j['addr'] as String?,
        type,
      );
}
