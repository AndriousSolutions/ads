library ads;

///
/// Copyright (C) 2019 Andrious Solutions
///
/// This program is free software; you can redistribute it and/or
/// modify it under the terms of the GNU General Public License
/// as published by the Free Software Foundation; either version 3
/// of the License, or any later version.
///
/// You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
///          Created  04 Aug 2019
///
///

import 'package:flutter/widgets.dart' show State;

import 'dart:async' show Future;

import 'package:flutter/foundation.dart';

import 'package:firebase_admob/firebase_admob.dart';

/// Signature for a [RewardAd] status change callback.
typedef void RewardListener(String rewardType, int rewardAmount);

/// Signature for a [AdError] status change callback.
typedef void AdErrorListener(Exception ex);

class Banner extends MobileAds {
  factory Banner({MobileAdListener listener}) {
    _this ??= Banner._(listener);
    return _this;
  }
  static Banner _this;
  Banner._(MobileAdListener listener) : super(listener: listener);

  AdSize _setSize;
  AdSize _showSize;

  /// Set options to the Banner Ad.
  @override
  Future<bool> set({
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool nonPersonalizedAds,
    bool testing,
    AdSize size,
    double anchorOffset,
    double horizontalCenterOffset,
    AnchorType anchorType,
    AdErrorListener errorListener,
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
      anchorType: anchorType,
      errorListener: errorListener,
    );
    _setSize ??= size ?? AdSize.banner;
    return load(
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
      anchorType: anchorType,
    );
  }

  /// Show the Banner Ad.
  @override
  Future<bool> show({
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool testing,
    AdSize size,
    double anchorOffset,
    double horizontalCenterOffset,
    AnchorType anchorType,
    State state,
  }) async {
    if (size != null) dispose();
    _showSize = size ?? _setSize ?? AdSize.banner;
    return super.show(
        adUnitId: adUnitId,
        targetInfo: targetInfo,
        keywords: keywords,
        contentUrl: contentUrl,
        childDirected: childDirected,
        testDevices: testDevices,
        testing: testing,
        anchorOffset: anchorOffset,
        horizontalCenterOffset: horizontalCenterOffset,
        anchorType: anchorType,
        state: state);
  }

  @override
  _createAd({bool testing, String adUnitId, MobileAdTargetingInfo targetInfo}) {
    return BannerAd(
      adUnitId: testing
          ? BannerAd.testAdUnitId
          : adUnitId.isEmpty ? BannerAd.testAdUnitId : adUnitId.trim(),
      size: _showSize ?? _setSize ?? AdSize.banner,
      targetingInfo: targetInfo,
    );
  }
}

class FullScreenAd extends MobileAds {
  factory FullScreenAd({MobileAdListener listener}) {
    _this ??= FullScreenAd._(listener);
    return _this;
  }
  static FullScreenAd _this;
  FullScreenAd._(MobileAdListener listener) : super(listener: listener);

  /// Set options for the Interstitial Ad
  // Uses super.set();
  @override
  Future<bool> set({
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool nonPersonalizedAds,
    bool testing,
    double anchorOffset,
    double horizontalCenterOffset,
    AnchorType anchorType,
    AdErrorListener errorListener,
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
      anchorType: anchorType,
      errorListener: errorListener,
    );
    return load(
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
      anchorType: anchorType,
    );
  }

  _createAd({bool testing, String adUnitId, MobileAdTargetingInfo targetInfo}) {
    return InterstitialAd(
      adUnitId: testing
          ? InterstitialAd.testAdUnitId
          : adUnitId.isEmpty ? InterstitialAd.testAdUnitId : adUnitId.trim(),
      targetingInfo: targetInfo,
    );
  }
}

abstract class MobileAds extends AdMob {
  MobileAds({this.listener});
  MobileAd _ad;
  final MobileAdListener listener;
  double _anchorOffset;
  double _horizontalCenterOffset;
  AnchorType _anchorType;

  Future<bool> load({
    @required bool show,
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool nonPersonalizedAds,
    bool testing,
    double anchorOffset,
    double horizontalCenterOffset,
    AnchorType anchorType,
  }) async {
    // Are we testing?
    testing ??= _testing;

    // Supply a valid unit id.
    if (adUnitId == null || adUnitId.isEmpty || adUnitId.length < 30) {
      adUnitId = _adUnitId;
    }

    if (targetInfo == null)
      targetInfo = _targetInfo(
        keywords: keywords,
        contentUrl: contentUrl,
        childDirected: childDirected,
        testDevices: testDevices,
        nonPersonalizedAds: nonPersonalizedAds,
      );

    // Get rid of the ad if already created.
    dispose();

    // Create the ad.
    _ad =
        _createAd(testing: testing, adUnitId: adUnitId, targetInfo: targetInfo);

    // Assign the ad's listener
    _ad?.listener = (MobileAdEvent event) {
      if (show && event == MobileAdEvent.loaded) {
        try {
          _ad.show(
              anchorOffset: anchorOffset ?? _anchorOffset ?? 0.0,
              horizontalCenterOffset:
                  horizontalCenterOffset ?? _horizontalCenterOffset ?? 0.0,
              anchorType: anchorType ?? _anchorType ?? AnchorType.bottom);
        } catch (ex) {
          _setError(ex);
          return;
        }
      }

      if (listener != null) {
        listener(event);
      }

      // Dispose and load the ad again.
      if (event == MobileAdEvent.closed) {
        dispose().then((_) {
          load(
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
            anchorType: anchorType,
          );
        });
      }
    };

    bool loaded;
    try {
      loaded = await _ad?.load();
    } catch (ex) {
      loaded = false;
      _setError(ex);
    }
    // Load the ad in memory.
    return loaded;
  }

