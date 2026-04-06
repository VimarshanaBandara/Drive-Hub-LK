// lib/service_screen/services_screen.dart
import 'package:drive_hub_lk_srilanka/map_screen/learners_map_screen.dart';
import 'package:drive_hub_lk_srilanka/pass_papers_screen/pass_papers_home.dart';
import 'package:drive_hub_lk_srilanka/syllabus_screen/syllabus_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
// Keeping WebView imports in case you use WebViewPage elsewhere
import 'package:webview_flutter/webview_flutter.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

// Added "centres"
enum _Category {
  all,
  dmt,
  licence,
  forms,
  vehicle,
  medical,
  study,
  syllabus,
  centres
}

class _ServicesScreenState extends State<ServicesScreen> {
  final _search = TextEditingController();
  _Category _cat = _Category.all;

  static const purple1 = Color(0xFF7451FF);
  static const purple2 = Color(0xFF5B40E6);
  static const ink = Color(0xFF0F172A);
  static const slate = Color(0xFF475569);
  static const bg = Color(0xFFF1F4F8);

  // NOTE: mark official sites as external:true (opens system browser)
  late final List<_ServiceItem> _items = [
    // _ServiceItem(
    //   title: 'DMT Appointments',
    //   icon: Icons.calendar_month_rounded,
    //   url: 'https://dmtappointments.dmt.gov.lk/',
    //   category: _Category.dmt,
    //   external: true, // <-- open in browser
    // ),
    // _ServiceItem(
    //   title: 'Driving Licence',
    //   icon: Icons.badge_rounded,
    //   url:
    //       'https://dmt.gov.lk/index.php?option=com_content&view=category&layout=blog&id=12&Itemid=204&lang=en',
    //   category: _Category.licence,
    //   external: true,
    // ),
    // _ServiceItem(
    //   title: 'Download Forms',
    //   icon: Icons.download_for_offline_rounded,
    //   url:
    //       'https://dmt.gov.lk/index.php?option=com_content&view=article&id=17&Itemid=133&lang=en#forms',
    //   category: _Category.forms,
    //   external: true,
    // ),
    // _ServiceItem(
    //   title: 'Vehicle Services',
    //   icon: Icons.directions_car_rounded,
    //   url:
    //       'https://dmt.gov.lk/index.php?option=com_content&view=category&layout=blog&id=11&Itemid=203&lang=en',
    //   category: _Category.vehicle,
    //   external: true,
    // ),
    // _ServiceItem(
    //   title: 'Medical Appointments (eChannelling)',
    //   icon: Icons.medical_information_rounded,
    //   url: 'https://www.echannelling.com/driving-license-medical',
    //   category: _Category.medical,
    //   external: true,
    // ),

    // In-app pages
    _ServiceItem(
      title: 'Pass Papers',
      icon: Icons.menu_book_rounded,
      page: (_) => const PassPapersHome(),
      category: _Category.study,
    ),
    _ServiceItem(
      title: 'Syllabus',
      icon: Icons.article_rounded,
      page: (_) => const SyllabusHome(),
      category: _Category.syllabus,
    ),
    _ServiceItem(
      title: 'Centres Map (Licence & Medical)',
      icon: Icons.map_rounded,
      page: (_) => const LearnersMapScreen(),
      category: _Category.centres,
    ),
  ];

