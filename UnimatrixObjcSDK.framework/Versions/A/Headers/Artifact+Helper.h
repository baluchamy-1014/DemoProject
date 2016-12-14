//
// Created by Shovan Joshi on 9/29/16.
// Copyright (c) 2016 Sprotsrocket. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Artifact.h"

@interface Artifact (Helper)
// helper methods
+ (void)getVideoArtifacts:params
               propertyID:(int)propertyID
                    count:(int)count
             onCompletion:(APIQueryCompletionBlock)callback;
@end