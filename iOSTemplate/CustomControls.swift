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
  override func draw(_ rect: CGRect) {
    self.customize()
  }
  
  func imageWithColor(_ color: UIColor) -> UIImage {
    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: self.frame.size.height)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor);
    context?.fill(rect);
    let image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image!    
  }
  
  func customize() {
    self.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 18), NSForegroundColorAttributeName:UIColor(red: 136/266, green: 136/255, blue: 136/255, alpha: 1.0)], for:UIControlState())
    self.setTitleTextAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 18), NSForegroundColorAttributeName:UIColor.white], for:UIControlState.selected)
    
    self.setDividerImage(self.imageWithColor(UIColor.clear), forLeftSegmentState: UIControlState(), rightSegmentState: UIControlState(), barMetrics: UIBarMetrics.default)
    
    self.setBackgroundImage(self.imageWithColor(UIColor.clear), for:UIControlState(), barMetrics:UIBarMetrics.default)
    // TODO: theme
    self.setBackgroundImage(UIImage(named: "TabSlider"), for:UIControlState.selected, barMetrics:UIBarMetrics.default);   
  }
}

class AuthorLabel: UILabel {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.font = UIFont.systemFont(ofSize: 11)
    self.textColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 1.0)
    self.backgroundColor = UIColor.white
    self.textAlignment = .left
  }
}

class ArtifactTitleLabel: UILabel {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)

    self.textColor = UIColor(red: 22/255, green: 22/255, blue: 22/255, alpha: 1.0)
    self.backgroundColor = UIColor.white
    self.textAlignment = .left
  }
}

class SignInUpTextField: UITextField {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func createBottomBorder() {
    let border = CALayer()
    let width = CGFloat(2.0)
    border.borderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1.0).cgColor

    border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
    border.borderWidth = width
    self.layer.addSublayer(border)
    self.layer.masksToBounds = true
    
    
    if let _ = self.placeholder{
      self.self.attributedPlaceholder = NSAttributedString(string:self.placeholder!,
                                                                    attributes:[NSForegroundColorAttributeName: UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0)])
    }
  }
}

class AddedAtLabel: UILabel {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.textAlignment = .left
    self.backgroundColor = UIColor.white
    self.textColor = UIColor(red: 149/255, green: 149/255, blue: 149/255, alpha: 1.0)
  }
  
  required override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.font = UIFont.systemFont(ofSize: 10)
    self.textAlignment = .left
    self.backgroundColor = UIColor.white
    self.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0)
  }
  
  func displayDateTime(_ date: String) {
    let rawDateFormatter = DateFormatter()
    rawDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
    rawDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    let gmtPubAtDate = rawDateFormatter.date(from: date)
    
    let dateComponentsFormatter = DateComponentsFormatter()
    dateComponentsFormatter.allowedUnits = [.hour, NSCalendar.Unit.day, .month, .minute]
    dateComponentsFormatter.unitsStyle = .full
    dateComponentsFormatter.maximumUnitCount = 1
    
    let currentTimestamp = Date()
    if gmtPubAtDate != nil {
      self.text = dateComponentsFormatter.string(from: gmtPubAtDate!, to: currentTimestamp)
    }
  }
}

class TeamFilterButton: UIButton {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    self.setTitle("All Teams", for: UIControlState())
    self.setTitleColor(UIColor.white, for: UIControlState())
  }
}

class PlayButton: UIButton {
  required override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setImage(UIImage(named: "PlayButton"), for: UIControlState())
    self.backgroundColor = UIColor.clear
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
    self.backgroundColor = UIColor(red: 37/255, green: 38/255, blue: 39/255, alpha: 1.0)
    
    self.setTitle(text, for: UIControlState())
    self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    self.setTitleColor(UIColor.white, for: UIControlState())
    self.titleColor(for: UIControlState())
    
    self.layer.cornerRadius = 2.0
    
    self.addTarget(nil, action: "openTag:", for: UIControlEvents.touchUpInside)
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

class SelectedCellBurgerMenuBackgroundColorView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = UIColor(red: 60/255, green: 75/255, blue: 87/255, alpha: 1.0)
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
    
    self.setBackgroundImage(UIImage(named: "TabSlider"), for: .selected)
    self.setTitleColor(UIColor.white, for: .selected)
    
    self.setBackgroundImage(UIImage(named: ""), for: UIControlState())
    self.setTitleColor(UIColor.lightGray, for: UIControlState())
  }
}

class SignInUpButton: UIButton {
  required override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
    
    self.setBackgroundImage(self.imageWithColor(UIColor(red: 127/255, green: 127/255, blue: 127/255, alpha: 1.0)), for: .disabled)
    self.setTitleColor(UIColor.lightGray, for: .disabled)
    
    self.setBackgroundImage(self.imageWithColor(UIColor(red: 106/255, green: 154/255, blue: 50/255, alpha: 1.0)), for: UIControlState())
    self.setTitleColor(UIColor.white, for: UIControlState())
    
    self.layer.cornerRadius = 5.0
    self.clipsToBounds = true
  }
  
  func imageWithColor(_ color: UIColor) -> UIImage {
    let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: self.frame.size.height)
    UIGraphicsBeginImageContext(rect.size)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(color.cgColor);
    context?.fill(rect);
    let image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image!
  }
}

class EmailValidator {
  func isValidEmail(_ testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    
    return emailTest.evaluate(with: testStr)
  }
}

class DeviceChecker {
  enum UIUserInterfaceIdiom: Int
  {
    case unspecified
    case phone
    case pad
  }
  
  struct ScreenSize
  {
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
  }
  
  struct DeviceType
  {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
  }
}
