library ads;
// Copyright 2019 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by the Apache License, Version 2.0 that can be
// found in the LICENSE file.
//
// http://www.apache.org/licenses/LICENSE-2.0
//

import 'dart:async';

import 'dart:developer' show log;

import 'package:flutter/material.dart';

import 'package:ads/admob.dart' as m
    show
        AdErrorListener,
        AdMobListener,
        adEventListeners,
        Banner,
        eventErrors,
        eventErrorListeners,
        FullScreenAd,
        MobileAdListener,
        Native,
        VideoAd;

import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Export the very library file needed for the developer to also use.
export 'package:google_mobile_ads/google_mobile_ads.dart';

/// Export types and properties for the developer to use.
export 'package:ads/admob.dart' hide MobileAds, FullScreenAd;

/// Signature for a ['AdError'] status change callback.
//typedef void EventErrorListener(MobileAdEvent event, Exception ex);

typedef RewardListener = void Function(String rewardType, int rewardAmount);

/// The Ads class
class Ads {
  factory Ads({
    String? trackingId,
    bool analyticsEnabled = false,
    String? bannerUnitId,
    String? screenUnitId,
    String? nativeUnitId,
    String? videoUnitId,
    String? factoryId,
    AdRequest? adRequest,
    List<String>? keywords,
    String? contentUrl,
    bool? childDirected,
    List<String>? testDevices,
    bool? nonPersonalizedAds,
    RequestConfiguration? requestConfiguration,
    bool? testing,
    m.MobileAdListener? listener,
    AdSize? size,
    double? anchorOffset,
    double? horizontalCenterOffset,
    m.AdErrorListener? errorListener,
  }) =>
      _this ??= Ads._(
        trackingId: trackingId,
        analyticsEnabled: analyticsEnabled,
        bannerUnitId: bannerUnitId,
        screenUnitId: screenUnitId,
        nativeUnitId: nativeUnitId,
        videoUnitId: videoUnitId,
        factoryId: factoryId,
        keywords: keywords,
        contentUrl: contentUrl,
        childDirected: childDirected,
        testDevices: testDevices,
        nonPersonalizedAds: nonPersonalizedAds,
        requestConfiguration: requestConfiguration,
        testing: testing,
        listener: listener,
        size: size,
        anchorOffset: anchorOffset,
        horizontalCenterOffset: horizontalCenterOffset,
        errorListener: errorListener,
      );

