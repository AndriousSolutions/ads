// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:firebase_admob/firebase_admob.dart';

import 'package:ads/ads.dart';

void main() {
  runApp(MyApp(initOption: 1));
}

class MyApp extends StatefulWidget {
  const MyApp({this.initOption, Key key}) : super(key: key);

  final int initOption;
  @override
  _MyAppState createState() => _MyAppState(initOption: initOption);
}

class _MyAppState extends State<MyApp> {
  _MyAppState({this.initOption = 1});

  Ads ads;
  final int initOption;
  int _coins = 0;

  final String appId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544~3347511713'
      : 'ca-app-pub-3940256099942544~1458002511';
  final String bannerUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';
  final String screenUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';
  final String videoUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  @override
  void initState() {
    super.initState();

    switch (initOption) {
      case 1:

        /// Assign a listener.
        var eventListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.clicked) {
            print("The opened ad is clicked on.");
          }
        };

        ads = Ads(
          appId,
          bannerUnitId: bannerUnitId,
          screenUnitId: screenUnitId,
          videoUnitId: videoUnitId,
          keywords: <String>['ibm', 'computers'],
          contentUrl: 'http://www.ibm.com',
          childDirected: false,
          testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
          testing: false,
          listener: eventListener,
        );

        break;

      case 2:
        ads = Ads(appId);

