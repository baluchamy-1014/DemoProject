#import "NSObject+NewProperty.h"

NSString* addPropertyException = @"addPropertyException";

@implementation NSObject( NewProperty )

  static inline NSString* setterSelectorNameofProperty( NSString* property ) {
    NSString* headCharacter = [ [ property substringToIndex: 1 ] uppercaseString ];
    NSString* OtherString = [ property substringFromIndex: 1 ];
    return [ NSString stringWithFormat: @"set%@%@:", headCharacter, OtherString ];
  }

  +( void ) addObjectProperty: ( NSString* ) name {
    [ self addObjectProperty: name associationPolicy: OBJC_ASSOCIATION_RETAIN_NONATOMIC ];
  }

  +( void ) addObjectProperty: ( NSString* ) name
            associationPolicy: ( objc_AssociationPolicy ) policy {

      if ( !name.length ) {
        [ [ NSException exceptionWithName: addPropertyException
                                   reason: @"property must not be empty"
                                 userInfo: @{@"name": name, @"policy": @( policy )}
          ] raise
        ];
  }

		NSString* key = [ NSString stringWithFormat: @"%p_%@", self, name ];

		id setblock = ^( id self, id value ) {
			objc_setAssociatedObject( self, ( __bridge void* ) key, value, policy );
		};

		IMP selectorPointer = imp_implementationWithBlock( setblock );
		NSString* selectorString = setterSelectorNameofProperty( name );

		BOOL result = class_addMethod(
									  [ self class ],
										NSSelectorFromString( selectorString ),
										selectorPointer,
										"v@:@"
									);

		assert( result );

		id getBlock = ^id( id self ) {
			return objc_getAssociatedObject( self, ( __bridge void* ) key );
		};

		IMP getSelector = imp_implementationWithBlock( getBlock );
		result = class_addMethod( [ self class ], NSSelectorFromString( name ), getSelector, "@@:" );
		assert( result );
  }
  
@end
