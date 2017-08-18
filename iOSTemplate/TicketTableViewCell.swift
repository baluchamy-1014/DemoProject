//
//  TicketTableViewCell.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 3/6/17.
//  Copyright © 2017 Sportsrocket. All rights reserved.
//

import UIKit

class TicketTableViewCell: UITableViewCell {
  @IBOutlet weak var passTitle: UILabel!
  @IBOutlet weak var passSubtitle: UILabel!
  @IBOutlet weak var passPrice: UILabel!
  @IBOutlet weak var passTax: UILabel!
  @IBOutlet weak var passTopBorderView: UIView!
  @IBOutlet weak var passBottomBorderView: UIView!
  @IBOutlet weak var passLeadingImage: UIImageView!
  @IBOutlet weak var passTrailingImage: UIImageView!

  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)

      // Configure the view for the selected state
  }
  
  override var frame: CGRect {
    get {
      return super.frame
    }
    set (newFrame) {
    
      var frame = newFrame
      var newWidth = frame.width
      
      if DeviceChecker.DeviceType.IS_IPAD || DeviceChecker.DeviceType.IS_IPAD_PRO {
        newWidth = frame.width * 0.76
      }
      let margins = (frame.width - newWidth) / 2
      frame.size.width = newWidth
      frame.origin.x += margins
      
      super.frame = frame
      
    }
  }
  
}
