//
//  SREnvConfig.h
//  UnimatrixObjcSDK
//
//  Created by Shovan Joshi on 10/27/16.
//  Copyright © 2016 Sprotsrocket. All rights reserved.
//

#ifndef SREnvConfig_h
#define SREnvConfig_h

@interface SREnvConfig : NSObject

+ (SREnvConfig *)sharedConfig;
- (int)environment;

@end


#endif /* SREnvConfig_h */
