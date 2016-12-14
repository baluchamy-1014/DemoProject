//
//  CustomTabBar.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 10/23/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

class CustomTabBar: UITabBar {
  override func drawRect(rect: CGRect) {
    // TODO: Theme
    self.tintColor = UIColor(red: 63/255, green: 64/255, blue: 65/255, alpha: 1.0)
    self.selectionIndicatorImage = self.imageWithColor(UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 0.5))
  }
  
  func imageWithColor(color: UIColor) -> UIImage {
    let rect = CGRectMake(0.0, 0.0, 65, self.frame.size.height)
//    print(rect)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    let image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image
  }
}