  MobileAd _createAd(
      {bool testing, String adUnitId, MobileAdTargetingInfo targetInfo});

  /// Set the MobileAd's options.
  @override
  void set({
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool nonPersonalizedAds,
    bool testing,
    double anchorOffset,
    double horizontalCenterOffset,
    AnchorType anchorType,
    AdErrorListener errorListener,
  }) {
    super.set(
      adUnitId: adUnitId,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      nonPersonalizedAds: nonPersonalizedAds,
      testing: testing,
      errorListener: errorListener,
    );
    _anchorOffset ??= anchorOffset;
    _horizontalCenterOffset ??= horizontalCenterOffset;
    _anchorType ??= anchorType;
  }

  /// Display the MobileAd
  @override
  Future<bool> show({
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool testing,
    double anchorOffset,
    double horizontalCenterOffset,
    AnchorType anchorType,
    State state,
  }) async {
    if (state != null && !state.mounted) return Future.value(false);

    // Load a new ad if a parameter is passed.
    if ((adUnitId != null && adUnitId.isNotEmpty) ||
        targetInfo != null ||
        (keywords != null && keywords.isNotEmpty) ||
        (contentUrl != null && contentUrl.isNotEmpty) ||
        childDirected != null ||
        (testDevices != null && testDevices.isNotEmpty) ||
        testing != null ||
        anchorOffset != null ||
        horizontalCenterOffset != null ||
        anchorType != null) {
      await dispose();
    }

    // The ad is already loaded. Show it now.
    if (_ad != null) {
      try {
        bool show = await _ad.show(
            anchorOffset: anchorOffset ?? _anchorOffset ?? 0.0,
            horizontalCenterOffset:
                horizontalCenterOffset ?? _horizontalCenterOffset ?? 0.0,
            anchorType: anchorType ?? _anchorType ?? AnchorType.bottom);
        if (show) return show;
      } catch (ex) {
        _ad?.dispose();
        _ad = null;

        /// try loading it again.
      }
    }

    // Load the ad and show it when loaded.
    return load(
      show: true,
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      testing: testing,
      anchorOffset: anchorOffset,
      horizontalCenterOffset: horizontalCenterOffset,
      anchorType: anchorType,
    );
  }

  /// Clear the MobileAd reference.
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

  Future<bool> isLoaded() async {
    bool loaded = false;
    if (_ad != null) {
      try {
        loaded = await _ad?.isLoaded();
      } catch (ex) {
        loaded = false;
        _setError(ex);
      }
    }
    return loaded;
  }
}

class VideoAd extends AdMob {
  factory VideoAd({RewardedVideoAdListener listener}) {
    _this ??= VideoAd._(listener);
    return _this;
  }

  static VideoAd _this;

  VideoAd._(RewardedVideoAdListener listener) : super() {
    this.listener = listener;
  }

  RewardedVideoAdListener listener;
  RewardedVideoAd _rewardedVideoAd;

  /// Set the Video Ad's options.
  @override
  Future<bool> set({
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool nonPersonalizedAds,
    bool testing,
    AdErrorListener errorListener,
  }) {
    super.set(
      adUnitId: adUnitId,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      nonPersonalizedAds: nonPersonalizedAds,
      testing: testing,
    );
    // Load into memory.
    return _loadVideo(
      show: false,
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      nonPersonalizedAds: nonPersonalizedAds,
      testing: testing,
    );
  }

  /// Show the Video Ad.
  @override
  Future<bool> show({
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool nonPersonalizedAds,
    bool testing,
    State state,
  }) async {
    bool show = false;

    // Don't bother if the app is terminating.
    if (state != null && !state.mounted) return show;

    // Load a new ad if a parameter is passed.
    if ((adUnitId != null && adUnitId.isNotEmpty) ||
        targetInfo != null ||
        (keywords != null && keywords.isNotEmpty) ||
        (contentUrl != null && contentUrl.isNotEmpty) ||
        childDirected != null ||
        (testDevices != null && testDevices.isNotEmpty) ||
        testing != null) {
      _rewardedVideoAd = null;
    }

    // Show if already loaded.
    if (_rewardedVideoAd != null) {
      try {
        show = await _rewardedVideoAd.show();
        if (show) return show;
      } catch (ex) {
        /// try loading it again.
        _rewardedVideoAd = null;
      }
    }

    // Show the ad when loaded.
    show = await _loadVideo(
      show: true,
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      nonPersonalizedAds: nonPersonalizedAds,
      testing: testing,
    );

    return show;
  }

