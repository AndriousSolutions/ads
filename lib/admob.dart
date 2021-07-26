library ads;

// Copyright 2019 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by the Apache License, Version 2.0 that can be
// found in the LICENSE file.

import 'dart:async' show Future;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show Container, Widget;

import 'package:google_mobile_ads/google_mobile_ads.dart' as g;

// import 'package:firebase_admob/firebase_admob.dart'
//     hide AdSize, BannerAd, InterstitialAd, MobileAdListener, NativeAd;

/// The Ads event function signature
typedef AdsListener = void Function(g.Ad ad);

/// Signature for a 'Load Error' callback
typedef VoidLoadErrorCallback = void Function(g.Ad ad, g.LoadAdError error);

/// Signature for a ['MobileAd'] status change callback.
typedef MobileAdListener = void Function(AdsEvent event);

/// Signature for a ['RewardAd'] status change callback.
typedef RewardListener = void Function(g.RewardedAd ad, g.RewardItem reward);

/// Signature for a ['AdError'] status change callback.
typedef AdErrorListener = void Function(Exception ex);

class BannerAd extends MobileAds {
  //
  factory BannerAd({required AdMobListener listener}) =>
      _this ??= BannerAd._(listener);
  BannerAd._(AdMobListener listener) : super(listener: listener) {
    listener.closedListener = () {
      loadAd(show: false);
    };
  }
  static BannerAd? _this;
  g.AdSize? _setSize;
  g.AdSize? _showSize;

//  final _bannerListener = AdMobListener(adEventListeners);

  Set<MobileAdListener> get eventListeners => listener!.eventListeners;

  // ignore: avoid_setters_without_getters
  set loadedListener(VoidCallback listener) =>
      this.listener!.loadedListener = listener;
  bool removeLoaded(VoidCallback listener) =>
      this.listener!.removeLoaded(listener);
  // ignore: avoid_setters_without_getters
  set failedListener(VoidLoadErrorCallback listener) =>
      this.listener!.failedListener = listener;
  bool removeFailed(VoidLoadErrorCallback listener) =>
      this.listener!.removeFailed(listener);
  // ignore: avoid_setters_without_getters
  set clickedListener(VoidCallback listener) =>
      this.listener!.clickedListener = listener;
  bool removeClicked(VoidCallback listener) =>
      this.listener!.removeClicked(listener);
  // ignore: avoid_setters_without_getters
  set impressionListener(VoidCallback listener) =>
      this.listener!.impressionListener = listener;
  bool removeImpression(VoidCallback listener) =>
      this.listener!.removeImpression(listener);
  // ignore: avoid_setters_without_getters
  set openedListener(VoidCallback listener) =>
      this.listener!.openedListener = listener;
  bool removeOpened(VoidCallback listener) =>
      this.listener!.removeOpened(listener);
  // ignore: avoid_setters_without_getters
  set leftAppListener(VoidCallback listener) =>
      this.listener!.leftAppListener = listener;
  bool removeLeftApp(VoidCallback listener) =>
      this.listener!.removeLeftApp(listener);
  // ignore: avoid_setters_without_getters
  set closedListener(VoidCallback listener) =>
      this.listener!.closedListener = listener;
  bool removeClosed(VoidCallback listener) =>
      this.listener!.removeClosed(listener);

  void clearAll() => listener!.clearAll();

  /// Set options to the Banner Ad.
  @override
  Future<bool> set({
    String? adUnitId,
    g.AdRequest? targetInfo,
    List<String>? keywords,
    String? contentUrl,
    bool? childDirected,
    List<String>? testDevices,
    bool? nonPersonalizedAds,
    bool? testing,
    g.AdSize? size,
    double? anchorOffset,
    double? horizontalCenterOffset,
//    AnchorType anchorType,
    AdErrorListener? errorListener,
  }) {
    super.set(
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      nonPersonalizedAds: nonPersonalizedAds,
      testing: testing,
      anchorOffset: anchorOffset,
      horizontalCenterOffset: horizontalCenterOffset,
//      anchorType: anchorType,
      errorListener: errorListener,
    );
    _setSize ??= size ?? g.AdSize.banner;
    return loadAd(
      show: false,
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      nonPersonalizedAds: nonPersonalizedAds,
      testing: testing,
      anchorOffset: anchorOffset,
      horizontalCenterOffset: horizontalCenterOffset,
//      anchorType: anchorType,
    );
  }

