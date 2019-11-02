library ads;

///
/// Copyright (C) 2018 Andrious Solutions
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
///          Created  27 May 2018
///
///   Dart Packages.org: https://pub.dartlang.org/packages/ads#-changelog-tab-
///

import 'package:flutter/widgets.dart' show State;

import 'package:firebase_admob/firebase_admob.dart'
    show
        AdSize,
        AnchorType,
        FirebaseAdMob,
        MobileAdEvent,
        MobileAdListener,
        MobileAdTargetingInfo,
        RewardedVideoAdEvent,
        RewardedVideoAdListener;

import 'package:flutter/foundation.dart' show VoidCallback;

import 'dart:developer';

import 'package:ads/admob.dart';

typedef void RewardListener(String rewardType, int rewardAmount);

Set<MobileAdListener> _adEventListeners = Set();

class Ads {
  /// Initialize the Firebase AdMob plugin with a number of options.
  Ads(
    String appId, {
    String trackingId,
    bool analyticsEnabled = false,
    String bannerUnitId,
    String screenUnitId,
    String videoUnitId,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool nonPersonalizedAds,
    bool testing,
    MobileAdListener listener,
    AdSize size,
    double anchorOffset,
    double horizontalCenterOffset,
    AnchorType anchorType,
  }) {
    /// This class is being instantiated again??
    /// Continue, but do not activate this object to do anything.
    /// Once initialized only use the original reference.
    if (_initialized) {
      // This Ads object can continue to be instantiated, but it can't do anything.
      _firstObject = false;
      log(
        "An Ads class is already instantiated!",
        time: DateTime.now(),
        level: 1,
        name: 'Ads()',
      );
      return;
    }

    assert(appId != null && appId.isNotEmpty, 'class Ads: appId is required.');

    /// Test for parameters being pass null in production
    appId =
        appId == null || appId.isEmpty ? FirebaseAdMob.testAppId : appId.trim();

    if (bannerUnitId != null) {
      _bannerUnitId = bannerUnitId.trim();
    }
    if (screenUnitId != null) {
      _screenUnitId = screenUnitId.trim();
    }
    if (videoUnitId != null) {
      _videoUnitId = videoUnitId.trim();
    }

    _keywords = keywords ?? ["the"];

    _contentUrl = contentUrl ?? "";

    _childDirected = childDirected ?? false;

    if (testDevices != null &&
        testDevices.every((String s) => s == null || s.isEmpty)) {
      testDevices = null;
    }

    _testDevices = testDevices ?? [];

    _nonPersonalizedAds = nonPersonalizedAds ?? false;

    _testing = testing ?? false;

    if (listener != null) _adEventListeners.add(listener);

    _size = size ?? AdSize.banner;

    _anchorOffset = anchorOffset ?? 0.0;

    _horizontalCenterOffset = horizontalCenterOffset ?? 0.0;

    _anchorType = anchorType ?? AnchorType.bottom;

    /// Prevent any further instantiations until plugin is initialized or not.
    FirebaseAdMob.instance
        .initialize(
            appId: appId,
            trackingId: trackingId,
            analyticsEnabled: analyticsEnabled ?? false)
        .then((init) {
      if (!init) return;

      _initialized = init;

      if (bannerUnitId != null)
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
          anchorType: anchorType,
        );

      if (screenUnitId != null)
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
          anchorType: anchorType,
        );

      if (videoUnitId != null)
        setVideoAd(
          adUnitId: videoUnitId,
          keywords: keywords,
          contentUrl: contentUrl,
          childDirected: childDirected,
          testDevices: testDevices,
          testing: testing,
        );
    });
  }

  /// Stores the Banner ad unit id.
  String _bannerUnitId = '';

  /// Stores the Interstitial ad unit id.
  String _screenUnitId = '';

  /// Stores the Video ad unit id.
  String _videoUnitId = '';

  /// Flag indicating this is the first object instantiated.
  bool _firstObject = true;

  /// You can only initialize the Firebase_AdMob plugin once!
  static bool _initialized = false;

  bool get initialized => _initialized;

  List<String> _keywords;

  /// Get ad keywords
  List<String> get keywords => _keywords;

  String _contentUrl = "";

  /// Get the url providing ad content
  String get contentUrl => _contentUrl;

  bool _childDirected;

  bool get childDirected => _childDirected;

  List<String> _testDevices;

  /// Get list of test devices.
  List<String> get testDevices => _testDevices;

  bool _nonPersonalizedAds;

  bool get nonPersonalizedAds => _nonPersonalizedAds;

  bool _testing;

  /// Determine if testing or not
  bool get testing => _testing;

  AdSize _size;

  AdSize get size => _size;

  double _anchorOffset;

  double get anchorOffset => _anchorOffset;

  double _horizontalCenterOffset;

  double get horizontalCenterOffset => _horizontalCenterOffset;

  AnchorType _anchorType;

  AnchorType get anchorType => _anchorType;

  bool get inError =>
      (_bannerAd?._banner?.inError ?? false) ||
      (_fullScreenAd?.inError ?? false) ||
      (_videoAd?.inError ?? false);

  bool get bannerError => _bannerAd?._banner?.inError ?? false;

  bool get screenError => _fullScreenAd?.inError ?? false;

  bool get videoError => _videoAd?.inError ?? false;

  Exception getError() =>
      getBannerError() ?? getScreenError() ?? getVideoError();

  Exception getBannerError() => _bannerAd?._banner?.getError();

  Exception getScreenError() => _fullScreenAd?.getError();

  Exception getVideoError() => _videoAd?.getError();

  List<EventError> get eventErrors => _eventErrors;

  BannerAd _bannerAd;

  FullScreenAd _fullScreenAd;

  VideoAd _videoAd;

  /// Close any Ads, clean up memory and clear resources.
  void dispose() {
    closeBannerAd();
    closeFullScreenAd();

    /// Clear all Ad Event Listeners.
    _adEventListeners.clear();

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

    _eventErrors.clear();
  }

  /// Set the Banner Ad options.
  Future<bool> setBannerAd({
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool nonPersonalizedAds,
    bool testing,
    MobileAdListener listener,
    AdSize size,
    double anchorOffset,
    double horizontalCenterOffset,
    AnchorType anchorType,
  }) {
    // Can only have one instantiated Ads object.
    if (!_firstObject) return Future.value(false);

    if (listener != null) banner.eventListeners.add(listener);

    _bannerAd ??= BannerAd(listener: banner.eventListener);

    if (adUnitId == null || adUnitId.isEmpty || adUnitId.length < 30) {
      adUnitId = _bannerUnitId;
    }

    if (keywords == null || keywords.isEmpty) keywords = _keywords;

    if (testDevices == null || testDevices.isEmpty) testDevices = _testDevices;

    return _bannerAd.set(
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl ?? _contentUrl,
      childDirected: childDirected ?? _childDirected,
      testDevices: testDevices,
      nonPersonalizedAds: nonPersonalizedAds ?? _nonPersonalizedAds,
      testing: testing ?? _testing,
      size: size ?? _size,
      anchorOffset: anchorOffset ?? _anchorOffset,
      horizontalCenterOffset: horizontalCenterOffset ?? _horizontalCenterOffset,
      anchorType: anchorType ?? _anchorType,
    );
  }

  /// Show a Banner Ad.
  ///
  /// parameters:
  /// state is passed to determine if the app is not terminating. No need to show ad.
  ///
  /// anchorOffset is the logical pixel offset from the edge of the screen (default 0.0)
  ///
  /// anchorType place advert at top or bottom of screen (default bottom)
  Future<bool> showBannerAd({
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool testing,
    MobileAdListener listener,
    AdSize size,
    double anchorOffset,
    double horizontalCenterOffset,
    AnchorType anchorType,
    State state,
  }) async {
    bool show = false;
    // Can only have one instantiated Ads object.
    if (!_firstObject) return show;

    if (_bannerAd == null) {
      bool show = await setBannerAd(
        adUnitId: adUnitId,
        keywords: keywords,
        contentUrl: contentUrl,
        childDirected: childDirected,
        testDevices: testDevices,
        testing: testing,
        listener: listener,
        size: size,
        anchorOffset: anchorOffset,
        horizontalCenterOffset: horizontalCenterOffset,
        anchorType: anchorType,
      );
      if (show) show = await _bannerAd.show();
    } else {
      if (listener != null) banner.eventListeners.add(listener);

      show = await _bannerAd.show(
        adUnitId: adUnitId,
        targetInfo: targetInfo,
        testing: testing,
        size: size,
        anchorOffset: anchorOffset,
        horizontalCenterOffset: horizontalCenterOffset,
        anchorType: anchorType,
        state: state,
      );
    }
    return show;
  }

  @deprecated
  void hideBannerAd() => closeBannerAd();

  /// Hide a Banner Ad.
  void closeBannerAd({bool load = true}) => _bannerAd?.dispose(load: load);

  /// Remove the Banner Ad from memory
  void removeBannerAd({bool load = false}) => _bannerAd?.dispose(load: load);

  /// Set the Full Screen Ad options.
  Future<bool> setFullScreenAd({
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool nonPersonalizedAds,
    bool testing,
    MobileAdListener listener,
    double anchorOffset,
    double horizontalCenterOffset,
    AnchorType anchorType,
  }) async {
    // Can only have one instantiated Ads object.
    if (!_firstObject) return Future.value(false);

    if (listener != null) screen.eventListeners.add(listener);

    _fullScreenAd ??= FullScreenAd(listener: screen.eventListener);

    // If an unit id is not provided, it may be available from the constructor.
    if (adUnitId == null || adUnitId.isEmpty || adUnitId.length < 30) {
      adUnitId = _screenUnitId;
    }

    if (keywords == null || keywords.isEmpty) keywords = _keywords;

    if (testDevices == null || testDevices.isEmpty) testDevices = _testDevices;

    return await _fullScreenAd.set(
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl ?? _contentUrl,
      childDirected: childDirected ?? _childDirected,
      testDevices: testDevices,
      nonPersonalizedAds: nonPersonalizedAds ?? _nonPersonalizedAds,
      testing: testing ?? _testing,
      anchorOffset: anchorOffset ?? _anchorOffset,
      horizontalCenterOffset: horizontalCenterOffset ?? _horizontalCenterOffset,
      anchorType: anchorType ?? _anchorType,
    );
  }

  /// Show a Full Screen Ad.
  ///
  /// parameters:
  /// state is passed to determine if the app is not terminating. No need to show ad.
  /// anchorOffset is the logical pixel offset from the edge of the screen (default 0.0)
  /// anchorType place advert at top or bottom of screen (default bottom)
  Future<bool> showFullScreenAd({
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool testing,
    MobileAdListener listener,
    double anchorOffset,
    double horizontalCenterOffset,
    AnchorType anchorType,
    State state,
  }) async {
    bool show = false;
    // Can only have one instantiated Ads object.
    if (!_firstObject) return show;

    if (_fullScreenAd == null) {
      show = await setFullScreenAd(
        adUnitId: adUnitId,
        keywords: keywords,
        contentUrl: contentUrl,
        childDirected: childDirected,
        testDevices: testDevices,
        testing: testing,
        anchorOffset: anchorOffset,
        horizontalCenterOffset: horizontalCenterOffset,
        anchorType: anchorType,
        listener: listener,
      );
      if (show) show = await _fullScreenAd.show();
    } else {
      if (listener != null) screen.eventListeners.add(listener);

      show = await _fullScreenAd.show(
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
        state: state,
      );
    }
    return show;
  }

  /// Hide the Full Screen Ad.
  void closeFullScreenAd() => _fullScreenAd?.dispose();

  /// Set the Video Ad options.
  Future<bool> setVideoAd({
    bool show = false,
    String adUnitId,
    MobileAdTargetingInfo targetInfo,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool nonPersonalizedAds,
    bool testing,
    RewardedVideoAdListener listener,
  }) {
    // Can only have one instantiated Ads object.
    if (!_firstObject) return Future.value(false);

    if (listener != null) video.eventListeners.add(listener);

    _videoAd ??= VideoAd(listener: video.eventListener);

    // If an unit id is not provided, it may be available from the constructor.
    if (adUnitId == null || adUnitId.isEmpty || adUnitId.length < 30) {
      adUnitId = _videoUnitId;
    }

    if (keywords == null || keywords.isEmpty) keywords = _keywords;

    if (testDevices == null || testDevices.isEmpty) testDevices = _testDevices;

    return _videoAd.set(
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl ?? _contentUrl,
      childDirected: childDirected ?? _childDirected,
      testDevices: testDevices,
      nonPersonalizedAds: nonPersonalizedAds ?? _nonPersonalizedAds,
      testing: testing ?? _testing,
    );
  }

  /// Show a Video Ad.
  ///hideFullScreenAd
  /// parameters:
  /// state is passed to determine if the app is not terminating. No need to show ad.
  Future<bool> showVideoAd(
      {String adUnitId,
      MobileAdTargetingInfo targetInfo,
      List<String> keywords,
      String contentUrl,
      bool childDirected,
      List<String> testDevices,
      bool testing,
      RewardedVideoAdListener listener,
      State state}) async {
    bool show = false;
    // Can only have one instantiated Ads object.
    if (!_firstObject) return show;

    if (_videoAd == null) {
      show = await setVideoAd(
        adUnitId: adUnitId,
        keywords: keywords,
        contentUrl: contentUrl,
        childDirected: childDirected,
        testDevices: testDevices,
        testing: testing,
        listener: listener,
      );
      if (show) show = await _videoAd.show();
    } else {
      if (listener != null) video.eventListeners.add(listener);

      show = await _videoAd.show(
        adUnitId: adUnitId,
        targetInfo: targetInfo,
        keywords: keywords,
        contentUrl: contentUrl,
        childDirected: childDirected,
        testDevices: testDevices,
        testing: testing,
        state: state,
      );
    }
    return show;
  }

  /// Set an Ad Event Listener.
  set eventListener(MobileAdListener listener) =>
      _adEventListeners.add(listener);

  /// Remove a specific Add Event Listener.
  bool removeEvent(MobileAdListener listener) =>
      _adEventListeners.remove(listener);

  final banner = _AdListener(_adEventListeners);

  /// Set a Banner Ad Event Listener.
  set bannerListener(MobileAdListener listener) {
    if (listener == null) return;
    banner.eventListeners.add(listener);
  }

  /// Remove a specific Banner Ad Event Listener.
  bool removeBanner(MobileAdListener listener) =>
      banner.eventListeners.remove(listener);

  final screen = _AdListener(_adEventListeners);

  /// Set a Full Screen Ad Event Listener.
  set screenListener(MobileAdListener listener) {
    if (listener == null) return;

    screen.eventListeners.add(listener);
  }

  /// Remove a Full Screen Ad Event Listener.
  bool removeScreen(MobileAdListener listener) =>
      screen.eventListeners.remove(listener);

  final video = _VidListener(_adEventListeners);

  /// Set a Video Ad Event Listener
  set videoListener(RewardedVideoAdListener listener) {
    if (listener == null) return;
    video.eventListeners.add(listener);
  }

  /// Remove a specific Video Ad Event Listener.
  bool removeVideo(RewardedVideoAdListener listener) =>
      video.eventListeners.remove(listener);
}

