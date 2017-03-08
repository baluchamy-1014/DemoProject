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
    
    self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
  }
  
  func setupScrollView() {
    self.scrollView = UIScrollView(frame: self.view.bounds)
    self.scrollView.backgroundColor = UIColor.white
    self.view.addSubview(self.scrollView)
  }
  
  func createTitleLabel() {
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 30, width: 320, height: 37))
    titleLabel.font = titleLabel.font.withSize(20)
    titleLabel.text = artifact.name
    titleLabel.backgroundColor = UIColor.clear
    self.scrollView.addSubview(titleLabel)
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: scrollView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 30))
    view.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.lessThanOrEqual, toItem: scrollView, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0))
  }
  
  func createTextView() {
    self.articleTextView = UITextView(frame: CGRect(x: 34, y: 80, width: self.scrollView.frame.width-68, height: 300), textContainer: nil)
    self.articleTextView.textColor = UIColor.black
    self.articleTextView.text = artifact.longDescription
    self.articleTextView.sizeToFit()
    self.articleTextView.isSelectable = true;
    self.articleTextView.isScrollEnabled = false
    self.articleTextView.isEditable = false;
    self.articleTextView.backgroundColor = UIColor.white
    self.scrollView.addSubview(self.articleTextView)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
