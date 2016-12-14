//
//  CustomControls.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 9/26/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

class CustomSegmentedControl: UISegmentedControl {
  var bottomBorder = CALayer()
  override func drawRect(rect: CGRect) {
    self.customize()
  }
  
  func imageWithColor(color: UIColor) -> UIImage {
    let rect = CGRectMake(0.0, 0.0, 1.0, self.frame.size.height)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    let image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image    
  }
  
  func customize() {
    self.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFontOfSize(14), NSForegroundColorAttributeName:UIColor(red: 136/266, green: 136/255, blue: 136/255, alpha: 1.0)], forState:UIControlState.Normal)
    self.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFontOfSize(14), NSForegroundColorAttributeName:UIColor.whiteColor()], forState:UIControlState.Selected)
    
    self.setDividerImage(self.imageWithColor(UIColor.clearColor()), forLeftSegmentState: UIControlState.Normal, rightSegmentState: UIControlState.Normal, barMetrics: UIBarMetrics.Default)
    
    self.setBackgroundImage(self.imageWithColor(UIColor.clearColor()), forState:UIControlState.Normal, barMetrics:UIBarMetrics.Default)
    // TODO: theme
    self.setBackgroundImage(UIImage(named: "slider_trans"), forState:UIControlState.Selected, barMetrics:UIBarMetrics.Default);   
  }
}

class AuthorLabel: UILabel {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.font = UIFont.systemFontOfSize(11)
    self.textColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
//    self.numberOfLines = 0
    self.backgroundColor = UIColor.whiteColor()
    self.textAlignment = .Left
  }
}

class ArtifactTitleLabel: UILabel {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  
    self.font = UIFont.systemFontOfSize(12)
    self.textColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
    self.numberOfLines = 0
    self.backgroundColor = UIColor.whiteColor()
    self.textAlignment = .Left
  }
}

class AddedAtLabel: UILabel {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.font = UIFont.systemFontOfSize(10)
    self.textAlignment = .Right
    self.backgroundColor = UIColor.whiteColor()
    self.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0)
  }
  
  required override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.font = UIFont.systemFontOfSize(10)
    self.textAlignment = .Right
    self.backgroundColor = UIColor.whiteColor()
    self.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0)
  }
  
  func displayDateTime(date: String) {
    let rawDateFormatter = NSDateFormatter()
    rawDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
    rawDateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    let gmtPubAtDate = rawDateFormatter.dateFromString(date)
    
    let dateComponentsFormatter = NSDateComponentsFormatter()
    dateComponentsFormatter.allowedUnits = [.Hour, NSCalendarUnit.Day, .Month, .Minute]
    dateComponentsFormatter.unitsStyle = .Full
    dateComponentsFormatter.maximumUnitCount = 1
    
    let currentTimestamp = NSDate()
    if gmtPubAtDate != nil {
      self.text = dateComponentsFormatter.stringFromDate(gmtPubAtDate!, toDate: currentTimestamp)
    }
  }
}

class TeamFilterButton: UIButton {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.setTitle("All Teams", forState: .Normal)
    self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
  }
}

class PlayButton: UIButton {
  required override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setImage(UIImage(named: "play_button"), forState: .Normal)
    self.backgroundColor = UIColor.clearColor()
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class TagButton:UIButton {
  required override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(frame: CGRect, text: String) {
    self.init(frame: frame)
    self.backgroundColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1.0)
    
    self.setTitle(text, forState: UIControlState.Normal)
    self.titleLabel?.font = UIFont(name:"NimbusSan-Bla", size: 10.0)
    self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    self.titleColorForState(UIControlState.Normal)
    
    self.addTarget(nil, action: "openTag:", forControlEvents: UIControlEvents.TouchUpInside)
  }
}

class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
  override init() {
    super.init()
    
    self.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    self.minimumLineSpacing = 0.5
    self.minimumInteritemSpacing = 1
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class SelectedCellBackgroundColorView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = UIColor(red: 63/255, green: 64/255, blue: 65/255, alpha: 1.0)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

class UserScreenButton: UIButton {
  required override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    
    self.setBackgroundImage(UIImage(named: "TabSlider"), forState: .Selected)
    self.setTitleColor(UIColor.whiteColor(), forState: .Selected)
    
    self.setBackgroundImage(UIImage(named: ""), forState: .Normal)
    self.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
  }
}
