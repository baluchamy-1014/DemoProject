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
  let deviceType:NSString = UIDevice.current.model as NSString
  let deviceVersion:NSString = UIDevice.current.systemVersion as NSString
  let info: NSDictionary = Bundle.main.infoDictionary! as NSDictionary
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func createMailPopup() {
    self.mailComposeDelegate = self
    
    // TODO: replace email address
    let toRecipients:NSArray = NSArray(array: ["nllfeedback@sportsrocket.com"])
    self.setToRecipients(toRecipients as? [String])
    
    let appVersion: String = info.object(forKey: "CFBundleShortVersionString") as! String
    
    self.setSubject("NLL iPad App \(appVersion) Feedback")
    let emailBody:NSString = "<br><br><br><p><p><p><p>\(deviceType) running iOS \(deviceVersion) NLL app version \(appVersion)" as NSString
    self.setMessageBody(emailBody as String, isHTML: true)
  }
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    // used for analytics and testing
    switch result.rawValue {
    case MFMailComposeResult.cancelled.rawValue:
      NSLog("Mail cancelled")
    case MFMailComposeResult.saved.rawValue:
      NSLog("Mail saved")
    case MFMailComposeResult.sent.rawValue:
      print("Mail sent")
    case MFMailComposeResult.failed.rawValue:
      NSLog("Mail sent failure: %@", [error!.localizedDescription])
    default:
      break
    }
    self.dismiss(animated: true, completion: nil)
  }
}
