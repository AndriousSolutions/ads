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
  static void init(
    String appId, {
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
    assert(appId != null, 'Ads.init(): appId is required.');

    /// Redundancy with the assert, but kept if again made optional.
    _appId = appId == null ? FirebaseAdMob.testAppId : appId;

    if (bannerUnitId != null) {
      _bannerUnitId = bannerUnitId.trim();
    }
    if (screenUnitId != null) {
      _screenUnitId = screenUnitId.trim();
    }
    if (videoUnitId != null) {
      _videoUnitId = videoUnitId.trim();
    }

    /// Some keywords have to be provided if not passed in.
    _keywords =
        keywords == null || keywords.every((String s) => s == null || s.isEmpty)
            ? ['the']
            : keywords;
    _contentUrl = contentUrl;
    Ads.childDirected = childDirected;
    Ads.testDevices = testDevices;
    Ads.testing = testing;
    if (listener != null) _adEventListeners.add(listener);

    FirebaseAdMob.instance
        .initialize(appId: testing ? FirebaseAdMob.testAppId : Ads._appId);

    // Load the video ad now. It takes time.
    setVideoAd();
  }

  static String _appId;

  /// Get the app id.
  static String get appId => _appId;

  static String _bannerUnitId = '';

  /// Get the banner ad unit id.
  static String get bannerUnitId => _bannerUnitId;

  /// Set the banner ad unit id.
  static set bannerUnitId(String unitId) {
    if (unitId != null) _bannerUnitId = unitId.trim();
  }

  static String _screenUnitId = '';

  /// Get the interstitial ad unit id.
  static String get screenUnitId => _screenUnitId;

  /// Set the interstitial ad unit id.
  static set screenUnitId(String unitId) {
    if (unitId != null) _screenUnitId = unitId.trim();
  }

  static String _videoUnitId = '';

  /// Get the video ad unit id.
  static String get videoUnitId => _videoUnitId;

  /// Set the video ad unit id.
  static set videoUnitId(String unitId) {
    if (unitId != null) _videoUnitId = unitId.trim();
  }

  static List<String> _keywords;

  /// Get ad keywords
  static List<String> get keywords => _keywords;

  /// Set ad keywords
  static set keywords(List<String> keywords) {
    if (keywords != null) {
      if (keywords.every((String s) => s == null || s.isEmpty)) return;
      _keywords = keywords;
    }
  }

  static String _contentUrl;

  /// Get the url providing ad content
  static String get contentUrl => _contentUrl;

  /// Set the url providing ad content
  static set contentUrl(String contentUrl) {
    if (contentUrl == null || contentUrl.isEmpty) {
      _contentUrl = null;
    } else {
      _contentUrl = contentUrl;
    }
  }

  static bool childDirected;

  static List _testDevices = <String>[];

  /// Get list of test devices.
  static List<String> get testDevices => _testDevices;

  /// Set list of test devices.
  static set testDevices(List<String> devices) {
    if (devices == null) return;

    /// Take in only valid entries.
    for (var device in devices) {
      if (device != null && device.isNotEmpty) {
        _testDevices.add(device);
      }
    }
  }

  static bool testing;

  static BannerAd _bannerAd;

  /// Get Banner Ad object
  static BannerAd get bannerAd => _bannerAd;

  static InterstitialAd _fullScreenAd;

  /// Get Interstitial Ad object
  static InterstitialAd get fullScreenAd => _fullScreenAd;

  static RewardedVideoAd _rewardedVideoAd = RewardedVideoAd.instance;

  static _VideoAd _videoAd;

  /// Get Video Ad object
  static _VideoAd get videoAd => _videoAd;

  static bool _screenLoaded = false;
  static bool _showVideo = false;

  /// Close any Ads, clean up memory and clear resources.
  static void dispose() {
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
  static void showBannerAd(
      {String adUnitId,
      State state,
      double anchorOffset = 0.0,
      AnchorType anchorType = AnchorType.bottom}) {
    if (state != null && !state.mounted) return;
    if (_bannerAd == null) setBannerAd(adUnitId: adUnitId);
    _bannerAd
      ..load()
      ..show(anchorOffset: anchorOffset, anchorType: anchorType);
  }

  /// Set the Banner Ad options.
  static void setBannerAd({
    String adUnitId = '',
    AdSize size = AdSize.banner,
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    AdEventListener listener,
  }) {
    String unitId;

    if (adUnitId == null || adUnitId.isEmpty) {
      // Use the id passed to the init() function if any.
      unitId = _bannerUnitId;
    }else{
      unitId = adUnitId.trim();
    }

    var info = _targetInfo(
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
    );

    if (listener != null) banner._eventListeners.add(listener);

    // Clear memory of any previously set banner ad.
    hideBannerAd();

    _bannerAd = BannerAd(
      adUnitId: Ads.testing
          ? BannerAd.testAdUnitId
          : unitId.isEmpty ? BannerAd.testAdUnitId : unitId,
      size: size ?? AdSize.banner,
      targetingInfo: info,
      listener: banner._eventListener,
    );
  }

  /// Hide a Banner Ad.
  static void hideBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  /// Show a Full Screen Ad.
  ///
  /// parameters:
  /// state is passed to determine if the app is not terminating. No need to show ad.
  /// anchorOffset is the logical pixel offset from the edge of the screen (default 0.0)
  /// anchorType place advert at top or bottom of screen (default bottom)
  static void showFullScreenAd(
      {String adUnitId,
      State state,
      double anchorOffset = 0.0,
      AnchorType anchorType = AnchorType.bottom}) {
    if (state != null && !state.mounted) return;
    if (_fullScreenAd == null || !_screenLoaded)
      setFullScreenAd(adUnitId: adUnitId);
    _fullScreenAd.show(anchorOffset: anchorOffset, anchorType: anchorType);
    _screenLoaded = false;
  }

  /// Set the Full Screen Ad options.
  static void setFullScreenAd({
    String adUnitId = '',
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    AdEventListener listener,
  }) {
    String unitId;

    if (adUnitId == null || adUnitId.isEmpty) {
      unitId = _screenUnitId;
    }else{
      unitId = adUnitId.trim();
    }

    var info = _targetInfo(
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
    );

    if (listener != null) screen._eventListeners.add(listener);

    // Clear memory of any previously set interstitial ad.
    hideFullScreenAd();

    _fullScreenAd = InterstitialAd(
      adUnitId: Ads.testing
          ? InterstitialAd.testAdUnitId
          : unitId.isEmpty ? InterstitialAd.testAdUnitId : unitId,
      targetingInfo: info,
      listener: screen._eventListener,
    );

    _fullScreenAd.load();

    _screenLoaded = true;
  }

  /// Hide the Full Screen Ad.
  static void hideFullScreenAd() {
    _fullScreenAd?.dispose();
    _fullScreenAd = null;
  }

  /// Show a Video Ad.
  ///
  /// parameters:
  /// state is passed to determine if the app is not terminating. No need to show ad.
  static Future<void> showVideoAd({String adUnitId, State state}) async {
    if (state != null && !state.mounted) return;
    if (_showVideo) {
      _videoAd.ad.show();
      _showVideo = false;
    } else {
      /// calling with parameters will NOT show the video ad.
      setVideoAd(show: true, adUnitId: adUnitId);
    }
  }

  /// Set the Video Ad options.
  static Future<bool> setVideoAd({
    bool show = false,
    String adUnitId = '',
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
    VideoEventListener listener,
  }) async {
    String unitId;

    if (adUnitId == null || adUnitId.isEmpty) {
      unitId = _videoUnitId;
    }else{
      unitId = adUnitId.trim();
    }

    var info = _targetInfo(
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
    );

    if (listener != null) video._eventListeners.add(listener);

    // show set to true and these other parameters not passed.
    _showVideo = show &&
        keywords == null &&
        contentUrl == null &&
        childDirected == null &&
        testDevices == null &&
        listener == null;

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

    String adModId = Ads.testing
        ? RewardedVideoAd.testAdUnitId
        : unitId.isEmpty ? RewardedVideoAd.testAdUnitId : unitId;

    bool loaded =
        await _rewardedVideoAd.load(adUnitId: adModId, targetingInfo: info);

    _videoAd =
        _VideoAd(adUnitId: adModId, targetingInfo: info, ad: _rewardedVideoAd);
    return loaded;
  }

  /// Return the target audience information
  static MobileAdTargetingInfo _targetInfo({
    List<String> keywords,
    String contentUrl,
    bool childDirected,
    List<String> testDevices,
  }) {
    assert(Ads._appId != null,
        'Ads.init() must be called first in an initState() preferably!');

    // No parameters seek values from init()
    bool init = keywords == null &&
        contentUrl == null &&
        childDirected == null &&
        testDevices == null;

    if (init) {
      keywords ??= Ads.keywords;
      contentUrl ??= Ads.contentUrl;
      childDirected ??= Ads.childDirected;
      testDevices ??= Ads.testDevices;
    }

    return MobileAdTargetingInfo(
      keywords: keywords,
      contentUrl: contentUrl,
      childDirected: childDirected,
      testDevices: testDevices,
    );
  }

  /// Set an Ad Event Listener.
  static set eventListener(AdEventListener listener) =>
      _adEventListeners.add(listener);

  /// Remove a specific Add Event Listener.
  static set removeEvent(AdEventListener listener) =>
      _adEventListeners.remove(listener);

  /// Clear all Ad Event Listeners.
  static clearEventListeners() => _adEventListeners.clear();

  static final banner = _AdListener();

  /// Set a Banner Ad Event Listener.
  static set bannerListener(AdEventListener listener) =>
      banner._eventListeners.add(listener);

  /// Remove a specific Banner Ad Event Listener.
  static set removeBanner(AdEventListener listener) =>
      banner._eventListeners.remove(listener);

  /// Clear all Banner Ad Event Listeners.
  static clearBannerListeners() => banner._eventListeners.clear();

  static final screen = _AdListener();

  /// Set a Full Screen Ad Event Listener.
  static set screenListener(AdEventListener listener) =>
      screen._eventListeners.add(listener);

  /// Remove a Full Screen Ad Event Listener.
  static set removeScreen(AdEventListener listener) =>
      screen._eventListeners.remove(listener);

  /// Clear all Full Screen Ad Event Listeners.
  static clearScreenListeners() => screen._eventListeners.clear();

  static final video = _VidListener();

  /// Set a Video Ad Event Listener
  static set videoListener(VideoEventListener listener) =>
      video._eventListeners.add(listener);

  /// Remove a specific Video Ad Event Listener.
  static set removeVideo(VideoEventListener listener) =>
      video._eventListeners.remove(listener);

  /// Clear all Video Ad Event Listeners.
  static clearVideoListeners() => video._eventListeners.clear();
}

class _AdListener {
  List<AdEventListener> _eventListeners = [];

  List<VoidCallback> _loadedListeners = [];
  set loadedListener(VoidCallback listener) => _loadedListeners.add(listener);
  set removeLoaded(VoidCallback listener) => _loadedListeners.remove(listener);
  clearLoaded() => _loadedListeners.clear();

  List<VoidCallback> _failedListeners = [];
  set failedListener(VoidCallback listener) => _failedListeners.add(listener);
  set removeFailed(VoidCallback listener) => _failedListeners.remove(listener);
  clearFailed() => _failedListeners.clear();

  List<VoidCallback> _clickedListeners = [];
  set clickedListener(VoidCallback listener) => _clickedListeners.add(listener);
  set removeClicked(VoidCallback listener) =>
      _clickedListeners.remove(listener);
  clearClicked() => _clickedListeners.clear();

  List<VoidCallback> _impressionListeners = [];
  set impressionListener(VoidCallback listener) =>
      _impressionListeners.add(listener);
  set removeImpression(VoidCallback listener) =>
      _impressionListeners.remove(listener);
  clearImpression() => _impressionListeners.clear();

  List<VoidCallback> _openedListeners = [];
  set openedListener(VoidCallback listener) => _openedListeners.add(listener);
  set removeOpened(VoidCallback listener) => _openedListeners.remove(listener);
  clearOpened() => _openedListeners.clear();

  List<VoidCallback> _leftListeners = [];
  set leftAppListener(VoidCallback listener) => _leftListeners.add(listener);
  set removeLeftApp(VoidCallback listener) => _leftListeners.remove(listener);
  clearLeftApp() => _leftListeners.clear();

  List<VoidCallback> _closedListeners = [];
  set closedListener(VoidCallback listener) => _closedListeners.add(listener);
  set removeClosed(VoidCallback listener) => _closedListeners.remove(listener);
  clearClosed() => _closedListeners.clear();

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

  List<VoidCallback> _loadedListeners = [];
  set loadedListener(VoidCallback listener) => _loadedListeners.add(listener);
  set removeLoaded(VoidCallback listener) => _loadedListeners.remove(listener);
  clearLoaded() => _loadedListeners.clear();

  List<VoidCallback> _failedListeners = [];
  set failedListener(VoidCallback listener) => _failedListeners.add(listener);
  set removeFailed(VoidCallback listener) => _failedListeners.remove(listener);
  clearFailed() => _failedListeners.clear();

  List<VoidCallback> _clickedListeners = [];
  set clickedListener(VoidCallback listener) => _clickedListeners.add(listener);
  set removeClicked(VoidCallback listener) =>
      _clickedListeners.remove(listener);
  clearClicked() => _clickedListeners.clear();

  List<VoidCallback> _openedListeners = [];
  set openedListener(VoidCallback listener) => _openedListeners.add(listener);
  set removeOpened(VoidCallback listener) => _openedListeners.remove(listener);
  clearOpened() => _openedListeners.clear();

  List<VoidCallback> _leftListeners = [];
  set leftAppListener(VoidCallback listener) => _leftListeners.add(listener);
  set removeLeftApp(VoidCallback listener) => _leftListeners.remove(listener);
  clearLeftApp() => _leftListeners.clear();

  List<VoidCallback> _closedListeners = [];
  set closedListener(VoidCallback listener) => _closedListeners.add(listener);
  set removeClosed(VoidCallback listener) => _closedListeners.remove(listener);
  clearClosed() => _closedListeners.clear();

  List<RewardListener> _rewardedListeners = [];
  set rewardedListener(RewardListener listener) =>
      _rewardedListeners.add(listener);
  set rewardedClosed(RewardListener listener) =>
      _rewardedListeners.remove(listener);
  clearRewarded() => _rewardedListeners.clear();

  List<VoidCallback> _startedListeners = [];
  set startedListener(VoidCallback listener) => _startedListeners.add(listener);
  set removeStarted(VoidCallback listener) =>
      _startedListeners.remove(listener);
  clearStarted() => _startedListeners.clear();

  List<VoidCallback> _completedListeners = [];
  set completedListener(VoidCallback listener) =>
      _completedListeners.add(listener);
  set removeCompleted(VoidCallback listener) =>
      _completedListeners.remove(listener);
  clearCompleted() => _completedListeners.clear();

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