  /// Initialize the Firebase AdMob plugin with a number of options.
  Ads._({
    String? trackingId,
    bool analyticsEnabled = false,
    String? bannerUnitId,
    String? screenUnitId,
    String? nativeUnitId,
    String? videoUnitId,
    String? factoryId,
    List<String>? keywords,
    String? contentUrl,
    bool? childDirected,
    List<String>? testDevices,
    bool? nonPersonalizedAds,
    RequestConfiguration? requestConfiguration,
    bool? testing,
    m.MobileAdListener? listener,
    AdSize? size,
    double? anchorOffset,
    double? horizontalCenterOffset,
//    AnchorType anchorType,
    m.AdErrorListener? errorListener,
  }) {
    if (bannerUnitId != null) {
      _bannerUnitId = bannerUnitId.trim();
    }
    if (screenUnitId != null) {
      _screenUnitId = screenUnitId.trim();
    }
    if (nativeUnitId != null) {
      _nativeUnitId = nativeUnitId.trim();
    }
    if (videoUnitId != null) {
      _videoUnitId = videoUnitId.trim();
    }
    if (factoryId == null) {
      _factoryId = _nativeUnitId;
    } else {
      _factoryId = factoryId.trim();
    }

    _keywords = keywords ?? [];

    _contentUrl = contentUrl ?? '';

    _childDirected = childDirected ?? false;

    _testDevices = testDevices ?? [];

    _nonPersonalizedAds = nonPersonalizedAds ?? false;

    _testing = testing ?? false;

    if (listener != null) {
      m.adEventListeners.add(listener);
    }

    _size = size ?? AdSize.banner;

    _anchorOffset = anchorOffset ?? 0.0;

    _horizontalCenterOffset = horizontalCenterOffset ?? 0.0;

//    _anchorType = anchorType ?? AnchorType.bottom;

    _errorListener = errorListener;

    if (errorListener != null) {
      m.eventErrorListeners.add(errorListener);
    }

    MobileAds.instance
        .initialize()
        .then((status) {
      //
      status.adapterStatuses.forEach((key, value) {
        if (value.state == AdapterInitializationState.ready) {
          _initialized = true;
        }
      });

      // Configuration provided.
      if (requestConfiguration != null) {
        MobileAds.instance.updateRequestConfiguration(requestConfiguration);
      }

      if (bannerUnitId != null && _bannerAd == null) {
        setBannerAd(
          adUnitId: bannerUnitId,
          keywords: keywords,
          contentUrl: contentUrl,
          childDirected: childDirected,
          testDevices: testDevices,
          nonPersonalizedAds: nonPersonalizedAds,
          testing: testing,
          listener: listener,
          size: size,
          anchorOffset: anchorOffset,
          horizontalCenterOffset: horizontalCenterOffset,
//          anchorType: anchorType,
          errorListener: errorListener,
        );
      }

      if (screenUnitId != null && _fullScreenAd == null) {
        setFullScreenAd(
          adUnitId: screenUnitId,
          keywords: keywords,
          contentUrl: contentUrl,
          childDirected: childDirected,
          testDevices: testDevices,
          nonPersonalizedAds: nonPersonalizedAds,
          testing: testing,
          listener: listener,
          anchorOffset: anchorOffset,
          horizontalCenterOffset: horizontalCenterOffset,
//          anchorType: anchorType,
          errorListener: errorListener,
        );
      }

      if (nativeUnitId != null && _nativeAd == null) {
        setNativeAd(
          adUnitId: nativeUnitId,
          factoryId: factoryId,
          keywords: keywords,
          contentUrl: contentUrl,
          childDirected: childDirected,
          testDevices: testDevices,
          nonPersonalizedAds: nonPersonalizedAds,
          testing: testing,
          listener: listener,
          anchorOffset: anchorOffset,
          horizontalCenterOffset: horizontalCenterOffset,
//          anchorType: anchorType,
          errorListener: errorListener,
        );
      }

      if (videoUnitId != null && _videoAd == null) {
        // if (listener != null) {
        //   m.adEventListeners.add(listener);
        // }
        setVideoAd(
          adUnitId: videoUnitId,
          keywords: keywords,
          contentUrl: contentUrl,
          childDirected: childDirected,
          testDevices: testDevices,
          testing: testing,
          errorListener: errorListener,
        );
      }
    });
  }
  static Ads? _this;

  /// Properties
  ///
  ///

  /// Stores the Banner ad unit id.
  String _bannerUnitId = '';

  /// Stores the Interstitial ad unit id.
  String _screenUnitId = '';

  /// Stores the Native ad unit id.
  String _nativeUnitId = '';

  /// Stores the Video ad unit id.
  String _videoUnitId = '';

  /// Flag indicating this is the first object instantiated.
  bool _firstObject = true;

  /// You can only initialize the Firebase_AdMob plugin once!
  static bool _initialized = false;

  bool get initialized => _initialized;

  String? _factoryId;

  /// Get factory Id for platform-specific ad
  String? get factoryId => _factoryId;

  List<String>? _keywords;

  /// Get ad keywords
  List<String>? get keywords => _keywords;

  String? _contentUrl;

  /// Get the url providing ad content
  String? get contentUrl => _contentUrl;

  bool? _childDirected;

  bool? get childDirected => _childDirected;

  List<String>? _testDevices;

  /// Get list of test devices.
  List<String>? get testDevices => _testDevices;

  bool? _nonPersonalizedAds;

  bool? get nonPersonalizedAds => _nonPersonalizedAds;

  bool? _testing;

  /// Determine if testing or not
  bool? get testing => _testing;

  AdSize? _size;

  AdSize? get size => _size;

  double? _anchorOffset;

  double? get anchorOffset => _anchorOffset;

  double? _horizontalCenterOffset;

  double? get horizontalCenterOffset => _horizontalCenterOffset;

  /// Error Handling
  ///
  ///

  // AnchorType _anchorType;
  //
  // AnchorType get anchorType => _anchorType;

  m.AdErrorListener? _errorListener;

  bool get inError =>
      (m.eventErrors.isNotEmpty) ||
      (_bannerAd?._banner.inError ?? false) ||
      (_fullScreenAd?.inError ?? false) ||
      (_nativeAd?._native?.inError ?? false) ||
      (_videoAd?.inError ?? false);