bool _inError = false;

List<EventError> _eventErrors = List();

class BannerAd {
  factory BannerAd({MobileAdListener listener}) {
    _this ??= BannerAd._(listener);
    return _this;
  }
  static BannerAd _this;
  BannerAd._(MobileAdListener listener) {
    _banner = Banner(listener: listener);
  }
  Banner _banner;

  /// Set options to the Banner Ad.
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
  }) {
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
      anchorType: anchorType,
    );
  }

  /// Show the Banner Ad.
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
  }) {
    return _banner.show(
      adUnitId: adUnitId,
      targetInfo: targetInfo,
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
      testing: testing,
      size: size,
      anchorOffset: anchorOffset,
      horizontalCenterOffset: horizontalCenterOffset,
      anchorType: anchorType,
      state: state,
    );
  }

  void dispose({bool load = false}) {
    _banner?.dispose()?.then((_) {
      // Load the Ad into memory again
      if (load) _banner.load(show: false);
    });
  }
}

class _AdListener {
  _AdListener([this._adEventListeners]) {
    _adEventListeners ??= Set();
  }
  Set<MobileAdListener> _adEventListeners;

  Set<MobileAdListener> eventListeners = Set();

  /// Listens for when the Ad is loaded in memory.
  Set<VoidCallback> _loadedListeners = Set();
  set loadedListener(VoidCallback listener) => _loadedListeners.add(listener);
  bool removeLoaded(VoidCallback listener) => _loadedListeners.remove(listener);
  _clearLoaded() => _loadedListeners.clear();

