//
//  Artifact.h
//  VideoPlayerSDK
//
//  Created by Shovan Joshi on 11/7/15.
//  Copyright © 2015 Bedrocket Media. All rights reserved.
//

#ifndef Artifact_h
#define Artifact_h

#import "Resource.h"
#import "Attributes.h"

@class Campaign;

@interface Artifact : Resource

typedef void (^APIQueryCompletionBlock) (id response, NSError *error);

@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *provider;
@property (nonatomic, strong) NSString *providerUID;
@property (nonatomic, strong) NSString *UID;
@property (nonatomic, strong) NSArray  *artifacts;
@property (nonatomic, retain) NSDate   *createdAt;
@property (nonatomic, retain) NSDate   *updatedAt;
@property (nonatomic, retain) NSString *publishedAt;
@property (nonatomic, retain) NSString *shortDescription;
@property (nonatomic, retain) NSString *longDescription;
@property (nonatomic, retain) NSNumber *pictureID;
@property (nonatomic, retain) NSString *providerURL;

@property int propertyID;

+ (Attributes *)attributes;
/**
 * Makes a request to API using given artifact id and property id
 * @param artifactID The id for the artifact
 * @param propertyID Property to which the artifact belongs to
 * @param callback is the completion block which returns the artifact object if found and error message if needed
 *
 */
+ (void)getArtifact:(int)artifactID forProperty:(int)propertyID onCompletion:(APIQueryCompletionBlock)callback;

/**
 * Makes a request to API using given artifact id and property id to get related artifacts
 * @param artifactID The id for the artifact
 * @param propertyID Property to which the artifact belongs to
 * @param filter
 * @param callback is the completion block which returns artifacts array and error message if needed
 *
 */
+ (void)getRelatedArtifacts:(int)artifactID forProperty:(int)propertyID filter:(NSDictionary *)filter onCompletion:(APIQueryCompletionBlock)callback;

/**
 *
 * @param params
 * @param propertyID
 * @param count Number of artifacts requested
 * @param offset
 * @param callback block object that returns artifacts or error message
 */
+ (void)query:(NSDictionary *)params
   propertyID:(int)propertyID
        count:(int)count
       offset:(int)offset
 onCompletion:(APIQueryCompletionBlock)callback;

- (NSArray *)tags;
- (NSArray *)playlist;
- (NSArray *)groups;

- (Artifact *)author;

- (void)findCampaign;

- (Campaign *)getVideoAdvertisementFromCampaigns:(NSArray *)campaigns;
- (id)handleMissingAttributes:(NSString *)methodName;

+ (void)findBySlug:(NSString *)slugName
       forProperty:(int)propertyID
      onCompletion:(APIQueryCompletionBlock)callback;

// Helper methods
+ (void)queryNext:(NSDictionary *)dict
            count:(int)count
           offset:(int)offset
        reference:(id)reference
     onCompletion:(APIQueryCompletionBlock) callback;

+ (void)queryPrevious:(NSDictionary *)dict
                count:(int)count
               offset:(int)offset
            reference:(id)reference
         onCompletion:(APIQueryCompletionBlock) callback;


// POST methods
+ (void) create:(NSDictionary *)params
    forProperty:(int)propertyID
withAccessToken:(NSString *)accessToken
   onCompletion:(APIQueryCompletionBlock)callback;

@end

#endif /* Artifact_h */
