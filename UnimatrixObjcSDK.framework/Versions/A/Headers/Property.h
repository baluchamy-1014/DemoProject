//
//  Property.h
//  VideoPlayerSDK
//
//  Created by Shovan Joshi on 11/22/15.
//  Copyright © 2015 Bedrocket Media. All rights reserved.
//

#ifndef Property_h
#define Property_h

#import "Resource.h"
#import "Attributes.h"

@class Setting;

@interface Property : Resource

@property (nonatomic, strong) NSString     *name;
@property (nonatomic, strong) NSString     *typeName;
@property (nonatomic, strong) NSString     *domainName;
@property (nonatomic, strong) NSString     *realmUUID;

@property (nonatomic, strong) NSArray      *settings;
@property (nonatomic, strong) NSArray      *campaigns;

+ (Attributes *)attributes;
+ (void)getProperty:(id)propertyIdentifier
       onCompletion:(APIQueryCompletionBlock)callback;

- (NSString *)mediaHostString;
- (Setting *)streamSetting;
- (NSString *)streamHostString;
@end

#endif /* Property_h */