  /// Listens for when the Ad fails to display.
  Set<VoidCallback> _failedListeners = Set();
  set failedListener(VoidCallback listener) => _failedListeners.add(listener);
  bool removeFailed(VoidCallback listener) => _failedListeners.remove(listener);
  _clearFailed() => _failedListeners.clear();

  /// Listens for when the Ad is clicked on.
  Set<VoidCallback> _clickedListeners = Set();
  set clickedListener(VoidCallback listener) => _clickedListeners.add(listener);
  bool removeClicked(VoidCallback listener) =>
      _clickedListeners.remove(listener);
  _clearClicked() => _clickedListeners.clear();

  /// Listens for when the user clicks further on the Ad.
  Set<VoidCallback> _impressionListeners = Set();
  set impressionListener(VoidCallback listener) =>
      _impressionListeners.add(listener);
  bool removeImpression(VoidCallback listener) =>
      _impressionListeners.remove(listener);
  _clearImpression() => _impressionListeners.clear();

  /// Listens for when the Ad is opened.
  Set<VoidCallback> _openedListeners = Set();
  set openedListener(VoidCallback listener) => _openedListeners.add(listener);
  bool removeOpened(VoidCallback listener) => _openedListeners.remove(listener);
  _clearOpened() => _openedListeners.clear();

