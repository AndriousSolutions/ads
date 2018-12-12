library ads;
///
///
///
///    Classes to use the firebase_admob plugin.
///
/// Free to redistribute and/or modify.
/// http://www.apache.org/licenses/LICENSE-2.0
///                                     Andrious Solutions Ltd. 2018-05-27
///

import 'package:flutter/widgets.dart' show State;

import 'package:firebase_admob/firebase_admob.dart';

import 'package:flutter/foundation.dart' show VoidCallback;

typedef void AdEventListener(MobileAdEvent event);

typedef void VideoEventListener(RewardedVideoAdEvent event, {String rewardType, int rewardAmount});

typedef void RewardListener(String rewardType, int rewardAmount);


List<AdEventListener> _adEventListeners = [];


class Ads {

  static void init(
    String appId,
    {List<String> keywords,
    String contentUrl,
    DateTime birthday,
    MobileAdGender gender = MobileAdGender.unknown,
    bool designedForFamilies = true,
    bool childDirected = false,
    List<String> testDevices,
    bool testing = false,
    AdEventListener listener,
  }){
    assert(appId != null, 'Ads.init(): appId is required.');
    /// Redundancy with the assert, but kept if again made optional.
    _appId = appId == null ? FirebaseAdMob.testAppId : appId;
    /// Some keywords have to be provided if not passed int.
    _keywords = keywords == null ? ['foo', 'bar'] : keywords;
    _contentUrl = contentUrl;
    Ads.birthday = birthday;
    Ads.gender = gender;
    Ads.designedForFamilies = designedForFamilies;
    Ads.childDirected = childDirected;
    Ads.testDevices = testDevices;
    Ads.testing = testing;
    if(listener != null) _adEventListeners.add(listener);

    FirebaseAdMob.instance.initialize(appId: testing ? FirebaseAdMob.testAppId : Ads._appId);

    // Load the video ad now. It takes time.
    setVideoAd();
  }

  static String _appId;
  static get appId => _appId;

  static List<String> _keywords;
  static get keywords => _keywords;
  static set keywords(List<String> keywords){
    _keywords = keywords == null ? <String>['foo', 'bar'] : keywords;
  }

  static String _contentUrl;
  static get contentUrl => _contentUrl;
  static set contentUrl(String contentUrl){
    if (contentUrl == null || contentUrl.isEmpty){
       _contentUrl = null;
    }else {
       _contentUrl = contentUrl;
    }
  }

  static DateTime birthday;

  @Deprecated('This functionality is deprecated in AdMob without replacement.')
  static MobileAdGender gender;

  static bool designedForFamilies;

  static bool childDirected;

  static List _testDevices = <String>[];
  static get testDevices => _testDevices;
  static set testDevices(List<String> devices){
    if(devices == null) return;
    /// Take in only valid entries.
    for(var device in devices){
      if(device != null && device.isNotEmpty){
        _testDevices.add(device);
      }
    }
  }

  static bool testing;

  static BannerAd _bannerAd;
  static InterstitialAd _fullScreenAd;
  static RewardedVideoAd _videoAd = RewardedVideoAd.instance;

  static bool _screenLoaded = false;

