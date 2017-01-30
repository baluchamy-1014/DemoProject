//
//  AppDelegate.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 9/26/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SWRevealViewControllerDelegate {
  var window: UIWindow?
  var viewController: SWRevealViewController?
  let keymakerOrganizer = KeymakerOrganizer()

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    self.window = UIWindow(frame: UIScreen.mainScreen().bounds)

    UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    
    
    let appConfiguration = NSBundle.mainBundle().infoDictionary! as NSDictionary
    let environment    = appConfiguration["AppEnvironment"] as! NSString
    let configurations = appConfiguration["Configurations"] as! NSDictionary
    let configValues   = configurations[environment]! as! NSDictionary

    Session.sharedSession().clientID = configValues["clientID"] as! String
    Session.sharedSession().clientSecret = configValues["clientSecret"] as! String
    Session.sharedSession().propertyCode = appConfiguration["propertyCode"] as! String

    if let value: String = keymakerOrganizer.fileContents()?.objectForKey("token") as? String {
      Session.sharedSession().accessToken = value;
    }

    let frontVC: UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("featuredController")
    let rearVC = BurgerMenuController()

    let frontNC = UINavigationController(rootViewController: frontVC)
    let rearNC = UINavigationController(rootViewController: rearVC)
    
    let revealVC = SWRevealViewController(rearViewController: rearNC, frontViewController: frontNC);
    revealVC.delegate = self;
    
    revealVC.panGestureRecognizer()
    revealVC.tapGestureRecognizer()
    revealVC.rearViewRevealWidth = 160

    let revealButtomItem = UIBarButtonItem(image: UIImage(named: "reveal-icon.png"), style: UIBarButtonItemStyle.Plain, target: revealVC, action: #selector(revealVC.revealToggle(_:)))
    frontVC.navigationItem.leftBarButtonItem = revealButtomItem
    frontVC.navigationItem.title = "All Teams"

    self.viewController = revealVC
    
    self.window!.rootViewController = self.viewController;

    self.window!.rootViewController = self.viewController
    self.window!.makeKeyAndVisible()
    
    return true
  
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
    if self.window?.rootViewController?.presentedViewController is VideoPlayerController {
      let videoPlayerController = self.window!.rootViewController!.presentedViewController as! VideoPlayerController
      if videoPlayerController.isPresented {
        return UIInterfaceOrientationMask.All;
      } else {
        return UIInterfaceOrientationMask.Portrait;
      }
    } else {
      return UIInterfaceOrientationMask.Portrait;
    }
  }


}

