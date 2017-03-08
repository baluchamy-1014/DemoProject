//
//  UnimatrixConfiguration.h
//  UnimatrixObjcSDK
//
//  Created by Shovan Joshi on 2/7/17.
//  Copyright © 2017 Sprotsrocket. All rights reserved.
//

#ifndef UnimatrixConfiguration_h
#define UnimatrixConfiguration_h

#import <Foundation/Foundation.h>

@interface UnimatrixConfiguration : NSObject

@property (nonatomic, retain) NSString *appEnvironment;

+ (UnimatrixConfiguration *)sharedConfig;
- (NSDictionary *)configValues;

- (NSString *)archivistApiURL;
- (NSString *)keymakerApiURL;
- (NSString *)gatekeeperApiURL;

- (NSString *)mediaHostURL;
- (NSString *)pictureHostURL;
- (NSString *)streamHostURL;

@end


#endif /* UnimatrixConfiguration_h */
