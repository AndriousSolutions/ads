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

import 'package:firebase_admob/firebase_admob.dart';

import 'package:flutter/foundation.dart' show VoidCallback;

typedef void AdEventListener(MobileAdEvent event);

typedef void VideoEventListener(RewardedVideoAdEvent event,
    {String rewardType, int rewardAmount});

typedef void RewardListener(String rewardType, int rewardAmount);

List<AdEventListener> _adEventListeners = [];

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
    bool childDirected = false,
    List<String> testDevices,
    bool testing = false,
    AdEventListener listener,
  }) {
    assert(appId != null && appId.isNotEmpty, 'class Ads: appId is required.');

    /// Test for parameters being pass null in production
    // Accessed in _targetInfo() function.
    appId = appId == null || appId.isEmpty ? FirebaseAdMob.testAppId : appId;

    if (bannerUnitId != null) {
      _bannerUnitId = bannerUnitId.trim();
    }
    if (screenUnitId != null) {
      _screenUnitId = screenUnitId.trim();
    }
    if (videoUnitId != null) {
      _videoUnitId = videoUnitId.trim();
    }

    _keywords = keywords;

    _contentUrl = contentUrl;

    _childDirected = childDirected;

    _testDevices = testDevices;

    _testing = testing == null ? false : testing;

    if (listener != null) _adEventListeners.add(listener);

    /// This class is being instantiated again??
    /// Continue, but do not activate this object to do anything.
    /// Once initialized only use the original reference.
    if (_initialized) {
      // This Ads object can continue to be instantiated, but it can't do anything.
      _firstObject = false;
    } else {
      /// Prevent any further instantiations until plugin is initialized or not.
      _initialized = true;
      FirebaseAdMob.instance
          .initialize(
              appId: appId,
              trackingId: trackingId,
              analyticsEnabled: analyticsEnabled)
          .then((init) {
        // Determine if the plugin has initialized successfully.
        _initialized = init;
      });
    }
  }

  /// Stores the Banner ad unit id.
  String _bannerUnitId = '';

  /// Stores the Interstitial ad unit id.
  String _screenUnitId = '';

  /// Stores the Video ad unit id.
  String _videoUnitId = '';

  /// Activate this object.
  bool _firstObject = true;

  /// You can only initialize the Firebase_AdMob plugin once!
  static bool _initialized = false;

  bool get initialized => _initialized;

  List<String> _keywords;

  /// Get ad keywords
  List<String> get keywords => _keywords;

  String _contentUrl;

  /// Get the url providing ad content
  String get contentUrl => _contentUrl;

  bool _childDirected;

  bool get childDirected => _childDirected;

  List _testDevices = <String>[];

  /// Get list of test devices.
  List<String> get testDevices => _testDevices;

  bool _testing;

  /// Determine if testing or not
  bool get testing => _testing;

  BannerAd _bannerAd;

  InterstitialAd _fullScreenAd;

  RewardedVideoAd _rewardedVideoAd = RewardedVideoAd.instance;

  _VideoAd _videoAd;

  bool _screenLoaded = false;

  bool _showVideo = false;

  /// Close any Ads, clean up memory and clear resources.
  void dispose() {
    hideBannerAd();
    hideFullScreenAd();
    clearEventListeners();
    clearBannerListeners();
    clearScreenListeners();
    clearVideoListeners();
    banner.clearAll();
    screen.clearAll();
    video.clearAll();
    _videoAd = null;
  }

  /// Show a Banner Ad.
  ///
  /// parameters:
  /// state is passed to determine if the app is not terminating. No need to show ad.
  ///
  /// anchorOffset is the logical pixel offset from the edge of the screen (default 0.0)
  ///
  /// anchorType place advert at top or bottom of screen (default bottom)
  void showBannerAd(
      {String adUnitId = '',
      AdSize size = AdSize.banner,
      List<String> keywords,
      String contentUrl,
      bool childDirected,
      List<String> testDevices,
      bool testing,
      AdEventListener listener,
      State state,
      double anchorOffset = 0.0,
      AnchorType anchorType = AnchorType.bottom}) {
    assert(_firstObject,
        "An Ads class is already instantiated!");
    if (!_firstObject) return;
    if (state != null && !state.mounted) return;
    if (anchorOffset == null) anchorOffset = 0.0;
    if (anchorType == null) anchorType = AnchorType.bottom;
    if (_bannerAd != null &&
        (adUnitId != null ||
            size != null ||
            keywords != null ||
            contentUrl != null ||
            childDirected != null ||
            testDevices != null ||
            testing != null ||
            listener != null)) hideBannerAd();
    if (_bannerAd == null)
      setBannerAd(
        adUnitId: adUnitId,
        size: size,
        keywords: keywords,
        contentUrl: contentUrl,
        childDirected: childDirected,
        testDevices: testDevices,
        testing: testing,
        listener: listener,
      );
    _bannerAd
      ..load()
      ..show(anchorOffset: anchorOffset, anchorType: anchorType);
  }

  /// Set the Banner Ad options.
  void setBannerAd({
    String adUnitId = '',
    AdSize size = AdSize.banner,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool testing,
    AdEventListener listener,
  }) {
    assert(_firstObject,
    "An Ads class is already instantiated!");
    if (!_firstObject) return;

    String unitId;

    if (adUnitId == null || adUnitId.isEmpty) {
      // Use the id passed to the init() function if any.
      unitId = _bannerUnitId;
    } else {
      unitId = adUnitId.trim();
    }

    MobileAdTargetingInfo info = _targetInfo(
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
    );

    if (testing == null) testing = _testing;

    if (listener != null) banner._eventListeners.add(listener);

    // Clear memory of any previously set banner ad.
    hideBannerAd();

    _bannerAd = BannerAd(
      adUnitId: testing
          ? BannerAd.testAdUnitId
          : unitId.isEmpty ? BannerAd.testAdUnitId : unitId,
      size: size ?? AdSize.banner,
      targetingInfo: info,
      listener: banner._eventListener,
    );
  }

  /// Hide a Banner Ad.
  void hideBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  /// Show a Full Screen Ad.
  ///
  /// parameters:
  /// state is passed to determine if the app is not terminating. No need to show ad.
  /// anchorOffset is the logical pixel offset from the edge of the screen (default 0.0)
  /// anchorType place advert at top or bottom of screen (default bottom)
  void showFullScreenAd(
      {String adUnitId = '',
      List<String> keywords,
      String contentUrl,
      bool childDirected,
      List<String> testDevices,
      bool testing,
      AdEventListener listener,
      State state,
      double anchorOffset = 0.0,
      AnchorType anchorType = AnchorType.bottom}) {
    assert(_firstObject,
    "An Ads class is already instantiated!");
    if (!_firstObject) return;
    if (state != null && !state.mounted) return;
    if (anchorOffset == null) anchorOffset = 0.0;
    if (anchorType == null) anchorType = AnchorType.bottom;
    if (_fullScreenAd != null &&
        (adUnitId != null ||
            keywords != null ||
            contentUrl != null ||
            childDirected != null ||
            testDevices != null ||
            testing != null ||
            listener != null)) hideFullScreenAd();
    if (_fullScreenAd == null || !_screenLoaded)
      setFullScreenAd(
          adUnitId: adUnitId,
          keywords: keywords,
          contentUrl: contentUrl,
          childDirected: childDirected,
          testDevices: testDevices,
          testing: testing,
          listener: listener);
    _fullScreenAd.show(anchorOffset: anchorOffset, anchorType: anchorType);
    _screenLoaded = false;
  }

  /// Set the Full Screen Ad options.
  void setFullScreenAd({
    String adUnitId = '',
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool testing,
    AdEventListener listener,
  }) {
    assert(_firstObject,
    "An Ads class is already instantiated!");
    if (!_firstObject) return;

    String unitId;

    if (adUnitId == null || adUnitId.isEmpty) {
      unitId = _screenUnitId;
    } else {
      unitId = adUnitId.trim();
    }

    MobileAdTargetingInfo info = _targetInfo(
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
    );

    if (testing == null) testing = _testing;

    if (listener != null) screen._eventListeners.add(listener);

    // Clear memory of any previously set interstitial ad.
    hideFullScreenAd();

    _fullScreenAd = InterstitialAd(
      adUnitId: testing
          ? InterstitialAd.testAdUnitId
          : unitId.isEmpty ? InterstitialAd.testAdUnitId : unitId,
      targetingInfo: info,
      listener: screen._eventListener,
    );

    _fullScreenAd.load();

    _screenLoaded = true;
  }

  /// Hide the Full Screen Ad.
  void hideFullScreenAd() {
    _fullScreenAd?.dispose();
    _fullScreenAd = null;
  }

  /// Show a Video Ad.
  ///
  /// parameters:
  /// state is passed to determine if the app is not terminating. No need to show ad.
  void showVideoAd(
      {String adUnitId,
      List<String> keywords,
      String contentUrl,
      bool childDirected,
      List<String> testDevices,
      bool testing,
      VideoEventListener listener,
      State state}) {
    assert(_firstObject,
    "An Ads class is already instantiated!");
    if (!_firstObject) return;
    if (state != null && !state.mounted) return;
    if (_showVideo &&
        (adUnitId != null ||
            keywords != null ||
            contentUrl != null ||
            childDirected != null ||
            testDevices != null ||
            testing != null ||
            listener != null)) _showVideo = false;
    if (_showVideo) {
      _videoAd.ad.show();
      _showVideo = false;
    } else {
      /// calling with parameters will NOT show the video ad.
      setVideoAd(
          show: true,
          adUnitId: adUnitId,
          keywords: keywords,
          contentUrl: contentUrl,
          childDirected: childDirected,
          testDevices: testDevices,
          testing: testing,
          listener: listener);
    }
  }

  /// Set the Video Ad options.
  void setVideoAd({
    bool show = false,
    String adUnitId,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    bool testing,
    VideoEventListener listener,
  }) {
    assert(_firstObject,
    "An Ads class is already instantiated!");
    if (!_firstObject) return;

    String unitId;

    if (adUnitId == null || adUnitId.isEmpty) {
      unitId = _videoUnitId;
    } else {
      unitId = adUnitId.trim();
    }

    MobileAdTargetingInfo info = _targetInfo(
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
    );

    if (testing == null) testing = _testing;

    if (listener != null) video._eventListeners.add(listener);

    _showVideo = show;

    _rewardedVideoAd.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      if (event == RewardedVideoAdEvent.loaded) {
        if (_showVideo) {
          _videoAd.ad.show();
          _showVideo = false;
        } else {
          _showVideo = true;
        }
      }

      video._eventListener(event,
          rewardType: rewardType, rewardAmount: rewardAmount);
    };

    String adModId = testing
        ? RewardedVideoAd.testAdUnitId
        : unitId.isEmpty ? RewardedVideoAd.testAdUnitId : unitId;

    _rewardedVideoAd.load(adUnitId: adModId, targetingInfo: info);

    _videoAd =
        _VideoAd(adUnitId: adModId, targetingInfo: info, ad: _rewardedVideoAd);
  }

  /// Return the target audience information
  MobileAdTargetingInfo _targetInfo({
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
  }) {
    // No parameters seek values from init()
    bool init = keywords == null &&
        contentUrl == null &&
        childDirected == null &&
        testDevices == null;

    if (init) {
      keywords ??= _keywords;
      contentUrl ??= _contentUrl;
      childDirected ??= _childDirected;
      testDevices ??= _testDevices;
    }

    return MobileAdTargetingInfo(
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
    );
  }

  /// Set an Ad Event Listener.
  set eventListener(AdEventListener listener) =>
      _adEventListeners.add(listener);

  /// Remove a specific Add Event Listener.
  set removeEvent(AdEventListener listener) =>
      _adEventListeners.remove(listener);

  /// Clear all Ad Event Listeners.
  clearEventListeners() => _adEventListeners.clear();

  final banner = _AdListener();

  /// Set a Banner Ad Event Listener.
  set bannerListener(AdEventListener listener) =>
      banner._eventListeners.add(listener);

  /// Remove a specific Banner Ad Event Listener.
  set removeBanner(AdEventListener listener) =>
      banner._eventListeners.remove(listener);

  /// Clear all Banner Ad Event Listeners.
  clearBannerListeners() => banner._eventListeners.clear();

  final screen = _AdListener();

  /// Set a Full Screen Ad Event Listener.
  set screenListener(AdEventListener listener) =>
      screen._eventListeners.add(listener);

  /// Remove a Full Screen Ad Event Listener.
  set removeScreen(AdEventListener listener) =>
      screen._eventListeners.remove(listener);

  /// Clear all Full Screen Ad Event Listeners.
  clearScreenListeners() => screen._eventListeners.clear();

  final video = _VidListener();

  /// Set a Video Ad Event Listener
  set videoListener(VideoEventListener listener) =>
      video._eventListeners.add(listener);

  /// Remove a specific Video Ad Event Listener.
  set removeVideo(VideoEventListener listener) =>
      video._eventListeners.remove(listener);

  /// Clear all Video Ad Event Listeners.
  clearVideoListeners() => video._eventListeners.clear();
}

