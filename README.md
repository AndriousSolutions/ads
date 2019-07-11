# Add Ads to your App in a Snap! 
This Dart package will utilize the plugin, **firebase_admob**, so to quickly and easily implement ads into a Flutter app.
## Sign Up and Get Your ID’s
First and foremost, you have to [sign up for AdMob](https://support.google.com/admob/answer/7356219?hl=en). Please, turn to [AdMob Help](https://support.google.com/admob) for further guidance on this. You’re going to have to go to your [Google AdMob Dashboard](https://apps.admob.com/v2/apps/list?pli=1) and get your id’s as well. There’s the ‘app ID’ used to identify your individual app, and there’s individual unit ID’s unique to each ‘type’ of ad you decide to use. Currently, there are three types: a Banner ad, an Interstitial ad, and a Video ad. Might as well do all that now, and then come back here to learn how to display such ads in your Flutter app. 
[![GoogleAdMob](https://user-images.githubusercontent.com/32497443/59965408-8add0500-94db-11e9-9c28-2f161ccfb62e.png "Google Admob Dashboard")](https://apps.admob.com/v2/home?pli=1)

## It’s A Test. Not For Real
Note, test id’s are supplied by the plugin to be used during development. Using your own id would violate ‘AdMob by Google’ policy. You can’t be clicking ads on your own app. They’ll know.

## For Android, Modify AndroidManifest.xml
A common error you may encounter when trying this package out is Google complaining that the AdMob was not properly initialized. Merely follow the directions below to resolve this:
[![androidManifest](https://user-images.githubusercontent.com/32497443/54394329-ef89f780-4682-11e9-9539-3edeab1c7351.png)](https://developers.google.com/admob/android/quick-start#update_your_androidmanifestxml)
## For iOS, Update your Info.plist
[![Info.plist](https://user-images.githubusercontent.com/32497443/59237381-14c9cb80-8bc8-11e9-9bd7-c104fdde2f5e.png)](https://developers.google.com/admob/ios/quick-start#update_your_infoplist)
and add
![Info plist](https://user-images.githubusercontent.com/32497443/59237573-c406a280-8bc8-11e9-9600-cb051d068573.png)

## Your App's Analytics in Ads 
So, you created an AdMob account in order to monetize with ads in your production app. However, the kind of ads displayed will get a little help if you assign a Firebase project to your app as well. In fact, it's been suggested to be an esstential step, [Missing setup steps in readme](https://github.com/AndriousSolutions/ads/issues/9). This is yet to be confirmed however. Regardless, turn to the links below to add Firebase to your app: [Add Firebase to your iOS project](https://firebase.google.com/docs/ios/setup#create-firebase-project) and [Add Firebase to your Android project](https://firebase.google.com/docs/android/setup#create-firebase-project)
[![FirebaseToiOS](https://user-images.githubusercontent.com/32497443/60599891-35c3ad80-9d7d-11e9-9c1d-e258fbb0add9.png)](https://firebase.google.com/docs/ios/setup#create-firebase-project)
[![FirebaseToAndroid](https://user-images.githubusercontent.com/32497443/60599892-35c3ad80-9d7d-11e9-928f-cee55d4344ab.png)](https://firebase.google.com/docs/android/setup#create-firebase-project)

## failed to load ad : 3
[![errorLoadAd03](https://user-images.githubusercontent.com/32497443/59965843-55d3b100-94e1-11e9-909a-d27de8ac8fa1.png "failed to load ad : 3")](https://stackoverflow.com/questions/33566485/failed-to-load-ad-3#answer-33712905)
Patience is a virtue. The only errors I consistently receive from users are not of the Dart package itself, but are due to Google. Once the user has registered with Google, a common complaint is there’s still only ‘test’ ads being displayed, but that’s because it’ll take some hours if not a day to receive production ads. Wait a day, and see for yourself.

## There Must Only Be One!
Try instantiating more than one Ads object, and you'll be a little dissappointed if not down right confused. It'll appear the second Ads object is not working, and you'd be right.
```Java
    _ads = Ads(
      appId,
      bannerUnitId: bannerUnitId,
      screenUnitId: screenUnitId,
      keywords: <String>['ibm', 'computers'],
      contentUrl: 'http://www.ibm.com',
      childDirected: false,
      testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
      listener: eventListener,
    );

    _adsTest = Ads(
      appId,
      bannerUnitId: bannerUnitId,
      screenUnitId: screenUnitId,
      keywords: <String>['ibm', 'computers'],
      contentUrl: 'http://www.ibm.com',
      childDirected: false,
      testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
      listener: eventListener,
    );
```
The Google plugin is designed to work with one app and its set of ads. That's all. Creating another Ads object will serve no purpose for you because the Ads Dart package will be aware of the first one and work only with that one. Note, they'll be no 'error message' or notification there's more than one Ads object. The Dart package is designed not to be that disruptive in development or in production. The second object will just not do anything. It simply won't work, and will record the reason why in the log files. That's all.

## Keep It Static
A means to have access to the Ads instance from 'anywhere' in our app would be to have it all contained in a static ulitity class. Below only the showBannerAd() and dispose() functions are implemented, but you'll get the idea and should able to implement any and all the functions you require:
#### AppAds.dart
```Java
class AppAds {
  static Ads _ads;

  static final String _appId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544~3347511713'
      : 'ca-app-pub-3940256099942544~1458002511';

  static final String _bannerUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  /// Assign a listener.
  static AdEventListener _eventListener = (MobileAdEvent event) {
    if (event == MobileAdEvent.clicked) {
      print("The opened ad is clicked on.");
    }
  };

  static void showBanner(
          {String adUnitId,
          AdSize size,
          List<String> keywords,
          String contentUrl,
          bool childDirected,
          List<String> testDevices,
          bool testing,
          AdEventListener listener,
          State state,
          double anchorOffset,
          AnchorType anchorType}) =>
      _ads?.showBannerAd(
          adUnitId: adUnitId,
          size: size,
          keywords: keywords,
          contentUrl: contentUrl,
          childDirected: childDirected,
          testDevices: testDevices,
          testing: testing,
          listener: listener,
          state: state,
          anchorOffset: anchorOffset,
          anchorType: anchorType);

  static void hideBanner() => _ads?.hideBannerAd();

  /// Call this static function in your State object's initState() function.
  static void init() => _ads ??= Ads(
        _appId,
        bannerUnitId: _bannerUnitId,
        keywords: <String>['ibm', 'computers'],
        contentUrl: 'http://www.ibm.com',
        childDirected: false,
        testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
        testing: false,
        listener: _eventListener,
      );

 /// Remember to call this in the State object's dispose() function.
  static void dispose() => _ads?.dispose();

  /// Expose the 'event handling' capabilities to the World as well
  /// Set a Banner Ad Event Listener.

  /// Set an Ad Event Listener.
  set eventListener(AdEventListener listener) =>
      _ads?.eventListener = listener;

  /// Remove a specific Add Event Listener.
  bool removeEvent(AdEventListener listener) =>
      _ads?.removeEvent(listener);

  /// Set an Banner Event Listener.
  set bannerListener(AdEventListener listener) =>
      _ads?.bannerListener = listener;

  /// Remove a specific Banner Ad Event Listener.
  bool removeBanner(AdEventListener listener) =>
      _ads?.removeBanner(listener);

  /// Set a Full Screen Ad Event Listener.
  set screenListener(AdEventListener listener) =>
      _ads?.screenListener = listener;

  /// Remove a Full Screen Ad Event Listener.
  bool removeScreen(AdEventListener listener) =>
      _ads?.removeScreen(listener);

  /// Set a Video Ad Event Listener
  set videoListener(VideoEventListener listener) =>
      _ads?.videoListener = listener;

  /// Remove a specific Video Ad Event Listener.
  set removeVideo(VideoEventListener listener) =>
      _ads?.removeVideo = listener;
}
```
Simply import the Dart file, AppAds.dart, in this case to any library file you would need access to the Ads for one reason or another, and you're on your way.

## There's An Article On This
There is an extensive article about this Dart package available on medium.com:
[Add Ads To Your App in a Snap!](https://medium.com/@greg.perry/add-ads-in-your-app-in-a-snap-a980d2050ef9?postPublishedType=repub)

[![admobFlutter03](https://user-images.githubusercontent.com/32497443/59965197-e4900000-94d8-11e9-9cc2-b1519d22201d.png "Add Ads to Your App in a Snap!")](https://medium.com/@greg.perry/add-ads-in-your-app-in-a-snap-a980d2050ef9?postPublishedType=repub)

## How it works
![appCodeSample](https://user-images.githubusercontent.com/32497443/59967883-ec629b00-94fe-11e9-8223-600e100b9d8c.png)
gist: [AdMobAdsExample.dart](https://gist.github.com/Andrious/889f8774ddeee409a640e3cd4c10e7f4#file-admobadsexample-dart)
```Java
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:firebase_admob/firebase_admob.dart';

import 'package:ads/ads.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Ads appAds;
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

    /// Assign a listener.
    var eventListener = (MobileAdEvent event) {
      if (event == MobileAdEvent.opened) {
        print("The opened ad is clicked on.");
      }
    };

    appAds = Ads(
      appId,
      bannerUnitId: bannerUnitId,
      screenUnitId: screenUnitId,
      keywords: <String>['ibm', 'computers'],
      contentUrl: 'http://www.ibm.com',
      childDirected: false,
      testDevices: ['Samsung_Galaxy_SII_API_26:5554'],
      testing: false,
      listener: eventListener,
    );

    appAds.setVideoAd(
      adUnitId: videoUnitId,
      keywords: ['dart', 'java'],
      contentUrl: 'http://www.publang.org',
      childDirected: true,
      testDevices: null,
      listener: (RewardedVideoAdEvent event,
          {String rewardType, int rewardAmount}) {
        print("The ad was sent a reward amount.");
        setState(() {
          _coins += rewardAmount;
        });
      },
    );

    appAds.showBannerAd();
  }

  @override
  void dispose() {
    appAds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('AdMob Ad Examples'),
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
                      appAds.showBannerAd(state: this, anchorOffset: null);
                    }),
                RaisedButton(
                    key: ValueKey<String>('REMOVE BANNER'),
                    child: const Text('REMOVE BANNER'),
                    onPressed: () {
                      appAds.hideBannerAd();
                    }),
                RaisedButton(
                  key: ValueKey<String>('SHOW INTERSTITIAL'),
                  child: const Text('SHOW INTERSTITIAL'),
                  onPressed: () {
                    appAds.showFullScreenAd(state: this);
                  },
                ),
                RaisedButton(
                  key: ValueKey<String>('SHOW REWARDED VIDEO'),
                  child: const Text('SHOW REWARDED VIDEO'),
                  onPressed: () {
                    appAds.showVideoAd(state: this);
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
```

## Beta You Bet!
As of this writing, **firebase_admob**, is still in beta. As such, Banner ads can only be positioned at the top or the bottom of the screen, animation is limited, the ads come in a infinite set of sizes. Lastly, 'native ads' (i.e. ads displayed on UI components native to the platform) are not yet supported.

## And the Number of the Counting Shall Be…Three
There are three types of ads currently offered by the firebase_admob plugin. There's the traditional Banner ad, the Interstitial or full-screen ad that covers the interface of their host app when opened, and finally, there's the Video ad that also covers the screen when opened and then returns to the app when closed.

![Three types of ads.](https://user-images.githubusercontent.com/32497443/54376841-4929fc00-465a-11e9-9343-3438f5fd802e.png)


## It's an Event!
The plugin, **firebase_admob**, watches for seven separate events when it comes to the Banner ad and the Full-screen ad. Everything from the much-called 'loaded' event to the 'impression' event---which I think fires each if the user has been looking at the ad for so long that the ad itself has refreshed itself. I'm not certain however as there's not much API documentation for this plugin at the time of this writing either.

Below is the the enumerated values currently describing the currently supported events:

![Seven events are available to the Banner and Full-screen ad.](https://user-images.githubusercontent.com/32497443/54376782-2ef01e00-465a-11e9-9fc5-1b3de42dab5a.png)

With Video ads, there are eight events made available to watch out for. Events are triggered, for example, when the video opens, when the video starts to play, and when the video has completed running. There's also an event that rewards the user for viewing the video.

![Eight events associated with a Video.](https://user-images.githubusercontent.com/32497443/54376787-31eb0e80-465a-11e9-8678-4a89f4f4c5d7.png)

## Listen and Earn!
Since the plugin supplies a whole bunch of events, I've implemented no less than eleven event listeners in this library. The gist provided above lists all the possibles ways to set an event handler on all the types of ads offered by the plugin.

The Banner ad and the FullScreen ad use the same set of 'MobileAdEvent' events while the Video Ad has its own set under the event type, 'RewardedVideoAdEvent'. This means you can break up your event listeners by the type of ad if you want.

Yes, you can assign as many listeners as you want to a particular event. You or someone else can. For example, someone else on your team working on another part of your app may also need to know when an ad is opened.

## The Main Event Listener
There is a setter called, *eventListener*, that you can use to catch 'MobileAdEvent' events. Again, currently there is seven events defined so far and are used by the Banner ad and the Full-Screen (Interstitial) ad.
```Java
  appAds.eventListener = (MobileAdEvent event) {
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
```
Again, you can assign a listener at the **init**() function and at the 'set' functions---any number of listeners you like. There's functions available to remove these listeners as well of course.

## The Banner Listener
The Banner ad has its own *setter*. You can see below it's called *bannerListener*.
```Java
  appAds.bannerListener = (MobileAdEvent event) {
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
        print("The ad is now open.");
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
```
## The Full-Screen Listener
The *setter* for the Interstitial ad is called *screenListener*.
```Java
  appAds.screenListener = (MobileAdEvent event) {
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
        print("The ad is now open.");
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
```
## The Video Listener
Finally, the *setter* for the Video ad is called *videoListener*.
```Java
  appAds.videoListener =
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
```
## A Event Listener For Every Occasion
This last section provides yet another way to implement a specific event listeners for your ads:
```Java
  appAds.banner.loadedListener = () {
    print("An ad has loaded successfully in memory.");
  };

  appAds.banner.failedListener = () {
    print("An ad failed to load into memory.");
  };

  appAds.banner.clickedListener = () {
    print("The opened ad is clicked on.");
  };

  appAds.banner.impressionListener = () {
    print("The user is still looking at the ad. A new ad came up.");
  };

  appAds.banner.openedListener = () {
    print("The ad has opened.");
  };

  appAds.banner.leftAppListener = () {
    print("You left the app and gone to the ad's website.");
  };

  appAds.banner.impressionListener = () {
    print("The user is still looking at the ad. A new ad came up.");
  };

  appAds.banner.closedListener = () {
    print("You've closed an ad and returned to your app.");
  };

  appAds.screen.loadedListener = () {
    print("An ad has loaded into memory.");
  };

  appAds.screen.failedListener = () {
    print("An ad has failed to load in memory.");
  };

  appAds.screen.clickedListener = () {
    print("The opened ad was clicked on.");
  };

  appAds.screen.impressionListener = () {
    print("You've clicked on a link in the open ad.");
  };

  appAds.screen.openedListener = () {
    print("The ad has opened.");
  };

  appAds.screen.leftAppListener = () {
    print("The user has left the app and gone to the opened ad.");
  };

  appAds.screen.closedListener = () {
    print("The ad has been closed. The user returns to the app.");
  };

  appAds.video.loadedListener = () {
    print("An ad has loaded in memory.");
  };

  appAds.video.failedListener = () {
    print("An ad has failed to load in memory.");
  };

  appAds.video.clickedListener = () {
    print("An ad has been clicked on.");
  };

  appAds.video.openedListener = () {
    print("An ad has been opened.");
  };

  appAds.video.leftAppListener = () {
    print("You've left the app to view the video.");
  };

  appAds.video.closedListener = () {
    print("The video has been closed.");
  };

  appAds.video.rewardedListener = (String rewardType, int rewardAmount) {
    print("The ad was sent a reward amount.");
  };

  appAds.video.startedListener = () {
    print("You've just started playing the Video ad.");
  };

  appAds.video.completedListener = () {
    print("You've just finished playing the Video ad.");
  };
```

## Add Up Ad Errors
Below is a screenshot of some sample code implementing the error handling available to you when using the Dart package, Ads. By design, any exceptions that may occur in an event listeners' code is caught in a **try..catch** statement. The goal is to not crash the app for any reason involving AdMob ads. However, if and when an does error occurs, the developer has the means to determine the issue by collecting such errors in the List object, *eventErrors*.
![eventError](https://user-images.githubusercontent.com/32497443/60682408-e652af80-9e58-11e9-9c7a-259b0b0c6577.jpg)