//
// Created by Shovan Joshi on 7/14/16.
// Copyright (c) 2016 Sprotsrocket. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Property;
@class Video;
@class Artifact;

@interface SRVideo : NSObject

typedef void (^VideoAPIQueryCompletionBlock) (Artifact *artifact, Video *video, NSError *error);
typedef void (^PropertyVideoAPIQueryCompletionBlock) (Property *property, Artifact *artifact, id response, NSError *error);

+ (void)getVideo:(NSString *)videoUID  onCompletion:(PropertyVideoAPIQueryCompletionBlock)callback;

@end