  /// Return the Banner Ad.
  Widget get widget => adWidget();

  @override
  g.BannerAd _createAd(
          {bool? testing, String? adUnitId, g.AdRequest? targetInfo}) =>
      g.BannerAd(
        size: _showSize ?? _setSize ?? g.AdSize.banner,
        adUnitId: testing!
            ? g.BannerAd.testAdUnitId
            : adUnitId!.isEmpty
                ? g.BannerAd.testAdUnitId
                : adUnitId.trim(),
        listener: listener!.createListener(),
        request: targetInfo!,
      );
}

class FullScreenAd extends MobileAds {
  //
  factory FullScreenAd({required AdMobListener listener}) =>
      _this ??= FullScreenAd._(listener);
  FullScreenAd._(AdMobListener listener) : super(listener: listener) {
    listener.closedListener = () {
      loadAd(show: false);
    };
  }

  static FullScreenAd? _this;
//  final AdMobListener? interstitialListener;

//  final _screenListener = AdMobListener(adEventListeners);

  Set<MobileAdListener> get eventListeners => listener!.eventListeners;

  get targetingInfo => null;

  // ignore: avoid_setters_without_getters
  set loadedListener(VoidCallback listener) =>
      this.listener!.loadedListener = listener;
  bool removeLoaded(VoidCallback listener) =>
      this.listener!.removeLoaded(listener);
  // ignore: avoid_setters_without_getters
  set failedListener(VoidLoadErrorCallback listener) =>
      this.listener!.failedListener = listener;
  bool removeFailed(VoidLoadErrorCallback listener) =>
      this.listener!.removeFailed(listener);
  // ignore: avoid_setters_without_getters
  set clickedListener(VoidCallback listener) =>
      this.listener!.clickedListener = listener;
  bool removeClicked(VoidCallback listener) =>
      this.listener!.removeClicked(listener);
  // ignore: avoid_setters_without_getters
  set impressionListener(VoidCallback listener) =>
      this.listener!.impressionListener = listener;
  bool removeImpression(VoidCallback listener) =>
      this.listener!.removeImpression(listener);
  // ignore: avoid_setters_without_getters
  set openedListener(VoidCallback listener) =>
      this.listener!.openedListener = listener;
  bool removeOpened(VoidCallback listener) =>
      this.listener!.removeOpened(listener);
  // ignore: avoid_setters_without_getters
  set leftAppListener(VoidCallback listener) =>
      this.listener!.leftAppListener = listener;
  bool removeLeftApp(VoidCallback listener) =>
      this.listener!.removeLeftApp(listener);
  // ignore: avoid_setters_without_getters
  set closedListener(VoidCallback listener) =>
      this.listener!.closedListener = listener;
  bool removeClosed(VoidCallback listener) =>
      this.listener!.removeClosed(listener);
  void clearAll() => listener!.clearAll();

  /// Set options for the Interstitial Ad
  @override
  Future<bool> set({
    String? adUnitId,
    g.AdRequest? targetInfo,
    List<String>? keywords,
    String? contentUrl,
    bool? childDirected,
    List<String>? testDevices,
    bool? nonPersonalizedAds,
    bool? testing,
    double? anchorOffset,
    double? horizontalCenterOffset,
//    AnchorType anchorType,
    AdErrorListener? errorListener,
  }) {
    super.set(
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      nonPersonalizedAds: nonPersonalizedAds,
      testing: testing,
      anchorOffset: anchorOffset,
      horizontalCenterOffset: horizontalCenterOffset,
//      anchorType: anchorType,
      errorListener: errorListener,
    );
    return loadAd(
      show: false,
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      testing: testing,
      anchorOffset: anchorOffset,
      horizontalCenterOffset: horizontalCenterOffset,
//      anchorType: anchorType,
    );
  }

