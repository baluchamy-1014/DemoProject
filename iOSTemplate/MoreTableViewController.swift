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
  var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
  let signInText: String = "Sign In"
  let signOutText: String = "Sign Out"
  let appDelegate = UIApplication.shared.delegate as! AppDelegate

  override func viewDidLoad() {
    // TODO: theme
    self.navigationController?.navigationBar.barTintColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    
    tableView.separatorColor = UIColor(red: 37/255, green: 35/255, blue: 38/255, alpha: 1.0)
    tableView.backgroundColor = UIColor(red: 37/255, green: 35/255, blue: 38/255, alpha: 1.0)
    
    tableView.addSubview(activityIndicator)
    
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
    
    activityIndicator.startAnimating()
    
    // TODO: NLL instead?
    Session.shared().getProperty { (aProperty, error) in
      if (error == nil) {
        Group.getGroup("/navigation", forProperty: Int32(Int((aProperty?.id)!)), onCompletion: { (group, error) in
          if (error == nil) && (group != nil) {
            Artifact.getRelatedArtifacts(Int32(Int((group?.id)!)), forProperty: (group?.propertyID)!, filter: [:], onCompletion: { (tags, error) in
//            print(tags)
              self.moreItems = tags as! [AnyObject]
              if Session.shared().isValid() {
                self.moreItems.insert(self.signOutText as AnyObject, at: 0)
              } else {
                self.moreItems.insert(self.signInText as AnyObject, at: 0)
              }
              self.moreItems.append("Feedback" as AnyObject)
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

  override func viewWillAppear(_ animated: Bool) {
    self.displaySignOut()
    super.viewWillAppear(animated)
  }

  override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    // TODO: do we want sections?
      return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return moreItems.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableView.separatorColor = UIColor(red: 37/255, green: 35/255, blue: 38/255, alpha: 1.0)
    let cell = tableView.dequeueReusableCell(withIdentifier: "moreCell", for: indexPath)
    cell.backgroundColor = UIColor(red: 37/255, green: 35/255, blue: 38/255, alpha: 1.0)
    cell.textLabel?.textColor = UIColor.white
    let item = moreItems[indexPath.row]
    if let text = item as? String {
      cell.textLabel!.text = text
    } else {
      cell.textLabel!.text = moreItems[indexPath.row].name
    }
    cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
    cell.accessoryType = .disclosureIndicator
    
    let backgroundColorView = SelectedCellBackgroundColorView(frame: cell.frame)
    cell.selectedBackgroundView = backgroundColorView
    
    activityIndicator.stopAnimating()
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = moreItems[indexPath.row]
    if let stringValue = item as? String {
      if (stringValue == signInText) || stringValue == signOutText {
        if Session.shared().isValid() {
          self.signOut()
        } else {
          let userController = UserController(nibName: "UserAccount", bundle: nil)
          self.navigationController?.pushViewController(userController, animated: true)
          self.navigationController?.title = "Back"
        }
        clearSelectedTableViewCellOnLeave()
        tableView.reloadData()
      }
      else if (stringValue == "Feedback") {
        if (MFMailComposeViewController.canSendMail()) {
          let feedbackController = FeedbackViewController()
          feedbackController.createMailPopup()
          self.navigationController?.present(feedbackController, animated: true, completion: nil)
        }
        else {
          let alertViewController = UIAlertController.init(title: "Email Address Not Set Up", message: "Your Email Address is not set up yet, please add one in Settings", preferredStyle: UIAlertControllerStyle.alert)
          let alertAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alertViewController.dismiss(animated: true, completion: nil)
          })
          alertViewController.addAction(alertAction)
          self.present(alertViewController, animated: true, completion: nil)
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
          UIApplication.shared.openURL(URL(string: urlString)!)
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
    tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: false)
  }


  fileprivate func displaySignOut() {
    if (Session.shared().isValid()) {
      if self.moreItems.count > 0 {
        self.moreItems[0] = signOutText as AnyObject
        tableView.reloadData()
      }
    }
  }

  fileprivate func signOut() {
    Session.shared().resetSession();
    self.appDelegate.keymakerOrganizer.clearKeymakerToken()

    let alertViewController = UIAlertController.init(title: "Sign Out Successful!", message: "You will now be redirected to home screen", preferredStyle: UIAlertControllerStyle.alert)
    let alertAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
      alertViewController.dismiss(animated: true, completion: nil)
//      self.appDelegate.viewController!.selectedIndex = 0
    })
    alertViewController.addAction(alertAction)
    self.activityIndicator.isHidden = true
    self.present(alertViewController, animated: true, completion: nil)
    self.moreItems[0] = self.signInText as AnyObject
  }

}