  /// Listens for when the user has left the Ad.
  Set<VoidCallback> _leftListeners = Set();
  set leftAppListener(VoidCallback listener) => _leftListeners.add(listener);
  bool removeLeftApp(VoidCallback listener) => _leftListeners.remove(listener);
  _clearLeftApp() => _leftListeners.clear();

  /// Listens for when the Ad is closed.
  Set<VoidCallback> _closedListeners = Set();
  set closedListener(VoidCallback listener) => _closedListeners.add(listener);
  bool removeClosed(VoidCallback listener) => _closedListeners.remove(listener);
  _clearClosed() => _closedListeners.clear();

  /// The Ad's Event Listener Function.
  void eventListener(MobileAdEvent event) {
    for (var listener in _adEventListeners) {
      try {
        listener(event);
      } catch (ex) {
        _errorHandler(ex, event: event);
      }
    }

    for (var listener in eventListeners) {
      try {
        listener(event);
      } catch (ex) {
        _errorHandler(ex, event: event);
      }
    }

    switch (event) {
      case MobileAdEvent.loaded:
        for (var listener in _loadedListeners) {
          try {
            listener();
          } catch (ex) {
            _errorHandler(ex, event: MobileAdEvent.loaded);
          }
        }

        break;
      case MobileAdEvent.failedToLoad:
        for (var listener in _failedListeners) {
          try {
            listener();
          } catch (ex) {
            _errorHandler(ex, event: MobileAdEvent.failedToLoad);
          }
        }

        break;
      case MobileAdEvent.clicked:
        for (var listener in _clickedListeners) {
          try {
            listener();
          } catch (ex) {
            _errorHandler(ex, event: MobileAdEvent.clicked);
          }
        }

        break;
      case MobileAdEvent.impression:
        for (var listener in _impressionListeners) {
          try {
            listener();
          } catch (ex) {
            _errorHandler(ex, event: MobileAdEvent.impression);
          }
        }

        break;
      case MobileAdEvent.opened:
        for (var listener in _openedListeners) {
          try {
            listener();
          } catch (ex) {
            _errorHandler(ex, event: MobileAdEvent.opened);
          }
        }

        break;
      case MobileAdEvent.leftApplication:
        for (var listener in _leftListeners) {
          try {
            listener();
          } catch (ex) {
            _errorHandler(ex, event: MobileAdEvent.leftApplication);
          }
        }

        break;
      case MobileAdEvent.closed:
        for (var listener in _closedListeners) {
          try {
            listener();
          } catch (ex) {
            _errorHandler(ex, event: MobileAdEvent.closed);
          }
        }

        break;
      default:
    }
  }

