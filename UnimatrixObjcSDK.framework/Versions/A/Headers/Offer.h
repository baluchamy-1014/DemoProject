//
// Created by Shovan Joshi on 2/13/17.
// Copyright (c) 2017 Sportsrocket Inc. All rights reserved.
//

#import <UnimatrixObjcSDK/Resource.h>
#import <UnimatrixObjcSDK/Attributes.h>
#import "Tax.h"


@interface Offer : Resource

typedef void (^DealerAPIOfferQueryCompletionBlock) (NSArray *products, NSError *error);
typedef void (^DealerAPITaxQueryCompletionBlock) (Tax *tax, NSError *error);
typedef void (^DealerAPITransactionQueryCompletionBlock) (NSArray *transactions, NSError *error);

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *UUID;
@property (nonatomic, strong) NSString *filterUUID;
@property (nonatomic, strong) NSString *publishedAt;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *longDescription;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *regionUUID;
@property (nonatomic, strong) NSString *regionInclusion;

@property (nonatomic, strong) NSDate   *createdAt;
@property (nonatomic, strong) NSDate   *updatedAt;
@property (nonatomic, strong) NSDate   *startsAt;
@property (nonatomic, strong) NSDate   *endsAt;

@property (nonatomic, assign) BOOL recurring;
@property int productID;


+ (Attributes *)attributes;

- (void)getTaxInfo:(NSDictionary *)customerInfo
       billingInfo:(NSDictionary *)billingInfo
       accessToken:(NSString *)accessToken
             realm:(NSString *)realm
      onCompletion:(DealerAPITaxQueryCompletionBlock)callback;

/**
 * Makes a request to Dealer API
 * @param realm String that represents the property
 * @param count number of items to be returned
 * @param accessToken token for the user and is optional
 * @param products array of product ids. Can be empty
 * @param callback is the completion block which returns the artifact object if found and error message if needed
 *
 */

+ (void)query:(NSString *)realm
        count:(int)count
     products:(NSArray *)products
  accessToken:(NSString *)accessToken
 onCompletion:(DealerAPIOfferQueryCompletionBlock)callback;


- (void) purchase:(NSDictionary *)params
         forRealm:(NSString *)realm
  withAccessToken:(NSString *)accessToken
     onCompletion:(DealerAPITransactionQueryCompletionBlock)callback;
@end

#
