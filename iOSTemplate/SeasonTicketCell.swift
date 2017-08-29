//
//  SeasonTicketCell.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 5/8/17.
//  Copyright © 2017 Sportsrocket. All rights reserved.
//

import UIKit

class SeasonTicketCell: UITableViewCell {
  @IBOutlet var seasonPassTitle: UILabel!

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
