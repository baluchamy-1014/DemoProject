#include <objc/runtime.h>
#import "UnimatrixConfiguration.h"
#import "NSObject+NewProperty.h"

@implementation UnimatrixConfiguration

  //** Class Methods **//
  +( void ) initialize {
    if ( [ self class ] == [ UnimatrixConfiguration class ] ) {
      NSString* className = NSStringFromClass( [ UnimatrixConfiguration class ] );
      NSBundle* mainBundle = [ NSBundle mainBundle ];

      NSString* configurationPath = [ mainBundle pathForResource: @"Configuration"
                                                          ofType: @"plist"
                                    ];

      NSMutableDictionary* configuration = [
        NSMutableDictionary dictionaryWithContentsOfFile: configurationPath
      ];

      NSString* applicationEnvironment = [ configuration valueForKey: @"ENV" ];

      [ [ UnimatrixConfiguration class ] addObjectProperty: @"applicationEnvironment"
                                                  forClass: className
                                         withPropertyClass: NSStringFromClass( [ NSString class ] )
      ];

      NSMutableDictionary* environmentConfiguration = [
        configuration valueForKey: applicationEnvironment
      ];

      for ( NSString* key in environmentConfiguration ) {
        NSString* instanceVariableType  = @"";
        id value = [ environmentConfiguration valueForKey: key ];

        if ( [ value isKindOfClass: [ NSString class ] ] ) {
          instanceVariableType = NSStringFromClass( [ NSString class ] );
        }
        else if ( [ value isKindOfClass: [ NSArray class ] ] ) {
          instanceVariableType = NSStringFromClass( [ NSArray class ] );
        }
        else if ( [ value isKindOfClass: [ NSDictionary class ] ] ) {
          instanceVariableType = NSStringFromClass( [ NSDictionary class ] );
        }
        else if ( [ value isKindOfClass: [ NSDate class ] ] ) {
          instanceVariableType = NSStringFromClass( [ NSDate class ] );
        }
        else if ( [ value isKindOfClass: [ NSNumber class ] ] ) {
          instanceVariableType = NSStringFromClass( [ NSNumber class ] );
        }
        else {
          NSLog( @"Unrecognized Property for ClassName:%@", [value className] );
          continue;
        }

        [ [ UnimatrixConfiguration class ] addObjectProperty: key
                                                    forClass: className
                                           withPropertyClass: instanceVariableType
				];

      }
    }
  }

  //** Get Shared Instance **//
  +( UnimatrixConfiguration* ) getInstance {
    static UnimatrixConfiguration* sharedObject = nil;
    @synchronized( self ) {
      if ( !sharedObject )
      sharedObject = [ [ [ self class ]alloc ] init ];
    }
    return sharedObject;
  }

  //*Create New property*//
  +( BOOL ) addObjectProperty: ( NSString* ) propertyName
                     forClass: ( NSString* ) className
            withPropertyClass: ( NSString* ) propertyClassName {
    
    if ( 0 == className.length || 0 == propertyName.length || 0 == propertyClassName.length ) {
      return NO;
    }

    Class targetClass = NSClassFromString( className );
    Class valueClass = NSClassFromString( propertyClassName );

    Ivar instanceVariable = class_getInstanceVariable (
															targetClass,
												      [ [ NSString stringWithFormat: @"_%@", propertyName ] UTF8String ]
														);

    if ( instanceVariable ) {
      return NO;
    }

    objc_property_attribute_t type = {
      "T",
			[ [ NSString stringWithFormat: @"@\"%@\"", NSStringFromClass ( valueClass ) ] UTF8String ]
    };

    objc_property_attribute_t ownership0 = { "&", "" };
    objc_property_attribute_t ownership = { "N", "" };

    objc_property_attribute_t backingVariable  = {
      "V",
			[ [ NSString stringWithFormat: @"_%@", propertyName ] UTF8String ]
    };

    objc_property_attribute_t attributes[ ] = { type, ownership0, ownership, backingVariable };

    if ( class_addProperty( targetClass, [ propertyName UTF8String ], attributes, 4 ) ) {
      [ targetClass addObjectProperty: propertyName ];
      return YES;
    }

    return NO;
  }

  -( id ) init {
    NSBundle* mainBundle = [ NSBundle mainBundle ];
    NSString* configurationPath = [ mainBundle pathForResource: @"Configuration" ofType: @"plist" ];

    NSMutableDictionary* defaultConfiguration =  [
			NSMutableDictionary dictionaryWithContentsOfFile: configurationPath
		];

    NSString* applicationEnvironment = [ defaultConfiguration valueForKey: @"ENV" ];
	  [ self setValue: applicationEnvironment forKey: @"applicationEnvironment" ];

    NSMutableDictionary* environmentConfiguration = [
			defaultConfiguration valueForKey: applicationEnvironment
    ];

    [ self setValuesForKeysWithDictionary: environmentConfiguration ];
    return self;
  }

  //** Get or set base Url **//
  -( NSString* ) getUrl {
    return [ self valueForKey: @"apiURL" ];
  }

  -( void ) setUrl: ( NSString* ) urlString {
    [ self setValue: urlString forKey: @"apiURL" ];
  }

  //**KeyValueCoding DelegateMethods**//
  -( id ) valueForUndefinedKey: ( NSString* ) key {
    NSLog( @"ERROR:%@ Key not found ", key );
    return  nil;
  }

  -( void ) setValue: ( id ) value forUndefinedKey: ( NSString* ) key {
    NSLog ( @"ERROR:%@ Key not found ", key );
  }
  
@end
