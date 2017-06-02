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

  override func loadAllTeams() {
    
    Session.shared().getProperty { (aProperty, error) in
      if (error == nil) {
        
        Artifact.find(bySlug: "/live", forProperty: Int32(Int((aProperty?.id)!))) { (artifact, liveError) in
          if let liveArtifact = artifact as? Artifact {
            if (error == nil) {
              let params = ["type_name.in": self.artifactTypes(), "provider": "Boxxspring", "artifact_id": Int32(Int(liveArtifact.id))] as [String : Any]

              Artifact.query(params as [AnyHashable: Any], propertyID: Int32(Int((aProperty?.id)!)), count: 20, offset: 0, onCompletion: { (artifacts, error) in
                if (error == nil) {
                  self.updateCollectionView(artifacts: artifacts as! [Artifact])
                }
                self.refreshControl.endRefreshing()
              })
            }
          }
          else {
            self.displayPlaceholderMessage()
          }
        }
      }
    }
  }
  
  override func filterTeams(_ atagID:Int) {
    artifactID = atagID
    
    Session.shared().getProperty { (aProperty, error) in
      if (error == nil) {
        Artifact.find(bySlug: "/live", forProperty: Int32(Int((aProperty?.id)!))) { (artifact, liveError) in
          if let liveArtifact = artifact as? Artifact {
            let params = ["type_name.in": self.artifactTypes(), "provider": "Boxxspring", "artifact_id": [Int32(Int(liveArtifact.id)), atagID]] as [String : Any]

            Artifact.query(params as [AnyHashable: Any], propertyID: Int32(Int((aProperty?.id)!)), count: 20, offset: 0, onCompletion: { (artifacts, error) in
              if (error == nil) {
                self.updateCollectionView(artifacts: artifacts as! [Artifact])
              }
              self.refreshControl.endRefreshing()
            })
          }
          else {
            self.displayPlaceholderMessage()
          }
        }

      }
    }
  }

  
  override func artifactTypes() -> [String] {
    return ["stream_artifact"]
  }

  override func displayPlaceholderMessage() {
    self.collectionView.isHidden = true
  }
  
}