  @override
  g.InterstitialAd _createAd({
    bool? testing,
    String? adUnitId,
    g.AdRequest? targetInfo,
  }) =>
      g.InterstitialAd(
        adUnitId: testing!
            ? g.InterstitialAd.testAdUnitId
            : adUnitId!.isEmpty
                ? g.InterstitialAd.testAdUnitId
                : adUnitId.trim(),
        listener: listener!.createListener(),
        request: targetInfo!,
      );
}

class NativeAd extends MobileAds {
  //
  factory NativeAd({required AdMobListener listener}) =>
      _this ??= NativeAd._(listener);
  NativeAd._(AdMobListener listener) : super(listener: listener) {
    listener.closedListener = () {
      loadAd(show: false);
    };
  }

  static NativeAd? _this;

  Set<MobileAdListener> get eventListeners => listener!.eventListeners;

  // ignore: avoid_setters_without_getters
  set loadedListener(VoidCallback listener) =>
      this.listener!.loadedListener = listener;
  bool removeLoaded(VoidCallback listener) =>
      this.listener!.removeLoaded(listener);
  // ignore: avoid_setters_without_getters
  set failedListener(VoidLoadErrorCallback listener) =>
      this.listener!.failedListener = listener;
  bool removeFailed(VoidLoadErrorCallback listener) =>
      this.listener!.removeFailed(listener);
  // ignore: avoid_setters_without_getters
  set clickedListener(VoidCallback listener) =>
      this.listener!.clickedListener = listener;
  bool removeClicked(VoidCallback listener) =>
      this.listener!.removeClicked(listener);
  // ignore: avoid_setters_without_getters
  set impressionListener(VoidCallback listener) =>
      this.listener!.impressionListener = listener;
  bool removeImpression(VoidCallback listener) =>
      this.listener!.removeImpression(listener);
  // ignore: avoid_setters_without_getters
  set openedListener(VoidCallback listener) =>
      this.listener!.openedListener = listener;
  bool removeOpened(VoidCallback listener) =>
      this.listener!.removeOpened(listener);
  // ignore: avoid_setters_without_getters
  set leftAppListener(VoidCallback listener) =>
      this.listener!.leftAppListener = listener;
  bool removeLeftApp(VoidCallback listener) =>
      this.listener!.removeLeftApp(listener);
  // ignore: avoid_setters_without_getters
  set closedListener(VoidCallback listener) =>
      this.listener!.closedListener = listener;
  bool removeClosed(VoidCallback listener) =>
      this.listener!.removeClosed(listener);
  void clearAll() => listener!.clearAll();

  /// An identifier for the factory that creates the Platform view.
  String? _factoryId;

  /// Set options to the Banner Ad.
  @override
  Future<bool> set({
    String? adUnitId,
    String? factoryId,
    g.AdRequest? targetInfo,
    List<String>? keywords,
    String? contentUrl,
    bool? childDirected,
    List<String>? testDevices,
    bool? nonPersonalizedAds,
    bool? testing,
    double? anchorOffset,
    double? horizontalCenterOffset,
//    AnchorType anchorType,
    AdErrorListener? errorListener,
  }) {
    // Override the initial id.
    if (factoryId != null && factoryId.isNotEmpty) {
      _factoryId = factoryId;
    }
    super.set(
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      nonPersonalizedAds: nonPersonalizedAds,
      testing: testing,
      anchorOffset: anchorOffset,
      horizontalCenterOffset: horizontalCenterOffset,
//      anchorType: anchorType,
      errorListener: errorListener,
    );
    return loadAd(
      show: false,
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      nonPersonalizedAds: nonPersonalizedAds,
      testing: testing,
      anchorOffset: anchorOffset,
      horizontalCenterOffset: horizontalCenterOffset,
//      anchorType: anchorType,
    );
  }

  /// Show the Native Ad.
  Widget get widget => adWidget();

  @override
  g.NativeAd _createAd({
    bool? testing,
    String? adUnitId,
    g.AdRequest? targetInfo,
  }) =>
      g.NativeAd(
        adUnitId: testing!
            ? g.NativeAd.testAdUnitId
            : adUnitId!.isEmpty
                ? g.NativeAd.testAdUnitId
                : adUnitId.trim(),
        factoryId: _factoryId!,
        listener: listener!.createListener(),
        request: targetInfo,
      );
}

