//
//  Attributes.h
//  VideoPlayerSDK
//
//  Created by Shovan Joshi on 11/5/15.
//  Copyright © 2015 Bedrocket Media. All rights reserved.
//

#ifndef Attributes_h
#define Attributes_h

#import "Resource.h"

@interface Attributes : NSObject

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

-(id)initWithReflections:(NSArray *)reflectionArray;

-(void)setResourceProperties:(Resource*)resource
     fromAttributeDictionary:(NSDictionary*)attributes;

@end

#endif /* Attributes_h */
