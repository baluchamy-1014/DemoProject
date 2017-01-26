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
#define kMediaHost @"http://default.media.boxxspring.net"
#define kApiHost @"https://api.boxxspring.com"
#define kKeymakerHost @"https://keymaker.boxxspring.com"
#define kWidgetsHost @"https://widgets.boxxspring.com"
#define kPictureHost @"https://pictures.boxxspring.net"
#define kGatekeeperHost @"https://gatekeeper.boxxspring.com"
#define kStreamHost @"https://stream.boxxspring.com/live/"
#define kStreamWriteUrlWest @"rtmp://us-west-2.in.stream.staging.boxxspring.com/stream/"
#define kStreamReadUrlWest @"//us-west-2-staging.stream.boxxspring.net"
#define kStreamWriteUrlEast @"rtmp://us-east-1.in.stream.staging.boxxspring.com/stream/"
#define kStreamReadUrlEast @"//us-east-1-staging.stream.boxxspring.net"
#define kStreamWriteUrlEurope @"rtmp://eu-west-1.in.stream.boxxspring.com/stream/"
#define kStreamReadUrlEurope @"//eu-west-1.stream.boxxspring.com"
#endif


#if SR_ENV == STAGING
#define kMediaHost @"http://videos.staging.boxxspring.com"
#define kApiHost @"http://api.staging.boxxspring.com"
#define kKeymakerHost @"http://keymaker.staging.boxxspring.com"
#define kWidgetsHost @"http://staging.widgets.boxxspring.com"
#define kPictureHost @"http://pictures.staging.boxxspring.com"
#define kGatekeeperHost @"http://gatekeeper.staging.boxxspring.com"
#define kStreamHost @"http://stream.staging.boxxspring.com/live/"
#define kStreamWriteUrlWest @"rtmp://us-west-2.in.stream.staging.boxxspring.com/stream/"
#define kStreamReadUrlWest @"//us-west-2-staging.stream.boxxspring.net"
#define kStreamWriteUrlEast @"rtmp://us-east-1.in.stream.staging.boxxspring.com/stream/"
#define kStreamReadUrlEast @"//us-east-1-staging.stream.boxxspring.net"
#define kStreamWriteUrlEurope @"rtmp://us-east-1.in.stream.staging.boxxspring.com/stream/"
#define kStreamReadUrlEurope @"//us-east-1-staging.stream.boxxspring.net"
#endif

#if SR_ENV == ACCEPTANCE
#define kMediaHost @"http://videos.acceptance.boxxspring.com"
#define kApiHost @"http://api.acceptance.boxxspring.com"
#define kKeymakerHost @"http://keymaker.acceptance.boxxspring.com"
#define kWidgetsHost @"http://widgets.boxxspring.com"
#define kPictureHost @"http://pictures.acceptance.boxxspring.com"
#define kGatekeeperHost @"http://gatekeeper.acceptance.boxxspring.com"
#define kStreamHost @"http://stream.boxxspring.com/live/"
#endif

#if SR_ENV == LOCAL
#define kMediaHost @"http://videos.staging.boxxspring.com"
#define kApiHost @"http://lllocalhost:3000"
#define kWidgetsHost @"http://widgets.boxxspring.com"
#define kPictureHost @"http://pictures.staging.boxxspring.com"
#define kGatekeeperHost @"http://gatekeeper.staging.boxxspring.com"
#define kStreamHost @"http://stream.boxxspring.com/live/"
#endif

#endif /* Constants_h */
