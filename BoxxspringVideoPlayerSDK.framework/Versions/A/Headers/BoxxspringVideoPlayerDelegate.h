//
//  BoxxspringVideoPlayerDelegate.h
//  BoxxspringVideoPlayerSDK
//
//  Created by Shovan Joshi on 11/10/15.
//  Copyright © 2015 Bedrocket Media. All rights reserved.
//


@class Restriction;

@protocol BoxxspringVideoPlayerDelegate <NSObject>


- (void)didPause;
- (void)didPlay;
- (void)didFailToLoad;

@optional
- (void)didEnterFullScreen;
- (void)didExitFullScreen;
- (void)didTapScreen;
- (void)isReady;
- (void)didGetRestricted:(Restriction *)restriction;

@end