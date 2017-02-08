//
// Created by Shovan Joshi on 1/30/17.
// Copyright (c) 2017 Sportsrocket. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class BurgerMenuController: UITableViewController {
  var moreItems: [AnyObject] = Array()
  // TODO: use mutidimensional array for sections data
  var artifactItems: [AnyObject] = Array()
  var otherItems: [AnyObject] = Array()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.barTintColor = UIColor(red: 16/255, green: 24/255, blue: 31/255, alpha: 1.0)
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    self.tableView.backgroundColor = UIColor(red: 16/255, green: 24/255, blue: 31/255, alpha: 1.0)
    self.tableView.separatorStyle = .none
    
    Session.shared().getProperty { (aProperty, error) in
      if (error == nil) {
        Group.getGroup("/navigation", forProperty: Int32(Int((aProperty?.id)!)), onCompletion: { (group, error) in
          if (error == nil) && (group != nil) {
            Artifact.getRelatedArtifacts(Int32(Int((group?.id)!)), forProperty: (group?.propertyID)!, filter: [:], onCompletion: { (tags, error) in
              self.moreItems = tags as! [AnyObject]
              for item in self.moreItems {
                if item.typeName == "article_artifact" {
                  self.artifactItems.append(item)
                }
                else {
                  self.otherItems.append(item)
                }
              }
//              self.artifactItems.insert("Buy Content" as AnyObject, at: 0)
              self.artifactItems.append("Feedback" as AnyObject)
              self.tableView.reloadData()
            })
          }
        })
      }
    }
    tableView.reloadData()
    super.viewDidLoad()
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return otherItems.count
    case 1:
      return artifactItems.count
    default:
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableView.register(UINib(nibName: "BurgerMenuCell", bundle: nil), forCellReuseIdentifier: "burgerMenuCell")
    let cell = tableView.dequeueReusableCell(withIdentifier: "burgerMenuCell", for: indexPath) as! BurgerMenuCell
    
    switch indexPath.section {
    case 0:
      let item = self.otherItems[indexPath.row]
      cell.burgerCellLabel.text = item.name
      if item.typeName == "playlist_artifact" || item.typeName == "tag_artifact" || item.typeName == "group_artifact" {
        cell.burgerMenuImageView.image = UIImage(named: "play_button_inactive")
      }
      if item.name == "Home" {
        cell.burgerMenuImageView.image = UIImage(named: "home_icon_inactive")
      }
    case 1:
      let item = self.artifactItems[indexPath.row]
      if let text = item as? String {
        cell.burgerCellLabel!.text = text
        if text == "Buy Content" {
          cell.burgerMenuImageView.image = UIImage(named: "cart_inactive")
        }
        else if text == "Feedback" {
          cell.burgerMenuImageView.image = UIImage(named: "contact_inactive")
        }
      }
      else {
        cell.burgerCellLabel?.text = item.name
        cell.burgerMenuImageView.image = UIImage(named: "info_inactive")
      }
    default:
      break
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      let item = otherItems[indexPath.row]
      if item.name == "Home" { // will home actually need to be hardcoded?
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let frontVC: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "containerViewController")

        let navigationController = UINavigationController(rootViewController: frontVC )
        self.revealViewController().pushFrontViewController(navigationController, animated: true)
        
        let revealButtomItem = UIBarButtonItem(image: UIImage(named: "reveal-icon"), style: UIBarButtonItemStyle.plain, target: revealViewController(), action: #selector(self.revealViewController().revealToggle(_:)))
        frontVC.navigationItem.leftBarButtonItem = revealButtomItem
      }
      else if item.typeName == "playlist_artifact" || item.typeName == "tag_artifact" || item.typeName == "group_artifact" {
        let item = moreItems[indexPath.row]
    
        let viewController = LatestViewController(artifactID: Int(item.id))
        let navigationController = UINavigationController(rootViewController: viewController )
        self.revealViewController().pushFrontViewController(navigationController, animated: true)
        
        // TODO: move out button for reuse
        let revealButtomItem = UIBarButtonItem(image: UIImage(named: "reveal-icon"), style: UIBarButtonItemStyle.plain, target: revealViewController(), action: #selector(self.revealViewController().revealToggle(_:)))
        viewController.navigationItem.leftBarButtonItem = revealButtomItem
        viewController.navigationController?.navigationBar.barTintColor = UIColor(red: 16/255, green: 24/255, blue: 31/255, alpha: 1.0)
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        viewController.title = item.name
      }
      else if item.typeName == "link_artifact" {
        if var urlString = item.providerURL {
          if !urlString.hasPrefix("http") {
            urlString = "http://\(urlString)"
          }
          // TODO: setup for link_artifact
          //        UIApplication.shared.openURL(URL(string: urlString)!)
        }
      }
    case 1:
      let item = artifactItems[indexPath.row]
      if let stringValue = item as? String {
        if (stringValue == "Feedback") {
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
        if item.typeName == "article_artifact" {
          let viewController = ArticleArtifactViewController(artifact: item as! Artifact)

          let navigationController = UINavigationController(rootViewController: viewController )
          self.revealViewController().pushFrontViewController(navigationController, animated: true)
          let revealButtomItem = UIBarButtonItem(image: UIImage(named: "reveal-icon"), style: UIBarButtonItemStyle.plain, target: revealViewController(), action: #selector(self.revealViewController().revealToggle(_:)))
          viewController.navigationItem.leftBarButtonItem = revealButtomItem
          viewController.navigationController?.navigationBar.isTranslucent = false
          viewController.navigationController?.navigationBar.barTintColor = UIColor(red: 16/255, green: 24/255, blue: 31/255, alpha: 1.0)
          viewController.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
          viewController.title = item.name
        }
      }
    default:
      break
    }
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:8))
    view.backgroundColor = UIColor.gray // TODO: set color in specs
    
    return view
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return ""
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 1
  }
  
}