class _AdListener {
  List<AdEventListener> _eventListeners = [];

  /// Listens for when the Ad is loaded in memory.
  List<VoidCallback> _loadedListeners = [];
  set loadedListener(VoidCallback listener) => _loadedListeners.add(listener);
  set removeLoaded(VoidCallback listener) => _loadedListeners.remove(listener);
  clearLoaded() => _loadedListeners.clear();

  /// Listens for when the Ad fails to display.
  List<VoidCallback> _failedListeners = [];
  set failedListener(VoidCallback listener) => _failedListeners.add(listener);
  set removeFailed(VoidCallback listener) => _failedListeners.remove(listener);
  clearFailed() => _failedListeners.clear();

  /// Listens for when the Ad is clicked on.
  List<VoidCallback> _clickedListeners = [];
  set clickedListener(VoidCallback listener) => _clickedListeners.add(listener);
  set removeClicked(VoidCallback listener) =>
      _clickedListeners.remove(listener);
  clearClicked() => _clickedListeners.clear();

  /// Listens for when the user clicks further on the Ad.
  List<VoidCallback> _impressionListeners = [];
  set impressionListener(VoidCallback listener) =>
      _impressionListeners.add(listener);
  set removeImpression(VoidCallback listener) =>
      _impressionListeners.remove(listener);
  clearImpression() => _impressionListeners.clear();

