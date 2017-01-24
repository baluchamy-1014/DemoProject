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

typedef enum {
  ServerLocationUSWEST,
  ServerLocationUSEAST,
  ServerLocationEUROPE
} StreamServerLocation;

@class Property;

@interface Stream : Resource

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *hostURL;
@property (nonatomic, strong) NSString *recording;
@property (nonatomic, strong) NSString *recordingState;
@property (nonatomic, strong) NSString *inHostURL;
@property (nonatomic, retain) NSDate   *createdAt;
@property (nonatomic, retain) NSDate   *updatedAt;

+ (Attributes *)attributes;
+ (void)getStream:(NSString *)streamID onCompletion:(APIQueryCompletionBlock)callback;

/**
 *
 * @param params : NSDictionary with name key which will be the name of the stream
 * @param propertyID : the int id of the property
 * @param serverLocation : enum matching either ServerLocationUSEAST, ServerLocationUSWEST, or ServerLocationEurope
 * @param accessToken : the access token for authenticated user
 * @param callback is the completion block which returns the stream artifact object if created else error message provided
 **/
+ (void) create:(NSDictionary *)params
       property:(int)propertyID
       location:(StreamServerLocation)serverLocation
withAccessToken:(NSString *)accessToken
   onCompletion:(APIQueryCompletionBlock)callback;

- (NSURL *)url:(Property *)property;
- (BOOL)isLive;
@end


#endif /* Stream_h */
