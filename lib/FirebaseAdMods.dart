library ads;

///
/// Copyright (C) 2020 Andrious Solutions
///
/// Licensed under the Apache License, Version 2.0 (the "License");
/// you may not use this file except in compliance with the License.
/// You may obtain a copy of the License at
///
///    http://www.apache.org/licenses/LICENSE-2.0
///
/// Unless required by applicable law or agreed to in writing, software
/// distributed under the License is distributed on an "AS IS" BASIS,
/// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
/// See the License for the specific language governing permissions and
/// limitations under the License.
///
///          Created  26 Sep 2020
///
///

/// Export the firebase_admob plugin for the developer to use.
export 'package:firebase_admob/firebase_admob.dart';

/// Export the 'old' Ads package.
export 'package:ads/ads.dart' hide EventError;

import 'package:firebase_admob/firebase_admob.dart'
    show
        AnchorType,
        BannerAd,
        FirebaseAdMob,
        InterstitialAd,
        MobileAd,
        MobileAdEvent,
        MobileAdListener,
        MobileAdTargetingInfo,
        NativeAd,
        RewardedVideoAd,
        RewardedVideoAdEvent,
        RewardedVideoAdListener;

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show VoidCallback;

typedef void RewardListener(String rewardType, int rewardAmount);

/// Signature for a [AdError] status change callback.
typedef void AdErrorListener(Exception ex);

class FirebaseAdMods
    with ListenerAdsEvent, ListenerMobileAdEvent, ListenerRewardedVideoAdEvent {
  //
  FirebaseAdMods({
    String appId,
    String trackingId,
    bool analyticsEnabled = false,
  }) {
    /// Test for parameters being pass null in production
    _appId =
        appId == null || appId.isEmpty ? FirebaseAdMob.testAppId : appId.trim();

    if (!_initialized) {
      //
      _initialized = true;

      FirebaseAdMob.instance
          .initialize(
              appId: _appId,
              trackingId: trackingId,
              analyticsEnabled: analyticsEnabled)
          .then((init) {
        _initialized = init;
      });
    }

    _analyticsEnabled = analyticsEnabled;

    _anchorOffset = anchorOffset;
    _horizontalCenterOffset = horizontalCenterOffset;
    _anchorType =
        anchorType ?? Platform.isAndroid ? AnchorType.bottom : AnchorType.top;

    add(listener);

    _listener = (MobileAdEvent event) {
      //
      _adEventHandler(event);

      // Dispose and load the ad again.
      if (event == MobileAdEvent.closed) {
        // dispose().then((_) {
        //   //         _ad?.load();
        // });
      }
    };
  }

  String _appId;
  bool _analyticsEnabled;
  double _anchorOffset;
  double _horizontalCenterOffset;
  AnchorType _anchorType;

  MobileAdListener _listener;

  /// You can only initialize the Firebase_AdMob plugin once!
  static bool _initialized = false;

  bool get initialized => _initialized;

  bool get analyticsEnabled => _analyticsEnabled;

  bool get testing => _appId == FirebaseAdMob.testAppId;

  double get anchorOffset => _anchorOffset;

  double get horizontalCenterOffset => _horizontalCenterOffset;

  AnchorType get anchorType => _anchorType;

  String get bannerTestAdUnitId => BannerAd.testAdUnitId;

  String get fullScreenTestAdUnitId => InterstitialAd.testAdUnitId;

  String get interstitialTestAdUnitId => fullScreenTestAdUnitId;

  String get nativeAdTestAdUnitId => NativeAd.testAdUnitId;

  String get videoAdTestAdUnitId => RewardedVideoAd.testAdUnitId;

//  RewardedVideoAd videoListener(RewardedVideoAd ad) => super.addAd(ad, this);

  MobileAdListener adListener(MobileAdListener listener) {
    add(listener);
    return this.listener;
  }

  bool add(MobileAdListener listener) {
    bool add = listener != null;
    if (add) {
      add = eventListeners.add(listener);
    }
    return add;
  }

  Set<MobileAd> adMobSet = Set();

  AdMob mobileAd(MobileAd ad) {
    adMobSet.add(ad);
    return AdMob(ad, this);
  }

  VideoAdMob videoAb(RewardedVideoAd ad) {
    VideoAdMob(ad, this);
  }

  void dispose() {
    var it = adMobSet.iterator;
    while (it.moveNext()) {
      MobileAd ad = it.current;
      ad.dispose();
    }
  }
}

