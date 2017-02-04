//
//  BurgerMenuCell.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 2/3/17.
//  Copyright © 2017 Sportsrocket. All rights reserved.
//

import UIKit

class BurgerMenuCell: UITableViewCell {
  @IBOutlet weak var burgerCellLabel: UILabel!
  @IBOutlet weak var burgerMenuImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
        // Initialization code
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
  }
    
}