  bool get bannerError => _bannerAd?._banner.inError ?? false;

  bool get screenError => _fullScreenAd?.inError ?? false;

  bool get nativeError => _nativeAd?._native?.inError ?? false;

  bool get videoError => _videoAd?.inError ?? false;

  bool get eventError => m.eventErrors.isNotEmpty;

  Exception? getError() =>
      getBannerError() ?? getScreenError() ?? getVideoError();

  Exception? getBannerError() => _bannerAd?._banner.getError();

  Exception? getScreenError() => _fullScreenAd?.getError();

  Exception? getNativeError() => _nativeAd?._native?.getError();

  Exception? getVideoError() => _videoAd?.getError();

  /// The Type of Ads
  ///
  ///

  Banner? _bannerAd;

  Native? _nativeAd;

  m.FullScreenAd? _fullScreenAd;

  m.VideoAd? _videoAd;

  /// Close any Ads
  /// Clean up memory and clear resources.
  void dispose() {
    //
    removeBannerAd();

    closeFullScreenAd();

    closeNativeAd();

    /// Clear all Error Event Listeners.
    m.eventErrorListeners.clear();

    /// Clear all Ad Event Listeners.
    m.adEventListeners.clear();

    /// Clear all Banner Ad Event Listeners.
    banner.eventListeners.clear();

    /// Clear all Full Screen Ad Event Listeners.
    screen.eventListeners.clear();

    /// Clear all Video Ad Event Listeners.
    video.eventListeners.clear();
    banner.clearAll();
    screen.clearAll();
    video.clearAll();
    _videoAd = null;

    m.eventErrors.clear();
  }

  /// Event Listeners.
  ///
  ///

  /// Set an Ad Event Listener.
  // ignore: avoid_setters_without_getters
  set eventListener(m.MobileAdListener listener) =>
      m.adEventListeners.add(listener);

  /// Remove a specific Add Event Listener.
  bool removeEvent(m.MobileAdListener listener) =>
      m.adEventListeners.remove(listener);

  final Completer<BannerAd> bannerCompleter = Completer<BannerAd>();

  final Completer<PublisherBannerAd> publisherCompleter =
      Completer<PublisherBannerAd>();

  final Completer<NativeAd> nativeCompleter = Completer<NativeAd>();

  /// The Banner Ad
  ///
  ///

  final banner = m.AdMobListener();

  /// Set a Banner Ad Event Listener.
  // ignore: avoid_setters_without_getters
  set bannerListener(m.MobileAdListener? listener) {
    if (listener == null) {
      return;
    }
    banner.eventListeners.add(listener);
  }

  /// Remove a specific Banner Ad Event Listener.
  bool removeBanner(m.MobileAdListener listener) =>
      banner.eventListeners.remove(listener);

  /// Set the Banner Ad options.
  Future<bool> setBannerAd({
    String? adUnitId,
    AdRequest? targetInfo,
    List<String>? keywords,
    String? contentUrl,
    bool? childDirected,
    List<String>? testDevices,
    bool? nonPersonalizedAds,
    bool? testing,
    m.MobileAdListener? listener,
    AdSize? size,
    double? anchorOffset,
    double? horizontalCenterOffset,
//    AnchorType anchorType,
    m.AdErrorListener? errorListener,
  }) {
    // Can only have one instantiated Ads object.
    if (!_firstObject) {
      return Future.value(false);
    }

    if (listener != null) {
      banner.eventListeners.add(listener);
    }

    _bannerAd ??= Banner(listener: banner);

    banner.loadedListener = () {
      bannerCompleter.complete(_bannerAd!._banner.ad as BannerAd);
    };

    banner.failedListener = () {
//        completer.completeError(error);
    };

    if (adUnitId == null || adUnitId.isEmpty || adUnitId.length < 30) {
      adUnitId = _bannerUnitId;
    }

    return _bannerAd!.set(
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords ?? _keywords,
      contentUrl: contentUrl ?? _contentUrl,
      childDirected: childDirected ?? _childDirected,
      testDevices: testDevices ?? _testDevices,
      nonPersonalizedAds: nonPersonalizedAds ?? _nonPersonalizedAds,
      testing: testing ?? _testing,
      size: size ?? _size,
      anchorOffset: anchorOffset ?? _anchorOffset,
      horizontalCenterOffset: horizontalCenterOffset ?? _horizontalCenterOffset,
//      anchorType: anchorType ?? _anchorType,
      errorListener: errorListener ?? _errorListener,
    );
  }

