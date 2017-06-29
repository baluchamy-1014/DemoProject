//
//  BoxxspringVideoPlayer.h
//  BoxxspringVideoPlayer
//
//  Created by Shovan Joshi on 10/14/15.
//  Copyright © 2015 Bedrocket Media. All rights reserved.
//

#ifndef BoxxspringVideoPlayer_h
#define BoxxspringVideoPlayer_h

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BoxxspringVideoPlayerDelegate.h"

@interface BoxxspringVideoPlayer : NSObject

@property (weak, nonatomic) id <BoxxspringVideoPlayerDelegate> delegate;
@property (assign, nonatomic) BOOL fullScreen;

typedef NS_ENUM(NSInteger, BoxxspringVideoPlayerControls) {
  BoxxspringVideoPlayerControlsNormal = 0,
  BoxxspringVideoPlayerControlsLimited = 1,
  BoxxspringVideoPlayerControlsFull = 2
};

@property (nonatomic, assign) BoxxspringVideoPlayerControls fullScreenControls;

- (instancetype)init:(NSString *)artifactID
          forProperty:(int)propertyID
            withFrame:(CGRect)frame;

- (instancetype)init:(NSString *)videoUID
           withFrame:(CGRect)frame;

- (void)description;
- (UIView *)view;
- (void)play;
- (void)pause;

- (void)toggleScreenMode;

@end

#endif /* BoxxspringVideoPlayer_h */
