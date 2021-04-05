
## 3.0.0-beta01
 April 05, 2021
- Replaced firebase_admob with google_mobile_ads
- Upgraded to Flutter 2.12.0 with null safety

## 2.2.0
 January 17, 2021
- firebase_admob: ">=0.10.0 <1.0.0"

## 2.1.1+2
 September 30, 2020
- String factoryId to Ads constructor
- Complete incorporation of 'native ad' to Ads class.

## 2.1.0
 September 30, 2020
- Incorporate plugin's Native ads
- Upgraded to firebase_admob: ^0.10.0

## 2.0.0
 September 18, 2020
- Upgraded to firebase_admob: 0.10.0-dev.1

## 1.7.3
 June 04, 2020
- Corrected Apache Licence

## 1.7.2
 December 22, 2019
- further modified README.md

## 1.7.1
 December 21, 2019
- corrected README.md;

## 1.7.0
 November 07, 2019
- errorListener in setBannerAd() and others.
- removeBannerAd(); in dispose();

## 1.6.1
 November 05, 2019
- _eventErrors?.isNotEmpty || getter was called on null

## 1.6.0
 November 05, 2019
- New getter eventError
- New function getEventError 
- Logcat Event Errors
 
## 1.5.2
 November 05, 2019
- Add assert(_eventErrors.isEmpty,"Errors in Ad Events! Refer to logcat.");

## 1.5.1
 November 04, 2019
- local variable, show, was shadowed in showBannerAd()

## 1.5.0
 November 03, 2019
- Pass empty keywords and testDevices to override any previous values
- Allows a MobileAdListener listener to be added to a VideoAd

## 1.4.2
 November 02, 2019
- if (targetInfo == null) in _loadVideo()
- Removed MobileAdTargetingInfo _info from AdMob
- Removed bool _inError = false; from Ads

## 1.4.1
 November 01, 2019
- await dispose();
- Removed "" from adUnitId = "";
- _adUnitId ??= adUnitId;
- Add parameters to _bannerAd.show();

## 1.4.0
 October 31, 2019
- Additional parameters to Ads constructor
  - AdSize size,
  - double anchorOffset,
  - double horizontalCenterOffset,
  - AnchorType anchorType, 
  - bool nonPersonalizedAds,
    
## 1.3.0
 October 31, 2019
- Set Ads in constructor
- Future\<bool\> setBannerAd
- Future\<bool\> showBannerAd
- Future\<bool\> showFullScreenAd
- Future\<bool\> setVideoAd
- Future\<bool\> showVideoAd
- MobileAd.show() tries again if it fails
- size: _showSize ?? _setSize ?? AdSize.banner,
- MobileAd.horizontalCenterOffset
- New functions in Ads class:
  - inError 
  - getError()
  - bannerError 
  - getBannerError()
  - screenError 
  - getScreenError()
  - videoError 
  - getVideoError()
  - removeBannerAd()
  
## 1.2.1
 October 30, 2019
- set_Ad() in show_Ad() if _Ad == null

## 1.2.0
 September 19, 2019
- closeBannerAd({bool load = false}) Reload Banner Ad into memory when closed.
- updated README.md

## 1.1.0
 September 18, 2019
- Reload the ad into memory with every close
- MobileAds.load() and MobileAds._createAd()
- Include parameters for setBannerAd()
- Removed _targetInfo() from Ads class
- firebase_admob: any

## 1.0.1
 August 05, 2019
- Renamed admob.dart

## 1.0.0
 August 05, 2019
- Internal rewrite readying class for public use
- Deprecated hideBannerAd() & hideFullScreenAd()
- List listeners to Set if(listener != null)
- Replaced AdEventListener with MobileAdListener
- Replaced VideoEventListener with RewardedVideoAdListener
- testDevices.every((String s) => s == null || s.isNotEmpty))

## 0.12.0
 August 01, 2019
- Async setFullScreenAd hideFullScreenAd showBannerAd showFullScreenAd

