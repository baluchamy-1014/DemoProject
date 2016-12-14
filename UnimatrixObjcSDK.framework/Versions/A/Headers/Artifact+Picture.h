//
// Created by Shovan Joshi on 10/11/16.
// Copyright (c) 2016 Sprotsrocket. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Artifact.h"

#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#endif

@interface Artifact (Picture)
/**
 * Picture url for artifact
 * @return will return NSURL that points to the picture of the artifact
 */
- (NSURL *)pictureURL;

- (NSURL *)pictureURLwithWidth:(int)width height:(int)height;

/**
 *
 * @return will return UIImage object representing the picture of the artifact
 */
- (UIImage *)picture;

/**
 * UIImage with matching width/height
 * @param width Int value for width of the image
 * @param height Int value for height of the image
 * @return UIImage with width/height
 */
- (UIImage *)pictureWithWidth:(int)width height:(int)height;
@end