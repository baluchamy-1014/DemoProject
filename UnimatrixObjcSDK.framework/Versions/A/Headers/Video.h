//
//  Video.h
//  VideoPlayerSDK
//
//  Created by Shovan Joshi on 11/5/15.
//  Copyright © 2015 Shovan Joshi. All rights reserved.
//

#ifndef Video_h
#define Video_h

#import "Resource.h"
#import "Attributes.h"

@interface Video : Resource

@property (nonatomic, strong) NSString     *name;
@property (nonatomic, strong) NSString     *typeName;
@property (nonatomic, strong) NSString     *pictureID;
@property (nonatomic, strong) NSString     *storageKey;
@property (nonatomic, strong) NSArray      *videoSources;
@property (nonatomic, strong) NSArray      *tracks;

+ (Attributes *)attributes;
+ (void)getVideo:(NSString *)providerUID  onCompletion:(APIQueryCompletionBlock)callback;

- (NSURL *)url:(NSString *)string;
@end

#endif /* Video_h */
