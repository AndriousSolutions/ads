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

  @override
  void initState() {
    super.initState();

    switch (initOption) {
      case 1:
        Ads.init(
            Platform.isAndroid
                ? 'ca-app-pub-3940256099942544~3347511713'
                : 'ca-app-pub-3940256099942544~1458002511',
            testing: true);

        Ads.video.rewardedListener = (String rewardType, int rewardAmount) {
          setState(() {
            _coins += rewardAmount;
          });
        };
        break;

      case 2:
        var eventListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.opened) print("Returned to the app.");
        };

        Ads.init(
          Platform.isAndroid
              ? 'ca-app-pub-3940256099942544~3347511713'
              : 'ca-app-pub-3940256099942544~1458002511',
          bannerUnitId: Platform.isAndroid
              ? 'ca-app-pub-3940256099942544/6300978111'
              : 'ca-app-pub-3940256099942544/2934735716',
          screenUnitId: Platform.isAndroid
              ? 'ca-app-pub-3940256099942544/1033173712'
              : 'ca-app-pub-3940256099942544/4411468910',
          videoUnitId: Platform.isAndroid
              ? 'ca-app-pub-3940256099942544/5224354917'
              : 'ca-app-pub-3940256099942544/1712485313',
          keywords: <String>['ibm', 'computers'],
          contentUrl: 'http://www.ibm.com',
          birthday: DateTime.utc(1989, 11, 9),
          designedForFamilies: true,
          childDirected: false,
          testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
          testing: false,
          listener: eventListener,
        );

        break;

      case 3:
        var eventListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.closed) print("Returned to the app.");
        };

        Ads.init(
            Platform.isAndroid
                ? 'ca-app-pub-3940256099942544~3347511713'
                : 'ca-app-pub-3940256099942544~1458002511',
            listener: eventListener,
            testing: true);
        Ads.bannerUnitId = Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/6300978111'
            : 'ca-app-pub-3940256099942544/2934735716';
        Ads.screenUnitId = Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-3940256099942544/4411468910';
        Ads.videoUnitId = Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/5224354917'
            : 'ca-app-pub-3940256099942544/1712485313';
        // You can set individual settings
        Ads.keywords = ['cats', 'dogs'];
        Ads.contentUrl = 'http://www.animalsaspets.com';
        Ads.childDirected = false;
        Ads.testDevices = ['Samsung_Galaxy_SII_API_26:5554'];
        Ads.testing = true;
        Ads.bannerListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.opened) {
            print("This is the first listener.");
          }
        };

        break;

      case 4:
        Ads.init(Platform.isAndroid
            ? 'ca-app-pub-3940256099942544~3347511713'
            : 'ca-app-pub-3940256099942544~1458002511');

        var eventListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.closed) print("Returned to the app.");
        };

        /// You can set the Banner, Fullscreen and Video Ads separately.

        Ads.setBannerAd(
          adUnitId: Platform.isAndroid
              ? 'ca-app-pub-3940256099942544/6300978111'
              : 'ca-app-pub-3940256099942544/2934735716',
          size: AdSize.banner,
          keywords: ['andriod, flutter'],
          contentUrl: 'http://www.andrioussolutions.com',
          childDirected: false,
          testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
          listener: eventListener,
        );

        Ads.setFullScreenAd(
            adUnitId: Platform.isAndroid
                ? 'ca-app-pub-3940256099942544/1033173712'
                : 'ca-app-pub-3940256099942544/4411468910',
            keywords: ['dart', 'flutter'],
            contentUrl: 'http://www.fluttertogo.com',
            childDirected: false,
            testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
            listener: (MobileAdEvent event) {
              if (event == MobileAdEvent.opened) print("Opened the Ad.");
            });

        var videoListener = (RewardedVideoAdEvent event,
            {String rewardType, int rewardAmount}) {
          if (event == RewardedVideoAdEvent.closed) {
            print("Returned to the app.");
          }
        };

        Ads.setVideoAd(
          adUnitId: Platform.isAndroid
              ? 'ca-app-pub-3940256099942544/5224354917'
              : 'ca-app-pub-3940256099942544/1712485313',
          keywords: ['dart', 'java'],
          contentUrl: 'http://www.publang.org',
          childDirected: false,
          testDevices: null,
          listener: videoListener,
        );

        break;
      case 5:
        Ads.init(Platform.isAndroid
            ? 'ca-app-pub-3940256099942544~3347511713'
            : 'ca-app-pub-3940256099942544~1458002511');

        /// You can set individual settings
        Ads.keywords = ['cats', 'dogs'];
        Ads.contentUrl = 'http://www.animalsaspets.com';
        Ads.childDirected = false;
        // You can also test with your own ad unit IDs by registering your device as a
        // test device. Check the logs for your device's ID value.
        Ads.testDevices = ['Samsung_Galaxy_SII_API_26:5554'];

        /// Can set this at the init() function instead.
        Ads.testing = true;

        break;

      case 6:
        Ads.init(
            Platform.isAndroid
                ? 'ca-app-pub-3940256099942544~3347511713'
                : 'ca-app-pub-3940256099942544~1458002511',
            testing: true);

        Ads.eventListener = (MobileAdEvent event) {
          switch (event) {
            case MobileAdEvent.loaded:
              print(
                  "The Ad is loading into memory. Not necessarily displayed yet.");
              break;
            case MobileAdEvent.failedToLoad:
              print("The Ad failed to load into memory.");
              break;
            case MobileAdEvent.clicked:
              print("The Ad has been clicked and opened.");
              break;
            case MobileAdEvent.impression:
              print("The displayed Ad has 'changed' to a new one.");
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

        break;

      case 7:
        Ads.init(
            Platform.isAndroid
                ? 'ca-app-pub-3940256099942544~3347511713'
                : 'ca-app-pub-3940256099942544~1458002511',
            testing: true);

        Ads.showBannerAd(state: this);

        Ads.bannerListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.opened) {
            print("You've clicked on the Banner Ad");
          }
        };

        Ads.screenListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.opened) {
            print("You've clicked on the Fullscreen Ad.");
          }
        };

        Ads.videoListener = (RewardedVideoAdEvent event,
            {String rewardType, int rewardAmount}) {
          if (event == RewardedVideoAdEvent.opened) {
            print("You've clicked on the Fullscreen Ad.");
          }
        };

        break;
      case 8:
        Ads.init(
            Platform.isAndroid
                ? 'ca-app-pub-3940256099942544~3347511713'
                : 'ca-app-pub-3940256099942544~1458002511',
            testing: true);

        Ads.banner.openedListener = () {
          print("This is the first listener when you open the banner ad.");
        };

        Ads.banner.openedListener = () {
          print("This is the second listener when you open the banner ad.");
        };

        Ads.banner.leftAppListener = () {
          print("You've left your app.");
        };

        Ads.banner.closedListener = () {
          print("You've closed an ad and returned to your app.");
        };

        break;
      case 9:
        Ads.init(
            Platform.isAndroid
                ? 'ca-app-pub-3940256099942544~3347511713'
                : 'ca-app-pub-3940256099942544~1458002511',
            testing: true);

        Ads.screen.openedListener = () {
          print("This is the first listener when you open the full screen ad.");
        };

        Ads.screen.openedListener = () {
          print(
              "This is the second listener when you open the full screen ad.");
        };

        Ads.screen.leftAppListener = () {
          print("You've left your app.");
        };

        Ads.screen.closedListener = () {
          print("You've closed an ad and returned to your app.");
        };

        break;
      case 10:
        Ads.init(
            Platform.isAndroid
                ? 'ca-app-pub-3940256099942544~3347511713'
                : 'ca-app-pub-3940256099942544~1458002511',
            testing: true);

        Ads.video.closedListener = () {
          print("You've closed the video.");
        };

        Ads.video.rewardedListener = (String rewardType, int rewardAmount) {
          setState(() {
            _coins += rewardAmount;
          });
        };

        break;

      default:
        Ads.init(
            Platform.isAndroid
                ? 'ca-app-pub-3940256099942544~3347511713'
                : 'ca-app-pub-3940256099942544~1458002511',
            testing: true);
    }

    String one = Ads.appId;
    List<String> two = Ads.keywords;
    String three = Ads.contentUrl;
    bool seven = Ads.childDirected;
    List<String> eight = Ads.testDevices;
    bool nine = Ads.testing;
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
                      Ads.showBannerAd(state: this);
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
