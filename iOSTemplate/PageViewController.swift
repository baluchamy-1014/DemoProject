//
//  PageViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 9/26/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDelegate {  
  var pages = [UIViewController]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.delegate = self
  }
  
  func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
    return pages.count
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
    return 0
  }

}
