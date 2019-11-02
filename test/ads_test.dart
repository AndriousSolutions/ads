import 'package:flutter/material.dart'
    show Key, MaterialApp, Text, UniqueKey, ValueKey;
import 'dart:io' show Platform;
import 'package:flutter_test/flutter_test.dart';

import 'package:ads/ads.dart' show Ads;

import '../example/main.dart' show MyApp, ads;

int frames;

Key _showBanner = ValueKey<String>('SHOW BANNER');
Key _removeBanner = ValueKey<String>('REMOVE BANNER');
Key _showFullScreen = ValueKey<String>('SHOW INTERSTITIAL');
Key _showVideo = ValueKey<String>('SHOW REWARDED VIDEO');

/// Names the last event triggered.
String _event = '';

final String appId = Platform.isAndroid
    ? 'ca-app-pub-3940256099942544~3347511713'
    : 'ca-app-pub-3940256099942544~1458002511';

void main() {
  testWidgets('Test Rewarded Video', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: MyApp(
        initOption: 1,
      ),
    ));

//    ads.video.startedListener = () {
//      _event = 'started';
//    };
//
//    ads.video.completedListener = () {};
//    try {
//      frames = await tester.pumpAndSettle(const Duration(seconds: 30));
//    } catch (ex) {}
//    // Play a video ad.
//    Finder button = find.byKey(_showVideo);
//    await tester.tap(button);
//    await tester.pump(const Duration(seconds: 30));
//    frames = await tester.pumpAndSettle(const Duration(seconds: 30));
//    await tester.idle();
//
//    Text _coins = tester.widget(find.byKey(ValueKey<String>('COINS')));
//    String value = _coins.data;
//
//    // Verify the current counter.
//    expect(find.text(value), findsOneWidget);

    expect(ads.initialized, isTrue);
    expect(ads.keywords.contains('ibm'), isTrue);
    expect(ads.contentUrl.contains('ibm'), isTrue);
    expect(ads.childDirected, isFalse);
    expect(ads.testDevices, isNull);
    expect(ads.testing, isFalse);
    expect(ads.inError, isFalse);

//    ads.dispose();
//    ads = null;
  });

  String where = '';

