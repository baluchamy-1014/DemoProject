//
//  Track.h
//  VideoPlayerSDK
//
//  Created by Shovan Joshi on 12/8/15.
//  Copyright © 2015 Bedrocket Media. All rights reserved.
//

#ifndef Track_h
#define Track_h

#import "Resource.h"
#import "Attributes.h"

@interface Track : Resource

@property (nonatomic, strong) NSString     *name;
@property (nonatomic, strong) NSString     *typeName;
@property (nonatomic, strong) NSString     *kind;
@property (nonatomic, strong) NSString     *storageKey;
@property (nonatomic, strong) NSString     *language;
@property (nonatomic, strong) NSString     *label;
@property (nonatomic, strong) NSString     *contentType;

+ (Attributes *)attributes;
- (NSString *)subtitles;
@end


#endif /* Track_h */