mixin ListenerAdsEvent {
  MobileAdListener listener;

  final Set<MobileAdListener> _adEventListeners = Set();

  Exception _ex;
  final Set<AdErrorListener> _adErrorListeners = Set();

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
  bool removeError(AdErrorListener listener) =>
      _adErrorListeners.remove(listener);

  /// Empty any error handlers from memory.
  void clearErrorListeners() => _adErrorListeners.clear();
}

List<EventError> _eventErrors = List();

// class AdListener with MobileAdEventListener {
//   AdListener([Set<MobileAdListener> listeners]) {
//     adEventListeners.addAll(listeners);
//   }
// }

/// Stipulate event handling in the MobileAd objects.
mixin ListenerMobileAdEvent {
  final Set<MobileAdListener> adEventListeners = Set();

  final Set<MobileAdListener> eventListeners = Set();

  /// Set an Ad Event Listener.
  set eventListener(MobileAdListener listener) =>
      adEventListeners.add(listener);

  /// Remove a specific Add Event Listener.
  bool removeEvent(MobileAdListener listener) =>
      adEventListeners.remove(listener);

  /// Listens for when the Ad is loaded in memory.
  final Set<VoidCallback> _loadedListeners = Set();
  set loadedListener(VoidCallback listener) => _loadedListeners.add(listener);
  bool removeLoaded(VoidCallback listener) => _loadedListeners.remove(listener);
  _clearLoaded() => _loadedListeners.clear();

  /// Listens for when the Ad fails to display.
  final Set<VoidCallback> _failedListeners = Set();
  set failedListener(VoidCallback listener) => _failedListeners.add(listener);
  bool removeFailed(VoidCallback listener) => _failedListeners.remove(listener);
  _clearFailed() => _failedListeners.clear();

  /// Listens for when the Ad is clicked on.
  final Set<VoidCallback> _clickedListeners = Set();
  set clickedListener(VoidCallback listener) => _clickedListeners.add(listener);
  bool removeClicked(VoidCallback listener) =>
      _clickedListeners.remove(listener);
  _clearClicked() => _clickedListeners.clear();

  /// Listens for when the user clicks further on the Ad.
  final Set<VoidCallback> _impressionListeners = Set();
  set impressionListener(VoidCallback listener) =>
      _impressionListeners.add(listener);
  bool removeImpression(VoidCallback listener) =>
      _impressionListeners.remove(listener);
  _clearImpression() => _impressionListeners.clear();

  /// Listens for when the Ad is opened.
  final Set<VoidCallback> _openedListeners = Set();
  set openedListener(VoidCallback listener) => _openedListeners.add(listener);
  bool removeOpened(VoidCallback listener) => _openedListeners.remove(listener);
  _clearOpened() => _openedListeners.clear();

  /// Listens for when the user has left the Ad.
  final Set<VoidCallback> _leftListeners = Set();
  set leftAppListener(VoidCallback listener) => _leftListeners.add(listener);
  bool removeLeftApp(VoidCallback listener) => _leftListeners.remove(listener);
  _clearLeftApp() => _leftListeners.clear();

  /// Listens for when the Ad is closed.
  final Set<VoidCallback> _closedListeners = Set();
  set closedListener(VoidCallback listener) => _closedListeners.add(listener);
  bool removeClosed(VoidCallback listener) => _closedListeners.remove(listener);
  _clearClosed() => _closedListeners.clear();

  /// The Ad's Event Listener Function.
  void _adEventHandler(MobileAdEvent event) {
    for (var listener in adEventListeners) {
      try {
        listener(event);
      } catch (ex) {
        _eventError(ex, event: event);
      }
    }

    for (var listener in eventListeners) {
      try {
        listener(event);
      } catch (ex) {
        _eventError(ex, event: event);
      }
    }

    switch (event) {
      case MobileAdEvent.loaded:
        for (var listener in _loadedListeners) {
          try {
            listener();
          } catch (ex) {
            _eventError(ex, event: MobileAdEvent.loaded);
          }
        }

        break;
      case MobileAdEvent.failedToLoad:
        for (var listener in _failedListeners) {
          try {
            listener();
          } catch (ex) {
            _eventError(ex, event: MobileAdEvent.failedToLoad);
          }
        }

        break;
      case MobileAdEvent.clicked:
        for (var listener in _clickedListeners) {
          try {
            listener();
          } catch (ex) {
            _eventError(ex, event: MobileAdEvent.clicked);
          }
        }

        break;
      case MobileAdEvent.impression:
        for (var listener in _impressionListeners) {
          try {
            listener();
          } catch (ex) {
            _eventError(ex, event: MobileAdEvent.impression);
          }
        }

        break;
      case MobileAdEvent.opened:
        for (var listener in _openedListeners) {
          try {
            listener();
          } catch (ex) {
            _eventError(ex, event: MobileAdEvent.opened);
          }
        }

        break;
      case MobileAdEvent.leftApplication:
        for (var listener in _leftListeners) {
          try {
            listener();
          } catch (ex) {
            _eventError(ex, event: MobileAdEvent.leftApplication);
          }
        }

        break;
      case MobileAdEvent.closed:
        for (var listener in _closedListeners) {
          try {
            listener();
          } catch (ex) {
            _eventError(ex, event: MobileAdEvent.closed);
          }
        }

        break;
      default:
    }

    // Notify the developer of any errors.
    assert(_eventErrors.isEmpty, "Ads: Errors in Ad Events! Refer to logcat.");
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

mixin ListenerRewardedVideoAdEvent {
  final Set<MobileAdListener> adEventListeners = Set();

  final Set<RewardedVideoAdListener> _videoListeners = Set();

  /// Set a Video Ad Event Listener
  set videoListener(RewardedVideoAdListener listener) {
    if (listener == null) return;
    _videoListeners.add(listener);
  }

  /// Remove a specific Video Ad Event Listener.
  bool removeVideo(RewardedVideoAdListener listener) =>
      _videoListeners.remove(listener);

  /// Listens for when video ad is loaded.
  final Set<VoidCallback> _loadedListeners = Set();
  set loadedListener(VoidCallback listener) => _loadedListeners.add(listener);
  bool removeLoaded(VoidCallback listener) => _loadedListeners.remove(listener);
  _clearLoaded() => _loadedListeners.clear();

  /// Listens for when video ad fails.
  final Set<VoidCallback> _failedListeners = Set();
  set failedListener(VoidCallback listener) => _failedListeners.add(listener);
  bool removeFailed(VoidCallback listener) => _failedListeners.remove(listener);
  _clearFailed() => _failedListeners.clear();

  /// Listens for when video ad is clicked on.
  final Set<VoidCallback> _clickedListeners = Set();
  set clickedListener(VoidCallback listener) => _clickedListeners.add(listener);
  bool removeClicked(VoidCallback listener) =>
      _clickedListeners.remove(listener);
  _clearClicked() => _clickedListeners.clear();

  /// Listens for when video ad opens up.
  final Set<VoidCallback> _openedListeners = Set();
  set openedListener(VoidCallback listener) => _openedListeners.add(listener);
  bool removeOpened(VoidCallback listener) => _openedListeners.remove(listener);
  _clearOpened() => _openedListeners.clear();

  /// Listens for when user leaves the video ad.
  final Set<VoidCallback> _leftListeners = Set();
  set leftAppListener(VoidCallback listener) => _leftListeners.add(listener);
  bool removeLeftApp(VoidCallback listener) => _leftListeners.remove(listener);
  _clearLeftApp() => _leftListeners.clear();

  /// Listens for when video ad is closed.
  final Set<VoidCallback> _closedListeners = Set();
  set closedListener(VoidCallback listener) => _closedListeners.add(listener);
  bool removeClosed(VoidCallback listener) => _closedListeners.remove(listener);
  _clearClosed() => _closedListeners.clear();

  /// Listens for when video ad sends a reward.
  final Set<RewardListener> _rewardedListeners = Set();
  set rewardedListener(RewardListener listener) {
    if (listener == null) return;
    _rewardedListeners.add(listener);
  }

  bool removeRewarded(RewardListener listener) =>
      _rewardedListeners.remove(listener);
  _clearRewarded() => _rewardedListeners.clear();

  /// Listens for when video ad starts playing.
  final Set<VoidCallback> _startedListeners = Set();
  set startedListener(VoidCallback listener) => _startedListeners.add(listener);
  bool removeStarted(VoidCallback listener) =>
      _startedListeners.remove(listener);
  _clearStarted() => _startedListeners.clear();

  /// Listens for when video ad has finished playing.
  final Set<VoidCallback> _completedListeners = Set();
  set completedListener(VoidCallback listener) =>
      _completedListeners.add(listener);
  bool removeCompleted(VoidCallback listener) =>
      _completedListeners.remove(listener);
  _clearCompleted() => _completedListeners.clear();

  /// The Video Ad Event Listener Function.
  void _videoEventHandler(RewardedVideoAdEvent event,
      {String rewardType, int rewardAmount}) {
    MobileAdEvent mobileEvent = _toMobileAdEvent(event);

    /// Don't continue if there is no corresponding event type.
    if (mobileEvent != null) {
      for (var listener in adEventListeners) {
        try {
          listener(mobileEvent);
        } catch (ex) {
          _eventError(ex, event: mobileEvent);
        }
      }
    }

    for (var listener in _videoListeners) {
      try {
        listener(event, rewardType: rewardType, rewardAmount: rewardAmount);
      } catch (ex) {
        _eventError(ex, event: mobileEvent);
      }
    }

    switch (event) {
      case RewardedVideoAdEvent.loaded:
        for (var listener in _loadedListeners) {
          try {
            listener();
          } catch (ex) {
            _eventError(ex, event: mobileEvent);
          }
        }

        break;
      case RewardedVideoAdEvent.failedToLoad:
        for (var listener in _failedListeners) {
          try {
            listener();
          } catch (ex) {
            _eventError(ex, event: mobileEvent);
          }
        }

        break;
      case RewardedVideoAdEvent.opened:
        for (var listener in _openedListeners) {
          try {
            listener();
          } catch (ex) {
            _eventError(ex, event: mobileEvent);
          }
        }

        break;
      case RewardedVideoAdEvent.leftApplication:
        for (var listener in _leftListeners) {
          try {
            listener();
          } catch (ex) {
            _eventError(ex, event: mobileEvent);
          }
        }

        break;
      case RewardedVideoAdEvent.closed:
        for (var listener in _closedListeners) {
          try {
            listener();
          } catch (ex) {
            _eventError(ex, event: mobileEvent);
          }
        }

        break;
      case RewardedVideoAdEvent.rewarded:
        for (var listener in _rewardedListeners) {
          try {
            listener(rewardType, rewardAmount);
          } catch (ex) {
            _eventError(ex, event: mobileEvent);
          }
        }

        break;
      case RewardedVideoAdEvent.started:
        for (var listener in _startedListeners) {
          try {
            listener();
          } catch (ex) {
            _eventError(ex, event: mobileEvent);
          }
        }

        break;
      case RewardedVideoAdEvent.completed:
        for (var listener in _completedListeners) {
          try {
            listener();
          } catch (ex) {
            _eventError(ex, event: mobileEvent);
          }
        }

        break;
      default:
        print(event);
    }

    // Notify the developer of any errors.
    assert(_eventErrors.isEmpty, "Ads: Errors in Ad Events! Refer to logcat.");
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

class EventError {
  EventError(this.event, this.ex);
  MobileAdEvent event;
  Exception ex;
}

/// Error Handler for the event listeners.
void _eventError(Object ex, {MobileAdEvent event}) {
  //
  if (ex is! Exception) {
    ex = Exception(ex.toString());
  }
  _eventErrors?.add(EventError(event, ex));
  print("Ads: $event - ${ex.toString()}");
  // Loop through any error listeners.
  _adErrorListener(ex);
}

Set<AdErrorListener> _eventErrorListeners = Set();

/// The Ad's Error Listener Function.
void _adErrorListener(Exception ex) {
  //
  if (ex == null) {
    return;
  }
  for (AdErrorListener listener in _eventErrorListeners) {
    try {
      listener(ex);
    } catch (e) {
      print("Ads: ${e.toString()}");
    }
  }
}

class AdMob {
  //
  AdMob(this._ad, [this._parent]) : assert(_ad != null) {
    //
    if (_ad != null && _parent != null) {
      _parent.add(_ad.listener);
      _listener = _ad.listener;
    }
  }

  MobileAd _ad;

  /// The firebase Admob has been disposed.
  bool get disposed => _ad == null;

  final FirebaseAdMods _parent;

  bool _shown = false;

  String get adUnitId => _ad?.adUnitId;

  MobileAdTargetingInfo get targetingInfo => _ad?.targetingInfo;

  int get id => _ad?.hashCode;

  MobileAdListener _listener;

  MobileAdListener get listener => _listener;

  set listener(MobileAdListener listener) {
    //
    if (listener != null && _parent != null) {
      _parent.add(listener);
      _parent.removeEvent(_listener);
      _listener = listener;
    }
  }

  // Load the ad in memory.
  Future<bool> load() async {
    //
    bool loaded = _ad != null;

    if (loaded) {
      try {
        loaded = await _ad?.load();
      } catch (ex) {
        loaded = false;
        _parent?._setError(ex);
      }
    }
    return loaded;
  }

  Future<bool> show(
      {double anchorOffset,
      double horizontalCenterOffset,
      AnchorType anchorType}) async {
    //
    if (_shown) {
      return _shown;
    }

    _shown = _ad != null;

    if (_shown) {
      _shown = await isLoaded();
    }

    if (!_shown) {
      _shown = await load();
    }

    if (_shown) {
      //
      try {
        _shown = await _ad.show(
            anchorOffset: anchorOffset ?? _parent?.anchorOffset ?? 0.0,
            horizontalCenterOffset: horizontalCenterOffset ??
                _parent?.horizontalCenterOffset ??
                0.0,
            anchorType: anchorType ?? _parent?.anchorType ?? AnchorType.bottom);
      } catch (ex) {
        _shown = false;
      }
    }
    // return load();
    return _shown;
  }

  Future<bool> isLoaded() async {
    //
    bool loaded = _ad != null;

    if (loaded) {
      try {
        loaded = await _ad?.isLoaded();
      } catch (ex) {
        loaded = false;
      }
    }
    return loaded;
  }

  Future<bool> dispose() async {
    //
    bool dispose = _ad == null;

    if (!dispose) {
      dispose = _shown;
    }

    if (dispose) {
      try {
        dispose = await _ad?.dispose();
        _ad = null;
      } catch (ex) {
        dispose = false;
        _parent?._setError(ex);
      }
    }
    // retest the flag.
    _shown = !dispose;

    return dispose;
  }
}

class VideoAdMob {
  //
  VideoAdMob(this.video, [this._parent]) : assert(video != null) {
    //
    // if (video != null && _parent != null) {
    //   _parent.videoListener(video.listener);
    //   _listener = video.listener;
    //   video.listener = _parent.listener;
    // }
  }
  final RewardedVideoAd video;

  final FirebaseAdMods _parent;

  String get testAdUnitId => RewardedVideoAd.testAdUnitId;

  RewardedVideoAd get instance => RewardedVideoAd.instance;

  RewardedVideoAdListener listener;

  /// The user id used in server-to-server reward callbacks
  String get userId => video?.userId;

  /// The custom data included in server-to-server reward callbacks
  String get customData => video?.customData;

  /// Sets the user id to be used in server-to-server reward callbacks.
  set userId(String userId) => video?.userId = userId;

  /// Sets custom data to be included in server-to-server reward callbacks.
  set customData(String customData) => video?.customData = customData;

  /// Shows a rewarded video ad if one has been loaded.
  Future<bool> show() async {
    bool show = false;

    // Show if already loaded.
    if (video != null) {
      try {
        show = await video.show();
        if (show) return show;
      } catch (ex) {
        /// try loading it again.
//        video = null;
      }
    }
    return show;
  }

  /// Loads a rewarded video ad using the provided ad unit ID.
  Future<bool> load(
    String adUnitId,
    MobileAdTargetingInfo targetingInfo,
  ) async {
    //
    bool load = false;

    if (video != null) {
      //
      try {
        load = await video?.load(
          adUnitId: adUnitId,
          targetingInfo: targetingInfo,
        );
      } catch (ex) {
        load = false;
      }
    }
    return load;
  }
}
