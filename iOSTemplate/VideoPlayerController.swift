//
//  VideoPlayerController.swift
//  iOSTemplate
//
//  Created by Shovan Joshi on 10/28/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import Foundation

import UIKit

class VideoPlayerController: UIViewController {
  var isPresented = true
  
  @IBOutlet weak var videoContainerView: UIView!
  var videoUID = String()
  private var player: BoxxspringVideoPlayer?
  var delegateController: UINavigationController?
  
  func passString(videoUID: String) {
    self.videoUID = videoUID
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let containerView = videoContainerView {
      let player = BoxxspringVideoPlayer(videoUID, withFrame: containerView.bounds)
      containerView.backgroundColor = UIColor.blackColor()
      containerView.addSubview(player.view())
      self.player = player
    }
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    player?.fullScreen = true
    player?.fullScreenControls = .Limited
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  override func viewDidAppear(animated: Bool) {
    let orientation = UIDevice.currentDevice().orientation.rawValue
    if orientation == UIInterfaceOrientation.LandscapeRight.rawValue {
      UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeLeft.rawValue, forKey: "orientation")
    } else {
      UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeRight.rawValue, forKey: "orientation")
    }
    player?.play()
    UIDevice.currentDevice().setValue(orientation, forKey: "orientation")
    super.viewDidAppear(animated)
  }
  
  @IBAction func donePressed(sender: AnyObject) {
    player?.pause()
    isPresented = false
    dismissViewControllerAnimated(true, completion: nil)
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    appDelegate.viewController?.tabBar.hidden = false
    self.delegateController?.setNavigationBarHidden(false, animated: false)
  }
}
