//
//  FeaturedViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 9/27/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

class FeaturedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  var artifactItems: [Artifact] = Array()
  var refreshControl: UIRefreshControl!
  var collectionView: UICollectionView!
  let placeholderImage = UIImage(named: "Placeholder_nll_logo")
  var artifactID: Int?

  override func viewDidLoad() {
    // TODO: move out in CollectionView setup
    collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 100), collectionViewLayout: CustomCollectionViewFlowLayout())
    self.view.addSubview(collectionView)
    collectionView.allowsSelection = true
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.canCancelContentTouches = false
    collectionView.isUserInteractionEnabled = true
    collectionView.register(UINib(nibName: "LargeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "largeCell")
    collectionView.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "listCell")
    collectionView.register(UINib(nibName: "iPadHeroCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "iPadFeatureHero")
    // TODO: Theme
    collectionView.backgroundColor = UIColor(red: 36/255, green: 35/255, blue: 38/255, alpha: 1.0)
    collectionView!.alwaysBounceVertical = true
    
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    
    setup()
    loadData()
    
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if (self.revealViewController() != nil) {
      self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    }
  }
  
  func loadData() {
    if (artifactID != nil) {
      filterTeams(artifactID!)
    }
    else {
      loadFeatured()
    }
  }
  
  func loadFeatured() {
    Session.shared().getProperty { (aProperty, error) in
      if (error == nil) {
        Group.getGroup("/featured", forProperty: Int32(Int((aProperty?.id)!)), onCompletion: { (group, error) in
          if (error == nil) && (group != nil) {
            Artifact.getRelatedArtifacts(Int32(Int((group?.id)!)), forProperty: (group?.propertyID)!, filter: [:], onCompletion: { (tags, error) in
              self.artifactItems = tags as! [Artifact]
//              print("stories count \(self.artifactItems.count)")
              self.collectionView.reloadData()
              if self.artifactItems.isEmpty {
                self.displayPlaceholderMessage()
              } else {
                self.collectionView.isHidden = false
              }
              self.refreshControl.endRefreshing()
            })
          }
        })
      }
    }
    collectionView.reloadData()
  }
  
  func filterTeams(_ atagID:Int) {
    Session.shared().getProperty { (aProperty, error) in
      if (error == nil) {
        Group.getGroup("/featured", forProperty: Int32(Int((aProperty?.id)!)), onCompletion: { (group, error) in
          if (error == nil) && (group != nil) {
            let featuredTeamDict = ["artifact_id": [Int32(Int((group?.id)!)), atagID]]
            Artifact.query(featuredTeamDict as [AnyHashable : Any], propertyID: Int32(Int((aProperty?.id)!)), count: 20, offset: 0, onCompletion: { (artifacts, error) in
              if (error == nil) {
                self.artifactItems = artifacts as! [Artifact]
                self.collectionView.reloadData()
                if self.artifactItems.isEmpty {
                  self.displayPlaceholderMessage()
                } else {
                  self.collectionView.isHidden = false
                }
              }
              self.refreshControl.endRefreshing()
            })
          }
        })
      }
    }
  }
  
  func setup() {
    refreshControl = UIRefreshControl()
    refreshControl.tintColor = .white
    refreshControl.layer.zPosition = -1
    refreshControl.addTarget(self, action: #selector(FeaturedViewController.loadFeatured), for: .valueChanged)
    collectionView!.addSubview(refreshControl)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let item = self.artifactItems[indexPath.row]
    self.navigationController?.navigationBar.topItem?.title = ""

    let detailController = DetailViewController(artifact: item) as UIViewController
    self.navigationController?.pushViewController(detailController, animated: true)
    detailController.title = item.name
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return artifactItems.count
  }
  
  func applyiPadHeroCellSettings(cell: iPadHeroCollectionViewCell, item: Artifact, cellHeight: Int32) {
    if let thumbnailURL = item.pictureURLwithWidth(Int32(cell.frame.width), height: cellHeight) {
      cell.iPadFeatureHeroImageView.setImageWith(thumbnailURL, placeholderImage: placeholderImage)
    }
    else {
      cell.iPadFeatureHeroImageView.image = placeholderImage
    }
    cell.iPadFeatureHeroTitleLabel.textColor = UIColor.black
    if let aTitle = item.name {
      cell.iPadFeatureHeroTitleLabel.text = aTitle
    }
    cell.iPadFeatureHeroTitleLabel.sizeToFit()
    
    if let longDescriptionString = item.longDescription
    {
      cell.iPadFeatureHeroDescriptionLabel.numberOfLines = 2
      cell.iPadFeatureHeroDescriptionLabel.text = longDescriptionString
    }
    
    if let createdAtString = item.createdAt {
      cell.iPadFeatureHeroTimeElapsedLabel.displayDateTime(createdAtString)
    }
  }
  
  func applyLargeCellSettings(cell: LargeCollectionViewCell, item: Artifact, cellHeight: Int32) {
    if let thumbnailURL = item.pictureURLwithWidth(Int32(cell.frame.width), height: cellHeight) {
      cell.imageView.setImageWith(thumbnailURL, placeholderImage: placeholderImage)
    }
    else {
      cell.imageView.image = placeholderImage
    }
    cell.titleLabel.textColor = UIColor.black
    if let aTitle = item.name {
      cell.titleLabel.text = aTitle
    }
    cell.titleLabel.sizeToFit()
    
    if let longDescriptionString = item.longDescription
    {
      cell.descriptionLabel.numberOfLines = 2
      cell.descriptionLabel.text = longDescriptionString
    }
    
    if let createdAtString = item.createdAt {
      cell.timeElapsedLabel.displayDateTime(createdAtString)
    }

  }
  
  func applyListCellSettings(cell: ListCollectionViewCell, item: Artifact, cellHeight: Int32, cellWidth: Int32) {
    if let thumbnailURL = item.pictureURLwithWidth(cellWidth, height: cellHeight) {
      cell.imageView.setImageWith(thumbnailURL, placeholderImage: self.placeholderImage)
    }
    else {
      cell.imageView.image = self.placeholderImage
    }
    cell.artifactNameLabel.text = item.name.uppercased()
    cell.artifactNameLabel.numberOfLines = 2
    cell.artifactNameLabel.backgroundColor = UIColor.white
    cell.backgroundColor = UIColor.white
    
    if let aAuthor = item.author() {
      cell.authorLabel.text = aAuthor.name
    }
    else {
      cell.authorLabel.text = ""
    }
    
    if let createdAtString = item.createdAt {
      cell.timestampLabel.displayDateTime(createdAtString)
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if DeviceChecker.DeviceType.IS_IPAD || DeviceChecker.DeviceType.IS_IPAD_PRO {
      if indexPath.row == 0 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iPadFeatureHero", for: indexPath) as! iPadHeroCollectionViewCell
        let item = artifactItems[indexPath.row]
        let cellHeight = Int32(cell.frame.width * (9/16))
        applyiPadHeroCellSettings(cell: cell, item: item, cellHeight: cellHeight)
        return cell
      }
      else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! ListCollectionViewCell
        let item = artifactItems[indexPath.row]
        let collectionViewWidth = (self.collectionView.bounds.size.width/2) - 29
        cell.frame.size.width = collectionViewWidth
        
        applyListCellSettings(cell: cell, item: item, cellHeight:Int32(cell.frame.width * (9/16)), cellWidth: Int32(collectionViewWidth))

        return cell
      }
    }
    else {
      if indexPath.row == 0 || indexPath.row == 1 {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "largeCell", for: indexPath) as! LargeCollectionViewCell
        let item = artifactItems[indexPath.row]
        let cellHeight = Int32(cell.imageView.frame.height)
        
        applyLargeCellSettings(cell: cell, item: item, cellHeight: cellHeight)
        return cell
      }
      else {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! ListCollectionViewCell
        let item = artifactItems[indexPath.row]
        applyListCellSettings(cell: cell, item: item, cellHeight: 180, cellWidth: 320)

        return cell
      }
    }
  }
  // MARK: UICollectionViewFlowLayoutDelegate
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {

    if DeviceChecker.DeviceType.IS_IPAD {
      if indexPath.row == 0 {
        return CGSize(width: self.view.frame.width-40, height: 550)
      }
      else {
        return CGSize(width: (self.collectionView.bounds.size.width/2) - 29, height: 308)
      }
    }
    else if DeviceChecker.DeviceType.IS_IPAD_PRO {
      if indexPath.row == 0 {
        return CGSize(width: self.view.frame.width-40, height: 670)
      }
      else {
        return CGSize(width: (self.collectionView.bounds.size.width/2) - 29, height: 378)
      }
    }
    else {
      if DeviceChecker.DeviceType.IS_IPHONE_5 {
        if indexPath.row == 0 || indexPath.row == 1 {
          return CGSize(width: self.view.frame.width, height: 270)
        }
        else {
          return CGSize(width: self.view.frame.width, height: 120)
        }
      }
      else {
        if indexPath.row == 0 || indexPath.row == 1 {
          return CGSize(width: self.view.frame.width, height: 305)
        }
        else {
          return CGSize(width: self.view.frame.width, height: 120)
        }
      }
    }
  }
  
  func displayPlaceholderMessage() {
    self.collectionView.isHidden = true
  }
  
}
