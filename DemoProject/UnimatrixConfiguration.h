#import <Foundation/Foundation.h>

@interface UnimatrixConfiguration : NSObject

  +( UnimatrixConfiguration* ) getInstance;
  -( id ) init;
  -( NSString* ) getUrl;
  -( void ) setUrl: ( NSString* ) urlString;
  
@end
