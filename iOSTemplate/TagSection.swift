//
//  TagSection.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 10/27/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

class TagSection: NSObject {
  let view:UIView
  let tags:Array<AnyObject>
  let sectionWidth: CGFloat  = 259.0
  let buttonPadding: CGFloat = 24.0
  let xGap: CGFloat          = 5.0
  var sectionHeight: CGFloat
  
  var previousBtnXOrigin:CGFloat = 10.0
  var previousBtnYOrigin:CGFloat = 22.0
  var previousBtnLength:CGFloat  = 0
  
  init(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, tags:Array<AnyObject>) {
    self.view            = UIView(frame: CGRectMake(x, y, width, height))
    view.backgroundColor = UIColor.clearColor()
    
    self.tags            = tags
    sectionHeight        = y
  }
  
  func setupTags() {
    var x: CGFloat
    let btnHeight: CGFloat = 26
    let sectionGap: CGFloat = 15
    
    for tag in tags {
      let btnString:String = tag.name
      let btnNSString: NSString = btnString as NSString
      let font = UIFont.systemFontOfSize(18, weight: UIFontWeightMedium)
      let btnStringSize: CGSize = btnNSString.sizeWithAttributes([NSFontAttributeName: font])
      
      if (previousBtnXOrigin + previousBtnLength + btnStringSize.width + xGap) > sectionWidth
      {
        // reset values
        previousBtnYOrigin += 36
        previousBtnXOrigin = 10.0
        previousBtnLength  = 0.0
      }
      
      x = previousBtnLength + previousBtnXOrigin + xGap
      
      let btn = TagButton(frame: CGRectMake(x, previousBtnYOrigin, btnStringSize.width + buttonPadding, btnHeight),
                          text: tag.name)
      btn.tag = Int(tag.id)
      
      previousBtnLength  = btn.frame.size.width;
      previousBtnXOrigin = btn.frame.origin.x
      view.addSubview(btn)
    }
    
    let totalBtnHeight: CGFloat = previousBtnYOrigin + btnHeight + sectionGap
    self.view.frame = CGRectMake(0, sectionHeight, sectionWidth, totalBtnHeight)    
  }
  
}
