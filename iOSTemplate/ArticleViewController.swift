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
      collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height-95), collectionViewLayout: CustomCollectionViewFlowLayout())
      self.view.addSubview(collectionView)
      collectionView.allowsSelection = true
      collectionView.delegate = self
      collectionView.dataSource = self
      collectionView.canCancelContentTouches = false
      collectionView.isUserInteractionEnabled = true
      collectionView.register(UINib(nibName: "LargeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "largeCell")
      collectionView.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "listCell")
      // TODO: Theme
      collectionView.backgroundColor = UIColor(red: 36/255, green: 35/255, blue: 38/255, alpha: 1.0)
      collectionView!.alwaysBounceVertical = true
      
      self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
      
      setup()
      loadFeatured()
      
      super.viewDidLoad()
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
    refreshControl.addTarget(self, action: #selector(ArticleViewController.loadFeatured), for: .valueChanged)
    collectionView!.addSubview(refreshControl)
  }
  
  func articleTapped(_ recognizer: UITapGestureRecognizer) {
    let point: CGPoint = recognizer.location(in: recognizer.view)
    if let indexPath: IndexPath = collectionView.indexPathForItem(at: point) {
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

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return artifactItems.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.row == 0 || indexPath.row == 1 {
      
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "largeCell", for: indexPath) as! LargeCollectionViewCell
      let item = artifactItems[indexPath.row]

      if let thumbnailURL = item.pictureURLwithWidth(Int32(cell.frame.width), height: Int32(cell.imageView.frame.height)) {
        cell.imageView.setImageWith(thumbnailURL, placeholderImage: placeholderImage)
      } else {
        cell.imageView.image = placeholderImage
      }
      
      cell.titleLabel.textColor = UIColor.black
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
      let relatedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! ListCollectionViewCell
      let item = artifactItems[indexPath.row]
    
      let collectionViewWidth = self.collectionView.bounds.size.width
      relatedCell.frame.size.width = collectionViewWidth
      
      if let thumbnailURL = item.pictureURLwithWidth(320, height: 180) {
        relatedCell.imageView.setImageWith(thumbnailURL, placeholderImage: placeholderImage)
      } else {
        relatedCell.imageView.image = placeholderImage
      }

      relatedCell.artifactNameLabel.text = item.name.uppercased()
      relatedCell.artifactNameLabel.numberOfLines = 2
      relatedCell.artifactNameLabel.backgroundColor = UIColor.white
      relatedCell.backgroundColor = UIColor.white
      
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
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
    
    if indexPath.row == 0 || indexPath.row == 1 {
      if DeviceChecker.DeviceType.IS_IPHONE_5 {
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