  clearAll() {
    _clearLoaded();
    _clearFailed();
    _clearClicked();
    _clearImpression();
    _clearOpened();
    _clearLeftApp();
    _clearClosed();
  }
}

class _VidListener {
  _VidListener([this._adEventListeners]) {
    _adEventListeners ??= Set();
  }
  Set<MobileAdListener> _adEventListeners;

  Set<RewardedVideoAdListener> eventListeners = Set();

  /// Listens for when video ad is loaded.
  Set<VoidCallback> _loadedListeners = Set();
  set loadedListener(VoidCallback listener) => _loadedListeners.add(listener);
  bool removeLoaded(VoidCallback listener) => _loadedListeners.remove(listener);
  _clearLoaded() => _loadedListeners.clear();

  /// Listens for when video ad fails.
  Set<VoidCallback> _failedListeners = Set();
  set failedListener(VoidCallback listener) => _failedListeners.add(listener);
  bool removeFailed(VoidCallback listener) => _failedListeners.remove(listener);
  _clearFailed() => _failedListeners.clear();

  /// Listens for when video ad is clicked on.
  Set<VoidCallback> _clickedListeners = Set();
  set clickedListener(VoidCallback listener) => _clickedListeners.add(listener);
  bool removeClicked(VoidCallback listener) =>
      _clickedListeners.remove(listener);
  _clearClicked() => _clickedListeners.clear();

