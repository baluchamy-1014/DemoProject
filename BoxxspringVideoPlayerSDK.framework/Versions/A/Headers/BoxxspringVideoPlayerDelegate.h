//
//  BoxxspringVideoPlayerDelegate.h
//  BoxxspringVideoPlayerSDK
//
//  Created by Shovan Joshi on 11/10/15.
//  Copyright © 2015 Bedrocket Media. All rights reserved.
//

@protocol BoxxspringVideoPlayerDelegate <NSObject>

- (void)didPause;
- (void)didPlay;

@optional
- (void)didEnterFullScreen;
- (void)didExitFullScreen;
- (void)didTapScreen;
- (void)isReady;

@end