## 0.11.0
 July 11, 2019
- bool removeVideo(VideoEventListener listener)

## 0.10.1
 July 11, 2019
- updated README.md with static reference example.

## 0.10.0
 July 04, 2019
- try..catch statements in event handlers.

## 0.9.2
 July 03, 2019
- Updated the file, README.md, include adding a Firebase project to your app.

## 0.9.1
  June 29, 2019
- Remove assert statements, assert(_firstObject, "An Ads class is already instantiated!");

## 0.9.0
  June 25, 2019
- Remove static properties and methods; Many set to library-private. 
- Using a generative constructor

## 0.8.2
  June 27, 2019
- Private constructor, Ads._():super();

## 0.8.1
  June 22, 2019
- Corrected showVideoAd() bug
- Update README.md

## 0.8.0
  June 21, 2019
- Added all parameters to showBannerAd(), showFullScreenAd() and showVideoAd() 
- Add getter, childDirected.
- Removed setters bannerUnitId, screenUnitId, videoUnitId, keywords, contentUrl
- Removed getters appId, bannerUnitId, screenUnitId, videoUnitId
- Deprecated getters bannerAd, fullScreenAd and videoAd

## 0.7.1
  June 19, 2019
- Supply the getter, testing.

## 0.7.0
  June 19, 2019
- Removed the property, testing.
- Add testing parameter to 'set' functions.

## 0.6.1
  June 19,2019
- assert(appId != null && appId.isNotEmpty)
- Semantic versioning ^0.9.0

## 0.6.0
  June 10, 2019
- Allow for multiple unitId's: One at init() and one when setting ads.
- Removed the deprecated parameters: designedForFamilies and birthday 

## 0.5.1
  June 08, 2019
- Allow for the most recent firebase_admob plugin in the example as well

## 0.5.0
  June 08, 2019
- Allow for always the most recent firebase_admob plugin

## 0.4.2
  May 22, 2019
- Provided setters for adUnitId
- Clear memory variables before setting ad
- Show Video after RewardedVideoAdEvent.loaded

## 0.4.1
  May 21, 2019
- if (adUnitId.isNotEmpty) _bannerUnitId = adUnitId.trim();

## 0.4.0
  May 21, 2019
- A distinction now between App id and Unit id
- Each type of ad has been designated their own unit id.

## 0.3.0
  April 02, 2019
- Upgraded to firebase_admob: ^0.8.0 making this AndroidX compatible.
- **Note** Those not wishing to use AndroidX support files must remain with 0.2.0.

## 0.2.0
  March 24, 2019. 
- The named parameters, anchorOffset and anchorType, are supplied to the functions, showBannerAd() and showFullScreenAd()
- **Breaking Change** As a consequence the named parameter, state, is now used in all the show() functions.

## 0.1.5+3
  March 15, 2019. 
- Supplied a secure image for the YouTube Video onto README.md.

## 0.1.5+2
  March 15, 2019. 
- Append YouTube Video onto README.md.

## 0.1.5+1
  March 15, 2019. 
- Updated README.md.

## 0.1.5
  March 15, 2019. 
- Provided API Documentation.

## 0.1.4
  March 14, 2019. 
- Supplied a Homepage in pubspec.yaml

## 0.1.3
  March 14, 2019. 
- Lengthened pubspec description.
- Delete erroneous files
- Delete folders, _windows & codestyles

## 0.1.2
  March 14, 2019. 
- Corrected image in README.md
- Format files

## 0.1.1
  March 14, 2019. 
- Corrected images in README.md

## 0.1.0
  March 14, 2019. 
- Initial Release
- Remove deprecated fields: birthday, gender, designedForFamilies

## 0.1.0 
  December 11, ‎2018. 
- if (contentUrl == null || contentUrl.isEmpty)  if(devices == null)

## 0.0.2 
  December 03, ‎2018. 
- sdk: ">=2.0.0 <5.0.0"

## 0.0.1 
‎  May ‎29, ‎2018. 
- Initial Development Release