  List<_ServiceItem> get _filtered {
    final q = _search.text.trim().toLowerCase();
    return _items.where((e) {
      final byCat = _cat == _Category.all || e.category == _cat;
      final byText = q.isEmpty ||
          e.title.toLowerCase().contains(q) ||
          (e.url?.toLowerCase().contains(q) ?? false);
      return byCat && byText;
    }).toList();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _openExternal(String url) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      _toast(context, 'Couldn’t open browser');
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cross = w >= 1000
        ? 4
        : w >= 740
            ? 3
            : 2;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .5,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        title: const Text('More',
            style: TextStyle(color: ink, fontWeight: FontWeight.w900)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header banner
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Container(
                height: 104,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [purple1, purple2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x33000000),
                        blurRadius: 14,
                        offset: Offset(0, 8)),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -40,
                      top: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(.28),
                              Colors.transparent
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Center(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: Row(
                          children: [
                            Icon(Icons.room_preferences_rounded,
                                color: Colors.white, size: 34),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'More options in • DriveHub LK',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Compliance mini-banner (Play Store friendly)
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            //   child: Container(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            //     decoration: BoxDecoration(
            //       color: const Color(0xFFF8FAFC),
            //       borderRadius: BorderRadius.circular(12),
            //       border: Border.all(color: const Color(0xFFE5EAF0)),
            //     ),
            //     child: const Row(
            //       children: [
            //         Icon(Icons.info_outline, color: slate, size: 18),
            //         SizedBox(width: 8),
            //         Expanded(
            //           child: Text(
            //             'Unofficial app — links open the official DMT/NTMI/eChannelling websites in your browser.',
            //             style: TextStyle(
            //                 color: slate,
            //                 fontWeight: FontWeight.w700,
            //                 fontSize: 12.5),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            // Search
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
            //   child: Container(
            //     height: 46,
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.circular(14),
            //       border: Border.all(color: const Color(0xFFE5EAF0)),
            //     ),
            //     padding: const EdgeInsets.symmetric(horizontal: 12),
            //     child: Row(
            //       children: [
            //         const Icon(Icons.search, color: slate, size: 20),
            //         const SizedBox(width: 8),
            //         Expanded(
            //           child: TextField(
            //             controller: _search,
            //             onChanged: (_) => setState(() {}),
            //             decoration: const InputDecoration(
            //               hintText: 'Search a service…',
            //               border: InputBorder.none,
            //             ),
            //             style: const TextStyle(
            //                 color: ink, fontWeight: FontWeight.w600),
            //           ),
            //         ),
            //         if (_search.text.isNotEmpty)
            //           GestureDetector(
            //             onTap: () {
            //               _search.clear();
            //               setState(() {});
            //             },
            //             child: const Icon(Icons.close, color: slate, size: 18),
            //           ),
            //       ],
            //     ),
            //   ),
            // ),

            // Category chips
            // SizedBox(
            //   height: 44,
            //   child: ListView(
            //     padding: const EdgeInsets.symmetric(horizontal: 12),
            //     scrollDirection: Axis.horizontal,
            //     children: [
            //       _chip('All', _Category.all),
            //       _chip('DMT', _Category.dmt),
            //       _chip('Licence', _Category.licence),
            //       _chip('Forms', _Category.forms),
            //       _chip('Vehicle', _Category.vehicle),
            //       _chip('Medical', _Category.medical),
            //       _chip('Pass Papers', _Category.study),
            //       _chip('Syllabus', _Category.syllabus),
            //       _chip('Centres Map', _Category.centres),
            //     ],
            //   ),
            // ),

            const SizedBox(height: 8),

            // Grid
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(
                      child: Text('No services found',
                          style: TextStyle(
                              color: slate, fontWeight: FontWeight.w700)),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                      itemCount: _filtered.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cross,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: .96,
                      ),
                      itemBuilder: (_, i) => _ServiceCard(
                        item: _filtered[i],
                        onTap: () async {
                          final it = _filtered[i];
                          if (it.page != null) {
                            Navigator.push(
                                context, MaterialPageRoute(builder: it.page!));
                          } else if (it.external && it.url != null) {
                            await _openExternal(
                                it.url!); // <-- external browser
                          } else if (it.url != null) {
                            // fallback path if you ever set external:false
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    WebViewPage(title: it.title, url: it.url!),
                              ),
                            );
                          }
                        },
                        onLongPress: _filtered[i].url == null
                            ? null
                            : () => _showItemSheet(context, _filtered[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, _Category cat) {
    final selected = _cat == cat;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : slate)),
        selected: selected,
        onSelected: (_) => setState(() => _cat = cat),
        backgroundColor: const Color(0xFFF8FAFC),
        selectedColor: purple1,
        side: const BorderSide(color: Color(0xFFE5EAF0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _showItemSheet(BuildContext context, _ServiceItem item) async {
    if (item.url == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: ink, fontWeight: FontWeight.w900, fontSize: 16)),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.open_in_browser_rounded),
              title: const Text('Open in browser'),
              onTap: () async {
                Navigator.pop(context);
                await _openExternal(item.url!);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy_rounded),
              title: const Text('Copy link'),
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: item.url!));
                if (context.mounted) {
                  Navigator.pop(context);
                  _toast(context, 'Link copied');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w700)),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

// ================== models & widgets ==================

class _ServiceItem {
  final String title;
  final IconData icon;
  final String? url; // optional external link
  final WidgetBuilder? page; // optional in-app page
  final _Category category;
  final bool external; // <-- mark official site links

  const _ServiceItem({
    required this.title,
    required this.icon,
    this.url,
    this.page,
    required this.category,
    this.external = false,
  }) : assert(url != null || page != null,
            'Provide either a url or a page for a service item.');
}

class _ServiceCard extends StatelessWidget {
  final _ServiceItem item;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  const _ServiceCard({
    required this.item,
    required this.onTap,
    this.onLongPress,
  });

  static const purple1 = Color(0xFF7451FF);
  static const purple2 = Color(0xFF5B40E6);

  @override
  Widget build(BuildContext context) {
    final isExternal = item.external && item.url != null;
    final isInApp = item.page != null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [purple1, purple2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 12,
                    offset: Offset(0, 8)),
              ],
            ),
            child: Stack(
              children: [
                // Subtle shine
                Positioned(
                  top: -10,
                  right: -30,
                  child: Transform.rotate(
                    angle: -0.6,
                    child: Container(
                      width: 130,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(.22),
                            Colors.white.withOpacity(.04)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                // Badge — Official / In App
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isExternal
                          ? Colors.black.withOpacity(.55)
                          : Colors.white.withOpacity(.18),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(.35)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isExternal
                              ? Icons.verified_rounded
                              : Icons.phone_iphone,
                          size: 12,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isExternal
                              ? 'OFFICIAL SITE'
                              : (isInApp ? 'IN APP' : 'LINK'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Content
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.18),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(item.icon, color: Colors.white, size: 34),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        if (isExternal)
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              'Opens in browser',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // External icon hint
                if (isExternal)
                  const Positioned(
                    right: 10,
                    bottom: 10,
                    child: Icon(Icons.open_in_new_rounded,
                        color: Colors.white70, size: 18),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ========================= Optional Reusable WebView page =========================
class WebViewPage extends StatefulWidget {
  final String title;
  final String url;
  const WebViewPage({super.key, required this.title, required this.url});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController _controller;
  int _progress = 0;
  WebResourceError? _lastError;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) => setState(() => _progress = p),
          onWebResourceError: (err) => setState(() => _lastError = err),
          onNavigationRequest: (req) {
            final allow =
                req.url.startsWith('http://') || req.url.startsWith('https://');
            return allow
                ? NavigationDecision.navigate
                : NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<bool> _handleBack() async {
    if (await _controller.canGoBack()) {
      _controller.goBack();
      return false;
    }
    return true;
  }

  Future<void> _openInBrowser() async {
    final uri = Uri.parse(widget.url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Couldn’t open browser'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _lastError != null;

    return WillPopScope(
      onWillPop: _handleBack,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: .5,
          title: Text(
            widget.title,
            style: const TextStyle(
                color: Color(0xFF0F172A), fontWeight: FontWeight.w900),
          ),
          actions: [
            IconButton(
              tooltip: 'Back',
              onPressed: () async {
                if (await _controller.canGoBack()) _controller.goBack();
              },
              icon: const Icon(Icons.arrow_back_rounded,
                  color: Color(0xFF475569)),
            ),
            IconButton(
              tooltip: 'Forward',
              onPressed: () async {
                if (await _controller.canGoForward()) _controller.goForward();
              },
              icon: const Icon(Icons.arrow_forward_rounded,
                  color: Color(0xFF475569)),
            ),
            IconButton(
              tooltip: 'Reload',
              onPressed: () {
                setState(() => _lastError = null);
                _controller.reload();
              },
              icon: const Icon(Icons.refresh_rounded, color: Color(0xFF475569)),
            ),
            IconButton(
              tooltip: 'Open in Browser',
              onPressed: _openInBrowser,
              icon: const Icon(Icons.open_in_browser_rounded,
                  color: Color(0xFF475569)),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(3),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _progress == 100 ? 0 : 1,
              child: LinearProgressIndicator(
                value: _progress == 0 ? null : _progress / 100,
                minHeight: 3,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF7C4DFF)),
              ),
            ),
          ),
        ),
        body: hasError
            ? _ErrorView(
                message: _lastError!.errorCode == -2
                    ? 'No internet connection'
                    : 'Failed to load page',
                onRetry: () {
                  setState(() => _lastError = null);
                  _controller.loadRequest(Uri.parse(widget.url));
                },
              )
            : WebViewWidget(controller: _controller),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 56, color: Color(0xFF94A3B8)),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color(0xFF475569), fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
