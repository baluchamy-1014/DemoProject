//
//  ArtifactListViewController.swift
//  iOSTemplate
//
//  Created by Shovan Joshi on 12/6/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//


import UIKit

class LatestViewController: ArtifactListViewController {
  
  override func artifactTypes() -> [String] {
    return ["video_artifact"]
  }
  
}