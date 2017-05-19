//
// Created by Shovan Joshi on 5/18/17.
// Copyright (c) 2017 Sprotsrocket. All rights reserved.
//

#import <UnimatrixObjcSDK/Resource.h>
#import <UnimatrixObjcSDK/Attributes.h>



@interface Coupon : Resource


typedef void (^DealerAPICouponQueryCompletionBlock) (Coupon *coupon, NSError *error);

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *longDescription;
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *threshold;
@property (nonatomic, strong) NSNumber *count;

@property (nonatomic, strong) NSDate   *createdAt;
@property (nonatomic, strong) NSDate   *updatedAt;


+ (void)query:(NSString *)realm
     withCode:(NSString *)code
  accessToken:(NSString *)accessToken
 onCompletion:(DealerAPICouponQueryCompletionBlock)callback;

- (float)discountAmount:(NSNumber *)price;

@end