class VideoAd extends MobileAds {
  //
  factory VideoAd({required AdMobListener listener}) =>
      _this ??= VideoAd._(listener);
  VideoAd._(AdMobListener listener) : super(listener: listener) {
    listener.closedListener = () {
      loadAd(show: false);
    };
  }

  static VideoAd? _this;

  Set<MobileAdListener> get eventListeners => listener!.eventListeners;

  // ignore: avoid_setters_without_getters
  set loadedListener(VoidCallback listener) =>
      this.listener!.loadedListener = listener;
  bool removeLoaded(VoidCallback listener) =>
      this.listener!.removeLoaded(listener);

  // ignore: avoid_setters_without_getters
  set failedListener(VoidLoadErrorCallback listener) =>
      this.listener!.failedListener = listener;
  bool removeFailed(VoidLoadErrorCallback listener) =>
      this.listener!.removeFailed(listener);

  // ignore: avoid_setters_without_getters
  set clickedListener(VoidCallback listener) =>
      this.listener!.clickedListener = listener;
  bool removeClicked(VoidCallback listener) =>
      this.listener!.removeClicked(listener);

  // ignore: avoid_setters_without_getters
  set impressionListener(VoidCallback listener) =>
      this.listener!.impressionListener = listener;
  bool removeImpression(VoidCallback listener) =>
      this.listener!.removeImpression(listener);

  // ignore: avoid_setters_without_getters
  set openedListener(VoidCallback listener) =>
      this.listener!.openedListener = listener;
  bool removeOpened(VoidCallback listener) =>
      this.listener!.removeOpened(listener);

  // ignore: avoid_setters_without_getters
  set leftAppListener(VoidCallback listener) =>
      this.listener!.leftAppListener = listener;
  bool removeLeftApp(VoidCallback listener) =>
      this.listener!.removeLeftApp(listener);

  // ignore: avoid_setters_without_getters
  set closedListener(VoidCallback listener) =>
      this.listener!.closedListener = listener;
  bool removeClosed(VoidCallback listener) =>
      this.listener!.removeClosed(listener);

  // ignore: avoid_setters_without_getters
  set rewardListener(RewardListener listener) =>
      this.listener!.rewardListener = listener;
  bool removeReward(RewardListener listener) =>
      this.listener!.removeReward(listener);

  void clearAll() => listener!.clearAll();

  /// Set the Video Ad's options.
  @override
  Future<bool> set({
    String? adUnitId,
    g.AdRequest? targetInfo,
    List<String>? keywords,
    String? contentUrl,
    bool? childDirected,
    List<String>? testDevices,
    bool? nonPersonalizedAds,
    bool? testing,
    double? anchorOffset,
    double? horizontalCenterOffset,
//    AnchorType anchorType,
    AdErrorListener? errorListener,
  }) {
    super.set(
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      nonPersonalizedAds: nonPersonalizedAds,
      testing: testing,
      anchorOffset: anchorOffset,
      horizontalCenterOffset: horizontalCenterOffset,
//      anchorType: anchorType,
      errorListener: errorListener,
    );
    return loadAd(
      show: false,
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      testing: testing,
      anchorOffset: anchorOffset,
      horizontalCenterOffset: horizontalCenterOffset,
//      anchorType: anchorType,
    );
  }

  /// Display the Ad
  @override
  bool show() => super.show();

  @override
  g.RewardedAd _createAd({
    bool? testing,
    String? adUnitId,
    g.AdRequest? targetInfo,
  }) =>
      g.RewardedAd(
        adUnitId: testing!
            ? g.RewardedAd.testAdUnitId
            : adUnitId!.isEmpty
                ? g.RewardedAd.testAdUnitId
                : adUnitId.trim(),
        listener: listener!.createListener(),
        request: targetInfo,
      );
}

abstract class MobileAds extends AdMob {
  MobileAds({this.listener}) {
    listener?.loadedListener = () {
      loaded = true;
    };
  }

  final AdMobListener? listener;

