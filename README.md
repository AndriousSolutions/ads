---

# Ads in your App in a Snap! 
###### A Flutter Example

Here you go, copy this file, ads.dart, and you're on your way to monetizing your Flutter app. I've written a DART class library to utilize the plugin, firebase_admob, so to quickly and easily implement ads into a Flutter app. Take it, make it better, and then share.
Ads by Example
In the first example listed below, it takes only three lines of code, to get a banner ad displayed in your app. All that's required of you is the 'AdMob id' you got when you signed up for an Adsense account. The id listed here is a 'test id' offered by Google and is to be used during development. Of course, keep yours confidential, but when using yours during development, supply instead the second parameter, testing, to the init() function. Doing so, as you see in the example below, and setting it to true will bring up only 'test ads.'

![Flutter AdMob](https://github.com/AndriousSolutions/ads/blob/master/test/images/AdMob%20and%20Flutter.png)

## AdMob by Google
If you've yet to get setup for AdMob, go to this website, https://firebase.google.com/docs/admob/, after downloading this file. You'll need your 'AdMob id.' Again, test id's are supplied by the plugin to be used during development since using your own id would violate 'AdMob by Google' policy. I mean, you can't be clicking ads on your own app, don't you know! That'd be cheating! 
![Three lines of code, and you've a Banner ad.](https://github.com/AndriousSolutions/ads/blob/master/test/images/01iniState.png)
It's best practice to call the 'Ads' init() function in a State object's iniState() function, and to call its dispose() function in the State object's corresponding dispose() function. The third function call is showBannerAd() and, as the name implies, it does just that.

## Beta You Bet!
Again, this 'Ads' library currently uses the plugin, firebase_admob, which is, as of this writing, still in beta. As such, Banner ads can only be positioned at the top or the bottom of the screen, animation is limited, the ads come in a infinite set of sizes. Lastly, 'native ads' (i.e. ads displayed on UI components native to the platform) are not yet supported.

## You've Got Options
Anyone who's read my past articles knows I'm always looking for options. We software developers love options, right? Well, of course, using this library, you've got options.
You can see, in the second example below, along with the required 'AdMob id', you've got nine other settings you can optionally use to describe the kind of ads you may wish to be associated with your app.

![Nine named parameters that match the named parameters used by the plugin.](https://github.com/AndriousSolutions/ads/blob/master/test/images/02initOptions.png)

Ten options to initialize and display an AdMob Banner ad.

## 'Setter' Your Options
So you see, you can supply these options directly in the init() function. However, you could also specify just one or two individually before showing your ads. I'm always looking for options:
![The Setters in the Ads Library.](https://github.com/AndriousSolutions/ads/blob/master/test/images/03AdsSetters.png)

## There's Getters and Setters
Of course, as well as setting them, you can readily retrieve the values of these settings if you need to for one reason or another. Below, you can see there are just as many getters as there are setters in this 'Ads' class. And so, you or another developer working on another part of the app have ready access to all the settings currently available by this 'Ads' class and consequently currently available by the firebase_admob plugin.

![The Getters in the Ads Library.](https://github.com/AndriousSolutions/ads/blob/master/test/images/04AdsGetters.png)

## It's All Static
As you can deduce by now, this 'Ads' class is using only static members and methods. This means they can be accessed or changed any time and anywhere in your app. Makes it that much easier to deal with ads in your app.

## And the Number of the Counting Shall Be…Three
There are three types of ads currently offered by the firebase_admob plugin. There's the traditional Banner ad, the Interstitial or full-screen ad that covers the interface of their host app when opened, and finally, there's the Video ad that also covers the screen when opened and then returns to the app when closed.

![Three types of ads.](https://github.com/AndriousSolutions/ads/blob/master/test/images/15Three%20Types%20Ads.png)

## It's an Event!
Looking inside the plugin, we see it watches for seven separate events when it comes to the Banner ad and the Full-screen ad. Everything from the much-called 'loaded' event to the 'impression' event. Which I think fires each time an individual ad is displayed in your app. I'm not certain however as there's not much API documentation for this plugin at the time of this writing either.

![Seven events are available to the Banner and Full-screen ad.](https://github.com/AndriousSolutions/ads/blob/master/test/images/05MobileAdEvents.png)

With Video ads, there are eight events made available to watch out for. Events are triggered, for example, when the video opens, when the video starts to play, and when the video has completed running. There's also an event that rewards the user for viewing the video.

![Eight events associated with a Video.](https://github.com/AndriousSolutions/ads/blob/master/test/images/06RewardVideoAdEvents.png)

## Listen and Earn!
Since the plugin supplies a whole bunch of events, I've implemented no less than eleven event listeners in this library. Look at the example below. The 'Ads.eventListener' is the granddaddy of event listeners for this library. With all the events the plugin watches out for, you can use this event listener to catch the ones you're particular interested in. It applies to the types of events shared by all three types of ads.

![Ads Event Listener Example.](https://github.com/AndriousSolutions/ads/blob/master/test/images/07GrandDaddyListener.png)

## Listen Up!
Again, you have three types of ads, and so, instead of using that 'granddaddy' listener above, each has its own set of event listeners. There's the bannerListener, the screenListner, and the videoListener. As you know, the Banner ad and the FullScreen ad use the same set of 'MobileAdEvent' events while the Video Ad has its own set under the event type, 'RewardedVideoAdEvent'. This means you can break up your event listeners by the type of ad if you want.

![Three 'type' of Event Listeners are available.](https://github.com/AndriousSolutions/ads/blob/master/test/images/08ListenersByType.png)

## Let's Get Specific
However, you know me, there's other options. Again, that 'granddaddy' event listener could get a little messy - what with possibly a very long switch-case statement and all those MobileAdEvent options. How about not just targeting the type of Ad, but instead targeting one particular event? How about assigning any number of event listeners to just one particular event? How about that?
Yes, you can assign as many listeners as you want to a particular event. You or someone else can. For example, someone else on your team working on another part of your app may also need to know when an ad is opened. Below, we've got two listeners that both fire when the Banner ad is clicked on and opened, we've got another when the user is leaving the app to then view the ad, and the last one when the ad from the Banner ad is closed, and the user is now returning to the app. How about that?

![Banner Listeners](https://github.com/AndriousSolutions/ads/blob/master/test/images/09BannerListeners.png)

As you've likely suspected, the Full-screen ad also has the same array of event listeners like the Banner ad. Again, there's seven separate events you can individually assign an event listener - and as many listeners as you like at that. How about that!

![Full-Screen Listeners](https://github.com/AndriousSolutions/ads/blob/master/test/images/10ScreenListeners.png)

Finally, you guessed it, the Video ad also has all the event listeners needed to catch each of all the possibly events currently issued to it by the firebase_admob plugin-eight events as of this writing. Below, there's an example of how to 'reward' a passed amount when the user has finished viewing a video.

![Video Event Listeners Example](https://github.com/AndriousSolutions/ads/blob/master/test/images/11VideoListeners.png)

## Clean Up After Your Ads
Display ads do take up resources. This 'Ads' library therefore provides you the means to clean up after yourself when you may want to close your ads at some point for some reason. Also, you're free to hide and then show them again if you like. You're able to 'clear' any listeners at any point as well - either individually or in one fell swoop!

![Ads Cleaner Listeners](https://github.com/AndriousSolutions/ads/blob/master/test/images/12AdsClearListeners.png)

## It's All in the Setup
As you see in the example below, you've options galore! You can setup all three types of ads with the one-time call to the init() function or individually because each type has their own 'set' function: setBannerAd(), setFullScreenAd() and setVideoAd(). Why would you do such a thing? Who knows! What am I…a mindreader?! Maybe you've got different plans for each type of ad. Regardless, you've got that option.

![Ways to setup for AdMob ads.](https://github.com/AndriousSolutions/ads/blob/master/test/images/13initStateSetups.png)

## A Flutter Example
The PUB website offers an example on how to implement the firebase_admob plugin. I've included that example in the following gist, AdMob in Flutter Example. However, you guessed it, this example instead uses the 'Ads' library to demonstrate ads in a Flutter app. Below is the main.dart file found in the example. I've highlighted where the 'Ads' class library is used.

![main.dart for AdMob Example](https://github.com/AndriousSolutions/ads/blob/master/test/images/14FlutterExample.png)

---

## Conclusion
This library was offered to you merely to make your life a little easier when it comes to displaying ads in your app. It may have its short-comings, but this simply is my way of contributing to our fledgling Flutter community. Flutter is the way to go in my opinion, and sharing code is one way to help make this community grow and go forward.