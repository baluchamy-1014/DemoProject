//
//  MoreTableViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 10/23/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit
import MessageUI

class MoreTableViewController: UITableViewController {
  var moreItems: [AnyObject] = Array()
  var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
  
  override func viewDidLoad() {
    // TODO: theme
    self.navigationController?.navigationBar.barTintColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    
    tableView.separatorColor = UIColor(red: 37/255, green: 35/255, blue: 38/255, alpha: 1.0)
    tableView.backgroundColor = UIColor(red: 37/255, green: 35/255, blue: 38/255, alpha: 1.0)
    
    tableView.addSubview(activityIndicator)
    
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
    
    activityIndicator.startAnimating()
    
    // TODO: NLL instead?
    Session.sharedSession().getProperty { (aProperty, error) in
      if (error == nil) {
        Group.getGroup("/navigation", forProperty: Int32(Int(aProperty.id)), onCompletion: { (group, error) in
          if (error == nil) && (group != nil) {
            Artifact.getRelatedArtifacts(Int32(Int(group.id)), forProperty: group.propertyID, filter: [:], onCompletion: { (tags, error) in
//            print(tags)
            self.moreItems = tags as! [AnyObject]
            self.moreItems.insert("Sign In", atIndex: 0)
            self.moreItems.append("Feedback")
            self.tableView.reloadData()
            })
          }
        })
      }
    }
    tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      
    super.viewDidLoad()

  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // TODO: do we want sections?
      return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return moreItems.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    tableView.separatorColor = UIColor(red: 37/255, green: 35/255, blue: 38/255, alpha: 1.0)
    let cell = tableView.dequeueReusableCellWithIdentifier("moreCell", forIndexPath: indexPath)
    cell.backgroundColor = UIColor(red: 37/255, green: 35/255, blue: 38/255, alpha: 1.0)
    cell.textLabel?.textColor = UIColor.whiteColor()
    let item = moreItems[indexPath.row]
    if let text = item as? String {
      cell.textLabel!.text = text
    } else {
      cell.textLabel!.text = moreItems[indexPath.row].name
    }
    cell.textLabel?.font = UIFont.systemFontOfSize(17)
    cell.accessoryType = .DisclosureIndicator
    
    let backgroundColorView = SelectedCellBackgroundColorView(frame: cell.frame)
    cell.selectedBackgroundView = backgroundColorView
    
    activityIndicator.stopAnimating()
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let item = moreItems[indexPath.row]
    if let stringValue = item as? String {
      if (stringValue == "Sign In") {
        if Session.sharedSession().isValid() {
          let alertViewController = UIAlertController.init(title: "Login Status", message: "You are already logged in.", preferredStyle: UIAlertControllerStyle.Alert)
          let alertAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) in
            alertViewController.dismissViewControllerAnimated(true, completion: nil)
          })
          alertViewController.addAction(alertAction)
          self.presentViewController(alertViewController, animated: true, completion: nil)
        } else {
          let userController = UserController(nibName: "UserAccount", bundle: nil)
          self.navigationController?.pushViewController(userController, animated: true)
          self.navigationController?.title = "Back"
        }
        clearSelectedTableViewCellOnLeave()
      }
      else if (stringValue == "Feedback") {
        if (MFMailComposeViewController.canSendMail()) {
          let feedbackController = FeedbackViewController()
          feedbackController.createMailPopup()
          self.navigationController?.presentViewController(feedbackController, animated: true, completion: nil)
        }
        else {
          let alertViewController = UIAlertController.init(title: "Email Address Not Set Up", message: "Your Email Address is not set up yet, please add one in Settings", preferredStyle: UIAlertControllerStyle.Alert)
          let alertAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) in
            alertViewController.dismissViewControllerAnimated(true, completion: nil)
          })
          alertViewController.addAction(alertAction)
          self.presentViewController(alertViewController, animated: true, completion: nil)
        }
      }
     }
     else {
      if item.name == "Home" {
        let viewController = ArticleViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
        viewController.title = item.name
        clearSelectedTableViewCellOnLeave()
      }
      else if item.typeName == "link_artifact" {
//        print(item.providerURL)
        if var urlString = item.providerURL {
          if !urlString.hasPrefix("http") {
            urlString = "http://\(urlString)"
          }
          UIApplication.sharedApplication().openURL(NSURL(string: urlString)!)
          clearSelectedTableViewCellOnLeave()
        }
      }
      else if item.typeName == "playlist_artifact" || item.typeName == "tag_artifact" || item.typeName == "group_artifact" {
        let item = moreItems[indexPath.row]
        let viewController = LatestViewController(artifactID: Int(item.id))
        self.navigationController?.pushViewController(viewController, animated: true)
        viewController.title = item.name
      }
      else if item.typeName == "article_artifact" {
        let item = moreItems[indexPath.row]
        let viewController = ArticleArtifactViewController(artifact: item as! Artifact)
        self.navigationController?.pushViewController(viewController, animated: true)
        viewController.title = item.name
      }
    }
  }
  
  func clearSelectedTableViewCellOnLeave() {
    tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: false)
  }
  
}
