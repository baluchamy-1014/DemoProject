//
//  Resource.h
//  VideoPlayerSDK
//
//  Created by Shovan Joshi on 11/5/15.
//  Copyright © 2015 Bedrocket Media. All rights reserved.
//

#ifndef Resource_h
#define Resource_h

#import <Foundation/Foundation.h>

#import "Query.h"

@interface Resource : NSObject

@property (nonatomic, strong) NSNumber *id;

typedef void (^ResourceQueryCompletionBlock) (id response, NSError *error);

- (id)initWithAttributes:(NSDictionary*)dictionary;

@end



#endif /* Resource_h */
