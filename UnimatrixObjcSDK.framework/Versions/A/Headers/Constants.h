//
//  Constants.h
//  BoxxspringVideoPlayerSDK
//
//  Created by Shovan Joshi on 2/15/16.
//  Copyright © 2016 Bedrocket Media. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#define PRODUCTION 1
#define STAGING 2
#define ACCEPTANCE 3
#define LOCAL 4

#define SR_ENV PRODUCTION

#define kPlayerVersion @"1.0.2"
#define kBoxxspringApiVersion @"1.0.1"

#if SR_ENV == PRODUCTION
#define kStreamWriteUrlWest @"rtmp://us-west-2.in.stream.staging.boxxspring.com/stream/"
#define kStreamReadUrlWest @"//us-west-2-staging.stream.boxxspring.net"
#define kStreamWriteUrlEast @"rtmp://us-east-1.in.stream.staging.boxxspring.com/stream/"
#define kStreamReadUrlEast @"//us-east-1-staging.stream.boxxspring.net"
#define kStreamWriteUrlEurope @"rtmp://eu-west-1.in.stream.boxxspring.com/stream/"
#define kStreamReadUrlEurope @"//eu-west-1.stream.boxxspring.com"
#endif


#if SR_ENV == STAGING
#define kStreamWriteUrlWest @"rtmp://us-west-2.in.stream.staging.boxxspring.com/stream/"
#define kStreamReadUrlWest @"//us-west-2-staging.stream.boxxspring.net"
#define kStreamWriteUrlEast @"rtmp://us-east-1.in.stream.staging.boxxspring.com/stream/"
#define kStreamReadUrlEast @"//us-east-1-staging.stream.boxxspring.net"
#define kStreamWriteUrlEurope @"rtmp://us-east-1.in.stream.staging.boxxspring.com/stream/"
#define kStreamReadUrlEurope @"//us-east-1-staging.stream.boxxspring.net"
#endif

#if SR_ENV == ACCEPTANCE
#endif

#if SR_ENV == LOCAL
#endif

#endif /* Constants_h */
