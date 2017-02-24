//
//  SRAnalytics.h
//  UnimatrixAnalyticsObjC
//
//  Created by Shovan Joshi on 7/20/16.
//  Copyright © 2016 Sprotsrocket. All rights reserved.
//

#ifndef SRAnalytics_h
#define SRAnalytics_h

@interface SRAnalytics : NSObject

@property (nonatomic, retain) NSString *sessionUUID;
@property (nonatomic, retain) NSString *visitorUUID;
@property (nonatomic, retain) NSString *contextUUID;
@property (nonatomic, retain) NSString *userAgent;
@property (nonatomic, retain) NSString *host;

+ (SRAnalytics *)session;
- (NSString *)createdAt;
- (NSDictionary *)params;
- (void)track:(NSDictionary *)trackParams;
@end



#endif /* SRAnalytics_h */
