//
// Created by Shovan Joshi on 1/12/17.
// Copyright (c) 2017 Sprotsrocket. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Artifact.h"

@class Stream;

@interface StreamArtifact : Artifact

@property (nonatomic, retain) Stream *stream;

@end