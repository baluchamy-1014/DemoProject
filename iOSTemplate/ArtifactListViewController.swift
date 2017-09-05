//
//  LatestViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 10/11/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

class ArtifactListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
  var collectionView: UICollectionView!
  var items = [Artifact]()
  var artifactID: Int?
  let placeholderImage = UIImage(named: "Placeholder_nll_logo")
  var refreshControl: UIRefreshControl!
  var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  var translucentBool: Bool?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - 67), collectionViewLayout: CustomCollectionViewFlowLayout())
    self.view.addSubview(collectionView)
    
    collectionView.alwaysBounceVertical = true
    collectionView.delegate = self
    collectionView.dataSource = self
    // TODO: Theme
    collectionView.backgroundColor = UIColor(red: 36/255, green: 35/255, blue: 38/255, alpha: 1.0)
    collectionView.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "listCell")
    
    setupRefreshControl()

    collectionView?.addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
    activityIndicator.startAnimating()
    
    loadData()
    // NOTE: removed load data method from here because there was a race condition between viewDidLoad and manual trigger of
    // load method. Better way to handle this is to add a flag to prevent a new call being made
  }
  
  init(artifactID anArtifactID: Int) {
    super.init(nibName:nil, bundle:nil)
    
    artifactID = anArtifactID

    Session.shared().getProperty { property, error in
      if (error == nil) {
        Artifact.getArtifact(Int32(self.artifactID!), forProperty: Int32(Int((property?.id)!))) { (response, error) in
          if let response = response as? Artifact {
            let theTitle = response.name as String
            self.title = theTitle
          }
        }
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    if self.translucentBool != nil {
      self.navigationController?.navigationBar.isTranslucent = self.translucentBool!
    }
    super.viewWillAppear(animated)
  }
  
  func shouldBeTranslucent(translucent: Bool) {
    self.translucentBool = translucent
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
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
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    var params = NSDictionary()
    if (artifactID != nil) {
      params = ["type_name.in": self.artifactTypes(), "parent_id": artifactID!, "provider": "Boxxspring"]
    }
    else {
      params = ["type_name.in": self.artifactTypes(), "provider": "Boxxspring"]
    }
    
    let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
    if (actualPosition.y < 0){
      let artifact = items[items.count-1]
      Session.shared().getProperty { (aProperty, error) in
        Artifact.queryPrevious(params as! [AnyHashable: Any], count: 20, offset: 0, reference: artifact, onCompletion: { (artifactObjects, error) in
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
    let params = ["type_name.in": artifactTypes(), "provider": "Boxxspring"] as [String : Any]
    Session.shared().getProperty { (aProperty, error) in
      if (error == nil) {
        Artifact.query(params as [AnyHashable: Any], propertyID: Int32(Int((aProperty?.id)!)), count: 20, offset: 0, onCompletion: { (artifacts, error) in
          if (error == nil) {
            self.items = artifacts as! [Artifact]
            self.collectionView.reloadData()
            if self.items.isEmpty {
              self.displayPlaceholderMessage()
            } else {
              self.collectionView.isHidden = false
            }
          }
          self.refreshControl.endRefreshing()
        })
      }
    }
  }
  
  func filterTeams(_ atagID:Int) {
    artifactID = atagID
    let params = ["type_name.in": self.artifactTypes(), "parent_id": atagID, "provider": "Boxxspring"] as [String : Any]
    // latest w/ both video and article

    Session.shared().getProperty { (aProperty, error) in
      if (error == nil) {
        Artifact.query(params as [AnyHashable: Any], propertyID: Int32(Int((aProperty?.id)!)), count: 20, offset: 0, onCompletion: { (artifacts, error) in
          if (error == nil) {
            self.items = artifacts as! [Artifact]
            self.collectionView.reloadData()
            if self.items.isEmpty {
              self.displayPlaceholderMessage()
            } else {
              self.collectionView.isHidden = false
            }
          }
          self.refreshControl.endRefreshing()
        })
      }
    }
  }
  
  func setupRefreshControl() {
    refreshControl = UIRefreshControl()
    refreshControl.tintColor = .white
    refreshControl.layer.zPosition = -1
    refreshControl.addTarget(self, action: #selector(LatestViewController.refreshCollectionView), for: .valueChanged)
    collectionView!.addSubview(refreshControl)
  }
  
  func refreshCollectionView() {
    if self.items.count > 0 {
      let artifact = self.items[0]
      var params = NSDictionary()
      
      if (artifactID != nil) {
        params = ["type_name.in": self.artifactTypes(), "parent_id": artifactID!, "provider": "Boxxspring"]
      }
      else {
        params = ["type_name.in": self.artifactTypes(), "provider": "Boxxspring"]
      }
      
      Artifact.queryNext(params as! [AnyHashable: Any], count: 20, offset: 0, reference: artifact) { (artifacts, error) in
        if (error == nil) {
          self.appendItems(artifacts: artifacts as! [Artifact])
          self.collectionView.reloadData()
        }
        self.refreshControl.endRefreshing()
      }
    }
  }
  
  private func appendItems(artifacts: [Artifact]) {
      self.items = artifacts + self.items
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let artifact = self.items[indexPath.row]
    let detailController = DetailViewController(artifact: artifact) as UIViewController
    self.navigationController?.pushViewController(detailController, animated: true)
    detailController.title = artifact.name
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! ListCollectionViewCell
    let item = self.items[indexPath.row]
    cell.backgroundColor = UIColor.white
    var collectionViewWidth = self.collectionView.bounds.size.width
    var pictureWidth:Int32 = 320
    var pictureHeight:Int32 = 180
    
    if DeviceChecker.DeviceType.IS_IPAD || DeviceChecker.DeviceType.IS_IPAD_PRO {
      collectionViewWidth = (self.collectionView.bounds.size.width/2) - 29
      pictureWidth = Int32(cell.frame.width)
      pictureHeight = Int32(cell.frame.width * (9/16))
    }
    cell.frame.size.width = collectionViewWidth
    
    if let imageURL = item.pictureURLwithWidth(pictureWidth, height: pictureHeight) {
      cell.imageView.setImageWith(imageURL, placeholderImage: placeholderImage)
    }
    else {
      cell.imageView.image = placeholderImage
    }
    
    if let artifactNameString = item.name {
      cell.artifactNameLabel.text = artifactNameString.uppercased()
    }
    else {
      cell.artifactNameLabel.text = ""
    }
    
    cell.authorLabel.font = UIFont.systemFont(ofSize: 11)
    cell.authorLabel.backgroundColor = UIColor.white
    if let aAuthor = item.author() {
      cell.authorLabel.text = aAuthor.name
    }
    else {
      cell.authorLabel.text = ""
    }
    
    if let createdAtString = item.createdAt {
      cell.timestampLabel.displayDateTime(createdAtString)
    }
    activityIndicator.stopAnimating()
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
    if DeviceChecker.DeviceType.IS_IPAD {
      return CGSize(width: (self.collectionView.bounds.size.width/2) - 29, height: 300)
    }
    else if DeviceChecker.DeviceType.IS_IPAD_PRO {
      return CGSize(width: (self.collectionView.bounds.size.width/2) - 29, height: 378)
    }
    else {
      return CGSize(width: collectionView.bounds.size.width, height: CGFloat(120))
    }
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func displayPlaceholderMessage() {

  }
  
  func updateCollectionView(artifacts: [Artifact]) {
    // TODO: #SJ use this for the main artifactlist controller as well during next update
    self.items = artifacts 
    self.collectionView.reloadData()
    if self.items.isEmpty {
      self.displayPlaceholderMessage()
    } else {
      self.collectionView.isHidden = false
    }
  }
}
