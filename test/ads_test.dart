import 'package:flutter/material.dart';

import 'package:firebase_admob/firebase_admob.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:ads/ads.dart';

Key _showBanner = Key('SHOW BANNER');
Key _removeBanner = Key('REMOVE BANNER');
Key _showFullScreen = Key('SHOW INTERSTITIAL');
Key _showVideo = Key('SHOW REWARDED VIDEO');

/// Library-private variable accessed by all the classes and top-level functions.
int _coins = 0;

/// Names the last event triggered.
String _event = '';

void main() {
//  testWidgets('Test Rewarded Video', (WidgetTester tester) async {
//    Key key = new UniqueKey();
//
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: TestApp(
//          1,
//          key: key,
//        ),
//      ),
//    ));
//
//    await tester.tap(find.byKey(_showVideo));
//
//    expect(_coins, equals(10));
//
//    expect(Ads.appId, equals(FirebaseAdMob.testAppId));
//    expect(Ads.keywords.contains('foo'), isTrue);
//    expect(Ads.keywords.contains('bar'), isTrue);
//    expect(Ads.contentUrl, isNull);
//    expect(Ads.childDirected, isFalse);
//    expect(Ads.testDevices, isEmpty);
//    expect(Ads.testing, isTrue);
//  });
//
//  testWidgets('Header adds todo', (WidgetTester tester) async {
//    Key key = new UniqueKey();
//
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: TestApp(
//          2,
//          key: key,
//        ),
//      ),
//    ));
//
//    await tester.tap(find.byType(BannerAd));
//
//    expect(_event, equals('MobileAdEvent.opened'));
//
//    expect(Ads.appId, equals(FirebaseAdMob.testAppId));
//    expect(Ads.keywords.contains('ibm'), isTrue);
//    expect(Ads.keywords.contains('computers'), isTrue);
//    expect(Ads.contentUrl, equals('http://www.ibm.com'));
//    expect(Ads.childDirected, isFalse);
//    expect(Ads.testDevices.contains('Samsung_Galaxy_SII_API_26:5554'), isTrue);
//    expect(Ads.testing, isFalse);
//  });
//
//  testWidgets('Header adds todo', (WidgetTester tester) async {
//    Key key = new UniqueKey();
//
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: TestApp(
//          3,
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
//    Key key = new UniqueKey();
//
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: TestApp(
//          4,
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
//    Key key = new UniqueKey();
//
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: TestApp(
//          5,
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
//    Key key = new UniqueKey();
//
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: TestApp(
//          6,
//          key: key,
//        ),
//      ),
//    ));
//  });
//
//  testWidgets('Header adds todo', (WidgetTester tester) async {
//    Key key = new UniqueKey();
//
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: TestApp(
//          7,
//          key: key,
//        ),
//      ),
//    ));
//  });
//
//  testWidgets('Header adds todo', (WidgetTester tester) async {
//    Key key = new UniqueKey();
//
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: TestApp(
//          8,
//          key: key,
//        ),
//      ),
//    ));
//  });
//
//  testWidgets('Header adds todo', (WidgetTester tester) async {
//    Key key = new UniqueKey();
//
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: TestApp(
//          9,
//          key: key,
//        ),
//      ),
//    ));
//  });
//
//  testWidgets('Header adds todo', (WidgetTester tester) async {
//    Key key = new UniqueKey();
//
//    await tester.pumpWidget(MaterialApp(
//      home: Material(
//        child: TestApp(
//          10,
//          key: key,
//        ),
//      ),
//    ));
//  });
}

class TestApp extends StatefulWidget {
  TestApp(this.option, {Key key}) : super(key: key);
  final int option;
  @override
  _TestAppState createState() => _TestAppState(opt: option);
}

class _TestAppState extends State<TestApp> {
  _TestAppState({this.opt = 1});
  int opt;
  @override
  void initState() {
    super.initState();
    switch (opt) {
      case 1:
        Ads.init('ca-app-pub-3940256099942544', testing: true);

        Ads.showBannerAd(this);

        Ads.video.rewardedListener = (String rewardType, int rewardAmount) {
          _event = 'video.rewardedListener';
          setState(() {
            _coins += rewardAmount;
          });
        };

        break;
      case 2:
        var eventListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.opened) _event = 'MobileAdEvent.opened';
        };

        Ads.init(
          'ca-app-pub-3940256099942544',
          keywords: <String>['ibm', 'computers'],
          contentUrl: 'http://www.ibm.com',
          childDirected: false,
          testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
          testing: false,
          listener: eventListener,
        );

        Ads.showBannerAd(this);

        break;
      case 3:
        var eventListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.leftApplication)
            _event = 'MobileAdEvent.leftApplication';
        };

        Ads.init('ca-app-pub-3940256099942544',
            listener: eventListener, testing: true);

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

        Ads.showBannerAd(this);

        break;
      case 4:
        Ads.init('ca-app-pub-3940256099942544');

        var eventListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.closed) _event = 'MobileAdEvent.closed';
        };

        /// You can set the Banner, Fullscreen and Video Ads separately.

        Ads.setBannerAd(
          size: AdSize.banner,
          keywords: ['andriod, flutter'],
          contentUrl: 'http://www.andrioussolutions.com',
          childDirected: false,
          testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
          listener: eventListener,
        );

        Ads.setFullScreenAd(
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
          keywords: ['dart', 'java'],
          contentUrl: 'http://www.publang.org',
          childDirected: false,
          testDevices: null,
          listener: videoListener,
        );

        break;
      case 5:
        Ads.init('ca-app-pub-3940256099942544');

        /// You can set individual settings
        Ads.keywords = ['cats', 'dogs'];
        Ads.contentUrl = 'http://www.animalsaspets.com';
        Ads.childDirected = false;
        Ads.testDevices = ['Samsung_Galaxy_SII_API_26:5554'];

        /// Can set this at the init() function instead.
        Ads.testing = true;
        break;

      case 6:
        Ads.init('ca-app-pub-3940256099942544', testing: true);

        Ads.eventListener = (MobileAdEvent event) {
          switch (event) {
            case MobileAdEvent.loaded:
              _event = 'loaded';
              break;
            case MobileAdEvent.failedToLoad:
              _event += 'failedToLoad';
              break;
            case MobileAdEvent.clicked:
              _event += 'clicked';
              break;
            case MobileAdEvent.impression:
              _event += 'impression';
              break;
            case MobileAdEvent.opened:
              _event += 'opened';
              break;
            case MobileAdEvent.leftApplication:
              _event += 'leftApplication';
              break;
            case MobileAdEvent.closed:
              _event += 'closed';
              break;
            default:
              _event += 'default';
          }
        };

        Ads.showBannerAd(this);

        break;

      case 7:
        Ads.init('ca-app-pub-3940256099942544', testing: true);

        Ads.showBannerAd(this);

        Ads.bannerListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.opened) {
            _event = 'MobileAdEvent.opened';
          }
        };

        Ads.screenListener = (MobileAdEvent event) {
          if (event == MobileAdEvent.opened) {
            _event = 'MobileAdEvent.opened';
          }
        };

        Ads.videoListener = (RewardedVideoAdEvent event,
            {String rewardType, int rewardAmount}) {
          if (event == RewardedVideoAdEvent.opened) {
            _event = 'RewardedVideoAdEvent.opened';
          }
        };

        break;
      case 8:
        Ads.init('ca-app-pub-3940256099942544', testing: true);

        Ads.showBannerAd(this);

        Ads.banner.openedListener = () {
          _event = 'banner.openedListener One ';
        };

        Ads.banner.openedListener = () {
          _event = 'banner.openedListener Two';
        };

        Ads.banner.leftAppListener = () {
          _event = 'banner.leftAppListener';
        };

        Ads.banner.closedListener = () {
          _event = 'banner.closedListener';
        };

        break;
      case 9:
        Ads.init('ca-app-pub-3940256099942544', testing: true);

        Ads.showBannerAd(this);

        Ads.screen.openedListener = () {
          _event = 'screen.openedListener One';
        };

        Ads.screen.openedListener = () {
          _event = 'screen.openedListener Two';
        };

        Ads.screen.leftAppListener = () {
          _event = 'screen.leftAppListener';
        };

        Ads.screen.closedListener = () {
          _event = 'screen.closedListener';
        };

        break;
      case 10:
        Ads.init('ca-app-pub-3940256099942544', testing: true);

        Ads.showBannerAd(this);

        Ads.video.closedListener = () {
          _event = 'video.closedListener';
        };

        Ads.video.rewardedListener = (String rewardType, int rewardAmount) {
          _event = 'video.rewardedListener';
          setState(() {
            _coins += rewardAmount;
          });
        };

        break;

      default:
        Ads.init('ca-app-pub-3940256099942544', testing: true);

        Ads.showBannerAd(this);
    }
  }

  @override
  void dispose() {
    Ads.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('AdMob Plugin Test App'),
        ),
        body: new SingleChildScrollView(
          child: new Center(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new RaisedButton(
                    key: _showBanner,
                    child: const Text('SHOW BANNER'),
                    onPressed: () {
                      Ads.showBannerAd(this);
                    }),
                new RaisedButton(
                    key: _removeBanner,
                    child: const Text('REMOVE BANNER'),
                    onPressed: () {
                      Ads.hideBannerAd();
                    }),
                new RaisedButton(
                  key: _showFullScreen,
                  child: const Text('SHOW INTERSTITIAL'),
                  onPressed: () {
                    Ads.showFullScreenAd(this);
                  },
                ),
                new RaisedButton(
                  key: _showVideo,
                  child: const Text('SHOW REWARDED VIDEO'),
                  onPressed: () {
                    Ads.showVideoAd(this);
                  },
                ),
                new Text("You have $_coins coins."),
              ].map((Widget button) {
                return new Padding(
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
