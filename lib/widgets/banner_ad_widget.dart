import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Android Banner Ad Unit ID (Production)
const _kBannerAdUnitId = 'ca-app-pub-7778261196555839/9137056397';

/// Reusable adaptive banner ad widget.
///
/// ✔ Screen width එකට auto-resize වෙනවා (responsive).
/// ✔ Ad load වෙනකන් layout shift නෑ — SizedBox.shrink() return කරනවා.
/// ✔ Widget dispose වෙන විට ad memory free කරනවා.
///
/// Usage: ඕනෑම Scaffold ේ `bottomNavigationBar: const BannerAdWidget()`
class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _ad;
  bool _loaded = false;

  // Load eko witarai request kara — didChangeDependencies repeated call avoid
  bool _requested = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_requested) {
      _requested = true;
      _loadAd();
    }
  }

  Future<void> _loadAd() async {
    // Screen width එකට fit වෙන adaptive banner size ගන්නවා
    final width = MediaQuery.of(context).size.width.truncate();
    final adSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);

    // Context invalid නම් හෝ size null නම් skip
    if (adSize == null || !mounted) return;

    BannerAd(
      adUnitId: _kBannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // Widget unmount වී ඇත්නම් ad leak avoid
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _ad = ad as BannerAd;
            _loaded = true;
          });
        },
        // Load fail — silently dispose, layout unaffected
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    ).load();
  }

  @override
  void dispose() {
    _ad?.dispose(); // memory free
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ad ready වෙනකන් space consume කරන්නේ නෑ
    if (!_loaded || _ad == null) return const SizedBox.shrink();

    return SizedBox(
      width: _ad!.size.width.toDouble(),
      height: _ad!.size.height.toDouble(),
      child: AdWidget(ad: _ad!),
    );
  }
}
