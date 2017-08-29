//
//  CustomSplashScreen.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 6/8/17.
//  Copyright © 2017 Sportsrocket. All rights reserved.
//

import UIKit

class CustomSplashScreen: UIView {
  var splashImageView:UIImageView!
  var constantWidth: CGFloat = 290
  var constantHeight: CGFloat = 116
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = .black

    if DeviceChecker.DeviceType.IS_IPAD || DeviceChecker.DeviceType.IS_IPAD_PRO {
      constantWidth = 600
      constantHeight = 236
    }
    self.splashImageView = UIImageView(frame: CGRect(x: (self.frame.height)/2 - 150, y: (self.frame.height)/2 - 60, width: constantWidth, height: constantHeight))
    
    setupAnimation()
    setupConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupAnimation() {
    var imgArray = [UIImage]()
    
    for index in 1...31 {
      var img = UIImage(named: "NLL_Loading_Animation_\(index).png")
      if DeviceChecker.DeviceType.IS_IPAD || DeviceChecker.DeviceType.IS_IPAD_PRO {
        img = UIImage(named: "NLL_Loading_Animation_iPad_\(index).png")
      }
      imgArray.append(img!)
    }
    self.addSubview(self.splashImageView)
    
    self.splashImageView.animationImages = imgArray.reversed()
    self.splashImageView.backgroundColor = .black
    self.splashImageView.animationDuration = 0.6
    self.splashImageView.animationRepeatCount = 0
    self.splashImageView.startAnimating()
  }
  
  func setupConstraints() {
    self.splashImageView.translatesAutoresizingMaskIntoConstraints = false
    self.addConstraint(NSLayoutConstraint(item: self.splashImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
    self.addConstraint(NSLayoutConstraint(item: self.splashImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))

    if DeviceChecker.DeviceType.IS_IPAD || DeviceChecker.DeviceType.IS_IPAD_PRO {
      constantWidth = 600
      constantHeight = 236
    }
    
    self.splashImageView.addConstraint(NSLayoutConstraint(item: self.splashImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1, constant: constantWidth))
    self.splashImageView.addConstraint(NSLayoutConstraint(item: self.splashImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant: constantHeight))
  }
}
