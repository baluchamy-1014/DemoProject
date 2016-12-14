//
//  CollectionViewCell.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 9/27/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

class LargeCollectionViewCell: UICollectionViewCell {
    
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var authorLabel: AuthorLabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var titleLabel: ArtifactTitleLabel!
  @IBOutlet weak var timeElapsedLabel: AddedAtLabel!
  
}
