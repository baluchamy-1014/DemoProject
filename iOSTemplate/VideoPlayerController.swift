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
  fileprivate var player: BoxxspringVideoPlayer?
  var delegateController: UINavigationController?
  
  func passString(_ videoUID: String) {
    self.videoUID = videoUID
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let containerView = videoContainerView {
      let player = BoxxspringVideoPlayer(videoUID, withFrame: containerView.bounds)
      containerView.backgroundColor = UIColor.black
      containerView.addSubview((player?.view())!)
      self.player = player
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    player?.fullScreen = true
    player?.fullScreenControls = .limited
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    let orientation = UIDevice.current.orientation.rawValue
    if orientation == UIInterfaceOrientation.landscapeRight.rawValue {
      UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
    } else {
      UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
    }
    player?.play()
    UIDevice.current.setValue(orientation, forKey: "orientation")
    super.viewDidAppear(animated)
  }
  
  @IBAction func donePressed(_ sender: AnyObject) {
    player?.pause()
    isPresented = false
    dismiss(animated: true, completion: nil)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    appDelegate.viewController?.tabBar.hidden = false
    self.delegateController?.setNavigationBarHidden(false, animated: false)
  }
}