  Future<bool> _loadVideo({
    @required bool show,
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool nonPersonalizedAds,
    bool testing,
  }) {
    // Acquire an instance of the Video Ad.
    _rewardedVideoAd ??= RewardedVideoAd.instance;

    // Assign its listener.
    _rewardedVideoAd.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (show && event == RewardedVideoAdEvent.loaded) {
        try {
          _rewardedVideoAd.show();
        } catch (ex) {
          _setError(ex);
          return;
        }
      }

      // Call any listeners.
      if (this.listener != null)
        this.listener(event,
            rewardType: rewardType, rewardAmount: rewardAmount);

      // Dispose of the ad and recreate it.
      if (event == RewardedVideoAdEvent.closed) {
        dispose();
        _loadVideo(
          show: false,
          adUnitId: adUnitId,
          targetInfo: targetInfo,
          keywords: keywords,
          contentUrl: contentUrl,
          childDirected: childDirected,
          testDevices: testDevices,
          nonPersonalizedAds: nonPersonalizedAds,
          testing: testing,
        );
      }
    };

    // Assign a valid unit id.
    if (adUnitId == null || adUnitId.isEmpty || adUnitId.length < 30) {
      adUnitId = _adUnitId;
    }

    // Is this a test?
    testing ??= _testing;

    // If testing, assign a 'test' unit id.
    String adModId = testing
        ? RewardedVideoAd.testAdUnitId
        : adUnitId.isEmpty ? RewardedVideoAd.testAdUnitId : adUnitId.trim();

    if (targetInfo == null)
      targetInfo = _targetInfo(
        keywords: keywords,
        contentUrl: contentUrl,
        childDirected: childDirected,
        testDevices: testDevices,
        nonPersonalizedAds: nonPersonalizedAds,
      );

    // Load the ad into memory.
    return _rewardedVideoAd.load(adUnitId: adModId, targetingInfo: targetInfo);
  }

  /// Clear the video ad plugin.
  @override
  void dispose() {
    _rewardedVideoAd = null;
  }
}

abstract class AdMob {
  String _adUnitId;
  List<String> _keywords;
  String _contentUrl; // Can be null
  bool _childDirected; // Can be null
  List<String> _testDevices; // Can be null
  bool _nonPersonalizedAds; // Can be null
  bool _testing;

  Exception _ex;
  Set<AdErrorListener> _adErrorListeners = Set();

  /// Return any exception
  Exception getError() {
    Exception ex = _ex;
    _ex = null;
    return ex;
  }

  /// Indicate there was an error.
  bool get inError => _ex != null;

  /// Displays an error message if any.
  String get message => _ex?.toString() ?? "";

  void set({
    String adUnitId,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool nonPersonalizedAds,
    bool testing,
    AdErrorListener errorListener,
  }) {
    if (adUnitId != null && adUnitId.isNotEmpty && adUnitId.length > 30) {
      _adUnitId ??= adUnitId;
    }

    _keywords ??= keywords;

    _contentUrl ??= contentUrl;

    _childDirected ??= childDirected;

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
  MobileAdTargetingInfo _targetInfo({
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool nonPersonalizedAds,
  }) {
    // Either might be an 'empty' list.
    keywords ??= _keywords;

    // An 'empty' list is not passed.
    if (keywords.isEmpty ||
        keywords.every((String s) => s == null || s.isEmpty)) {
      keywords = null;
    }

    if (contentUrl == null) {
      contentUrl = _contentUrl;
    } else if (contentUrl.isEmpty) {
      contentUrl = null;
    }

    // If it's true, it has to be passed.
    if (_childDirected != null && _childDirected)
      childDirected ??= _childDirected;

    // Either might be an 'empty' list.
    testDevices ??= _testDevices;

    // An 'empty' list is not passed.
    if (testDevices.isEmpty ||
        testDevices.every((String s) => s == null || s.isEmpty)) {
      testDevices = null;
    }

    nonPersonalizedAds ??= _nonPersonalizedAds;

    return MobileAdTargetingInfo(
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
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
  void _adErrorListener(Exception ex) {
    if (ex == null) return;
    for (AdErrorListener listener in _adErrorListeners) {
      try {
        listener(ex);
      } catch (e) {
        print("AdMob: ${e.toString()}");
      }
    }
  }

  /// Set an Error Event Listener.
  set errorListener(AdErrorListener listener) {
    if (listener != null) _adErrorListeners.add(listener);
  }

  /// Remove a specific Error Listener.
  bool removeError(AdErrorListener listener) => _adErrorListeners.remove(listener);

  /// Empty any error handlers from memory.
  void clearErrorListeners() => _adErrorListeners.clear();
}
