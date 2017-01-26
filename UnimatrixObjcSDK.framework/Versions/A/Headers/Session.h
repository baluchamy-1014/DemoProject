//
//  Session.h
//  VideoPlayerSDK
//
//  Created by Shovan Joshi on 2/11/16.
//  Copyright © 2016 Bedrocket Media. All rights reserved.
//

#ifndef Session_h
#define Session_h

#import "Property.h"

@class SRUser;

@interface Session : NSObject

typedef void (^APIQueryCompletionBlock) (id response, NSError *error);

@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) NSDictionary *tokenDictionary;
@property (nonatomic, retain) NSString *clientID;
@property (nonatomic, retain) NSString *clientSecret;
@property (nonatomic, retain) SRUser *user;
@property (nonatomic, retain) Property *property;
@property (nonatomic, retain) NSString *propertyCode;

+ (Session *)sharedSession;
+ (void)setToken:(NSString *)token;

- (void)authenticate:(NSString *)username
            password:(NSString *)password
        onCompletion:(APIQueryCompletionBlock)callback;
- (BOOL)isValid;
- (void)getProperty:(APIQueryCompletionBlock)callback;
- (void)resetSession;

@end



#endif /* Session_h */
