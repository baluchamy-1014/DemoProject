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
    
    page1 = (storyboard?.instantiateViewController(withIdentifier: "featuredController"))!
    page2 = (storyboard?.instantiateViewController(withIdentifier: "latestController"))!
    page3 = (storyboard?.instantiateViewController(withIdentifier: "liveController"))!
    pages.append(page1)
    pages.append(page2)
    pages.append(page3)

    self.pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    self.pageController.view.frame = CGRect(x: 0, y: 100, width: self.view.frame.size.width, height: self.view.frame.size.height)
    self.pageController.setViewControllers([page1], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    if self.pageController.viewControllers![0].isKind(of: FeaturedViewController.self) {
       teamFilterButton.setTitle("NLL TV ", for: UIControlState())
       teamFilterButton.setImage(nil, for: UIControlState())
    }
    else {
      teamFilterButton.setTitle(selectedTeam + " ", for: UIControlState())
    }
    self.addChildViewController(self.pageController)
    self.view.addSubview(self.pageController.view)
    self.pageController.dataSource = self

    // TODO: theme

    self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
    
    teamFilterButtonRestoreTeamName()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.view.backgroundColor = UIColor(red: 16/255, green: 24/255, blue: 31/255, alpha: 1.0)
    self.navigationController?.navigationBar.backgroundColor = UIColor(red: 16/255, green: 24/255, blue: 31/255, alpha: 1.0)
    self.navigationController?.navigationBar.barTintColor = UIColor(red: 16/255, green: 24/255, blue: 31/255, alpha: 1.0)
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    self.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = nil
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func userDidTapTeamFilterButton(_ sender: UIButton) {
    let teamVC = storyboard!.instantiateViewController(withIdentifier: "teamviewcontroller")
    present(teamVC, animated: true, completion: nil)
 }
  
  @IBAction func segmentChanged(_ sender: AnyObject) {
    switch sender.selectedSegmentIndex {
    case 0:
      teamFilterButtonRestoreTeamName()
      loadDataForCurrentPageIndex(sender.selectedSegmentIndex)
      self.pageController.setViewControllers([page1], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    case 1:
      teamFilterButtonRestoreTeamName()
      loadDataForCurrentPageIndex(sender.selectedSegmentIndex)
      self.pageController.setViewControllers([page2], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    case 2:
      teamFilterButtonRestoreTeamName()
      loadDataForCurrentPageIndex(sender.selectedSegmentIndex)
      self.pageController.setViewControllers([page3], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    default: break
    }
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    var previousIndex = Int()
    Swift.print("pages count \(pages.count)")
    let currentIndex = pages.index(of: viewController)!
    if currentIndex == 0 {
      previousIndex = 2
    }
    else {
      previousIndex = abs((currentIndex - 1) % pages.count)
    }
    customSegmentedControl.selectedSegmentIndex = currentIndex
    teamFilterButtonRestoreTeamName()
    loadDataForCurrentPageIndex(currentIndex)
    
    return pages[previousIndex]
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    let currentIndex = pages.index(of: viewController)!
    let nextIndex = abs((currentIndex + 1) % pages.count)
    customSegmentedControl.selectedSegmentIndex = currentIndex
    teamFilterButtonRestoreTeamName()
    loadDataForCurrentPageIndex(currentIndex)
    
    return pages[nextIndex]
  }
  
  func teamFilterButtonRestoreTeamName() {
    if (selectedTeam == nil) {
      teamFilterButton.setTitle("All Teams ", for: UIControlState())
    }
    else {
      teamFilterButton.setTitle(selectedTeam + " ", for: UIControlState())
    }
    teamFilterButton.setImage(UIImage(named: "expand_indicator"), for: UIControlState())
    
    teamFilterButton.sizeToFit()
    teamFilterButton.imageEdgeInsets = UIEdgeInsetsMake(0, teamFilterButton.frame.size.width-10, 0, 0)
    teamFilterButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
  }
  
  func loadDataForCurrentPageIndex(_ currentPageIndex: Int) {
    switch currentPageIndex {
    case 0:
      if let _ = self.teamID {
        (page1 as! FeaturedViewController).artifactID = self.teamID!
      }
      (page1 as! FeaturedViewController).loadData()
    case 1:
      if let _ = self.teamID {
        (page2 as! LatestViewController).artifactID = self.teamID!
      }
      (page2 as! LatestViewController).loadData()
    case 2:
      if let _ = self.teamID {
        (page3 as! StreamListViewController).artifactID = self.teamID!
      }
      (page3 as! StreamListViewController).loadData()
    default:
      break
    }
  }

  @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
    self.navigationController?.navigationBar.topItem?.title = ""
    DispatchQueue.main.async(execute: {
      if segue.identifier == "selectTeamSegue" {
        let teamsFilterListViewController: TeamsFilterListViewController = segue.source as! TeamsFilterListViewController
        self.teamID = (teamsFilterListViewController.teamName == "All Teams") ? nil : teamsFilterListViewController.teamID
        self.selectedTeam = teamsFilterListViewController.teamName
        let currentController = self.pageController.viewControllers![0]
        if currentController.isKind(of: LatestViewController.self) {
          let latestViewController = self.pageController.viewControllers![0] as! LatestViewController
          self.teamID != nil ? latestViewController.filterTeams(teamsFilterListViewController.teamID) : latestViewController.loadAllTeams()
          latestViewController.collectionView.reloadData()
          latestViewController.collectionView.setContentOffset(CGPoint.zero, animated: false)
          self.teamFilterButton.setTitle(teamsFilterListViewController.teamName + " ", for: UIControlState())
        } else if currentController.isKind(of: StreamListViewController.self) {
          self.teamID != nil ? (currentController as! StreamListViewController).filterTeams(teamsFilterListViewController.teamID) : (currentController as! StreamListViewController).loadAllTeams()
          self.teamFilterButton.setTitle(teamsFilterListViewController.teamName + " ", for: UIControlState())
        }
        else if currentController.isKind(of: FeaturedViewController.self) {
          let featuredVC = self.pageController.viewControllers![0] as! FeaturedViewController
          self.teamID != nil ? featuredVC.filterTeams(teamsFilterListViewController.teamID) : featuredVC.loadFeatured()
          featuredVC.collectionView.reloadData()
          featuredVC.collectionView.setContentOffset(CGPoint.zero, animated: false)
          self.teamFilterButton.setTitle(teamsFilterListViewController.teamName + " ", for: UIControlState())
        }
        else {
          self.teamFilterButton.setTitle("All Team ", for: UIControlState())
        }
        self.teamFilterButton.sizeToFit()
        self.teamFilterButton.imageEdgeInsets = UIEdgeInsetsMake(0, self.teamFilterButton.frame.size.width-10, 0, 0)
        self.teamFilterButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
      }
    })
  }
}

