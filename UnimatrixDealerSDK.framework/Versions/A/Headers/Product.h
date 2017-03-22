//
//  Product.h
//  UnimatrixDealerSDK
//
//  Created by Shovan Joshi on 2/7/17.
//  Copyright © 2017 Sportsrocket Inc. All rights reserved.
//

#ifndef Product_h
#define Product_h

#import <UnimatrixObjcSDK/Resource.h>
#import <UnimatrixObjcSDK/Attributes.h>

@interface Product : Resource

typedef void (^DealerProductQueryCompletionBlock) (NSArray *products, NSError *error);


@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) NSString *filterUUID;
@property (nonatomic, strong) NSDate   *createdAt;
@property (nonatomic, strong) NSDate   *updatedAt;
@property (nonatomic, strong) NSDate   *startsAt;
@property (nonatomic, strong) NSDate   *endsAt;
@property (nonatomic, strong) NSString *publishedAt;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *longDescription;
@property (nonatomic, strong) NSArray  *offers;

+ (Attributes *)attributes;

/**
 * Makes a request to API using given artifact id and property id
 * @param artifactID The id for the artifact
 * @param propertyID Property to which the artifact belongs to
 * @param callback is the completion block which returns the artifact object if found and error message if needed
 *
 */
+ (void)query:(NSString *)realm
        state:(NSString *)state
        count:(int)count
   categories:(NSArray *)productCategories
        match:(NSString *)resourceID
 onCompletion:(DealerProductQueryCompletionBlock)callback;

+ (void)query:(NSString *)realm
   categories:(NSArray *)categories
 onCompletion:(DealerProductQueryCompletionBlock)callback;

+ (void)query:(NSString *)realm
   categories:(NSArray *)categories
        match:(NSString *)resourceID
 onCompletion:(DealerProductQueryCompletionBlock)callback;

@end

#endif /* Product_h */