  /// Listens for when the Ad is opened.
  List<VoidCallback> _openedListeners = [];
  set openedListener(VoidCallback listener) => _openedListeners.add(listener);
  set removeOpened(VoidCallback listener) => _openedListeners.remove(listener);
  clearOpened() => _openedListeners.clear();

  /// Listens for when the user has left the Ad.
  List<VoidCallback> _leftListeners = [];
  set leftAppListener(VoidCallback listener) => _leftListeners.add(listener);
  set removeLeftApp(VoidCallback listener) => _leftListeners.remove(listener);
  clearLeftApp() => _leftListeners.clear();

  /// Listens for when the Ad is closed.
  List<VoidCallback> _closedListeners = [];
  set closedListener(VoidCallback listener) => _closedListeners.add(listener);
  set removeClosed(VoidCallback listener) => _closedListeners.remove(listener);
  clearClosed() => _closedListeners.clear();

  /// The Ad's Event Listener Function.
  void _eventListener(MobileAdEvent event) {
    for (var listener in _adEventListeners) {
      listener(event);
    }

    for (var listener in _eventListeners) {
      listener(event);
    }

    switch (event) {
      case MobileAdEvent.loaded:
        for (var listener in _loadedListeners) {
          listener();
        }

        break;
      case MobileAdEvent.failedToLoad:
        for (var listener in _failedListeners) {
          listener();
        }

        break;
      case MobileAdEvent.clicked:
        for (var listener in _clickedListeners) {
          listener();
        }

        break;
      case MobileAdEvent.impression:
        for (var listener in _impressionListeners) {
          listener();
        }

        break;
      case MobileAdEvent.opened:
        for (var listener in _openedListeners) {
          listener();
        }

        break;
      case MobileAdEvent.leftApplication:
        for (var listener in _leftListeners) {
          listener();
        }

        break;
      case MobileAdEvent.closed:
        for (var listener in _closedListeners) {
          listener();
        }

        break;
      default:
    }
  }