  static void dispose(){
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

  static void showBannerAd([State state]){
    if(state != null && !state.mounted) return;
    if(_bannerAd==null)setBannerAd();
    _bannerAd
        ..load()
        ..show();
  }

  static void hideBannerAd(){
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  static void setBannerAd({
    AdSize size = AdSize.banner,
    List<String> keywords,
    String contentUrl,
    DateTime birthday,
    MobileAdGender gender,
    bool designedForFamilies,
    bool childDirected,
    List<String> testDevices,
    AdEventListener listener,
     }) {

    var info = _targetInfo(
      keywords: keywords,
      contentUrl: contentUrl,
      birthday: birthday,
      gender: gender,
      designedForFamilies: designedForFamilies,
      childDirected: childDirected,
      testDevices: testDevices,
    );

    if(listener != null) banner._eventListeners.add(listener);

    _bannerAd = BannerAd(
      adUnitId:  Ads.testing ? BannerAd.testAdUnitId : Ads._appId,
      size: size,
      targetingInfo: info,
      listener: banner._eventListener,
    );
  }


  static void showFullScreenAd([State state]){
    if(state != null && !state.mounted)return;
    if(_fullScreenAd==null||!_screenLoaded)setFullScreenAd();
    _fullScreenAd.show();
    _screenLoaded = false;
  }

  static void hideFullScreenAd(){
    _fullScreenAd?.dispose();
    _fullScreenAd = null;
  }

  static void setFullScreenAd({
    List<String> keywords,
    String contentUrl,
    DateTime birthday,
    MobileAdGender gender,
    bool designedForFamilies,
    bool childDirected,
    List<String> testDevices,
    AdEventListener listener,
  }) {

    var info = _targetInfo(
      keywords: keywords,
      contentUrl: contentUrl,
      birthday: birthday,
      gender: gender,
      designedForFamilies: designedForFamilies,
      childDirected: childDirected,
      testDevices: testDevices,
    );

    if(listener != null) screen._eventListeners.add(listener);

    _fullScreenAd = InterstitialAd(
      adUnitId:  Ads.testing ? InterstitialAd.testAdUnitId : Ads._appId,
      targetingInfo: info,
      listener: screen._eventListener,
    );

    _fullScreenAd.load();

    _screenLoaded = true;
  }

  static void showVideoAd([State state])async{
    if(state != null && !state.mounted) return;
    _videoAd.show();
    // Load it now for the next possible showing.
    setVideoAd();
  }

  static Future<bool> setVideoAd({
    List<String> keywords,
    String contentUrl,
    DateTime birthday,
    MobileAdGender gender,
    bool designedForFamilies,
    bool childDirected,
    List<String> testDevices,
    VideoEventListener listener,
  }) async {
    var info = _targetInfo(
      keywords: keywords,
      contentUrl: contentUrl,
      birthday: birthday,
      gender: gender,
      designedForFamilies: designedForFamilies,
      childDirected: childDirected,
      testDevices: testDevices,
    );

    if(listener != null) video._eventListeners.add(listener);

    _videoAd.listener = (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      video._eventListener(event, rewardType: rewardType, rewardAmount: rewardAmount);
    };
    bool loaded = await _videoAd.load(adUnitId: Ads.testing ? RewardedVideoAd.testAdUnitId : Ads._appId, targetingInfo: info);
    return loaded;
  }

  static MobileAdTargetingInfo _targetInfo({
      List<String> keywords,
      String contentUrl,
      DateTime birthday,
      MobileAdGender gender,
      bool designedForFamilies,
      bool childDirected,
      List<String> testDevices,
    }) {

      assert(Ads._appId != null,'Ads.init() must be called first in an initState() preferably!');

      keywords ??= Ads._keywords;
      contentUrl ??= Ads._contentUrl;
      birthday ??= Ads.birthday;
      gender ??= Ads.gender;
      designedForFamilies ??= Ads.designedForFamilies;
      childDirected ??= Ads.childDirected;
      testDevices ??= Ads._testDevices;

      return MobileAdTargetingInfo(
        keywords: keywords,
        contentUrl: contentUrl,
        birthday: birthday,
        gender: gender,
        designedForFamilies: designedForFamilies,
        childDirected: childDirected,
        testDevices: testDevices,
      );
  }

  static set eventListener(AdEventListener listener) => _adEventListeners.add(listener);
  static set removeEvent(AdEventListener listener) => _adEventListeners.remove(listener);
  static clearEventListeners() => _adEventListeners.clear();

  static final banner = _AdListener();

  static set bannerListener(AdEventListener listener) => banner._eventListeners.add(listener);
  static set removeBanner(AdEventListener listener) => banner._eventListeners.remove(listener);
  static clearBannerListeners() => banner._eventListeners.clear();

  static final screen = _AdListener();

  static set screenListener(AdEventListener listener) => screen._eventListeners.add(listener);
  static set removeScreen(AdEventListener listener) => screen._eventListeners.remove(listener);
  static clearScreenListeners() => screen._eventListeners.clear();

  static final video = _VidListener();

  static set videoListener(VideoEventListener listener) => video._eventListeners.add(listener);
  static set removeVideo(VideoEventListener listener) => video._eventListeners.remove(listener);
  static clearVideoListeners() => video._eventListeners.clear();
}


class _AdListener{

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
  set removeClicked(VoidCallback listener) => _clickedListeners.remove(listener);
  clearClicked() => _clickedListeners.clear();

  List<VoidCallback> _impressionListeners = [];
  set impressionListener(VoidCallback listener) => _impressionListeners.add(listener);
  set removeImpression(VoidCallback listener) => _impressionListeners.remove(listener);
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

  void _eventListener(MobileAdEvent event){

    for (var listener in _adEventListeners){

      listener(event);
    }

    for (var listener in _eventListeners){

      listener(event);
    }

    switch (event) {
      case MobileAdEvent.loaded:

        for (var listener in _loadedListeners){

          listener();
        }

        break;
      case MobileAdEvent.failedToLoad:

        for (var listener in _failedListeners){

          listener();
        }

        break;
      case MobileAdEvent.clicked:

        for (var listener in _clickedListeners){

          listener();
        }

        break;
      case MobileAdEvent.impression:

        for (var listener in _impressionListeners){

          listener();
        }

        break;
      case MobileAdEvent.opened:

        for (var listener in _openedListeners){

          listener();
        }

        break;
      case MobileAdEvent.leftApplication:

        for (var listener in _leftListeners){

          listener();
        }

        break;
      case MobileAdEvent.closed:

        for (var listener in _closedListeners){

          listener();
        }

        break;
      default:
    }
  }

  clearAll(){
    clearLoaded();
    clearFailed();
    clearClicked();
    clearOpened();
    clearLeftApp();
    clearClosed();
  }
}



class _VidListener{

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
  set removeClicked(VoidCallback listener) => _clickedListeners.remove(listener);
  clearClicked() => _clickedListeners.clear();

  List<VoidCallback> _openedListeners = [];
  set openedListener(VoidCallback listener) => _openedListeners.add(listener);
  set removeOpened(VoidCallback listener) =>_openedListeners.remove(listener);
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
  set rewardedListener(RewardListener listener) => _rewardedListeners.add(listener);
  set rewardedClosed(RewardListener listener) => _rewardedListeners.remove(listener);
  clearRewarded() => _rewardedListeners.clear();

  List<VoidCallback> _startedListeners = [];
  set startedListener(VoidCallback listener) => _startedListeners.add(listener);
  set removeStarted(VoidCallback listener) => _startedListeners.remove(listener);
  clearStarted() => _startedListeners.clear();

  List<VoidCallback> _completedListeners = [];
  set completedListener(VoidCallback listener) => _completedListeners.add(listener);
  set removeCompleted(VoidCallback listener) => _completedListeners.remove(listener);
  clearCompleted() => _completedListeners.clear();

  void _eventListener(RewardedVideoAdEvent event, {String rewardType, int rewardAmount}){

    var mobileEvent = _toMobileAdEvent(event);

    /// Don't continue if there is no corresponding event type.
    if(mobileEvent != null) {
      for (var listener in _adEventListeners) {

        listener(mobileEvent);
      }
    }

    for (var listener in _eventListeners){

      listener(event, rewardType: rewardType, rewardAmount: rewardAmount);
    }

    switch (event) {
      case RewardedVideoAdEvent.loaded:

        for (var listener in _loadedListeners){

          listener();
        }

        break;
      case RewardedVideoAdEvent.failedToLoad:

        for (var listener in _failedListeners){

          listener();
        }

        break;
      case RewardedVideoAdEvent.opened:

        for (var listener in _openedListeners){

          listener();
        }

        break;
      case RewardedVideoAdEvent.leftApplication:

        for (var listener in _leftListeners){

          listener();
        }

        break;
      case RewardedVideoAdEvent.closed:

        for (var listener in _closedListeners){

          listener();
        }

        break;
      case RewardedVideoAdEvent.rewarded:

        for (var listener in _rewardedListeners){

          listener(rewardType, rewardAmount);
        }

        break;
      case RewardedVideoAdEvent.started:

        for (var listener in _startedListeners){

          listener();
        }

        break;
      case RewardedVideoAdEvent.completed:

        for (var listener in _completedListeners){

          listener();
        }

        break;
      default:
    }
  }

  clearAll(){
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

  MobileAdEvent _toMobileAdEvent(RewardedVideoAdEvent event){

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