  g.AdRequest? _adRequest;

  List<String>? get keywords => _adRequest?.keywords;
  String? get contentUrl => _adRequest?.contentUrl;
  List<String>? get testDevices => _adRequest?.testDevices;
  bool? get nonPersonalizedAds => _adRequest?.nonPersonalizedAds;

  g.Ad? _ad;

  /// Provide the Ad object
  g.Ad? get ad => _ad;

  Key? _key;

  double? _anchorOffset;
  double? _horizontalCenterOffset;
//  AnchorType _anchorType;
  bool loaded = false;

  Future<bool> loadAd({
    required bool show,
    String? adUnitId,
    g.AdRequest? targetInfo,
    List<String>? keywords,
    String? contentUrl,
    bool? childDirected,
    List<String>? testDevices,
    bool? nonPersonalizedAds,
    bool? testing,
    double? anchorOffset,
    double? horizontalCenterOffset,
//    AnchorType anchorType,
  }) async {
    // Are we testing?
    testing ??= _testing;

    // Supply a valid unit id.
    if (adUnitId == null || adUnitId.isEmpty || adUnitId.length < 30) {
      adUnitId = _adUnitId;
    }

    targetInfo ??= _targetInfo(
      keywords: keywords,
      contentUrl: contentUrl,
      testDevices: testDevices,
      nonPersonalizedAds: nonPersonalizedAds,
    );

    // Save the info. into a class property.
    _adRequest = targetInfo;

    // Get rid of the ad if already created.
    await dispose();

    // Create the ad.
    _ad ??=
        _createAd(testing: testing, adUnitId: adUnitId, targetInfo: targetInfo);

    try {
      await _ad?.load();
      loaded = true;
    } catch (ex) {
      loaded = false;
      _setError(ex);
    }
    // Load the ad in memory.
    return loaded;
  }

  /// todo: Override and implement in a subclass.
  g.Ad _createAd({bool? testing, String? adUnitId, g.AdRequest? targetInfo});

  /// Set the MobileAd's options.
  @override
  void set({
    String? adUnitId,
    g.AdRequest? targetInfo,
    List<String>? keywords,
    String? contentUrl,
    bool? childDirected,
    List<String>? testDevices,
    bool? nonPersonalizedAds,
    bool? testing,
    double? anchorOffset,
    double? horizontalCenterOffset,
//    AnchorType anchorType,
    AdErrorListener? errorListener,
  }) {
    super.set(
      adUnitId: adUnitId,
      keywords: keywords,
      contentUrl: contentUrl,
      testDevices: testDevices,
      nonPersonalizedAds: nonPersonalizedAds,
      testing: testing,
      errorListener: errorListener,
    );
    _anchorOffset ??= anchorOffset;
    _horizontalCenterOffset ??= horizontalCenterOffset;
//    _anchorType ??= anchorType;
  }

  /// Explicitly load the Ad
  Future<bool> load() async {
    bool loaded = true;
    if (_ad != null) {
      try {
        await _ad?.load();
      } catch (ex) {
        loaded = false;
        _setError(ex);
      }
    }
    return loaded;
  }

  /// Determine if the Ad is loaded.
  Future<bool> isLoaded() async {
    bool loaded = false;
    if (_ad != null) {
      try {
        loaded = (await _ad?.isLoaded())!;
      } catch (ex) {
        loaded = false;
        _setError(ex);
      }
    }
    return loaded;
  }

  /// Display as a widget
  Widget adWidget({Key? key}) {
    Widget widget;
    if (_ad == null || _ad is! g.AdWithView) {
      widget = Container();
    } else {
      widget = g.AdWidget(key: key ?? _key, ad: _ad as g.AdWithView);
    }
    return widget;
  }

  /// Display the Ad
  @override
  bool show() {
    final show = loaded && _ad != null && _ad is g.AdWithoutView;
    if (show) {
      loaded = false; // It will have to load again.
      (_ad as g.AdWithoutView).show();
    }
    return show;
  }

  /// Clear the MobileAd reference.
  @override
  Future<void> dispose() async {
    if (_ad != null) {
      try {
        await _ad?.dispose();
      } catch (ex) {
        _setError(ex);
      }
      _ad = null;
    }
  }
}