        /// Assign the listener.
        var eventListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.closed) {
            print("User has opened and now closed the ad.");
          }
        };

        /// You can set the Banner, Fullscreen and Video Ads separately.

        ads.setBannerAd(
          adUnitId: bannerUnitId,
          size: AdSize.banner,
          keywords: ['andriod, flutter'],
          contentUrl: 'http://www.andrioussolutions.com',
          childDirected: false,
          testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
          listener: eventListener,
        );

        ads.setFullScreenAd(
            adUnitId: screenUnitId,
            keywords: ['dart', 'flutter'],
            contentUrl: 'http://www.fluttertogo.com',
            childDirected: false,
            testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
            listener: (MobileAdEvent event) {
              if (event == MobileAdEvent.opened) {
                print("An ad has opened up.");
              }
            });

        var videoListener = (RewardedVideoAdEvent event,
            {String rewardType, int rewardAmount}) {
          if (event == RewardedVideoAdEvent.rewarded) {
            print("The video ad has been rewarded.");
          }
        };

        ads.setVideoAd(
          adUnitId: videoUnitId,
          keywords: ['dart', 'java'],
          contentUrl: 'http://www.publang.org',
          childDirected: true,
          testDevices: null,
          listener: videoListener,
        );

        break;

      case 3:
        ads = Ads(appId);

        /// Assign the listener.
        var eventListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.closed) {
            print("User has opened and now closed the ad.");
          }
        };

        /// You just show the Banner, Fullscreen and Video Ads separately.

        ads.showBannerAd(
          adUnitId: bannerUnitId,
          size: AdSize.banner,
          keywords: ['andriod, flutter'],
          contentUrl: 'http://www.andrioussolutions.com',
          childDirected: false,
          testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
          listener: eventListener,
        );

        ads.showFullScreenAd(
            adUnitId: screenUnitId,
            keywords: ['dart', 'flutter'],
            contentUrl: 'http://www.fluttertogo.com',
            childDirected: false,
            testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
            listener: (MobileAdEvent event) {
              if (event == MobileAdEvent.opened) {
                print("An ad has opened up.");
              }
            });

        var videoListener = (RewardedVideoAdEvent event,
            {String rewardType, int rewardAmount}) {
          if (event == RewardedVideoAdEvent.rewarded) {
            print("The video ad has been rewarded.");
          }
        };

        ads.showVideoAd(
          adUnitId: videoUnitId,
          keywords: ['dart', 'java'],
          contentUrl: 'http://www.publang.org',
          childDirected: true,
          testDevices: null,
          listener: videoListener,
        );

        break;

      default:
        ads = Ads(appId, testing: true);
    }

    ads.eventListener = (MobileAdEvent event) {
      switch (event) {
        case MobileAdEvent.loaded:
          print("An ad has loaded successfully in memory.");
          break;
        case MobileAdEvent.failedToLoad:
          print("The ad failed to load into memory.");
          break;
        case MobileAdEvent.clicked:
          print("The opened ad was clicked on.");
          break;
        case MobileAdEvent.impression:
          print("The user is still looking at the ad. A new ad came up.");
          break;
        case MobileAdEvent.opened:
          print("The Ad is now open.");
          break;
        case MobileAdEvent.leftApplication:
          print("You've left the app after clicking the Ad.");
          break;
        case MobileAdEvent.closed:
          print("You've closed the Ad and returned to the app.");
          break;
        default:
          print("There's a 'new' MobileAdEvent?!");
      }
    };

    AdEventListener eventHandler = (MobileAdEvent event) {
      print("This is an event handler.");
    };

    ads.bannerListener = (MobileAdEvent event) {
      switch (event) {
        case MobileAdEvent.loaded:
          print("An ad has loaded successfully in memory.");
          break;
        case MobileAdEvent.failedToLoad:
          print("The ad failed to load into memory.");
          break;
        case MobileAdEvent.clicked:
          print("The opened ad was clicked on.");
          break;
        case MobileAdEvent.impression:
          print("The user is still looking at the ad. A new ad came up.");
          break;
        case MobileAdEvent.opened:
          print("The Ad is now open.");
          break;
        case MobileAdEvent.leftApplication:
          print("You've left the app after clicking the Ad.");
          break;
        case MobileAdEvent.closed:
          print("You've closed the Ad and returned to the app.");
          break;
        default:
          print("There's a 'new' MobileAdEvent?!");
      }
    };

    ads.removeBanner(eventHandler);

    ads.removeEvent(eventHandler);

    ads.removeScreen(eventHandler);

    ads.screenListener = (MobileAdEvent event) {
      switch (event) {
        case MobileAdEvent.loaded:
          print("An ad has loaded successfully in memory.");
          break;
        case MobileAdEvent.failedToLoad:
          print("The ad failed to load into memory.");
          break;
        case MobileAdEvent.clicked:
          print("The opened ad was clicked on.");
          break;
        case MobileAdEvent.impression:
          print("The user is still looking at the ad. A new ad came up.");
          break;
        case MobileAdEvent.opened:
          print("The Ad is now open.");
          break;
        case MobileAdEvent.leftApplication:
          print("You've left the app after clicking the Ad.");
          break;
        case MobileAdEvent.closed:
          print("You've closed the Ad and returned to the app.");
          break;
        default:
          print("There's a 'new' MobileAdEvent?!");
      }
    };

    ads.videoListener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      switch (event) {
        case RewardedVideoAdEvent.loaded:
          print("An ad has loaded successfully in memory.");
          break;
        case RewardedVideoAdEvent.failedToLoad:
          print("The ad failed to load into memory.");
          break;
        case RewardedVideoAdEvent.opened:
          print("The ad is now open.");
          break;
        case RewardedVideoAdEvent.leftApplication:
          print("You've left the app after clicking the Ad.");
          break;
        case RewardedVideoAdEvent.closed:
          print("You've closed the Ad and returned to the app.");
          break;
        case RewardedVideoAdEvent.rewarded:
          print("The ad has sent a reward amount.");
          break;
        case RewardedVideoAdEvent.started:
          print("You've just started playing the Video ad.");
          break;
        case RewardedVideoAdEvent.completed:
          print("You've just finished playing the Video ad.");
          break;
        default:
          print("There's a 'new' RewardedVideoAdEvent?!");
      }
    };

    VoidCallback handlerFunc = () {
      print("The opened ad was clicked on.");
    };

    ads.banner.loadedListener = () {
      print("An ad has loaded successfully in memory.");
    };

    ads.banner.removeLoaded(handlerFunc);

    ads.banner.failedListener = () {
      print("An ad failed to load into memory.");
    };

    ads.banner.removeFailed(handlerFunc);

    ads.banner.clickedListener = () {
      print("The opened ad is clicked on.");
    };

    ads.banner.removeClicked(handlerFunc);

    ads.banner.impressionListener = () {
      print("The user is still looking at the ad. A new ad came up.");
    };

    ads.banner.removeImpression(handlerFunc);

    ads.banner.openedListener = () {
      print("You've closed an ad and returned to your app.");
    };

    ads.banner.removeOpened(handlerFunc);

    ads.banner.leftAppListener = () {
      print("You left the app and gone to the ad's website.");
    };

    ads.banner.removeLeftApp(handlerFunc);

    ads.banner.closedListener = () {
      print("You've closed an ad and returned to your app.");
    };

    ads.banner.removeClosed(handlerFunc);

    ads.screen.loadedListener = () {
      print("An ad has loaded into memory.");
    };

    ads.screen.removeLoaded(handlerFunc);

    ads.screen.failedListener = () {
      print("An ad has failed to load in memory.");
    };

    ads.screen.removeFailed(handlerFunc);

    ads.screen.clickedListener = () {
      print("The opened ad was clicked on.");
    };

    ads.screen.removeClicked(handlerFunc);

    ads.screen.impressionListener = () {
      print("You've clicked on a link in the open ad.");
    };

    ads.screen.removeImpression(handlerFunc);

    ads.screen.openedListener = () {
      print("The ad has opened.");
    };

    ads.screen.removeOpened(handlerFunc);

    ads.screen.leftAppListener = () {
      print("The user has left the app and gone to the opened ad.");
    };

    ads.screen.leftAppListener = handlerFunc;

    ads.screen.closedListener = () {
      print("The ad has been closed. The user returns to the app.");
    };

    ads.screen.removeClosed(handlerFunc);

    ads.video.loadedListener = () {
      print("An ad has loaded in memory.");
    };

    ads.video.removeLoaded(handlerFunc);

    ads.video.failedListener = () {
      print("An ad has failed to load in memory.");
    };

    ads.video.removeFailed(handlerFunc);

    ads.video.clickedListener = () {
      print("An ad has been clicked on.");
    };

    ads.video.removeClicked(handlerFunc);

    ads.video.openedListener = () {
      print("An ad has been opened.");
    };

    ads.video.removeOpened(handlerFunc);

    ads.video.leftAppListener = () {
      print("You've left the app to view the video.");
    };

    ads.video.leftAppListener = handlerFunc;

    ads.video.closedListener = () {
      print("The video has been closed.");
    };

    ads.video.removeClosed(handlerFunc);

    ads.video.rewardedListener = (String rewardType, int rewardAmount) {
      print("The ad was sent a reward amount.");
      setState(() {
        _coins += rewardAmount;
      });
    };

    RewardListener rewardHandler = (String rewardType, int rewardAmount){
      print("This is the Rewarded Video handler");
    };

    ads.video.removeRewarded(rewardHandler);

    ads.video.startedListener = () {
      print("You've just started playing the Video ad.");
    };

    ads.video.removeStarted(handlerFunc);

    ads.video.completedListener = () {
      print("You've just finished playing the Video ad.");
    };

    ads.video.removeCompleted(handlerFunc);

    List<String> one = ads.keywords;

    String two = ads.contentUrl;

    bool three = ads.childDirected;

    List<String> four = ads.testDevices;

    bool five = ads.initialized;

    ads.dispose();

    ads.hideBannerAd();

    ads.hideFullScreenAd();
  }

  @override
  void dispose() {
    ads.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AdMob Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RaisedButton(
                    key: ValueKey<String>('SHOW BANNER'),
                    child: const Text('SHOW BANNER'),
                    onPressed: () {
                      ads.showBannerAd(state: this, anchorOffset: null);
                    }),
                RaisedButton(
                    key: ValueKey<String>('REMOVE BANNER'),
                    child: const Text('REMOVE BANNER'),
                    onPressed: () {
                      ads.hideBannerAd();
                    }),
                RaisedButton(
                  key: ValueKey<String>('SHOW INTERSTITIAL'),
                  child: const Text('SHOW INTERSTITIAL'),
                  onPressed: () {
                    ads.showFullScreenAd(state: this);
                  },
                ),
                RaisedButton(
                  key: ValueKey<String>('SHOW REWARDED VIDEO'),
                  child: const Text('SHOW REWARDED VIDEO'),
                  onPressed: () {
                    ads.showVideoAd(state: this);
                  },
                ),
                Text(
                  "You have $_coins coins.",
                  key: ValueKey<String>('COINS'),
                ),
              ].map((Widget button) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: button,
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
