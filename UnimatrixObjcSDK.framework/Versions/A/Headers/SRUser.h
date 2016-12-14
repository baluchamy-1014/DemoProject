//
//  SRUser.h
//  UnimatrixObjcSDK
//
//  Created by Shovan Joshi on 11/17/16.
//  Copyright © 2016 Sprotsrocket. All rights reserved.
//


#ifndef SRUser_h
#define SRUser_h

@interface SRUser : NSObject

typedef void (^APIQueryCompletionBlock) (id response, NSError *error);

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email_address;
@property (nonatomic, strong) NSString *uuid;

- (instancetype)initWithAttributes:(NSDictionary *)attributesDict;

+ (void)create:(NSDictionary *)resourceOwner
  onCompletion:(APIQueryCompletionBlock)callback;

@end

#endif /* SRUser_h */
