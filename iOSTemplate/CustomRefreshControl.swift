//
//  CustomRefreshControl.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 10/29/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

class CustomRefreshControl: UIRefreshControl {  
  override func drawRect(rect: CGRect) {
    self.tintColor = UIColor.whiteColor()
  }

}