  /// Return a Widget containing a Banner Ad.
  Widget bannerAdWidget({Key? key}) => _BannerAdWidget(key: key);

  /// Return a Widget containing an Publisher Ad.
  Widget publisherAdWidget({Key? key}) => _PublisherBannerAdWidget(key: key);

  /// Hide a Banner Ad.
  void closeBannerAd({bool load = true}) => _bannerAd?.dispose(load: load);

  /// Remove the Banner Ad from memory
  void removeBannerAd({bool load = false}) => _bannerAd?.dispose(load: load);

  /// Full Screen Ad
  // m.FullScreenAd? get interstitial => _fullScreenAd;
  // m.FullScreenAd? get screen => _fullScreenAd;

  final screen = m.AdMobListener();

  /// Set a Full Screen Ad Event Listener.
  // ignore: avoid_setters_without_getters
  set screenListener(m.MobileAdListener? listener) {
    if (listener == null) {
      return;
    }

    screen.eventListeners.add(listener);
  }

  /// Remove a Full Screen Ad Event Listener.
  bool removeScreen(m.MobileAdListener listener) =>
      screen.eventListeners.remove(listener);

  /// Set the Full Screen Ad options.
  Future<bool> createInterstitialAd({
    String? adUnitId,
    AdRequest? targetInfo,
    List<String>? keywords,
    String? contentUrl,
    bool? childDirected,
    List<String>? testDevices,
    bool? nonPersonalizedAds,
    bool? testing,
    m.MobileAdListener? listener,
    double? anchorOffset,
    double? horizontalCenterOffset,
//    AnchorType anchorType,
    m.AdErrorListener? errorListener,
  }) =>
      setFullScreenAd(
        adUnitId: adUnitId,
        targetInfo: targetInfo,
        keywords: keywords,
        contentUrl: contentUrl,
        childDirected: childDirected,
        testDevices: testDevices,
        nonPersonalizedAds: nonPersonalizedAds,
        testing: testing,
        listener: listener,
        anchorOffset: anchorOffset,
        horizontalCenterOffset: horizontalCenterOffset,
        errorListener: errorListener,
      );

  /// Set the Full Screen Ad options.
  Future<bool> setFullScreenAd({
    String? adUnitId,
    AdRequest? targetInfo,
    List<String>? keywords,
    String? contentUrl,
    bool? childDirected,
    List<String>? testDevices,
    bool? nonPersonalizedAds,
    bool? testing,
    m.MobileAdListener? listener,
    double? anchorOffset,
    double? horizontalCenterOffset,
//    AnchorType anchorType,
    m.AdErrorListener? errorListener,
  }) async {
    // Can only have one instantiated Ads object.
    if (!_firstObject) {
      return Future.value(false);
    }

    if (listener != null) {
      screen.eventListeners.add(listener);
    }

    // Add this listener to the Error Listeners.
    if (errorListener != null) {
      m.eventErrorListeners.add(errorListener);
    }

    _fullScreenAd ??= m.FullScreenAd(listener: screen);

    // If an unit id is not provided, it may be available from the constructor.
    if (adUnitId == null || adUnitId.isEmpty || adUnitId.length < 30) {
      adUnitId = _screenUnitId;
    }

    return _fullScreenAd!.set(
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords ?? _keywords,
      contentUrl: contentUrl ?? _contentUrl,
      childDirected: childDirected ?? _childDirected,
      testDevices: testDevices ?? _testDevices,
      nonPersonalizedAds: nonPersonalizedAds ?? _nonPersonalizedAds,
      testing: testing ?? _testing,
      anchorOffset: anchorOffset ?? _anchorOffset,
      horizontalCenterOffset: horizontalCenterOffset ?? _horizontalCenterOffset,
//      anchorType: anchorType ?? _anchorType,
      errorListener: errorListener ?? _errorListener,
    );
  }

