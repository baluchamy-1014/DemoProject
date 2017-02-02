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
  let sectionWidth: CGFloat  = UIScreen.main.bounds.size.width - 40
  let buttonPadding: CGFloat = 0.0
  let xGap: CGFloat          = 10.0
  var sectionHeight: CGFloat
  
  var previousBtnXOrigin:CGFloat = 10.0
  var previousBtnYOrigin:CGFloat = 0.0
  var previousBtnLength:CGFloat  = 0
  
  init(x:CGFloat, y:CGFloat, width:CGFloat, height:CGFloat, tags:Array<AnyObject>) {
    self.view            = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
    view.backgroundColor = UIColor.clear
    
    self.tags            = tags
    sectionHeight        = y
  }
  
  func setupTags() {
    var x: CGFloat
    let btnHeight: CGFloat = 32
    let sectionGap: CGFloat = 0
    
    for tag in tags {
      let btnString:String = tag.name
      let btnNSString: NSString = btnString as NSString
      let font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightMedium)
      let btnStringSize: CGSize = btnNSString.size(attributes: [NSFontAttributeName: font])
      
      if (previousBtnXOrigin + previousBtnLength + btnStringSize.width + xGap) > sectionWidth
      {
        // reset values
        previousBtnYOrigin += 40
        previousBtnXOrigin = 10.0
        previousBtnLength  = 0.0
      }
      
      x = previousBtnLength + previousBtnXOrigin + xGap
      
      let btn = TagButton(frame: CGRect(x: x, y: previousBtnYOrigin, width: btnStringSize.width + buttonPadding, height: btnHeight),
                          text: tag.name)
      btn.tag = Int(tag.id)
      
      previousBtnLength  = btn.frame.size.width;
      previousBtnXOrigin = btn.frame.origin.x
      view.addSubview(btn)
    }
    
    let totalBtnHeight: CGFloat = previousBtnYOrigin + btnHeight + sectionGap
    self.view.frame = CGRect(x: 0, y: sectionHeight, width: sectionWidth, height: totalBtnHeight)    
  }
  
}
