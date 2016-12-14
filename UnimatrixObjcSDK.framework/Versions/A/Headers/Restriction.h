//
//  Restriction.h
//  VideoPlayerSDK
//
//  Created by Shovan Joshi on 12/2/15.
//  Copyright © 2015 Bedrocket Media. All rights reserved.
//

#ifndef Restriction_h
#define Restriction_h

#import "Resource.h"
#import "Attributes.h"

@interface Restriction : Resource

typedef void (^APIQueryCompletionBlock) (id response, NSError *error);

@property (nonatomic, strong) NSString     *name;
@property (nonatomic, strong) NSString     *uuid;
@property (nonatomic, strong) NSString     *typeName;
@property (nonatomic, strong) NSString     *filterUUID;
@property (nonatomic, strong) NSString     *method;
@property (nonatomic, strong) NSString     *geographicRegionUUID;

@property int propertyID;

+ (Attributes *)attributes;
+ (void)getRestriction:(int)artifactID
           forProperty:(int)propertyID
              andRealm:(NSString *)realm
        andAccessToken:(NSString *)accessToken
          onCompletion:(APIQueryCompletionBlock)callback;

- (NSString *)message;
@end

#endif /* Restriction_h */
