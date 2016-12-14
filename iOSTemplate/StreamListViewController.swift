//
//  StreamListViewController.swift
//  iOSTemplate
//
//  Created by Shovan Joshi on 12/6/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import Foundation

import Foundation

class StreamListViewController: ArtifactListViewController {

  override func artifactTypes() -> [String] {
    return ["stream_artifact"]
  }

  override func displayPlaceholderMessage() {
    self.collectionView.hidden = true
  }
  
}