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

import 'package:firebase_admob/firebase_admob.dart';

typedef void RewardListener(String rewardType, int rewardAmount);

class Banner extends MobileAds {
  factory Banner({MobileAdListener listener}) {
    _this ??= Banner._(listener);
    return _this;
  }
  static Banner _this;
  Banner._(MobileAdListener listener) : super(listener: listener);

  AdSize _size = AdSize.banner;

  /// Set options to the Banner Ad.
  @override
  void set({
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool testing,
    AdSize size,
    double anchorOffset,
    AnchorType anchorType,
  }) {
    super.set(
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      testing: testing,
      anchorOffset: anchorOffset,
      anchorType: anchorType,
    );
    _size = size ?? _size;
  }

  /// Show the Banner Ad.
  @override
  void show({
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool testing,
    AdSize size,
    double anchorOffset,
    AnchorType anchorType,
    State state,
  }) {
    if (state != null && !state.mounted) return;

    adUnitId = adUnitId ?? _adUnitId;

    testing = testing ?? _testing;
    size = size ?? _size;

    MobileAdTargetingInfo info;

    if (targetInfo != null) {
      info = targetInfo;
    } else if (_info != null) {
      info = _info;
    } else {
      info = _targetInfo(
        keywords: keywords,
        contentUrl: contentUrl,
        childDirected: childDirected,
        testDevices: testDevices,
      );
    }

    _ad ??= BannerAd(
      adUnitId: testing
          ? BannerAd.testAdUnitId
          : adUnitId.isEmpty ? BannerAd.testAdUnitId : adUnitId.trim(),
      size: size ?? AdSize.banner,
      targetingInfo: info,
    );

    super.show(anchorOffset: anchorOffset, anchorType: anchorType);
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

  /// Display the Interstitial Ad.
  @override
  void show({
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool testing,
    double anchorOffset,
    AnchorType anchorType,
    State state,
  }) {
    if (state != null && !state.mounted) return;

    adUnitId = adUnitId ?? _adUnitId;
    testing = testing ?? _testing;

    MobileAdTargetingInfo info;

    if (targetInfo != null) {
      info = targetInfo;
    } else if (_info != null) {
      info = _info;
    } else {
      info = _targetInfo(
        keywords: keywords,
        contentUrl: contentUrl,
        childDirected: childDirected,
        testDevices: testDevices,
      );
    }

    _ad ??= InterstitialAd(
      adUnitId: testing
          ? InterstitialAd.testAdUnitId
          : adUnitId.isEmpty ? InterstitialAd.testAdUnitId : adUnitId.trim(),
      targetingInfo: info,
    );

    _ad?.listener = (MobileAdEvent event) {
      if (event == MobileAdEvent.loaded) {
        _ad?.show(
            anchorOffset: anchorOffset ?? 0.0,
            anchorType: anchorType ?? AnchorType.bottom);
      }

      if (listener != null) {
        listener(event);
      }

      if (event == MobileAdEvent.closed) {
        dispose();
      }
    };

    _ad?.load();
  }
}

class MobileAds extends AdMob {
  MobileAds({this.listener});
  MobileAd _ad;
  final MobileAdListener listener;
  double _anchorOffset;
  AnchorType _anchorType;

  /// Set the MobileAd's options.
  @override
  void set({
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool testing,
    double anchorOffset,
    AnchorType anchorType,
  }) {
    super.set(
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      testing: testing,
    );
    _anchorOffset = anchorOffset ?? _anchorOffset;
    _anchorType = anchorType ?? _anchorType;
  }

  /// Display the MobileAd
  void show({
    double anchorOffset,
    AnchorType anchorType,
  }) async {
    anchorOffset = anchorOffset ?? _anchorOffset;
    anchorType = anchorType ?? _anchorType;

//    try {
//      _ad
//        ..load()
//        ..show(
//            anchorOffset: anchorOffset ?? 0.0,
//            anchorType: anchorType ?? AnchorType.bottom);
//    } catch (ex) {
//      _setError(ex);
//    }

    _ad?.listener = (MobileAdEvent event) {
      if (event == MobileAdEvent.loaded) {
        _ad?.show(
            anchorOffset: anchorOffset ?? 0.0,
            anchorType: anchorType ?? AnchorType.bottom);
      }
      if (listener != null) listener(event);
    };

    _ad?.load();
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
    _rewardedVideoAd = RewardedVideoAd.instance;

    this.listener = listener;

    _rewardedVideoAd.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.loaded) {
        _rewardedVideoAd.show();
      }

      if (this.listener != null)
        this.listener(event,
            rewardType: rewardType, rewardAmount: rewardAmount);
    };
  }
  RewardedVideoAdListener listener;
  RewardedVideoAd _rewardedVideoAd;

  /// Set the Video Ad's options.
  @override
  void set({
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool testing,
  }) {
    super.set(
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      testing: testing,
    );
  }

  /// Show the Video Ad.
  Future<bool> show({
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool testing,
    State state,
  }) {
    if (adUnitId == null || adUnitId.isEmpty || adUnitId.length < 30) {
      adUnitId = _adUnitId;
    }

    testing = testing ?? _testing;

    MobileAdTargetingInfo info;

    if (targetInfo != null) {
      info = targetInfo;
    } else if (_info != null) {
      info = _info;
    } else {
      info = _targetInfo(
        keywords: keywords,
        contentUrl: contentUrl,
        childDirected: childDirected,
        testDevices: testDevices,
      );
    }

    String adModId = testing
        ? RewardedVideoAd.testAdUnitId
        : adUnitId.isEmpty ? RewardedVideoAd.testAdUnitId : adUnitId.trim();

    return _rewardedVideoAd.load(adUnitId: adModId, targetingInfo: info);
  }

  /// Clear the video ad plugin.
  void dispose() {
    _rewardedVideoAd = null;
  }
}

abstract class AdMob {
  String _adUnitId = "";

  MobileAdTargetingInfo _info;
  List<String> _keywords = ["the"];
  String _contentUrl;
  bool _childDirected;
  List<String> _testDevices;

  bool _testing = false;

  Exception _ex;

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
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool testing,
  }) {
    if (adUnitId != null && adUnitId.isNotEmpty && adUnitId.length > 30) {
      _adUnitId = adUnitId;
    }

    _info = targetInfo ?? _info;

    _keywords = keywords ?? _keywords;

    _contentUrl = contentUrl ?? _contentUrl;

    _childDirected = childDirected ?? _childDirected;

    if (testDevices != null &&
        testDevices.every((String s) => s == null || s.isNotEmpty))
      testDevices = null;

    _testDevices = testDevices ?? _testDevices;

    _testing = testing ?? _testing;
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
  }) {
    keywords ??= _keywords;
    if (keywords != null && keywords.isEmpty) keywords = _keywords;

    contentUrl ??= _contentUrl;
    if (contentUrl != null && contentUrl.isEmpty) contentUrl = _contentUrl;

    // If it's true, it has to be passed.
    if (_childDirected) childDirected = _childDirected;

    testDevices ??= _testDevices;
    if (testDevices != null && testDevices.isEmpty) testDevices = _testDevices;

    return MobileAdTargetingInfo(
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
    );
  }

  void _setError(Object ex) {
    if (ex is! Exception) {
      _ex = Exception(ex.toString());
    } else {
      _ex = ex;
    }
  }
}
