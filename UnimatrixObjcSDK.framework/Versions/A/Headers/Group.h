//
// Created by Shovan Joshi on 9/23/16.
// Copyright (c) 2016 Sprotsrocket. All rights reserved.
//

#import "Resource.h"
#import "Attributes.h"

@interface Group : Resource

typedef void (^APIQueryCompletionGroupBlock) (Group *group, NSError *error);

@property (nonatomic, retain) NSString     *name;
@property (nonatomic, retain) NSString     *typeName;
@property (nonatomic, retain) NSString     *longDescription;
@property (nonatomic, retain) NSString     *shortDescription;
@property (nonatomic, retain) NSString     *slug;
@property (nonatomic, retain) NSNumber     *pictureID;
@property (nonatomic, retain) NSNumber     *sponsorID;
@property (nonatomic, strong) NSString     *UID;
@property (nonatomic, retain) NSDate       *createdAt;
@property (nonatomic, retain) NSDate       *updatedAt;
@property (nonatomic, retain) NSArray      *artifacts;
@property (nonatomic, retain) NSArray      *pictures;
@property int propertyID;

+ (Attributes *)attributes;
+ (void)getGroup:(NSString *)groupName forProperty:(int)propertyID onCompletion:(APIQueryCompletionGroupBlock)callback;

@end
