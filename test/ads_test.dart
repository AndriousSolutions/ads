import 'package:flutter/material.dart';

import 'package:firebase_admob/firebase_admob.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:ads/ads.dart';

import '../example/main.dart';

Key _showBanner = ValueKey<String>('SHOW BANNER');
Key _removeBanner = ValueKey<String>('REMOVE BANNER');
Key _showFullScreen = ValueKey<String>('SHOW INTERSTITIAL');
Key _showVideo = ValueKey<String>('SHOW REWARDED VIDEO');

/// Names the last event triggered.
String _event = '';

void main() {
  testWidgets('Test Rewarded Video', (WidgetTester tester) async {
    Key key = UniqueKey();

    await tester.pumpWidget(MaterialApp(
      home: MyApp(
        initOption: 1,
        key: key,
      ),
    ));

    Ads.video.startedListener = () {
      _event = 'started';
    };

    Ads.video.completedListener = () {};

    // Play a video ad.
    await tester.tap(find.byKey(_showVideo));
    await tester.pumpAndSettle();
//    await tester.idle();

    Text _coins = tester.widget(find.byKey(ValueKey<String>('COINS')));
    String value = _coins.data;

    // Verify the current counter.
    expect(find.text(value), findsOneWidget);

    expect(Ads.appId, equals(FirebaseAdMob.testAppId));
    expect(Ads.keywords.contains('the'), isTrue);
    expect(Ads.contentUrl, isNull);
    expect(Ads.childDirected, isFalse);
    expect(Ads.testDevices, isEmpty);
    expect(Ads.testing, isTrue);
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
//    Ads.banner.loadedListener = () {
//      where = 'loaded';
//    };
//
//    Ads.banner.clickedListener = () {
//      where = 'clicked';
//    };
//
//    Ads.banner.openedListener = () {
//      where = 'opened';
//    };
//
//    Ads.banner.leftAppListener = () {
//      where = 'left';
//    };
//
//    Ads.banner.closedListener = () {
//      where = 'closed';
//    };
//
//    Ads.video.openedListener = () {
//      where = 'opened';
//    };
//
//    await tester.tap(find.byKey(_showBanner));
//    await tester.pumpAndSettle();
//
////    expect(where, equals('MobileAdEvent.opened'));
//
//
////    Ads.clearVideoListeners();
//
////    Ads.videoListener(VideoEventListener listener) =>
//
//    expect(Ads.appId, equals(FirebaseAdMob.testAppId));
//    expect(Ads.keywords.contains('ibm'), isTrue);
//    expect(Ads.keywords.contains('computers'), isTrue);
//    expect(Ads.contentUrl, equals('http://www.ibm.com'));
//    expect(Ads.childDirected, isFalse);
//    expect(Ads.testDevices.contains('Samsung_Galaxy_SII_API_26:5554'), isTrue);
//    expect(Ads.testing, isFalse);
////    Ads.banner.clearAll();
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
//    expect(Ads.appId, equals(FirebaseAdMob.testAppId));
//    expect(Ads.keywords.contains('cats'), isTrue);
//    expect(Ads.keywords.contains('dogs'), isTrue);
//    expect(Ads.contentUrl, equals('http://www.animalsaspets.com'));
//    expect(Ads.childDirected, isFalse);
//    expect(Ads.testDevices.contains('Samsung_Galaxy_SII_API_26:5554'), isTrue);
//    expect(Ads.testing, isTrue);
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
//    expect(Ads.bannerAd.adUnitId, equals(FirebaseAdMob.testAppId));
//    expect(Ads.bannerAd.targetingInfo.keywords.contains('android'), isTrue);
//    expect(Ads.bannerAd.targetingInfo.keywords.contains('flutter'), isTrue);
//    expect(Ads.bannerAd.targetingInfo.contentUrl,
//        equals('http://www.andrioussolutions.com'));
//    expect(Ads.bannerAd.targetingInfo.childDirected, isFalse);
//    expect(
//        Ads.bannerAd.targetingInfo.testDevices
//            .contains('Samsung_Galaxy_SII_API_26:5554'),
//        isTrue);
//
//    expect(Ads.fullScreenAd.adUnitId, equals(FirebaseAdMob.testAppId));
//    expect(Ads.fullScreenAd.targetingInfo.keywords.contains('dart'), isTrue);
//    expect(Ads.fullScreenAd.targetingInfo.keywords.contains('flutter'), isTrue);
//    expect(Ads.fullScreenAd.targetingInfo.contentUrl,
//        equals('http://www.fluttertogo.com'));
//    expect(Ads.fullScreenAd.targetingInfo.childDirected, isFalse);
//    expect(
//        Ads.fullScreenAd.targetingInfo.testDevices
//            .contains('Samsung_Galaxy_SII_API_26:5554'),
//        isTrue);
//
//    expect(Ads.videoAd.adUnitId, equals(FirebaseAdMob.testAppId));
//    expect(Ads.videoAd.targetingInfo.keywords.contains('dart'), isTrue);
//    expect(Ads.videoAd.targetingInfo.keywords.contains('java'), isTrue);
//    expect(
//        Ads.videoAd.targetingInfo.contentUrl, equals('http://www.publang.org'));
//    expect(Ads.videoAd.targetingInfo.childDirected, isFalse);
//    expect(
//        Ads.videoAd.targetingInfo.testDevices
//            .contains('Samsung_Galaxy_SII_API_26:5554'),
//        isFalse);
//    expect(Ads.videoAd.listener, isNotNull);
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
//    expect(Ads.keywords.contains('cats'), isTrue);
//    expect(Ads.keywords.contains('dogs'), isTrue);
//    expect(Ads.contentUrl, equals('http://www.animalsaspets.com'));
//    expect(Ads.childDirected, isFalse);
//    expect(Ads.testDevices.contains('Samsung_Galaxy_SII_API_26:5554'), isTrue);
//    expect(Ads.testing, isTrue);
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
