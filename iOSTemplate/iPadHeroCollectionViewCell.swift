//
//  iPadHeroCollectionViewCell.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 9/21/17.
//  Copyright © 2017 Sportsrocket. All rights reserved.
//

import UIKit

class iPadHeroCollectionViewCell: UICollectionViewCell {
  @IBOutlet var iPadFeatureHeroImageView: UIImageView!
  @IBOutlet var iPadFeatureHeroTitleLabel: UILabel!
  @IBOutlet var iPadFeatureHeroDescriptionLabel: ArtifactTitleLabel!
  @IBOutlet var iPadFeatureHeroTimeElapsedLabel: AddedAtLabel!
  
  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }

}
