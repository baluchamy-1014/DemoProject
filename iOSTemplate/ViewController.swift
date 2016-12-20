//
//  ViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 9/26/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource {
  var pageController: UIPageViewController!
  var page1 = UIViewController() 
  var page2 = UIViewController()
  var page3 = UIViewController()
  var pages = [UIViewController]()
  var selectedTeam: String!
  var teamID: Int?

  @IBOutlet weak var customSegmentedControl: CustomSegmentedControl!
  @IBOutlet weak var teamFilterButton: TeamFilterButton!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    page1 = (storyboard?.instantiateViewControllerWithIdentifier("featuredController"))!
    page2 = (storyboard?.instantiateViewControllerWithIdentifier("latestController"))!
    page3 = (storyboard?.instantiateViewControllerWithIdentifier("liveController"))!
    pages.append(page1)
    pages.append(page2)
    pages.append(page3)

    self.pageController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    self.pageController.view.frame = CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height-45)
    self.pageController.setViewControllers([page1], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    if self.pageController.viewControllers![0].isKindOfClass(ArticleViewController) {
       teamFilterButton.setTitle("NLL TV", forState: .Normal)
       teamFilterButton.setImage(nil, forState: .Normal)
    }
    else {
      teamFilterButton.setTitle(selectedTeam, forState: .Normal)
    }
    self.addChildViewController(self.pageController)
    self.view.addSubview(self.pageController.view)
    self.pageController.dataSource = self

    // TODO: theme
    self.view.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)

    self.navigationController?.navigationBar.barTintColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func userDidTapTeamFilterButton(sender: UIButton) {
    if self.pageController.viewControllers![0].isKindOfClass(ArticleViewController) {
      // do nothing
    }
    else {
      let teamVC = storyboard!.instantiateViewControllerWithIdentifier("teamviewcontroller")
      presentViewController(teamVC, animated: true, completion: nil)
    }
  }
  
  @IBAction func segmentChanged(sender: AnyObject) {
    switch sender.selectedSegmentIndex {
    case 0:
//      print("page 0")
      resetTeamFilterButtonAllTeams()
      self.pageController.setViewControllers([page1], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    case 1:
//      print("page 1")
      teamFilterButtonRestoreTeamName()
      if let _ = self.teamID {
        (page2 as! LatestViewController).artifactID = self.teamID!
      }
      (page2 as! LatestViewController).loadData()
      self.pageController.setViewControllers([page2], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    case 2:
//      print("page 2")
      teamFilterButtonRestoreTeamName()
      if let _ = self.teamID {
        (page3 as! StreamListViewController).artifactID = self.teamID!
      }
      (page3 as! StreamListViewController).loadData()
      self.pageController.setViewControllers([page3], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    default: break
    }
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    var previousIndex = Int()
    Swift.print("pages count \(pages.count)")
    let currentIndex = pages.indexOf(viewController)!
    if currentIndex == 0 {
      previousIndex = 2
    }
    else {
      previousIndex = abs((currentIndex - 1) % pages.count)
 
    }
    customSegmentedControl.selectedSegmentIndex = currentIndex
//    print(currentIndex)
    if currentIndex == 0 {
      resetTeamFilterButtonAllTeams()
    }
    else {
      teamFilterButtonRestoreTeamName()
    }
    return pages[previousIndex]
  }
  
  func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    let currentIndex = pages.indexOf(viewController)!
    let nextIndex = abs((currentIndex + 1) % pages.count)
    customSegmentedControl.selectedSegmentIndex = currentIndex
//    print(currentIndex)
    if currentIndex == 0 {
      resetTeamFilterButtonAllTeams()
    }
    else {
      teamFilterButtonRestoreTeamName()
    }
    return pages[nextIndex]
  }
  
  func teamFilterButtonRestoreTeamName() {
    if (selectedTeam == nil) {
      teamFilterButton.setTitle("NLL TV", forState: .Normal)
    }
    else {
      teamFilterButton.setTitle(selectedTeam, forState: .Normal)
    }
    teamFilterButton.setImage(UIImage(named: "expand_indicator"), forState: .Normal)
  }
  
  func resetTeamFilterButtonAllTeams() {
    teamFilterButton.setImage(nil, forState: .Normal)
    teamFilterButton.setTitle("NLL TV", forState: .Normal)
  }

  @IBAction func unwindSegue(segue: UIStoryboardSegue) {
//    print(segue.identifier)
    // TODO: add LIVE functionality
    self.navigationController?.navigationBar.topItem?.title = ""
    dispatch_async(dispatch_get_main_queue(), {
      if segue.identifier == "selectTeamSegue" {
        let teamsFilterListViewController: TeamsFilterListViewController = segue.sourceViewController as! TeamsFilterListViewController
        self.teamID = (teamsFilterListViewController.teamName == "NLL TV") ? nil : teamsFilterListViewController.teamID
        self.selectedTeam = teamsFilterListViewController.teamName
        let currentController = self.pageController.viewControllers![0]
        if currentController.isKindOfClass(LatestViewController) {
          let latestViewController = self.pageController.viewControllers![0] as! LatestViewController
          self.teamID != nil ? latestViewController.filterTeams(teamsFilterListViewController.teamID) : latestViewController.loadAllTeams()
          latestViewController.collectionView.reloadData()
          latestViewController.collectionView.setContentOffset(CGPointZero, animated: false)
          self.teamFilterButton.setTitle(teamsFilterListViewController.teamName, forState: .Normal)
        } else if currentController.isKindOfClass(StreamListViewController) {
          self.teamID != nil ? (currentController as! StreamListViewController).filterTeams(teamsFilterListViewController.teamID) : (currentController as! StreamListViewController).loadAllTeams()
          self.teamFilterButton.setTitle(teamsFilterListViewController.teamName, forState: .Normal)
        }
        else {
          self.teamFilterButton.setTitle("All Team", forState: .Normal)
        }
      }
    })
  }
}

