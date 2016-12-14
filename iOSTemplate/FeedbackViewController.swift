//
//  FeedbackViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 12/9/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit
import MessageUI

class FeedbackViewController: MFMailComposeViewController, MFMailComposeViewControllerDelegate {
  let deviceType:NSString = UIDevice.currentDevice().model
  let deviceVersion:NSString = UIDevice.currentDevice().systemVersion
  let info: NSDictionary = NSBundle.mainBundle().infoDictionary!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func createMailPopup() {
    self.mailComposeDelegate = self
    
    // TODO: replace email address
    let toRecipients:NSArray = NSArray(array: ["nllfeedback@sportsrocket.com"])
    self.setToRecipients(toRecipients as? [String])
    
    let appVersion: String = info.objectForKey("CFBundleShortVersionString") as! String
    
    self.setSubject("NLL iPad App \(appVersion) Feedback")
    let emailBody:NSString = "<br><br><br><p><p><p><p>\(deviceType) running iOS \(deviceVersion) NLL app version \(appVersion)"
    self.setMessageBody(emailBody as String, isHTML: true)
  }
  
  func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
    // used for analytics and testing
    switch result.rawValue {
    case MFMailComposeResultCancelled.rawValue:
      NSLog("Mail cancelled")
    case MFMailComposeResultSaved.rawValue:
      NSLog("Mail saved")
    case MFMailComposeResultSent.rawValue:
      print("Mail sent")
    case MFMailComposeResultFailed.rawValue:
      NSLog("Mail sent failure: %@", [error!.localizedDescription])
    default:
      break
    }
    self.dismissViewControllerAnimated(true, completion: nil)
  }
}
