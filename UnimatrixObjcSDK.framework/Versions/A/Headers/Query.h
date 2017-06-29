//
//  Query.h
//  BoxxspringVideoPlayerSDK
//
//  Created by Shovan Joshi on 11/3/15.
//  Copyright © 2015 Bedrocket Media. All rights reserved.
//

#ifndef Query_h
#define Query_h

#import <Foundation/Foundation.h>

@interface Query : NSObject

// this is a new comment

typedef void (^APIQueryCompletionBlock) (id response, NSError *error);

@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSNumber *offset;
@property (nonatomic, strong) NSString *requestSerializer;
@property (nonatomic) int totalCount;

- (instancetype)initWithPath:(NSString *)path;
- (instancetype)initWithPath:(NSString *)path andHost:(NSString *)host;
- (void)include:(id)includesData;
- (void)execute:(APIQueryCompletionBlock) callback;
- (void)executeWithParams:(NSDictionary *)params onCompletion:(APIQueryCompletionBlock)callback;
- (void)get:(APIQueryCompletionBlock)callback;
- (void)post:(NSMutableDictionary *)params onCompletion:(APIQueryCompletionBlock)callback;
- (void)create:(NSMutableDictionary *)params onCompletion:(APIQueryCompletionBlock)callback;

@end


#endif /* Query_h */
