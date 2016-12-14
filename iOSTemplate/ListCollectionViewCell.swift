//
//  ListCollectionViewCell.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 10/18/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var artifactNameLabel: ArtifactTitleLabel!
  @IBOutlet weak var authorLabel: AuthorLabel!
  @IBOutlet weak var timestampLabel: AddedAtLabel!
}
