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