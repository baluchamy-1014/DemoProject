//
// Created by Shovan Joshi on 7/22/16.
// Copyright (c) 2016 Sprotsrocket. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Artifact;
@class Property;

@interface SRVideoPlayerAnalytics : NSObject

@property (nonatomic, strong) Artifact *artifact;
@property (nonatomic, strong) Property *property;

- (instancetype)initWithProperty:(Property*)aProperty andArtifact:(Artifact *)artifact;

@end