//
//  DetailViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 9/29/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

enum VideoPlayerState {
  case NotReady
  case Initialized
  case ReadyForDisplay
  case Failed
  case RestrictedAuthentication
  case RestrictedPaygate
}

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, BoxxspringVideoPlayerDelegate, UserSessionDelegate {
  
  var detailCollectionView: UICollectionView!
  var tagSection: TagSection!
  var artifact: Artifact!
  var items: [Artifact] = Array()
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  var counter: Int = 0
  let placeholderImage = UIImage(named: "Placeholder_nll_logo")
  let videoPlayerController = VideoPlayerController()
  var videoReadyForPlayback = false
  var headerImageView: UIImageView!
  let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
  var button: PlayButton!
  let signInButton = UIButton(type: .roundedRect)
  let buyNowButton = UIButton(type: .roundedRect)

  var videoPlayerState: VideoPlayerState = .NotReady {
    didSet {
      switch videoPlayerState {
      case .ReadyForDisplay:
        presentVideoPlayerController()
      case .RestrictedAuthentication, .RestrictedPaygate:
        resetRestrictionView()
      default:
        print("Nothing to be done.")
      }
    }
  }

  init(artifact anArtifact: Artifact) {
    super.init(nibName:nil, bundle:nil)
    artifact = anArtifact
    videoPlayerController.delegateController = self


  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    detailCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: CustomCollectionViewFlowLayout())
    detailCollectionView.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "listCell")
    detailCollectionView.delegate = self
    detailCollectionView.dataSource = self
    detailCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
    loadRelatedContent()
    detailCollectionView.backgroundColor = UIColor(red: 36/255, green: 35/255, blue: 38/255, alpha: 1.0)
    self.navigationController?.navigationBar.backgroundColor = UIColor(red: 16/255, green: 24/255, blue: 31/255, alpha: 1.0)
    videoPlayerController.navController = self.navigationController
    
    if headerImageView != nil && videoPlayerState != .ReadyForDisplay {
      setupRestrictionOverlay()
    }
    self.view.addSubview(detailCollectionView)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    signInButton.isEnabled = true
    buyNowButton.isEnabled = true

    self.navigationController?.navigationBar.isTranslucent = false
    self.navigationController?.navigationBar.barTintColor = UIColor(red: 16/255, green: 24/255, blue: 31/255, alpha: 1.0)
    videoPlayerController.navController = self.navigationController
  }
  
  override func viewWillDisappear(_ animated: Bool) {
     self.navigationController?.navigationBar.isTranslucent = true
  }
  
  func setupRestrictionOverlay() {
    var buyNowButtonWidth: CGFloat = headerImageView.frame.width/2
    var buyNowXOrigin: CGFloat = headerImageView.frame.width/2
    let overlayView = UIView(frame: CGRect(x: 0, y: 0, width: headerImageView.frame.width, height: headerImageView.frame.height - 60))
    overlayView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
    let overlayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: headerImageView.frame.width-100, height: 180))
    
    overlayLabel.numberOfLines = 3
    overlayLabel.text = "This content requires you to be signed in and have an NLL Pass."
    overlayLabel.textAlignment = .center
    overlayLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightSemibold)
    overlayLabel.textColor = UIColor.white
    overlayView.addSubview(overlayLabel)
    headerImageView.addSubview(overlayView)
    
    overlayLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addConstraint(NSLayoutConstraint(item: overlayLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: overlayView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: overlayLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: overlayView, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: overlayLabel, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 180))
    view.addConstraint(NSLayoutConstraint(item: overlayLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 250))
    
    buyNowButton.setTitle("BUY NOW", for: .normal)
    buyNowButton.setTitleColor(UIColor.white, for: .normal)
    buyNowButton.frame = CGRect(x: buyNowXOrigin, y: headerImageView.frame.height - 60, width: buyNowButtonWidth, height: 60)
    buyNowButton.backgroundColor = UIColor(red: 136/255, green: 136/255, blue: 136/255, alpha: 1.0)
    buyNowButton.addTarget(self, action: #selector(DetailViewController.displaySubscriptionOptions(_:)), for: UIControlEvents.touchUpInside)
    headerImageView.addSubview(buyNowButton)
    
    if Session.shared().isValid() {
      buyNowButtonWidth = headerImageView.frame.width
      buyNowXOrigin = 0
    }
    else {
      signInButton.setTitle("SIGN IN", for: .normal)
      signInButton.setTitleColor(UIColor.white, for: .normal)
      signInButton.frame = CGRect(x: 0, y: headerImageView.frame.height - 60, width: headerImageView.frame.width/2, height: 60)
      signInButton.backgroundColor = UIColor(red: 37/255, green: 38/255, blue: 39/255, alpha: 1.0)
      signInButton.addTarget(self, action: #selector(DetailViewController.userTappedSignInButton), for: UIControlEvents.touchUpInside)
      headerImageView.addSubview(signInButton)
    }
    buyNowButton.frame = CGRect(x: buyNowXOrigin, y: headerImageView.frame.height - 60, width: buyNowButtonWidth, height: 60)
  }
  
  func loadRelatedContent() {
    var params: [String:String] = [:]
    
    switch artifact.typeName {
    case "video_artifact":
      params = ["type_name.in": "video_artifact", "provider": "Boxxspring"]
    case "article_artifact":
      params = ["type_name.in": "video_artifact", "provider": "Boxxspring"]
    case "stream_artifact":
      params = ["type_name.in": "stream_artifact", "provider": "Boxxspring"]
    default:
      break
    }

    Session.shared().getProperty { property, error in
      if (error == nil) {
        Artifact.getArtifact(Int32(Int(self.artifact.id)), forProperty: Int32(Int((property?.id)!))) { (relatedArtifact, error) in
          if let relatedArtifact = relatedArtifact as? Artifact {
            if error == nil && relatedArtifact.tags() != nil && relatedArtifact.tags().count > 0 {
              let tag = relatedArtifact.tags()[0]

              self.tagSection = TagSection(x: 0, y: 340, width: 299, height: 100, tags: relatedArtifact.tags() as Array<AnyObject>)
              self.tagSection.view.backgroundColor = UIColor.clear
              self.tagSection.setupTags()

              if (tag as? Artifact) != nil {
                Artifact.getRelatedArtifacts(Int32(Int((tag as AnyObject).id)), forProperty: Int32(Int((property?.id)!)), filter: params as [AnyHashable: Any], onCompletion: { (relatedVideos, error) in
                  self.items = relatedVideos as! Array
                  self.detailCollectionView.reloadData()
                })
              }
            }
          }
        }
      }
    }

  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }
    
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCell", for: indexPath) as! ListCollectionViewCell
    let item = items[indexPath.row]
    cell.backgroundColor = UIColor.white
    
    let collectionViewWidth = detailCollectionView.bounds.size.width
    cell.frame.size.width = collectionViewWidth
    
    if let imageURL = item.pictureURLwithWidth(320, height: 180) {
      cell.imageView.setImageWith(imageURL, placeholderImage: placeholderImage)
    }
    else {
      cell.imageView.image = placeholderImage
    }
    
    cell.artifactNameLabel.text = item.name
    cell.artifactNameLabel.numberOfLines = 2
    cell.artifactNameLabel.backgroundColor = UIColor.white
    
    cell.authorLabel.font = UIFont.systemFont(ofSize: 12)
    cell.authorLabel.backgroundColor = UIColor.white
    if let aAuthor = item.author() {
      cell.authorLabel.text = aAuthor.name
    }
    else {
      cell.authorLabel.text = ""
    }
    
    cell.timestampLabel.font = UIFont.systemFont(ofSize: 12)
    cell.timestampLabel.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0)
    if let createdAtString = item.createdAt {
      cell.timestampLabel.displayDateTime(createdAtString)
    }
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  


  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
  {
    var reusableHeaderView: UICollectionReusableView! = nil
    if (kind == UICollectionElementKindSectionHeader) {
      reusableHeaderView = detailCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header", for: indexPath) as UICollectionReusableView
      reusableHeaderView.backgroundColor = UIColor.white
      
      headerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: reusableHeaderView.frame.size.width, height: 200))
      headerImageView.isUserInteractionEnabled = true
      reusableHeaderView.addSubview(headerImageView)

      if artifact.typeName == "video_artifact" || artifact.typeName == "stream_artifact" {
        button = PlayButton(frame: CGRect(x: (headerImageView.frame.size.width/2) - 30, y: (headerImageView.frame.size.height/2) - 30, width: 60, height: 60))
        button.addTarget(self, action: #selector(DetailViewController.openVideoPlayer(_:)), for: UIControlEvents.touchUpInside)
        headerImageView.addSubview(button)
      }

      activityIndicator.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
      activityIndicator.backgroundColor = UIColor.black
      activityIndicator.layer.cornerRadius = 32.0
      activityIndicator.layer.opacity = 0.55
      activityIndicator.center = headerImageView.center
      headerImageView.addSubview(activityIndicator)

//      displayPlaybackButton()
      
      if let thumbnailImageURL = artifact.pictureURLwithWidth(Int32(headerImageView.frame.width), height: Int32(headerImageView.frame.height)) {
        headerImageView.setImageWith(thumbnailImageURL, placeholderImage: placeholderImage)
      } else {
        headerImageView.image = placeholderImage
      }
        

      
      // Todo: Create custom labels
      let articleLabel = UILabel(frame: CGRect(x: 20, y: 220, width: reusableHeaderView.frame.size.width-40, height: 45))
      articleLabel.font = UIFont.boldSystemFont(ofSize: 20)
      articleLabel.numberOfLines = 2
      articleLabel.text = artifact.name
      articleLabel.sizeToFit()
      reusableHeaderView.addSubview(articleLabel)
      
      let authorLabel = UILabel(frame: CGRect(x: 10, y: 261, width: 200, height: 16))
      authorLabel.font = UIFont.systemFont(ofSize: 12)
      authorLabel.backgroundColor = UIColor.white
      authorLabel.textColor = UIColor.black
      // hiding hiding author label
      //      reusableHeaderView.addSubview(authorLabel)
      if let authorString = artifact.author() {
        authorLabel.text = authorString.name
      }
      
      let dateLabel = AddedAtLabel(frame: CGRect(x: 20, y: articleLabel.frame.height + 230, width: 160, height: 16))
      dateLabel.font = UIFont.systemFont(ofSize: 12)
      dateLabel.backgroundColor = UIColor.white
      if let createdAtString = artifact.createdAt {
        dateLabel.displayDateTime(createdAtString)
      }
      reusableHeaderView.addSubview(dateLabel)

      let articleDescriptionTextView = UITextView(frame: CGRect(x: 16, y: dateLabel.frame.origin.y + dateLabel.frame.height + 10, width: reusableHeaderView.frame.size.width - 32, height: 0))
      articleDescriptionTextView.backgroundColor = UIColor.white
      articleDescriptionTextView.font = UIFont.systemFont(ofSize: 15)
      articleDescriptionTextView.isEditable = false
      articleDescriptionTextView.isScrollEnabled = false
      if let longDescriptionString = artifact.longDescription
      {
        articleDescriptionTextView.text = longDescriptionString
        if articleDescriptionTextView.text != "" {
          articleDescriptionTextView.sizeToFit()
        }
      }
      reusableHeaderView.addSubview(articleDescriptionTextView)

      if tagSection != nil {
        reusableHeaderView.addSubview(tagSection.view)
      }
      
      if counter != 0 {
      let relatedVideosLabel = UILabel(frame: CGRect(x: 20, y: reusableHeaderView.frame.size.height-40, width: 400, height: 26))
      relatedVideosLabel.font = UIFont.boldSystemFont(ofSize: 24)
      relatedVideosLabel.textColor = UIColor.black
      relatedVideosLabel.text = "Related Content"
      reusableHeaderView.addSubview(relatedVideosLabel)
      
      let horizontalLine = UIView(frame: CGRect(x: 0, y: reusableHeaderView.frame.size.height, width: self.view.frame.size.width, height: 0.5))
      // TODO: theme
      horizontalLine.backgroundColor = UIColor(red: 36/255, green: 35/255, blue: 38/255, alpha: 1.0)
      reusableHeaderView.addSubview(horizontalLine)
      }
      counter += 1
      reusableHeaderView.backgroundColor = UIColor.white
      if tagSection != nil {
        tagSection.view.frame.origin.y = articleDescriptionTextView.frame.height + articleLabel.frame.height + 271
      }
      return reusableHeaderView
    }
    return reusableHeaderView
  }
  
  func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, referenceSizeForHeaderInSection section: Int) -> CGSize
  {
    let articleDescriptionTextView = UITextView(frame: CGRect(x: 41, y: 220, width: self.view.frame.width - 32, height: 0))
    articleDescriptionTextView.font = UIFont.systemFont(ofSize: 15)
    if let artifactDescription = artifact.longDescription {
      articleDescriptionTextView.text = artifactDescription
      if articleDescriptionTextView.text != "" {
        articleDescriptionTextView.sizeToFit()
      }
    }

    let articleLabel = UILabel(frame: CGRect(x: 20, y: 220, width: self.view.frame.width - 40, height: 45))
    articleLabel.font = UIFont.boldSystemFont(ofSize: 20)
    articleLabel.numberOfLines = 2
    articleLabel.text = artifact.name
    articleLabel.sizeToFit()
 
    if tagSection != nil {
      return CGSize(width: self.view.frame.width, height: articleDescriptionTextView.frame.height + articleLabel.frame.height + tagSection.view.frame.height + 335)
    }
    else {
      return CGSize(width: self.view.frame.width, height: articleDescriptionTextView.frame.height + articleLabel.frame.height + 333)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {

    return CGSize(width: collectionView.bounds.size.width, height: CGFloat(120))
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let artifact = self.items[indexPath.row]
    let detailController = DetailViewController(artifact: artifact) as UIViewController
    self.navigationController?.pushViewController(detailController, animated: true)
    detailController.title = artifact.name
  }
  
  func articleTapped(_ recognizer: UITapGestureRecognizer) {
    let point: CGPoint = recognizer.location(in: recognizer.view)
    if let indexPath: IndexPath = detailCollectionView.indexPathForItem(at: point) {
      let artifact = self.items[indexPath.row]
      let detailController = DetailViewController(artifact: artifact) as UIViewController
      self.navigationController?.pushViewController(detailController, animated: true)
      detailController.title = artifact.name
    }
  }
  
  func openTag(_ sender:UIButton) {
    let detailController = LatestViewController(artifactID: sender.tag)
    detailController.shouldBeTranslucent(translucent: false)
    self.navigationController?.pushViewController(detailController, animated: true)
  }
  
  func didPlay() {
    print("Resource didPlay")
  }
  
  func didPause() {
    //
    activityIndicator.stopAnimating()
    button.isHidden = false
  }
  
  func didFailToLoad() {
    print("Resource failed to load!")
  }
  
  func didGetRestricted(_ restriction: Restriction!) {
    switch restriction.typeName {
      case "payment_restriction":
        videoPlayerState = .RestrictedPaygate
      case "authentcation_restriction":
        videoPlayerState = .RestrictedAuthentication
      default:
        print("Do nothing")
    }
  }
  
  func isReady() {
    videoPlayerState = .ReadyForDisplay
  }

  func openVideoPlayer(_ sender: UIButton) {
    activityIndicator.startAnimating()

    switch videoPlayerState {
    case .NotReady:
      videoPlayerController.setupPlayer(videoUID: artifact.uid)
      activityIndicator.startAnimating()
    case .ReadyForDisplay:
      presentVideoPlayerController()
    default:
      print("Nothing to be done.")
    }
  }

  func displayPlaybackButton() {
    activityIndicator.stopAnimating()
  }

  func presentVideoPlayerController() {
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    videoPlayerController.modalTransitionStyle = .crossDissolve
    present(videoPlayerController, animated: true, completion: nil)
    videoPlayerController.playVideo()
  }
  
  func userTappedSignInButton() {
    let userController = UserController(nibName: "UserAccount", bundle: nil)
    userController.sessionDelegate = self
    self.navigationController?.pushViewController(userController, animated: true)
  }

  func displaySubscriptionOptions(_ sender: UIButton) {
    self.signInButton.isEnabled = false
    self.buyNowButton.isEnabled = false
    
    Session.shared().getProperty({ (property, error) in
        if (error == nil) {
          Product.query(self.appDelegate.appConfiguration["DEALER_REALM_UUID"] as! String, match: self.artifact.id.stringValue, options: [:], onCompletion: { (products, error) in
            let subscriptionsVC = PassTypeViewController()
            self.appDelegate.throughBurgerMenu = false
            ProductGroup.applyCategoryToProducts(categoryProducts: self.appDelegate.archivistProductCategories, products: products as! [Product])
            let validProducts = (products as! [Product]).filter({ (product) -> Bool in product.category != nil })
            subscriptionsVC.subscriptionItems = validProducts
            self.navigationController?.pushViewController(subscriptionsVC, animated: true)
          })
        }
      })
  }

  func userDidSignIn() {
    resetRestrictionView()
  }

  private func resetRestrictionView() {
    for view in headerImageView.subviews {
      view.removeFromSuperview()
    }
    setupRestrictionOverlay()
  }
}
