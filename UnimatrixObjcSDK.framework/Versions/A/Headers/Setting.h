//
//  Setting.h
//  VideoPlayerSDK
//
//  Created by Shovan Joshi on 11/22/15.
//  Copyright © 2015 Bedrocket Media. All rights reserved.
//

#ifndef Setting_h
#define Setting_h

#import "Resource.h"
#import "Attributes.h"

@interface Setting : Resource

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *typeName;
@property(nonatomic, strong) NSString *content;

+ (Attributes *)attributes;

- (NSString *)contentToHostString;
@end


#endif /* Setting_h */
