//
//  ArtifactDetailViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 9/29/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

class ArtifactDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
  
  var artifactDetailCollectionView: UICollectionView!
  var tagSection: TagSection!
  var artifact: Artifact!
  var items: [Artifact] = Array()
  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  var counter: Int = 0
  let placeholderImage = UIImage(named: "Placeholder_nll_logo")
  
  init(artifact anArtifact: Artifact) {
    super.init(nibName:nil, bundle:nil)
    
    artifact = anArtifact
//    print(artifact.name)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    artifactDetailCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height-110), collectionViewLayout: CustomCollectionViewFlowLayout())
    artifactDetailCollectionView.registerNib(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "listCell")
    artifactDetailCollectionView.delegate = self
    artifactDetailCollectionView.dataSource = self
    artifactDetailCollectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
    loadRelatedContent()
    
    // TODO: theme
    artifactDetailCollectionView.backgroundColor = UIColor(red: 36/255, green: 35/255, blue: 38/255, alpha: 1.0)
    self.view.addSubview(artifactDetailCollectionView)
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector(ArtifactDetailViewController.articleTapped(_:)))
    tapRecognizer.delegate = self
    artifactDetailCollectionView.addGestureRecognizer(tapRecognizer)
  }
  
  func loadRelatedContent() {
    var params = [:]
    
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

    Session.sharedSession().getProperty { property, error in
      if (error == nil) {
        Artifact.getArtifact(Int32(Int(self.artifact.id)), forProperty: Int32(Int(property.id))) { (relatedArtifact, error) in
          if error == nil && relatedArtifact.tags() != nil && relatedArtifact.tags().count > 0 {
            let tag = relatedArtifact.tags()[0]

            self.tagSection = TagSection(x: 0, y: 340, width: 299, height: 100, tags: relatedArtifact.tags())
            self.tagSection.view.backgroundColor = UIColor.clearColor()
            self.tagSection.setupTags()

            if (tag as? Artifact) != nil {
              Artifact.getRelatedArtifacts(Int32(Int(tag.id)), forProperty: Int32(Int(property.id)), filter: params as [NSObject : AnyObject], onCompletion: { (relatedVideos, error) in
                self.items = relatedVideos as! Array
                self.artifactDetailCollectionView.reloadData()
              })
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
    
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("listCell", forIndexPath: indexPath) as! ListCollectionViewCell
    let item = items[indexPath.row]
    cell.backgroundColor = UIColor.whiteColor()
    
    let collectionViewWidth = artifactDetailCollectionView.bounds.size.width
    cell.frame.size.width = collectionViewWidth
    
    if let imageURL = item.pictureURLwithWidth(105, height: 72) {
      cell.imageView.setImageWithURL(imageURL, placeholderImage: placeholderImage)
    }
    else {
      cell.imageView.image = placeholderImage
    }
    
    cell.artifactNameLabel.text = item.name
    cell.artifactNameLabel.numberOfLines = 2
    cell.artifactNameLabel.backgroundColor = UIColor.whiteColor()
    
    cell.authorLabel.font = UIFont.systemFontOfSize(12)
    cell.authorLabel.backgroundColor = UIColor.whiteColor()
    if let aAuthor = item.author() {
      cell.authorLabel.text = aAuthor.name
    }
    else {
      cell.authorLabel.text = ""
    }
    
    cell.timestampLabel.font = UIFont.systemFontOfSize(12)
    cell.timestampLabel.textColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1.0)
    if let publishedAtString = item.publishedAt {
      cell.timestampLabel.displayDateTime(publishedAtString)
    }
    
    return cell
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  func openVideoPlayer(sender: UIButton) {
    appDelegate.viewController?.tabBar.hidden = true
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    
    let videoPlayerController = VideoPlayerController()
    videoPlayerController.passString(artifact.UID)
    videoPlayerController.modalTransitionStyle = .CrossDissolve
    videoPlayerController.delegateController = self.navigationController
    presentViewController(videoPlayerController, animated: true, completion: nil)
  }

  
  func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
  {
    var reusableHeaderView: UICollectionReusableView! = nil
    if (kind == UICollectionElementKindSectionHeader) {
      reusableHeaderView = artifactDetailCollectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header", forIndexPath: indexPath) as UICollectionReusableView
      reusableHeaderView.backgroundColor = UIColor.whiteColor()
      
      let headerImageView = UIImageView(frame: CGRectMake(0, 0, reusableHeaderView.frame.size.width, 200))
      headerImageView.userInteractionEnabled = true
      reusableHeaderView.addSubview(headerImageView)
      
      if let thumbnailImageURL = artifact.pictureURLwithWidth(Int32(headerImageView.frame.width), height: Int32(headerImageView.frame.height)) {
        headerImageView.setImageWithURL(thumbnailImageURL, placeholderImage: placeholderImage)
      } else {
        headerImageView.image = placeholderImage
      }
        
      if artifact.typeName == "video_artifact" || artifact.typeName == "stream_artifact" {
        let button = PlayButton(frame: CGRectMake((headerImageView.frame.size.width/2) - 30, (headerImageView.frame.size.height/2) - 30, 60, 60))
        button.addTarget(self, action: #selector(ArtifactDetailViewController.openVideoPlayer(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        headerImageView.addSubview(button)
      }
      
      // Todo: Create custom labels
      let articleLabel = UILabel(frame: CGRectMake(20, 220, reusableHeaderView.frame.size.width-40, 45))
      articleLabel.font = UIFont.boldSystemFontOfSize(20)
      articleLabel.numberOfLines = 2
      articleLabel.text = artifact.name
      articleLabel.sizeToFit()
      reusableHeaderView.addSubview(articleLabel)
      
      let authorLabel = UILabel(frame: CGRectMake(10, 261, 200, 16))
      authorLabel.font = UIFont.systemFontOfSize(12)
      authorLabel.backgroundColor = UIColor.whiteColor()
      authorLabel.textColor = UIColor.blackColor()
      // hiding hiding author label
      //      reusableHeaderView.addSubview(authorLabel)
      if let authorString = artifact.author() {
        authorLabel.text = authorString.name
      }
      
      let dateLabel = AddedAtLabel(frame: CGRectMake(20, articleLabel.frame.height + 230, 160, 16))
      dateLabel.font = UIFont.systemFontOfSize(12)
      dateLabel.backgroundColor = UIColor.whiteColor()
      if let publishedAtString = artifact.publishedAt {
        dateLabel.displayDateTime(publishedAtString)
      }
      reusableHeaderView.addSubview(dateLabel)

      let articleDescriptionTextView = UITextView(frame: CGRectMake(16, dateLabel.frame.origin.y + dateLabel.frame.height + 10, reusableHeaderView.frame.size.width - 32, 0))
      articleDescriptionTextView.backgroundColor = UIColor.whiteColor()
      articleDescriptionTextView.font = UIFont.systemFontOfSize(15)
      articleDescriptionTextView.editable = false
      articleDescriptionTextView.scrollEnabled = false
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
      let relatedVideosLabel = UILabel(frame: CGRectMake(20, reusableHeaderView.frame.size.height-40, 400, 26))
      relatedVideosLabel.font = UIFont.boldSystemFontOfSize(24)
      relatedVideosLabel.textColor = UIColor.blackColor()
      relatedVideosLabel.text = "Related Content"
      reusableHeaderView.addSubview(relatedVideosLabel)
      
      let horizontalLine = UIView(frame: CGRectMake(0, reusableHeaderView.frame.size.height, self.view.frame.size.width, 0.5))
      // TODO: theme
      horizontalLine.backgroundColor = UIColor(red: 36/255, green: 35/255, blue: 38/255, alpha: 1.0)
      reusableHeaderView.addSubview(horizontalLine)
      }
      counter += 1
      reusableHeaderView.backgroundColor = UIColor.whiteColor()
      if tagSection != nil {
        tagSection.view.frame.origin.y = articleDescriptionTextView.frame.height + articleLabel.frame.height + 271
      }
      return reusableHeaderView
    }
    return reusableHeaderView
  }
  
  func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, referenceSizeForHeaderInSection section: Int) -> CGSize
  {
    let articleDescriptionTextView = UITextView(frame: CGRectMake(41, 220, self.view.frame.width - 32, 0))
    articleDescriptionTextView.font = UIFont.systemFontOfSize(15)
    if let artifactDescription = artifact.longDescription {
      articleDescriptionTextView.text = artifactDescription
      if articleDescriptionTextView.text != "" {
        articleDescriptionTextView.sizeToFit()
      }
    }

    let articleLabel = UILabel(frame: CGRectMake(20, 220, self.view.frame.width - 40, 45))
    articleLabel.font = UIFont.boldSystemFontOfSize(20)
    articleLabel.numberOfLines = 2
    articleLabel.text = artifact.name
    articleLabel.sizeToFit()
 
    if tagSection != nil {
      return CGSizeMake(self.view.frame.width, articleDescriptionTextView.frame.height + articleLabel.frame.height + tagSection.view.frame.height + 335)
    }
    else {
      return CGSizeMake(self.view.frame.width, articleDescriptionTextView.frame.height + articleLabel.frame.height + 333)
    }
  }
  
  func collectionView(collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                             sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {

    return CGSizeMake(collectionView.bounds.size.width, CGFloat(120))
  }
  
  func articleTapped(recognizer: UITapGestureRecognizer) {
    let point: CGPoint = recognizer.locationInView(recognizer.view)
    if let indexPath: NSIndexPath = artifactDetailCollectionView.indexPathForItemAtPoint(point) {
      let artifact = self.items[indexPath.row]
//      self.navigationController?.navigationBar.topItem?.title = ""
      let detailController = ArtifactDetailViewController(artifact: artifact) as UIViewController
      self.navigationController?.pushViewController(detailController, animated: true)
      detailController.title = artifact.name
    }
  }
  
  func openTag(sender:UIButton) {
    let detailController = LatestViewController(artifactID: sender.tag)
    self.navigationController?.pushViewController(detailController, animated: true)
  }

}