  /// Listens for when video ad opens up.
  Set<VoidCallback> _openedListeners = Set();
  set openedListener(VoidCallback listener) => _openedListeners.add(listener);
  bool removeOpened(VoidCallback listener) => _openedListeners.remove(listener);
  _clearOpened() => _openedListeners.clear();

  /// Listens for when user leaves the video ad.
  Set<VoidCallback> _leftListeners = Set();
  set leftAppListener(VoidCallback listener) => _leftListeners.add(listener);
  bool removeLeftApp(VoidCallback listener) => _leftListeners.remove(listener);
  _clearLeftApp() => _leftListeners.clear();

  /// Listens for when video ad is closed.
  Set<VoidCallback> _closedListeners = Set();
  set closedListener(VoidCallback listener) => _closedListeners.add(listener);
  bool removeClosed(VoidCallback listener) => _closedListeners.remove(listener);
  _clearClosed() => _closedListeners.clear();

  /// Listens for when video ad sends a reward.
  Set<RewardListener> _rewardedListeners = Set();
  set rewardedListener(RewardListener listener) {
    if (listener == null) return;
    _rewardedListeners.add(listener);
  }

  bool removeRewarded(RewardListener listener) =>
      _rewardedListeners.remove(listener);
  _clearRewarded() => _rewardedListeners.clear();

  /// Listens for when video ad starts playing.
  Set<VoidCallback> _startedListeners = Set();
  set startedListener(VoidCallback listener) => _startedListeners.add(listener);
  bool removeStarted(VoidCallback listener) =>
      _startedListeners.remove(listener);
  _clearStarted() => _startedListeners.clear();

  /// Listens for when video ad has finished playing.
  Set<VoidCallback> _completedListeners = Set();
  set completedListener(VoidCallback listener) =>
      _completedListeners.add(listener);
  bool removeCompleted(VoidCallback listener) =>
      _completedListeners.remove(listener);
  _clearCompleted() => _completedListeners.clear();