//  testWidgets('Header adds todo', (WidgetTester tester) async {
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: MyApp(
//          initOption: 2,
//        ),
//      ),
//    ));
//
//    ads.banner.loadedListener = () {
//      where = 'loaded';
//    };
//
//    ads.banner.clickedListener = () {
//      where = 'clicked';
//    };
//
//    ads.banner.openedListener = () {
//      where = 'opened';
//    };
//
//    ads.banner.leftAppListener = () {
//      where = 'left';
//    };
//
//    ads.banner.closedListener = () {
//      where = 'closed';
//    };
//
//    ads.video.openedListener = () {
//      where = 'opened';
//    };
//
//    await tester.tap(find.byKey(_showBanner));
//    await tester.pumpAndSettle();
//
////    expect(where, equals('MobileAdEvent.opened'));
//
//
////    ads.clearVideoListeners();
//
////    ads.videoListener(VideoEventListener listener) =>
//
//    expect(ads.appId, equals(FirebaseAdMob.testAppId));
//    expect(ads.keywords.contains('ibm'), isTrue);
//    expect(ads.keywords.contains('computers'), isTrue);
//    expect(ads.contentUrl, equals('http://www.ibm.com'));
//    expect(ads.childDirected, isFalse);
//    expect(ads.testDevices.contains('Samsung_Galaxy_SII_API_26:5554'), isTrue);
//    expect(ads.testing, isFalse);
////    ads.banner.clearAll();
//
//  });
//
//  testWidgets('Header adds todo', (WidgetTester tester) async {
//    Key key = UniqueKey();
//
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: MyApp(
//          initOption: 3,
//          key: key,
//        ),
//      ),
//    ));
//
//    await tester.tap(find.byType(BannerAd));
//
//    expect(_event, equals('MobileAdEvent.leftApplication'));
//
//    expect(ads.appId, equals(FirebaseAdMob.testAppId));
//    expect(ads.keywords.contains('cats'), isTrue);
//    expect(ads.keywords.contains('dogs'), isTrue);
//    expect(ads.contentUrl, equals('http://www.animalsaspets.com'));
//    expect(ads.childDirected, isFalse);
//    expect(ads.testDevices.contains('Samsung_Galaxy_SII_API_26:5554'), isTrue);
//    expect(ads.testing, isTrue);
//  });
//
//  testWidgets('Header adds todo', (WidgetTester tester) async {
//    Key key = UniqueKey();
//
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: MyApp(
//          initOption: 4,
//          key: key,
//        ),
//      ),
//    ));
//
//    expect(ads.bannerAd.adUnitId, equals(FirebaseAdMob.testAppId));
//    expect(ads.bannerAd.targetingInfo.keywords.contains('android'), isTrue);
//    expect(ads.bannerAd.targetingInfo.keywords.contains('flutter'), isTrue);
//    expect(ads.bannerAd.targetingInfo.contentUrl,
//        equals('http://www.andrioussolutions.com'));
//    expect(ads.bannerAd.targetingInfo.childDirected, isFalse);
//    expect(
//        ads.bannerAd.targetingInfo.testDevices
//            .contains('Samsung_Galaxy_SII_API_26:5554'),
//        isTrue);
//
//    expect(ads.fullScreenAd.adUnitId, equals(FirebaseAdMob.testAppId));
//    expect(ads.fullScreenAd.targetingInfo.keywords.contains('dart'), isTrue);
//    expect(ads.fullScreenAd.targetingInfo.keywords.contains('flutter'), isTrue);
//    expect(ads.fullScreenAd.targetingInfo.contentUrl,
//        equals('http://www.fluttertogo.com'));
//    expect(ads.fullScreenAd.targetingInfo.childDirected, isFalse);
//    expect(
//        ads.fullScreenAd.targetingInfo.testDevices
//            .contains('Samsung_Galaxy_SII_API_26:5554'),
//        isTrue);
//
//    expect(ads.videoAd.adUnitId, equals(FirebaseAdMob.testAppId));
//    expect(ads.videoAd.targetingInfo.keywords.contains('dart'), isTrue);
//    expect(ads.videoAd.targetingInfo.keywords.contains('java'), isTrue);
//    expect(
//        ads.videoAd.targetingInfo.contentUrl, equals('http://www.publang.org'));
//    expect(ads.videoAd.targetingInfo.childDirected, isFalse);
//    expect(
//        ads.videoAd.targetingInfo.testDevices
//            .contains('Samsung_Galaxy_SII_API_26:5554'),
//        isFalse);
//    expect(ads.videoAd.listener, isNotNull);
//  });
//
//  testWidgets('Header adds todo', (WidgetTester tester) async {
//    Key key = UniqueKey();
//
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: MyApp(
//          initOption: 5,
//          key: key,
//        ),
//      ),
//    ));
//
//    expect(ads.keywords.contains('cats'), isTrue);
//    expect(ads.keywords.contains('dogs'), isTrue);
//    expect(ads.contentUrl, equals('http://www.animalsaspets.com'));
//    expect(ads.childDirected, isFalse);
//    expect(ads.testDevices.contains('Samsung_Galaxy_SII_API_26:5554'), isTrue);
//    expect(ads.testing, isTrue);
//  });
//
//  testWidgets('Header adds todo', (WidgetTester tester) async {
//    Key key = UniqueKey();
//
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: MyApp(
//          initOption: 6,
//          key: key,
//        ),
//      ),
//    ));
//  });
//
//  testWidgets('Header adds todo', (WidgetTester tester) async {
//    Key key = UniqueKey();
//
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: MyApp(
//          initOption: 7,
//          key: key,
//        ),
//      ),
//    ));
//  });
//
//  testWidgets('Header adds todo', (WidgetTester tester) async {
//    Key key = UniqueKey();
//
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: MyApp(
//          initOption: 8,
//          key: key,
//        ),
//      ),
//    ));
//  });
//
//  testWidgets('Header adds todo', (WidgetTester tester) async {
//    Key key = UniqueKey();
//
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: MyApp(
//          initOption: 9,
//          key: key,
//        ),
//      ),
//    ));
//  });
//
//  testWidgets('Header adds todo', (WidgetTester tester) async {
//    Key key = UniqueKey();
//
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: MyApp(
//          initOption: 10,
//          key: key,
//        ),
//      ),
//    ));
//  });
}