  /// Show a Full Screen Ad.
  ///
  /// parameters:
  /// state is passed to determine if the app is not terminating. No need to show ad.
  /// anchorOffset is the logical pixel offset from the edge of the screen (default 0.0)
  /// anchorType place advert at top or bottom of screen (default bottom)
  Future<bool> showFullScreenAd({
    String? adUnitId,
    AdRequest? targetInfo,
    List<String>? keywords,
    String? contentUrl,
    bool? childDirected,
    List<String>? testDevices,
    bool? testing,
    m.MobileAdListener? listener,
    double? anchorOffset,
    double? horizontalCenterOffset,
//    AnchorType? anchorType,
    m.AdErrorListener? errorListener,
    State? state,
  }) async {
    // Return true only if the attempt was successful.
    bool show = false;

    // state is passed to determine if the app is not terminating. No need to show ad.
    if (state != null && !state.mounted) {
      return show;
    }

    // Can only have one instantiated Ads object.
    if (!_firstObject) {
      return show;
    }

    if (_fullScreenAd == null || !_fullScreenAd!.loaded) {
      show = await setFullScreenAd(
        adUnitId: adUnitId,
        keywords: keywords,
        contentUrl: contentUrl,
        childDirected: childDirected,
        testDevices: testDevices,
        testing: testing,
        anchorOffset: anchorOffset,
        horizontalCenterOffset: horizontalCenterOffset,
//        anchorType: anchorType,
        listener: listener,
        errorListener: errorListener,
      );

      if (show) {
        show = _fullScreenAd!.show();
      }
    } else {
      if (listener != null) {
        screen.eventListeners.add(listener);
      }

      // Add this listener to the Error Listeners.
      if (errorListener != null) {
        m.eventErrorListeners.add(errorListener);
      }
      show = _fullScreenAd!.show();
    }
    return show;
  }

  /// Hide the Full Screen Ad.
  void closeFullScreenAd() => _fullScreenAd?.dispose();

  /// Native Ad
  ///
//  m.Native? get native => _nativeAd!._native;

  final native = m.AdMobListener();

  /// Set a Native Ad Event Listener.
  // ignore: avoid_setters_without_getters
  set nativeListener(m.MobileAdListener? listener) {
    if (listener == null) {
      return;
    }

    native.eventListeners.add(listener);
  }

  /// Remove a Native Ad Event Listener.
  bool removeNative(m.MobileAdListener listener) =>
      native.eventListeners.remove(listener);

  /// Set the Native Ad options.
  Future<bool> setNativeAd({
    String? adUnitId,
    String? factoryId,
    AdRequest? targetInfo,
    List<String>? keywords,
    String? contentUrl,
    bool? childDirected,
    List<String>? testDevices,
    bool? nonPersonalizedAds,
    bool? testing,
    m.MobileAdListener? listener,
    AdSize? size,
    double? anchorOffset,
    double? horizontalCenterOffset,
//    AnchorType anchorType,
    m.AdErrorListener? errorListener,
  }) {
    // Can only have one instantiated Ads object.
    if (!_firstObject) {
      return Future.value(false);
    }

    if (listener != null) {
      native.eventListeners.add(listener);
    }

    _nativeAd ??= Native(listener: native);

    if (adUnitId == null || adUnitId.isEmpty || adUnitId.length < 30) {
      adUnitId = _nativeUnitId;
    }
// For Setup Instructions:
    /// https://pub.dev/packages/google_mobile_ads#native-ads
    return _nativeAd!.set(
      adUnitId: adUnitId,
      factoryId: factoryId ?? _factoryId,
      targetInfo: targetInfo,
      keywords: keywords ?? _keywords,
      contentUrl: contentUrl ?? _contentUrl,
      childDirected: childDirected ?? _childDirected,
      testDevices: testDevices ?? _testDevices,
      nonPersonalizedAds: nonPersonalizedAds ?? _nonPersonalizedAds,
      testing: testing ?? _testing,
      anchorOffset: anchorOffset ?? _anchorOffset,
      horizontalCenterOffset: horizontalCenterOffset ?? _horizontalCenterOffset,
//      anchorType: anchorType ?? _anchorType,
      errorListener: errorListener ?? _errorListener,
    );
  }

  /// Return a Widget containing the ad.
  Widget nativeAd({Key? key}) => _NativeAdWidget(key: key);

  /// Hide a Native Ad.
  void closeNativeAd({bool load = true}) => _nativeAd?.dispose(load: load);

  /// Remove the Native Ad from memory
  void removeNativeAd({bool load = false}) => _nativeAd?.dispose(load: load);

  /// Video Ad
  ///
//  m.VideoAd? get video => _videoAd;
  final video = m.AdMobListener();