  /// The Video Ad Event Listener Function.
  void eventListener(RewardedVideoAdEvent event,
      {String rewardType, int rewardAmount}) {
    MobileAdEvent mobileEvent = _toMobileAdEvent(event);

    /// Don't continue if there is no corresponding event type.
    if (mobileEvent != null) {
      for (var listener in _adEventListeners) {
        try {
          listener(mobileEvent);
        } catch (ex) {
          _errorHandler(ex, event: mobileEvent);
        }
      }
    }

    for (var listener in eventListeners) {
      try {
        listener(event, rewardType: rewardType, rewardAmount: rewardAmount);
      } catch (ex) {
        _errorHandler(ex, event: mobileEvent);
      }
    }

    switch (event) {
      case RewardedVideoAdEvent.loaded:
        for (var listener in _loadedListeners) {
          try {
            listener();
          } catch (ex) {
            _errorHandler(ex, event: mobileEvent);
          }
        }

        break;
      case RewardedVideoAdEvent.failedToLoad:
        for (var listener in _failedListeners) {
          try {
            listener();
          } catch (ex) {
            _errorHandler(ex, event: mobileEvent);
          }
        }

        break;
      case RewardedVideoAdEvent.opened:
        for (var listener in _openedListeners) {
          try {
            listener();
          } catch (ex) {
            _errorHandler(ex, event: mobileEvent);
          }
        }

        break;
      case RewardedVideoAdEvent.leftApplication:
        for (var listener in _leftListeners) {
          try {
            listener();
          } catch (ex) {
            _errorHandler(ex, event: mobileEvent);
          }
        }

        break;
      case RewardedVideoAdEvent.closed:
        for (var listener in _closedListeners) {
          try {
            listener();
          } catch (ex) {
            _errorHandler(ex, event: mobileEvent);
          }
        }

        break;
      case RewardedVideoAdEvent.rewarded:
        for (var listener in _rewardedListeners) {
          try {
            listener(rewardType, rewardAmount);
          } catch (ex) {
            _errorHandler(ex, event: mobileEvent);
          }
        }

        break;
      case RewardedVideoAdEvent.started:
        for (var listener in _startedListeners) {
          try {
            listener();
          } catch (ex) {
            _errorHandler(ex, event: mobileEvent);
          }
        }

        break;
      case RewardedVideoAdEvent.completed:
        for (var listener in _completedListeners) {
          try {
            listener();
          } catch (ex) {
            _errorHandler(ex, event: mobileEvent);
          }
        }

        break;
      default:
        print(event);
    }
  }

  /// Clear all possible types of Ad listeners on one call.
  clearAll() {
    _clearLoaded();
    _clearFailed();
    _clearClicked();
    _clearOpened();
    _clearLeftApp();
    _clearClosed();
    _clearRewarded();
    _clearStarted();
    _clearCompleted();
  }

  MobileAdEvent _toMobileAdEvent(RewardedVideoAdEvent event) {
    MobileAdEvent type;

    switch (event) {
      case RewardedVideoAdEvent.loaded:
        type = MobileAdEvent.loaded;

        break;
      case RewardedVideoAdEvent.failedToLoad:
        type = MobileAdEvent.failedToLoad;

        break;
      case RewardedVideoAdEvent.opened:
        type = MobileAdEvent.opened;

        break;
      case RewardedVideoAdEvent.leftApplication:
        type = MobileAdEvent.leftApplication;

        break;
      case RewardedVideoAdEvent.closed:
        type = MobileAdEvent.closed;

        break;
      case RewardedVideoAdEvent.rewarded:
        type = null;

        break;
      case RewardedVideoAdEvent.started:
        type = null;

        break;
      case RewardedVideoAdEvent.completed:
        type = null;

        break;
      default:
        type = null;
    }

    return type;
  }
}

/// Error Handler for the event listeners.
void _errorHandler(Object ex, {MobileAdEvent event}) {
  if (ex is! Exception) ex = Exception(ex.toString());
  _eventErrors.add(EventError(event, ex));
  _inError = true;
}

class EventError {
  EventError(this.event, this.ex);
  MobileAdEvent event;
  Exception ex;
}