abstract class AdMob {
  String? _adUnitId;
  List<String>? _keywords;
  String? _contentUrl;
  List<String>? _testDevices;
  bool? _nonPersonalizedAds;
  bool? _testing;

  Exception? _ex;
  final Set<AdErrorListener> _adErrorListeners = {};

  /// Return any exception
  Exception? getError() {
    final Exception? ex = _ex;
    _ex = null;
    return ex;
  }

  /// Indicate there was an error.
  bool get inError => _ex != null;

  /// Displays an error message if any.
  String get message => _ex?.toString() ?? '';

  void set({
    String? adUnitId,
    List<String>? keywords,
    String? contentUrl,
    List<String>? testDevices,
    bool? nonPersonalizedAds,
    bool? testing,
    AdErrorListener? errorListener,
  }) {
    if (adUnitId != null && adUnitId.isNotEmpty && adUnitId.length > 30) {
      _adUnitId ??= adUnitId;
    }

    _keywords ??= keywords;

    _contentUrl ??= contentUrl;

    _testDevices ??= testDevices;

    _nonPersonalizedAds ??= nonPersonalizedAds;

    _testing ??= testing;

    this.errorListener = errorListener;
  }

  // Must show the AdMob ad.
  void show();

  // Must dispose the object properly.
  void dispose();

  /// Return the target audience information
  g.AdRequest _targetInfo({
    List<String>? keywords,
    String? contentUrl,
    List<String>? testDevices,
    bool? nonPersonalizedAds,
  }) {
    // Either might be an 'empty' list.
    keywords ??= _keywords;

    // An 'empty' list is not passed.
    if (keywords!.isEmpty ||
        keywords.every((String? s) => s == null || s.isEmpty)) {
      keywords = null;
    }

    if (contentUrl == null) {
      contentUrl = _contentUrl;
    } else if (contentUrl.isEmpty) {
      contentUrl = null;
    }

    // Either might be an 'empty' list.
    testDevices ??= _testDevices;

    // An 'empty' list is not passed.
    if (testDevices!.isEmpty ||
        testDevices.every((String? s) => s == null || s.isEmpty)) {
      testDevices = null;
    }

    nonPersonalizedAds ??= _nonPersonalizedAds;

    return g.AdRequest(
      keywords: keywords,
      contentUrl: contentUrl,
      testDevices: testDevices,
      nonPersonalizedAds: nonPersonalizedAds,
    );
  }

  void _setError(Object ex) {
    if (ex is! Exception) {
      _ex = Exception(ex.toString());
    } else {
      _ex = ex;
    }
    // Run any listeners.
    _adErrorListener(_ex);
  }

  /// The Ad's Error Listener Function.
  void _adErrorListener(Exception? ex) {
    if (ex == null) {
      return;
    }
    for (final AdErrorListener listener in _adErrorListeners) {
      try {
        listener(ex);
      } catch (e) {
        // ignore: avoid_print
        print('AdMob: ${e.toString()}');
      }
    }
  }

  /// Set an Error Event Listener.
  // ignore: avoid_setters_without_getters
  set errorListener(AdErrorListener? listener) {
    if (listener != null) {
      _adErrorListeners.add(listener);
    }
  }

  /// Remove a specific Error Listener.
  bool removeError(AdErrorListener listener) =>
      _adErrorListeners.remove(listener);

  /// Empty any error handlers from memory.
  void clearErrorListeners() => _adErrorListeners.clear();
}

/// Ads listener
class AdMobListener {
  AdMobListener([this._adEventListeners]) {
    _adEventListeners ??= {};
  }
  Set<MobileAdListener>? _adEventListeners;

  Set<MobileAdListener> eventListeners = {};

  /// Listens for when the Ad is loaded in memory.
  final Set<VoidCallback> _loadedListeners = {};

  // ignore: avoid_setters_without_getters
  set loadedListener(VoidCallback listener) => _loadedListeners.add(listener);
  bool removeLoaded(VoidCallback listener) => _loadedListeners.remove(listener);
  void _clearLoaded() => _loadedListeners.clear();

