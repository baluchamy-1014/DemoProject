//
//  ArticleArtifactViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 12/9/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

class ArticleArtifactViewController: UIViewController {
  var scrollView:UIScrollView!
  var articleTextView:UITextView!
  var artifact:Artifact!
  
  init(artifact anArtifact: Artifact) {
    super.init(nibName:nil, bundle:nil)
    
    artifact = anArtifact
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupScrollView()
    self.createTitleLabel()
    self.createTextView()
    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: 188 + self.articleTextView.frame.size.height)
  }
  
  func setupScrollView() {
    self.scrollView = UIScrollView(frame: self.view.bounds)
    self.scrollView.backgroundColor = UIColor.whiteColor()
    self.view.addSubview(self.scrollView)
  }
  
  func createTitleLabel() {
    let titleLabel = UILabel(frame: CGRectMake(0, 30, 320, 37))
    titleLabel.font = titleLabel.font.fontWithSize(20)
    titleLabel.text = artifact.name
    titleLabel.backgroundColor = UIColor.clearColor()
    self.scrollView.addSubview(titleLabel)
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 30))
  }
  
  func createTextView() {
    self.articleTextView = UITextView(frame: CGRectMake(34, 80, self.scrollView.frame.width-68, 300), textContainer: nil)
    self.articleTextView.textColor = UIColor.blackColor()
    self.articleTextView.text = artifact.longDescription
    self.articleTextView.sizeToFit()
    self.articleTextView.selectable = true;
    self.articleTextView.scrollEnabled = false
    self.articleTextView.editable = false;
    self.articleTextView.backgroundColor = UIColor.whiteColor()
    self.scrollView.addSubview(self.articleTextView)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