  clearAll() {
    clearLoaded();
    clearFailed();
    clearClicked();
    clearOpened();
    clearLeftApp();
    clearClosed();
  }
}

class _VidListener {
  List<VideoEventListener> _eventListeners = [];

  /// Listens for when video ad is loaded.
  List<VoidCallback> _loadedListeners = [];
  set loadedListener(VoidCallback listener) => _loadedListeners.add(listener);
  set removeLoaded(VoidCallback listener) => _loadedListeners.remove(listener);
  clearLoaded() => _loadedListeners.clear();

  /// Listens for when video ad fails.
  List<VoidCallback> _failedListeners = [];
  set failedListener(VoidCallback listener) => _failedListeners.add(listener);
  set removeFailed(VoidCallback listener) => _failedListeners.remove(listener);
  clearFailed() => _failedListeners.clear();

  /// Listens for when video ad is clicked on.
  List<VoidCallback> _clickedListeners = [];
  set clickedListener(VoidCallback listener) => _clickedListeners.add(listener);
  set removeClicked(VoidCallback listener) =>
      _clickedListeners.remove(listener);
  clearClicked() => _clickedListeners.clear();

  /// Listens for when video ad opens up.
  List<VoidCallback> _openedListeners = [];
  set openedListener(VoidCallback listener) => _openedListeners.add(listener);
  set removeOpened(VoidCallback listener) => _openedListeners.remove(listener);
  clearOpened() => _openedListeners.clear();

