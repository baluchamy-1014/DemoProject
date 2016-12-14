//
//  BoxxspringVideoPlayerView.h
//  BoxxspringVideoPlayerSDK
//
//  Created by Shovan Joshi on 12/9/15.
//  Copyright © 2015 Bedrocket Media. All rights reserved.
//

#ifndef BoxxspringVideoPlayerView_h
#define BoxxspringVideoPlayerView_h


#import <UIKit/UIKit.h>
//#import "BoxxspringVideoPlaybackControlsView.h"
#import "BoxxspringVideoPlayerDelegate.h"
#import "BoxxspringVideoPlayer.h"

@class AVPlayer;

@interface BoxxspringVideoPlayerView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, weak) BoxxspringVideoPlayer* boxxspringPlayer;
@property (nonatomic, weak) AVPlayer* player;
@property (nonatomic, strong) UIView *fullscreenVideoBackgroundView;
@property (nonatomic, weak) id<BoxxspringVideoPlayerDelegate> delegate;

- (void)play;
- (void)pause;

@end

#endif /* BoxxspringVideoPlayerView_h */
