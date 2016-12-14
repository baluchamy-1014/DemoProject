//
// Created by Shovan Joshi on 10/13/16.
// Copyright (c) 2016 Sprotsrocket. All rights reserved.
//


#import "Resource.h"
#import "Attributes.h"

@interface ArtifactRelationship : Resource

typedef void (^APIQueryCompletionBlock) (id response, NSError *error);

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, retain) NSDate   *createdAt;
@property (nonatomic, retain) NSDate   *updatedAt;
@property (nonatomic, retain) NSNumber *artifactID;
@property (nonatomic, retain) NSNumber *relatedArtifactID;
@property (nonatomic, strong) NSArray  *relatedArtifacts;
@property int relatedArtifactPosition;

+ (void)query:(int)artifactID forProperty:(int)propertyID onCompletion:(APIQueryCompletionBlock)callback;

@end