// Copyright 2019 Andrious Solutions Ltd. All rights reserved.
// Use of this source code is governed by the Apache License, Version 2.0 that can be
// found in the LICENSE file.
//
// http://www.apache.org/licenses/LICENSE-2.0
//

import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:ads/ads.dart';


void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({this.initOption = 1, Key? key}) : super(key: key);
  final int? initOption;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var _coins = 0;

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

  late Ads ads;

  @override
  void initState() {
    super.initState();

    switch (widget.initOption) {
      case 1:
        ads = Ads(
          bannerUnitId: bannerUnitId,
          screenUnitId: screenUnitId,
          videoUnitId: videoUnitId,
          keywords: <String>['ibm', 'computers'],
          contentUrl: 'http://www.ibm.com',
          childDirected: false,
          testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
          testing: false,
          listener: (AdsEvent event) {
            if (event == AdsEvent.onNativeAdClicked) {
              // ignore: avoid_print
              print('The opened ad is clicked on.');
            }
          },
        );

        break;

      case 2:
        ads = Ads();

        /// You can set the Banner, Fullscreen and Video Ads separately.

        ads.setBannerAd(
          adUnitId: bannerUnitId,
          size: AdSize.banner,
          keywords: ['andriod, flutter'],
          contentUrl: 'http://www.andrioussolutions.com',
          childDirected: false,
          testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
          listener: (AdsEvent event) {
            if (event == AdsEvent.onAdClosed) {
              // ignore: avoid_print
              print('User has opened and now closed the ad.');
            }
          },
        );

        ads.setFullScreenAd(
            adUnitId: screenUnitId,
            keywords: ['dart', 'flutter'],
            contentUrl: 'http://www.fluttertogo.com',
            childDirected: false,
            testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
            listener: (AdsEvent event) {
              if (event == AdsEvent.onAdOpened) {
                // ignore: avoid_print
                print('An ad has opened up.');
              }
            });

        // var videoListener = (RewardedVideoAdEvent event,
        //     {String rewardType, int rewardAmount}) {
        //   if (event == RewardedVideoAdEvent.rewarded) {
        //     print("The video ad has been rewarded.");
        //   }
        // };

        ads.setVideoAd(
          adUnitId: videoUnitId,
          keywords: ['dart', 'java'],
          contentUrl: 'http://www.publang.org',
          childDirected: true,
//          listener: videoListener,
        );

        break;

      case 3:
        ads = Ads();

        /// You just show the Banner, Fullscreen and Video Ads separately.

        ads.setBannerAd(
          adUnitId: bannerUnitId,
          size: AdSize.banner,
          keywords: ['andriod, flutter'],
          contentUrl: 'http://www.andrioussolutions.com',
          childDirected: false,
          testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
          listener: (AdsEvent event) {
            if (event == AdsEvent.onAdClosed) {
              // ignore: avoid_print
              print('User has opened and now closed the ad.');
            }
          },
        );

        ads.showFullScreenAd(
            adUnitId: screenUnitId,
            keywords: ['dart', 'flutter'],
            contentUrl: 'http://www.fluttertogo.com',
            childDirected: false,
            testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
            listener: (AdsEvent event) {
              if (event == AdsEvent.onAdOpened) {
                // ignore: avoid_print
                print('An ad has opened up.');
              }
            });

        // var videoListener = (RewardedVideoAdEvent event,
        //     {String rewardType, int rewardAmount}) {
        //   if (event == RewardedVideoAdEvent.rewarded) {
        //     print("The video ad has been rewarded.");
        //   }
        // };

        ads.showVideoAd(
          adUnitId: videoUnitId,
          keywords: ['dart', 'java'],
          contentUrl: 'http://www.publang.org',
          childDirected: true,
//          listener: videoListener,
        );

        break;

      default:
        ads = Ads(testing: true);
    }

    ads.eventListener = (AdsEvent event) {
      switch (event) {
        case AdsEvent.onAdLoaded:
        // ignore: avoid_print
          print('An ad has loaded successfully in memory.');
          break;
        case AdsEvent.onAdFailedToLoad:
        // ignore: avoid_print
          print('The ad failed to load into memory.');
          break;
        case AdsEvent.onNativeAdClicked:
        // ignore: avoid_print
          print('The opened ad was clicked on.');
          break;
        case AdsEvent.onNativeAdImpression:
        // ignore: avoid_print
          print('The user is still looking at the ad. A new ad came up.');
          break;
        case AdsEvent.onAdOpened:
        // ignore: avoid_print
          print('The Ad is now open.');
          break;
        case AdsEvent.onApplicationExit:
        // ignore: avoid_print
          print("You've left the app after clicking the Ad.");
          break;
        case AdsEvent.onAdClosed:
        // ignore: avoid_print
          print("You've closed the Ad and returned to the app.");
          break;
        default:
        // ignore: avoid_print
          print("There's a 'new' MobileAdEvent?!");
      }
    };

    ads.bannerListener = (AdsEvent event) {
      switch (event) {
        case AdsEvent.onAdLoaded:
        // ignore: avoid_print
          print('An ad has loaded successfully in memory.');
          break;
        case AdsEvent.onAdFailedToLoad:
        // ignore: avoid_print
          print('The ad failed to load into memory.');
          break;
        case AdsEvent.onNativeAdClicked:
        // ignore: avoid_print
          print('The opened ad was clicked on.');
          break;
        case AdsEvent.onNativeAdImpression:
        // ignore: avoid_print
          print('The user is still looking at the ad. A new ad came up.');
          break;
        case AdsEvent.onAdOpened:
        // ignore: avoid_print
          print('The Ad is now open.');
          break;
        case AdsEvent.onApplicationExit:
        // ignore: avoid_print
          print("You've left the app after clicking the Ad.");
          break;
        case AdsEvent.onAdClosed:
        // ignore: avoid_print
          print("You've closed the Ad and returned to the app.");
          break;
        default:
        // ignore: avoid_print
          print("There's a 'new' MobileAdEvent?!");
      }
    };

    ads.screenListener = (AdsEvent event) {
      switch (event) {
        case AdsEvent.onAdLoaded:
        // ignore: avoid_print
          print('An ad has loaded successfully in memory.');
          break;
        case AdsEvent.onAdFailedToLoad:
        // ignore: avoid_print
          print('The ad failed to load into memory.');
          break;
        case AdsEvent.onNativeAdClicked:
        // ignore: avoid_print
          print('The opened ad was clicked on.');
          break;
        case AdsEvent.onNativeAdImpression:
        // ignore: avoid_print
          print('The user is still looking at the ad. A new ad came up.');
          break;
        case AdsEvent.onAdOpened:
        // ignore: avoid_print
          print('The Ad is now open.');
          break;
        case AdsEvent.onApplicationExit:
        // ignore: avoid_print
          print("You've left the app after clicking the Ad.");
          break;
        case AdsEvent.onAdClosed:
        // ignore: avoid_print
          print("You've closed the Ad and returned to the app.");
          break;
        default:
        // ignore: avoid_print
          print("There's a 'new' MobileAdEvent?!");
      }
    };

    ads.banner.loadedListener = () {
      // ignore: avoid_print
      print('An ad has loaded successfully in memory.');
    };

    ads.banner.failedListener = (Ad ad, LoadAdError error) {
      // ignore: avoid_print
      print('An ad failed to load into memory.');
    };

    ads.banner.clickedListener = () {
      // ignore: avoid_print
      print('The opened ad is clicked on.');
    };

    ads.banner.impressionListener = () {
      // ignore: avoid_print
      print('The user is still looking at the ad. A new ad came up.');
    };

    ads.banner.openedListener = () {
      // ignore: avoid_print
      print("You've closed an ad and returned to your app.");
    };

    ads.banner.leftAppListener = () {
      // ignore: avoid_print
      print("You left the app and gone to the ad's website.");
    };

    ads.banner.impressionListener = () {
      // ignore: avoid_print
      print('The user is still looking at the ad. A new ad came up.');
    };

    ads.banner.closedListener = () {
      // ignore: avoid_print
      print("You've closed an ad and returned to your app.");
    };

    ads.screen.loadedListener = () {
      // ignore: avoid_print
      print('An ad has loaded into memory.');
    };

    ads.screen.failedListener = (Ad ad, LoadAdError error) {
      // ignore: avoid_print
      print('An ad has failed to load in memory.');
    };

    ads.screen.clickedListener = () {
      // ignore: avoid_print
      print('The opened ad was clicked on.');
    };

    ads.screen.impressionListener = () {
      // ignore: avoid_print
      print("You've clicked on a link in the open ad.");
    };

    ads.screen.openedListener = () {
      // ignore: avoid_print
      print('The ad has opened.');
    };

    ads.screen.leftAppListener = () {
      // ignore: avoid_print
      print('The user has left the app and gone to the opened ad.');
    };

    ads.screen.closedListener = () {
      // ignore: avoid_print
      print('The ad has been closed. The user returns to the app.');
    };

    ads.video.loadedListener = () {
      // ignore: avoid_print
      print('An ad has loaded in memory.');
    };

    ads.video.failedListener = (Ad ad, LoadAdError error) {
      // ignore: avoid_print
      print('An ad has failed to load in memory.');
    };

    ads.video.clickedListener = () {
      // ignore: avoid_print
      print('An ad has been clicked on.');
    };

    ads.video.openedListener = () {
      // ignore: avoid_print
      print('An ad has been opened.');
    };

    ads.video.leftAppListener = () {
      // ignore: avoid_print
      print("You've left the app to view the video.");
    };

    ads.video.closedListener = () {
      // ignore: avoid_print
      print('The video has been closed.');
    };

    // ads.video.rewardedListener = (String rewardType, int rewardAmount) {
    //   // ignore: avoid_print
    //   print('The ad was sent a reward amount.');
    //   setState(() {
    //     _coins += rewardAmount;
    //   });
    // };


    List<String> two = ads.keywords!;
    String three = ads.contentUrl!;
    bool seven = ads.childDirected!;
    List<String> eight = ads.testDevices!;
    // ignore: avoid_print
    print(two);
  }

  @override
  void dispose() {
    ads.dispose();
    super.dispose();
  }

  bool show = false;

  @override
  Widget build(BuildContext context) {
    Widget? bannerWidget;
    if (show) {
      bannerWidget ??= ads.bannerAdWidget();
    } else {
      bannerWidget = null;
      bannerWidget = Container();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AdMob Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  key: const ValueKey<String>('SHOW BANNER'),
                  onPressed: () {
                    setState(() {
                      show = true;
                    });
                  },
                  child: const Text('SHOW BANNER'),
                ),
                ElevatedButton(
                  key: const ValueKey<String>('REMOVE BANNER'),
                  onPressed: () {
                    setState(() {
                      show = false;
                    });
                  },
                  child: const Text('REMOVE BANNER'),
                ),
                ElevatedButton(
                  key: const ValueKey<String>('SHOW INTERSTITIAL'),
                  onPressed: () {
                    ads.showFullScreenAd(state: this);
                  },
                  child: const Text('SHOW INTERSTITIAL'),
                ),
                ElevatedButton(
                  key: const ValueKey<String>('SHOW REWARDED VIDEO'),
                  onPressed: () {
                    ads.showVideoAd(state: this);
                  },
                  child: const Text('SHOW REWARDED VIDEO'),
                ),
                Text(
                  'You have $_coins coins.',
                  key: const ValueKey<String>('COINS'),
                ),
                bannerWidget,
              ].map((Widget button) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