  /// Set a Video Ad Event Listener
  // ignore: avoid_setters_without_getters
  set videoListener(m.MobileAdListener? listener) {
    if (listener == null) {
      return;
    }
    video.eventListeners.add(listener);
  }

  /// Remove a specific Video Ad Event Listener.
  bool removeVideo(m.MobileAdListener listener) =>
      video.eventListeners.remove(listener);

  /// Video Ad
  ///
  /// Set the Video Ad options.
  Future<bool> setVideoAd({
    bool show = false,
    String? adUnitId,
    AdRequest? targetInfo,
    List<String>? keywords,
    String? contentUrl,
    bool? childDirected,
    List<String>? testDevices,
    bool? nonPersonalizedAds,
    bool? testing,
    m.MobileAdListener? listener,
    m.AdErrorListener? errorListener,
  }) {
    // Can only have one instantiated Ads object.
    if (!_firstObject) {
      return Future.value(false);
    }

    if (listener != null) {
      video.eventListeners.add(listener);
    }

    // Add this listener to the Error Listeners.
    if (errorListener != null) {
      m.eventErrorListeners.add(errorListener);
    }

    _videoAd ??= m.VideoAd(listener: video);

    // If an unit id is not provided, it may be available from the constructor.
    if (adUnitId == null || adUnitId.isEmpty || adUnitId.length < 30) {
      adUnitId = _videoUnitId;
    }

    return _videoAd!.set(
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords ?? _keywords,
      contentUrl: contentUrl ?? _contentUrl,
      childDirected: childDirected ?? _childDirected,
      testDevices: testDevices ?? _testDevices,
      nonPersonalizedAds: nonPersonalizedAds ?? _nonPersonalizedAds,
      testing: testing ?? _testing,
      errorListener: errorListener ?? _errorListener,
    );
  }

  /// Show a Video Ad.
  ///hideFullScreenAd
  /// parameters:
  /// state is passed to determine if the app is not terminating. No need to show ad.
  Future<bool> showVideoAd(
      {String? adUnitId,
      AdRequest? targetInfo,
      List<String>? keywords,
      String? contentUrl,
      bool? childDirected,
      List<String>? testDevices,
      bool? testing,
      m.MobileAdListener? listener,
      m.AdErrorListener? errorListener,
      State? state}) async {
    //
    bool show = false;

    if (state != null && !state.mounted) {
      return show;
    }

    // Can only have one instantiated Ads object.
    if (!_firstObject) {
      return show;
    }

    if (_videoAd == null || !_videoAd!.loaded) {
      show = await setVideoAd(
        adUnitId: adUnitId,
        keywords: keywords,
        contentUrl: contentUrl,
        childDirected: childDirected,
        testDevices: testDevices,
        testing: testing,
        listener: listener,
        errorListener: errorListener,
      );

      if (show) {
        show = _videoAd!.show();
      }
    } else {
      if (listener != null) {
        video.eventListeners.add(listener);
      }
      // Add this listener to the Error Listeners.
      if (errorListener != null) {
        m.eventErrorListeners.add(errorListener);
      }

      show = _videoAd!.show();
    }
    return show;
  }
}

/// Implement the Banner Ad
class Banner {
//
  factory Banner({required m.AdMobListener listener}) =>
      _this ??= Banner._(listener);

  Banner._(m.AdMobListener listener) : _banner = m.Banner(listener: listener);
  static Banner? _this;

  m.Banner _banner;

  /// Set options to the Banner Ad.
  Future<bool> set({
    String? adUnitId,
    AdRequest? targetInfo,
    List<String>? keywords,
    String? contentUrl,
    bool? childDirected,
    List<String>? testDevices,
    bool? nonPersonalizedAds,
    bool? testing,
    AdSize? size,
    double? anchorOffset,
    double? horizontalCenterOffset,
//    AnchorType anchorType,
    m.AdErrorListener? errorListener,
  }) {
    // Add this listener to the Error Listeners.
    if (errorListener != null) {
      m.eventErrorListeners.add(errorListener);
    }
    return _banner.set(
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      nonPersonalizedAds: nonPersonalizedAds,
      testing: testing,
      size: size,
      anchorOffset: anchorOffset,
      horizontalCenterOffset: horizontalCenterOffset,
//      anchorType: anchorType,
      errorListener: errorListener,
    );
  }