  /// Listens for when the Ad fails to display.
  final Set<VoidLoadErrorCallback> _failedListeners = {};

  // ignore: avoid_setters_without_getters
  set failedListener(VoidLoadErrorCallback listener) =>
      _failedListeners.add(listener);
  bool removeFailed(VoidLoadErrorCallback listener) =>
      _failedListeners.remove(listener);
  void _clearFailed() => _failedListeners.clear();

  /// Listens for when the Ad is clicked on.
  final Set<VoidCallback> _clickedListeners = {};

  // ignore: avoid_setters_without_getters
  set clickedListener(VoidCallback listener) => _clickedListeners.add(listener);
  bool removeClicked(VoidCallback listener) =>
      _clickedListeners.remove(listener);
  void _clearClicked() => _clickedListeners.clear();

  /// Listens for when the user clicks further on the Ad.
  final Set<VoidCallback> _impressionListeners = {};

  // ignore: avoid_setters_without_getters
  set impressionListener(VoidCallback listener) =>
      _impressionListeners.add(listener);
  bool removeImpression(VoidCallback listener) =>
      _impressionListeners.remove(listener);
  void _clearImpression() => _impressionListeners.clear();

  /// Listens for when the Ad is opened.
  final Set<VoidCallback> _openedListeners = {};

  // ignore: avoid_setters_without_getters
  set openedListener(VoidCallback listener) => _openedListeners.add(listener);
  bool removeOpened(VoidCallback listener) => _openedListeners.remove(listener);
  void _clearOpened() => _openedListeners.clear();

  /// Listens for when the user has left the Ad.
  final Set<VoidCallback> _leftListeners = {};

  /// todo: Rename to 'exit'
  // ignore: avoid_setters_without_getters
  set leftAppListener(VoidCallback listener) => _leftListeners.add(listener);
  bool removeLeftApp(VoidCallback listener) => _leftListeners.remove(listener);
  void _clearLeftApp() => _leftListeners.clear();

  /// Listens for when the Ad is closed.
  final Set<VoidCallback> _closedListeners = {};

  // ignore: avoid_setters_without_getters
  set closedListener(VoidCallback listener) => _closedListeners.add(listener);
  bool removeClosed(VoidCallback listener) => _closedListeners.remove(listener);
  void _clearClosed() => _closedListeners.clear();

  /// Listens for when the Ad is loaded in memory.
  final Set<RewardListener> _rewardListeners = {};

  // ignore: avoid_setters_without_getters
  set rewardListener(RewardListener listener) => _rewardListeners.add(listener);
  bool removeReward(RewardListener listener) =>
      _rewardListeners.remove(listener);
  void _clearReward() => _rewardListeners.clear();

  /// The Ad's Event Listener Function.
  void eventListener(g.Ad ad, AdsEvent event, [g.LoadAdError? error]) {
    //
    for (final listener in _adEventListeners!) {
      try {
        listener(event);
      } catch (ex) {
        eventError(ex, event: event);
      }
    }

    for (final listener in eventListeners) {
      try {
        listener(event);
      } catch (ex) {
        eventError(ex, event: event);
      }
    }

    switch (event) {
      case AdsEvent.onAdLoaded:
        for (final listener in _loadedListeners) {
          try {
            listener();
          } catch (ex) {
            eventError(
              ex,
              event: AdsEvent.onAdLoaded,
            );
          }
        }

        break;
      case AdsEvent.onAdFailedToLoad:
        for (final listener in _failedListeners) {
          try {
            listener(ad, error!);
          } catch (ex) {
            eventError(ex, event: AdsEvent.onAdFailedToLoad);
          }
        }

        break;
      case AdsEvent.onNativeAdClicked:
        for (final listener in _clickedListeners) {
          try {
            listener();
          } catch (ex) {
            eventError(ex, event: AdsEvent.onNativeAdClicked);
          }
        }

        break;
      case AdsEvent.onNativeAdImpression:
        for (final listener in _impressionListeners) {
          try {
            listener();
          } catch (ex) {
            eventError(ex, event: AdsEvent.onNativeAdImpression);
          }
        }

        break;
      case AdsEvent.onAdOpened:
        for (final listener in _openedListeners) {
          try {
            listener();
          } catch (ex) {
            eventError(ex, event: AdsEvent.onAdOpened);
          }
        }

        break;
      case AdsEvent.onApplicationExit:
        for (final listener in _leftListeners) {
          try {
            listener();
          } catch (ex) {
            eventError(ex, event: AdsEvent.onApplicationExit);
          }
        }

        break;
      case AdsEvent.onAdClosed:
        for (final listener in _closedListeners) {
          try {
            listener();
          } catch (ex) {
            eventError(ex, event: AdsEvent.onAdClosed);
          }
        }

        break;
      default:
    }

    // Notify the developer of any errors.
    assert(eventErrors.isEmpty, 'Ads: Errors in Ad Events! Refer to logcat.');
  }

