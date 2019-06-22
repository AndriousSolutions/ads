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

        Ads.init(
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
        Ads.init(appId);

        /// Assign the listener.
        var eventListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.closed) {
            print("User has opened and now closed the ad.");
          }
        };

        /// You can set the Banner, Fullscreen and Video Ads separately.

        Ads.setBannerAd(
          adUnitId: bannerUnitId,
          size: AdSize.banner,
          keywords: ['andriod, flutter'],
          contentUrl: 'http://www.andrioussolutions.com',
          childDirected: false,
          testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
          listener: eventListener,
        );

        Ads.setFullScreenAd(
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

        Ads.setVideoAd(
          adUnitId: videoUnitId,
          keywords: ['dart', 'java'],
          contentUrl: 'http://www.publang.org',
          childDirected: true,
          testDevices: null,
          listener: videoListener,
        );

        break;

      case 3:
        Ads.init(appId);

        /// Assign the listener.
        var eventListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.closed) {
            print("User has opened and now closed the ad.");
          }
        };

        /// You just show the Banner, Fullscreen and Video Ads separately.

        Ads.showBannerAd(
          adUnitId: bannerUnitId,
          size: AdSize.banner,
          keywords: ['andriod, flutter'],
          contentUrl: 'http://www.andrioussolutions.com',
          childDirected: false,
          testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
          listener: eventListener,
        );

        Ads.showFullScreenAd(
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

        Ads.showVideoAd(
          adUnitId: videoUnitId,
          keywords: ['dart', 'java'],
          contentUrl: 'http://www.publang.org',
          childDirected: true,
          testDevices: null,
          listener: videoListener,
        );

        break;

      default:
        Ads.init(appId, testing: true);
    }

    Ads.eventListener = (MobileAdEvent event) {
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

    Ads.bannerListener = (MobileAdEvent event) {
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

    Ads.screenListener = (MobileAdEvent event) {
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

    Ads.videoListener =
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

    Ads.banner.loadedListener = () {
      print("An ad has loaded successfully in memory.");
    };

    Ads.banner.failedListener = () {
      print("An ad failed to load into memory.");
    };

    Ads.banner.clickedListener = () {
      print("The opened ad is clicked on.");
    };

    Ads.banner.impressionListener = () {
      print("The user is still looking at the ad. A new ad came up.");
    };

    Ads.banner.openedListener = () {
      print("You've closed an ad and returned to your app.");
    };

    Ads.banner.leftAppListener = () {
      print("You left the app and gone to the ad's website.");
    };

    Ads.banner.impressionListener = () {
      print("The user is still looking at the ad. A new ad came up.");
    };

    Ads.banner.closedListener = () {
      print("You've closed an ad and returned to your app.");
    };

    Ads.screen.loadedListener = () {
      print("An ad has loaded into memory.");
    };

    Ads.screen.failedListener = () {
      print("An ad has failed to load in memory.");
    };

    Ads.screen.clickedListener = () {
      print("The opened ad was clicked on.");
    };

    Ads.screen.impressionListener = () {
      print("You've clicked on a link in the open ad.");
    };

    Ads.screen.openedListener = () {
      print("The ad has opened.");
    };

    Ads.screen.leftAppListener = () {
      print("The user has left the app and gone to the opened ad.");
    };

    Ads.screen.closedListener = () {
      print("The ad has been closed. The user returns to the app.");
    };

    Ads.video.loadedListener = () {
      print("An ad has loaded in memory.");
    };

    Ads.video.failedListener = () {
      print("An ad has failed to load in memory.");
    };

    Ads.video.clickedListener = () {
      print("An ad has been clicked on.");
    };

    Ads.video.openedListener = () {
      print("An ad has been opened.");
    };

    Ads.video.leftAppListener = () {
      print("You've left the app to view the video.");
    };

    Ads.video.closedListener = () {
      print("The video has been closed.");
    };

    Ads.video.rewardedListener = (String rewardType, int rewardAmount) {
      print("The ad was sent a reward amount.");
      setState(() {
        _coins += rewardAmount;
      });
    };

    Ads.video.startedListener = () {
      print("You've just started playing the Video ad.");
    };

    Ads.video.completedListener = () {
      print("You've just finished playing the Video ad.");
    };

    List<String> two = Ads.keywords;
    String three = Ads.contentUrl;
    bool seven = Ads.childDirected;
    List<String> eight = Ads.testDevices;
    print(two);
  }

  @override
  void dispose() {
    Ads.dispose();
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
                      Ads.showBannerAd(state: this, anchorOffset: null);
                    }),
                RaisedButton(
                    key: ValueKey<String>('REMOVE BANNER'),
                    child: const Text('REMOVE BANNER'),
                    onPressed: () {
                      Ads.hideBannerAd();
                    }),
                RaisedButton(
                  key: ValueKey<String>('SHOW INTERSTITIAL'),
                  child: const Text('SHOW INTERSTITIAL'),
                  onPressed: () {
                    Ads.showFullScreenAd(state: this);
                  },
                ),
                RaisedButton(
                  key: ValueKey<String>('SHOW REWARDED VIDEO'),
                  child: const Text('SHOW REWARDED VIDEO'),
                  onPressed: () {
                    Ads.showVideoAd(state: this);
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
