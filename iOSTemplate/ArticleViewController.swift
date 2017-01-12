//
//  ArticleViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 9/27/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
  var artifactItems: [Artifact] = Array()
  var refreshControl: CustomRefreshControl!
  var collectionView: UICollectionView!
  let placeholderImage = UIImage(named: "Placeholder_nll_logo")

    override func viewDidLoad() {
      // TODO: move out in CollectionView setup
      collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height-110), collectionViewLayout: CustomCollectionViewFlowLayout())
      self.view.addSubview(collectionView)
      collectionView.allowsSelection = true
      collectionView.delegate = self
      collectionView.dataSource = self
      collectionView.canCancelContentTouches = false
      collectionView.userInteractionEnabled = true
      collectionView.registerNib(UINib(nibName: "LargeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "largeCell")
      collectionView.registerNib(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "listCell")
      // TODO: Theme
      collectionView.backgroundColor = UIColor(red: 36/255, green: 35/255, blue: 38/255, alpha: 1.0)
      collectionView!.alwaysBounceVertical = true
      
      self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
      
      setup()
      loadFeatured()
      
      super.viewDidLoad()
    }
  
  func loadFeatured() {
    Session.sharedSession().getProperty { (aProperty, error) in
      if (error == nil) {
        Group.getGroup("/featured", forProperty: Int32(Int(aProperty.id)), onCompletion: { (group, error) in
          if (error == nil) && (group != nil) {
            Artifact.getRelatedArtifacts(Int32(Int(group.id)), forProperty: group.propertyID, filter: [:], onCompletion: { (tags, error) in
              self.artifactItems = tags as! [Artifact]
//              print("stories count \(self.artifactItems.count)")
              self.collectionView.reloadData()
              self.refreshControl.endRefreshing()
            })
          }
        })
      }
    }
    collectionView.reloadData()
  }
  
  func setup() {
    let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(ArticleViewController.articleTapped(_:)))
    tapRecognizer.delegate = self
    collectionView.addGestureRecognizer(tapRecognizer)
    
    refreshControl = CustomRefreshControl()
    refreshControl.addTarget(self, action: #selector(ArticleViewController.loadFeatured), forControlEvents: .ValueChanged)
    collectionView!.addSubview(refreshControl)
  }
  
  func articleTapped(recognizer: UITapGestureRecognizer) {
    let point: CGPoint = recognizer.locationInView(recognizer.view)
    if let indexPath: NSIndexPath = collectionView.indexPathForItemAtPoint(point) {
      let item = self.artifactItems[indexPath.row]
      self.navigationController?.navigationBar.topItem?.title = ""

      let detailController = ArtifactDetailViewController(artifact: item) as UIViewController
      self.navigationController?.pushViewController(detailController, animated: true)
      detailController.title = item.name
    }
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return artifactItems.count
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    if indexPath.row == 0 || indexPath.row == 1 {
      
      let cell = collectionView.dequeueReusableCellWithReuseIdentifier("largeCell", forIndexPath: indexPath) as! LargeCollectionViewCell
      let item = artifactItems[indexPath.row]

      if let thumbnailURL = item.pictureURLwithWidth(Int32(cell.frame.width), height: Int32(cell.imageView.frame.height)) {
        cell.imageView.setImageWithURL(thumbnailURL, placeholderImage: placeholderImage)
      } else {
        cell.imageView.image = placeholderImage
      }
      
      cell.titleLabel.textColor = UIColor.blackColor()
      if let aTitle = item.name {
        cell.titleLabel.text = aTitle
      }
      cell.titleLabel.sizeToFit()
      
      if let publishedAtString = item.publishedAt {
        cell.timeElapsedLabel.displayDateTime(publishedAtString)
      }
      return cell
    }
    else {
      let relatedCell = collectionView.dequeueReusableCellWithReuseIdentifier("listCell", forIndexPath: indexPath) as! ListCollectionViewCell
      let item = artifactItems[indexPath.row]
    
      let collectionViewWidth = self.collectionView.bounds.size.width
      relatedCell.frame.size.width = collectionViewWidth
      
      if let thumbnailURL = item.pictureURLwithWidth(320, height: 180) {
        relatedCell.imageView.setImageWithURL(thumbnailURL, placeholderImage: placeholderImage)
      } else {
        relatedCell.imageView.image = placeholderImage
      }

      relatedCell.artifactNameLabel.text = item.name.uppercaseString
      relatedCell.artifactNameLabel.numberOfLines = 2
      relatedCell.artifactNameLabel.backgroundColor = UIColor.whiteColor()
      relatedCell.backgroundColor = UIColor.whiteColor()
      
      if let aAuthor = item.author() {
        relatedCell.authorLabel.text = aAuthor.name
//        print("Author\(aAuthor.name)")
      }
      else {
        relatedCell.authorLabel.text = ""
      }

      if let publishedAtString = item.publishedAt {
        relatedCell.timestampLabel.displayDateTime(publishedAtString)
      }
      return relatedCell
    }
  }
  // MARK: UICollectionViewFlowLayoutDelegate
  
  func collectionView(collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    // TODO: move into class or use size classes when more time
    enum UIUserInterfaceIdiom : Int
    {
      case Unspecified
      case Phone
      case Pad
    }
    
    struct ScreenSize
    {
      static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
      static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
      static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
      static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType
    {
      static let IS_IPHONE_4_OR_LESS  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
      static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
      static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
      static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
      static let IS_IPAD              = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    }
    
    if indexPath.row == 0 || indexPath.row == 1 {
      if DeviceType.IS_IPHONE_5 {
        return CGSize(width: self.view.frame.width, height: 270)
      }
      else {
        return CGSize(width: self.view.frame.width, height: 305)
      }
    } else {
      return CGSize(width: self.view.frame.width, height: 120)
    }
  }
  
}
