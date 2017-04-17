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
typedef void (^DealerProductCategoryQueryCompletionBlock) (NSDictionary *productsByUids, NSError *error);


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
@property (nonatomic, strong) NSArray  *productCategorizations;

+ (Attributes *)attributes;

 /**
  * Makes a request to the Dealer API to get products that match the given params
  * @param realm represents the property realm
  * @param productCategories string value representing product gategory. eg: 'team', 'single-game', 'season'
  * @param resourceID reprsents the artifact UID for which the products are being requested for. Can be nil
  * @param params optional dict to override default values in the query
  * @param callback that returns products or error depending upon the params
  */
+ (void)query:(NSString *)realm
   categories:(NSArray *)productCategories
        match:(NSString *)resourceID
      options:(NSDictionary *)params
 onCompletion:(DealerProductQueryCompletionBlock)callback;

/**
 * Makes a request to the Dealer API to get product categorization
 * @param realm represents the property realmn
 * @param uids is an array of uids values from Archivist. eg: uid value for "2016 Season" tag in Archivist
 * @param callback that returns a dictionary of uid key and products as values
 */
+ (void)        query:(NSString *)realm
archivistCategoryUids:(NSArray *)uids
         onCompletion:(DealerProductCategoryQueryCompletionBlock)callback;

/**
 * Makes a request to the Dealer API to get products that match the given params
 * @param realm represents the property realm
 * @param categories string value representing product gategory. eg: 'team', 'single-game', 'season'
 * @param options is optional dict to override default values in the query
 * @param callback that returns products or error depending upon the params
 */
+ (void)query:(NSString *)realm
   categories:(NSArray *)categories
      options:(NSDictionary *)options
 onCompletion:(DealerProductQueryCompletionBlock)callback;

@end

#endif /* Product_h */