  void dispose({bool load = false}) {
    _banner.dispose().then((_) {
      // Load the Ad into memory again
      if (load) {
        _banner.loadAd(show: false);
      }
    });
  }
}

/// Implement the Native Ad
class Native {
//
  factory Native({required m.AdMobListener listener}) =>
      _this ??= Native._(listener);

  Native._(m.AdMobListener listener) {
    _native = m.Native(listener: listener);
  }

  static Native? _this;

  m.Native? _native;

  /// Set options to the Native Ad.
  Future<bool> set({
    String? adUnitId,
    String? factoryId,
    AdRequest? targetInfo,
    List<String>? keywords,
    String? contentUrl,
    bool? childDirected,
    List<String>? testDevices,
    bool? nonPersonalizedAds,
    bool? testing,
    AdSize? size,
    double? anchorOffset,
    double? horizontalCenterOffset,
//    AnchorType anchorType,
    m.AdErrorListener? errorListener,
  }) {
    // Add this listener to the Error Listeners.
    if (errorListener != null) {
      m.eventErrorListeners.add(errorListener);
    }
    return _native!.set(
      adUnitId: adUnitId,
      factoryId: factoryId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      nonPersonalizedAds: nonPersonalizedAds,
      testing: testing,
      anchorOffset: anchorOffset,
      horizontalCenterOffset: horizontalCenterOffset,
//     anchorType: anchorType,
      errorListener: errorListener,
    );
  }

  void dispose({bool load = false}) {
    _native?.dispose().then((_) {
      // Load the Ad into memory again
      if (load) {
        _native!.loadAd(show: false);
      }
    });
  }
}

/// Return this widget to 'display' the BannerAd.
class _BannerAdWidget extends StatefulWidget {
  const _BannerAdWidget({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _BannerAdState();
}

class _BannerAdState extends State<_BannerAdWidget> {
  late Ads ads;

  @override
  void initState() {
    super.initState();
    ads = Ads();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<BannerAd>(
        future: ads.bannerCompleter.future,
        builder: (BuildContext context, AsyncSnapshot<BannerAd> snapshot) {
          Widget? child;
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              child = Container();
              break;
            case ConnectionState.done:
              if (snapshot.hasData) {
                final bannerAd = snapshot.data as BannerAd;
                child = Container(
                  width: bannerAd.size.width.toDouble(),
                  height: bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: snapshot.data as AdWithView),
                );
              } else {
                child = Container();
              }
          }
          return child;
        },
      );
}

class _PublisherBannerAdWidget extends StatefulWidget {
  const _PublisherBannerAdWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PublisherBannerAdState();
}

class _PublisherBannerAdState extends State<_PublisherBannerAdWidget> {
  late Ads ads;

  @override
  void initState() {
    super.initState();
    ads = Ads();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<PublisherBannerAd>(
        future: ads.publisherCompleter.future,
        builder:
            (BuildContext context, AsyncSnapshot<PublisherBannerAd> snapshot) {
          Widget? child;
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              child = Container();
              break;
            case ConnectionState.done:
              if (snapshot.hasData) {
                final bannerAd = snapshot.data as PublisherBannerAd;
                child = Container(
                  width: bannerAd.sizes[0].width.toDouble(),
                  height: bannerAd.sizes[0].height.toDouble(),
                  child: AdWidget(ad: snapshot.data as AdWithView),
                );
              } else {
                child = Container();
              }
          }
          return child;
        },
      );
}

class _NativeAdWidget extends StatefulWidget {
  const _NativeAdWidget({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _NativeAdState();
}

class _NativeAdState extends State<_NativeAdWidget> {
  late Ads ads;

  @override
  void initState() {
    super.initState();
    ads = Ads();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<NativeAd>(
    future: ads.nativeCompleter.future,
    builder:
        (BuildContext context, AsyncSnapshot<NativeAd> snapshot) {
      Widget? child;
      switch (snapshot.connectionState) {
        case ConnectionState.none:
        case ConnectionState.waiting:
        case ConnectionState.active:
          child = Container();
          break;
        case ConnectionState.done:
          if (snapshot.hasData) {
            child = Container(
              width: 250,
              height: 350,
              child: AdWidget(ad: snapshot.data as AdWithView),
            );
          } else {
            child = Container();
          }
      }
      return child;
    },
  );
}