  void rewardedListener(g.RewardedAd ad, g.RewardItem reward) {
    for (final listener in _rewardListeners) {
      try {
        listener(ad, reward);
      } catch (ex) {
        eventError(ex, event: AdsEvent.onRewardedAdUserEarnedReward);
      }
    }
  }

  void clearAll() {
    _clearLoaded();
    _clearFailed();
    _clearClicked();
    _clearImpression();
    _clearOpened();
    _clearLeftApp();
    _clearClosed();
    _clearReward();
  }

  /// Supply a comprehensive Ad Listener to all for multiple listeners assigned.
  g.AdListener createListener() => g.AdListener(
        onAdLoaded: (g.Ad ad) => eventListener(ad, AdsEvent.onAdLoaded),
        onAdFailedToLoad: (g.Ad ad, g.LoadAdError error) =>
            eventListener(ad, AdsEvent.onAdFailedToLoad, error),
        onNativeAdClicked: (g.NativeAd ad) =>
            eventListener(ad, AdsEvent.onNativeAdClicked),
        onNativeAdImpression: (g.NativeAd ad) =>
            eventListener(ad, AdsEvent.onNativeAdImpression),
        onAdOpened: (g.Ad ad) => eventListener(ad, AdsEvent.onAdOpened),
        onApplicationExit: (g.Ad ad) =>
            eventListener(ad, AdsEvent.onApplicationExit),
        onAdClosed: (g.Ad ad) => eventListener(ad, AdsEvent.onAdClosed),
        onRewardedAdUserEarnedReward: (g.RewardedAd ad, g.RewardItem reward) {
          eventListener(ad, AdsEvent.onRewardedAdUserEarnedReward);
          rewardedListener(ad, reward);
        },
        onAppEvent: (g.Ad ad, String name, String data) =>
            eventListener(ad, AdsEvent.onAppEvent),
      );
}

/// The possible events that may occurs working with Ads.
enum AdsEvent {
  onAdLoaded,
  onAdFailedToLoad,
  onNativeAdClicked,
  onNativeAdImpression,
  onAdOpened,
  onApplicationExit,
  onAdClosed,
  onRewardedAdUserEarnedReward,
  onAppEvent,
}

List<EventError> eventErrors = [];

List<EventError> getEventErrors() {
  final List<EventError> list = eventErrors;
  eventErrors = [];
  return list;
}

/// Error Handler for the event listeners.
void eventError(Object ex, {AdsEvent? event}) {
  if (ex is! Exception) {
    ex = Exception(ex.toString());
  }
  eventErrors.add(EventError(event, ex));
  // ignore: avoid_print
  print('Ads: $event - ${ex.toString()}');
  // Loop through any error listeners.
  _adErrorListener(ex);
}

/// Event Error class
class EventError {
  EventError(this.event, this.ex);
  AdsEvent? event;
  Exception ex;
}

Set<MobileAdListener> adEventListeners = {};

Set<AdErrorListener> eventErrorListeners = {};

/// The Ad's Error Listener Function.
void _adErrorListener(Exception? ex) {
  if (ex == null) {
    return;
  }
  for (final AdErrorListener listener in eventErrorListeners) {
    try {
      listener(ex);
    } catch (e) {
      // ignore: avoid_print
      print('Ads: ${e.toString()}');
    }
  }
}
