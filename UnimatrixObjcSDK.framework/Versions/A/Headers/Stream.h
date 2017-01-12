//
//  Stream.h
//  VideoPlayerSDK
//
//  Created by Shovan Joshi on 11/19/15.
//  Copyright © 2015 Bedrocket Media. All rights reserved.
//

#ifndef Stream_h
#define Stream_h


#import "Resource.h"
#import "Attributes.h"

@class Property;

@interface Stream : Resource

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *hostURL;

+ (Attributes *)attributes;
+ (void)getStream:(NSString *)streamID onCompletion:(APIQueryCompletionBlock)callback;

- (NSURL *)url:(Property *)property;
- (BOOL)isLive;
@end


#endif /* Stream_h */