  /// Listens for when user leaves the video ad.
  List<VoidCallback> _leftListeners = [];
  set leftAppListener(VoidCallback listener) => _leftListeners.add(listener);
  set removeLeftApp(VoidCallback listener) => _leftListeners.remove(listener);
  clearLeftApp() => _leftListeners.clear();

  /// Listens for when video ad is closed.
  List<VoidCallback> _closedListeners = [];
  set closedListener(VoidCallback listener) => _closedListeners.add(listener);
  set removeClosed(VoidCallback listener) => _closedListeners.remove(listener);
  clearClosed() => _closedListeners.clear();

  /// Listens for when video ad sends a reward.
  List<RewardListener> _rewardedListeners = [];
  set rewardedListener(RewardListener listener) =>
      _rewardedListeners.add(listener);
  set rewardedClosed(RewardListener listener) =>
      _rewardedListeners.remove(listener);
  clearRewarded() => _rewardedListeners.clear();

  /// Listens for when video ad starts playing.
  List<VoidCallback> _startedListeners = [];
  set startedListener(VoidCallback listener) => _startedListeners.add(listener);
  set removeStarted(VoidCallback listener) =>
      _startedListeners.remove(listener);
  clearStarted() => _startedListeners.clear();

  /// Listens for when video ad has finished playing.
  List<VoidCallback> _completedListeners = [];
  set completedListener(VoidCallback listener) =>
      _completedListeners.add(listener);
  set removeCompleted(VoidCallback listener) =>
      _completedListeners.remove(listener);
  clearCompleted() => _completedListeners.clear();

  /// The Video Ad Event Listener Function.
  void _eventListener(RewardedVideoAdEvent event,
      {String rewardType, int rewardAmount}) {
    var mobileEvent = _toMobileAdEvent(event);

    /// Don't continue if there is no corresponding event type.
    if (mobileEvent != null) {
      for (var listener in _adEventListeners) {
        listener(mobileEvent);
      }
    }

    for (var listener in _eventListeners) {
      listener(event, rewardType: rewardType, rewardAmount: rewardAmount);
    }

    switch (event) {
      case RewardedVideoAdEvent.loaded:
        for (var listener in _loadedListeners) {
          listener();
        }

        break;
      case RewardedVideoAdEvent.failedToLoad:
        for (var listener in _failedListeners) {
          listener();
        }

        break;
      case RewardedVideoAdEvent.opened:
        for (var listener in _openedListeners) {
          listener();
        }

        break;
      case RewardedVideoAdEvent.leftApplication:
        for (var listener in _leftListeners) {
          listener();
        }

        break;
      case RewardedVideoAdEvent.closed:
        for (var listener in _closedListeners) {
          listener();
        }

        break;
      case RewardedVideoAdEvent.rewarded:
        for (var listener in _rewardedListeners) {
          listener(rewardType, rewardAmount);
        }

        break;
      case RewardedVideoAdEvent.started:
        for (var listener in _startedListeners) {
          listener();
        }

        break;
      case RewardedVideoAdEvent.completed:
        for (var listener in _completedListeners) {
          listener();
        }

        break;
      default:
    }
  }

  /// Clear all possible types of Ad listeners on one call.
  clearAll() {
    clearLoaded();
    clearFailed();
    clearClicked();
    clearOpened();
    clearLeftApp();
    clearClosed();
    clearRewarded();
    clearStarted();
    clearCompleted();
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

class _VideoAd {
  _VideoAd({this.adUnitId, this.targetingInfo, this.ad});

  /// Identifies the source of ads for your application.
  final String adUnitId;

  /// Optional targeting info per the native AdMob API.
  final MobileAdTargetingInfo targetingInfo;

  RewardedVideoAd ad;

  RewardedVideoAdListener get listener => ad.listener;

  /// An internal id that identifies this mobile ad to the native AdMob plugin.
  int get id => hashCode;
}
