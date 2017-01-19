//
//  LatestViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 10/11/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

class ArtifactListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, UIScrollViewDelegate {
  var collectionView: UICollectionView!
  var items = [Artifact]()
  var artifactID: Int?
  let placeholderImage = UIImage(named: "Placeholder_nll_logo")
  var refreshControl: CustomRefreshControl!
  var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.backItem?.title = ""
    
    collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height-110), collectionViewLayout: CustomCollectionViewFlowLayout())
    self.view.addSubview(collectionView)
    
    collectionView.alwaysBounceVertical = true
    collectionView.delegate = self
    collectionView.dataSource = self
    // TODO: Theme
    collectionView.backgroundColor = UIColor(red: 36/255, green: 35/255, blue: 38/255, alpha: 1.0)
    collectionView.registerNib(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "listCell")
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(LatestViewController.articleTapped(_:)))
    tapRecognizer.delegate = self
    collectionView.addGestureRecognizer(tapRecognizer)

    refreshControl = CustomRefreshControl()
    refreshControl.addTarget(self, action: #selector(LatestViewController.loadAllTeams), forControlEvents: .ValueChanged)
    collectionView!.addSubview(refreshControl)

    collectionView?.addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
    activityIndicator.startAnimating()
    
    // NOTE: removed load data method from here because there was a race condition between viewDidLoad and manual trigger of
    // load method. Better way to handle this is to add a flag to prevent a new call being made
  }
  
  init(artifactID anArtifactID: Int) {
    super.init(nibName:nil, bundle:nil)
    
    artifactID = anArtifactID
    filterTeams(artifactID!)

    Session.sharedSession().getProperty { property, error in
      if (error == nil) {
        Artifact.getArtifact(Int32(self.artifactID!), forProperty: Int32(Int(property.id))) { (response, error) in
          let theTitle = response.name as String
          self.title = theTitle
        }
      }
    }
 }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func artifactTypes() -> [String] {
    return []
  }

  func loadData() {
    if (artifactID != nil) {
      filterTeams(artifactID!)
    }
    else {
      loadAllTeams()
    }
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    var params = NSDictionary()
    if (artifactID != nil) {
      params = ["type_name.in": self.artifactTypes(), "parent_id": artifactID!, "provider": "Boxxspring"]
    }
    else {
      params = ["type_name.in": self.artifactTypes(), "provider": "Boxxspring"]
    }
    
    let actualPosition = scrollView.panGestureRecognizer.translationInView(scrollView.superview)
    if (actualPosition.y < 0){
      let artifact = items[items.count-1]
      Session.sharedSession().getProperty { (aProperty, error) in
        Artifact.queryPrevious(params as [NSObject : AnyObject], count: 20, offset: 0, reference: artifact, onCompletion: { (artifactObjects, error) in
          print(artifactObjects)
          if error == nil {
            let newStories: [Artifact] = (artifactObjects as! Array)
            self.items = self.items + newStories
            self.collectionView.reloadData()
          }
        })
      }
    }
  }

  func loadAllTeams() {
    let params = ["type_name.in": artifactTypes(), "provider": "Boxxspring"]
    Session.sharedSession().getProperty { (aProperty, error) in
      if (error == nil) {
        Artifact.query(params as [NSObject : AnyObject], propertyID: Int32(Int(aProperty.id)), count: 50, offset: 0, onCompletion: { (artifacts, error) in
          if (error == nil) {
            self.items = artifacts as! [Artifact]
            self.collectionView.reloadData()
            if self.items.isEmpty {
              self.displayPlaceholderMessage()
            } else {
              self.collectionView.hidden = false
            }
          }
          self.refreshControl.endRefreshing()
        })
      }
    }
  }
  
  func filterTeams(atagID:Int) {
    artifactID = atagID
    let params = ["type_name.in": self.artifactTypes(), "parent_id": atagID, "provider": "Boxxspring"]
    // latest w/ both video and article

    Session.sharedSession().getProperty { (aProperty, error) in
      if (error == nil) {
        Artifact.query(params as [NSObject : AnyObject], propertyID: Int32(Int(aProperty.id)), count: 50, offset: 0, onCompletion: { (artifacts, error) in
          if (error == nil) {
            self.items = artifacts as! [Artifact]
            self.collectionView.reloadData()
            if self.items.isEmpty {
              self.displayPlaceholderMessage()
            } else {
              self.collectionView.hidden = false
            }
          }
          self.refreshControl.endRefreshing()
        })
      }
    }
  }
  
  func articleTapped(recognizer: UITapGestureRecognizer) {
    let point: CGPoint = recognizer.locationInView(recognizer.view)
    if let indexPath: NSIndexPath = collectionView.indexPathForItemAtPoint(point) {
      let artifact = self.items[indexPath.row]
      self.navigationController?.navigationBar.topItem?.title = ""
      let detailController = ArtifactDetailViewController(artifact: artifact) as UIViewController
      self.navigationController?.pushViewController(detailController, animated: true)
      detailController.title = artifact.name
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("listCell", forIndexPath: indexPath) as! ListCollectionViewCell
    let item = self.items[indexPath.row]
    cell.backgroundColor = UIColor.whiteColor()
    
    let collectionViewWidth = self.collectionView.bounds.size.width
    cell.frame.size.width = collectionViewWidth
    
    if let imageURL = item.pictureURLwithWidth(320, height: 180) {
      cell.imageView.setImageWithURL(imageURL, placeholderImage: placeholderImage)
    }
    else {
      cell.imageView.image = placeholderImage
    }
    
    if let artifactNameString = item.name {
      cell.artifactNameLabel.text = artifactNameString.uppercaseString
    }
    else {
      cell.artifactNameLabel.text = ""
    }
    
    cell.authorLabel.font = UIFont.systemFontOfSize(11)
    cell.authorLabel.backgroundColor = UIColor.whiteColor()
    if let aAuthor = item.author() {
      cell.authorLabel.text = aAuthor.name
    }
    else {
      cell.authorLabel.text = ""
    }
    
    if let publishedAtString = item.publishedAt {
      cell.timestampLabel.displayDateTime(publishedAtString)
    }
    activityIndicator.stopAnimating()
    return cell
  }
  
  func collectionView(collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return CGSizeMake(collectionView.bounds.size.width, CGFloat(120))
  }
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }

  func displayPlaceholderMessage() {

  }
}
