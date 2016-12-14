//
// Created by Shovan Joshi on 3/4/16.
// Copyright (c) 2016 Bedrocket Media. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Resource.h"
#import "Attributes.h"

@interface Campaign : Resource

@property (nonatomic, strong) NSString     *name;
@property (nonatomic, strong) NSString     *typeName;
@property (nonatomic, strong) NSString     *state;
@property (nonatomic, strong) NSString     *urlPattern;

@property int videoAdvertisementID;
@property int displayAdvertisementID;
@property int filterID;
@property int position;

@property (nonatomic, strong) NSArray      *filters;
@property (nonatomic, strong) NSArray      *videoAdvertisements;
+ (void)getCampaigns:(int)propertyID onCompletion:(APIQueryCompletionBlock)callback;

@end