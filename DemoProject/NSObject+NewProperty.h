#import <Foundation/Foundation.h>
#import <objc/runtime.h>

extern NSString* addPropertyException;
@interface NSObject ( NewProperty )

 +( void ) addObjectProperty: ( NSString* ) name;
 +( void ) addObjectProperty: ( NSString* ) name
           associationPolicy: ( objc_AssociationPolicy ) policy;

@end
