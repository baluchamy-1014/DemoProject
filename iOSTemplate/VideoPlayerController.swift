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
//  var videoUID = String()
  fileprivate var player: BoxxspringVideoPlayer!
  var delegateController: DetailViewController?
  var navController: UINavigationController?

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.videoContainerView.backgroundColor = .black
    self.videoContainerView.addSubview(self.player.view())
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
    UIDevice.current.setValue(orientation, forKey: "orientation")
    super.viewDidAppear(animated)
  }
  
  func setupPlayer(videoUID: String) {
//    self.videoUID = videoUID
    self.player = BoxxspringVideoPlayer(videoUID, withFrame: CGRect.zero)
    self.player.delegate = self.delegateController as? BoxxspringVideoPlayerDelegate!
    player.fullScreen = true
    player.fullScreenControls = .limited
  }

  func playVideo() {
    Analytics.logEvent("VideoPlayed", parameters: nil)
    self.player.play()
  }

  @IBAction func donePressed(_ sender: AnyObject) {
    player.pause()
    isPresented = false
    dismiss(animated: true, completion: nil)
    for view in self.videoContainerView.subviews {
      print(view)
    }
    self.navController?.setNavigationBarHidden(false, animated: false)
  }
}
