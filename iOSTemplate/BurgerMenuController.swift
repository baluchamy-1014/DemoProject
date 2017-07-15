//
// Created by Shovan Joshi on 1/30/17.
// Copyright (c) 2017 Sportsrocket. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class BurgerMenuController: UITableViewController, UserSessionDelegate {
// TODO: use mutidimensional array for sections data?
  var articleItems: [AnyObject] = Array()
  var menuItems: [AnyObject] = Array()
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  var signButton = UIBarButtonItem()
  var signButtonTitle = String()
  
  override func viewWillAppear(_ animated: Bool) {
    if Session.shared().isValid() {
      signButton.title = "Sign Out"
    }
    else {
      signButton.title = "Sign In/Sign Up"
    }
    self.navigationController?.navigationBar.isTranslucent = false
  }

  override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.navigationBar.isTranslucent = true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.barTintColor = UIColor(red: 16/255, green: 24/255, blue: 31/255, alpha: 1.0)
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    self.tableView.backgroundColor = UIColor(red: 16/255, green: 24/255, blue: 31/255, alpha: 1.0)
    self.tableView.separatorStyle = .none
    
    setupSignInUpOutButton()
    setupBurgerMenuItems()
    
    super.viewDidLoad()
  }
  
  func setupSignInUpOutButton() {
    let fixedItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    fixedItem.width = 16.0
    let signInUpButtomItem = UIBarButtonItem(image: UIImage(named: "user_inactive"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(BurgerMenuController.userDidTapSignInOutButton))
    if Session.shared().isValid() {
      signButtonTitle = "Sign Out"
    }
    else {
      signButtonTitle = "Sign In/Sign Up"
    }
    signButton = UIBarButtonItem(title: signButtonTitle, style: .plain, target: self, action: #selector(BurgerMenuController.userDidTapSignInOutButton))
    self.navigationItem.setLeftBarButtonItems([fixedItem, signInUpButtomItem, signButton], animated: false)
  }
  
  func setupBurgerMenuItems() {
    for item in appDelegate.burgerMenuItems {
      if item.typeName == "article_artifact" || item.slug == "/buy"{
        self.articleItems.append(item)
      }
      else {
        self.menuItems.append(item)
      }
    }
    self.articleItems.append("Feedback" as AnyObject)
  }
  
  func userDidTapSignInOutButton() {
    if Session.shared().isValid() {
      let alertController = UIAlertController(title: "Are You Sure You Want To Sign Out?", message: nil, preferredStyle: .alert)
      let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
      alertController.addAction(noAction)
      let yesAction = UIAlertAction(title: "Yes", style: .default) { action in
        self.signOut()
      }
      alertController.addAction(yesAction)
      self.present(alertController, animated: true, completion: nil)
    }
    else {
      let userController = UserController(nibName: "UserAccount", bundle: nil)
      userController.sessionDelegate = self
      let revealButtomItem = UIBarButtonItem(image: UIImage(named: "reveal-icon"), style: UIBarButtonItemStyle.plain, target: revealViewController(), action: #selector(self.revealViewController().revealToggle(_:)))
      userController.navigationItem.leftBarButtonItem = revealButtomItem
      let navigationController = UINavigationController(rootViewController: userController )
      navigationController.navigationBar.backgroundColor = UIColor(red: 16/255, green: 24/255, blue: 31/255, alpha: 1.0) // this
      self.revealViewController().pushFrontViewController(navigationController, animated: true)
    }
  }
  
  fileprivate func signOut() {
    Session.shared().resetSession();
    self.appDelegate.keymakerOrganizer.clearKeymakerToken()
    
    self.appDelegate.sendUserToHomeScreen()
    signButton.title = "Sign In/Sign Up"
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return menuItems.count
    case 1:
      return articleItems.count
    default:
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableView.register(UINib(nibName: "BurgerMenuCell", bundle: nil), forCellReuseIdentifier: "burgerMenuCell")
    let cell = tableView.dequeueReusableCell(withIdentifier: "burgerMenuCell", for: indexPath) as! BurgerMenuCell
    
    switch indexPath.section {
    case 0:
      let item = menuItems[indexPath.row]
      cell.burgerCellLabel.text = item.name
      if item.typeName == "playlist_artifact" || item.typeName == "tag_artifact" || item.typeName == "group_artifact" {
        cell.burgerMenuImageView.image = UIImage(named: "play_button_inactive")
        cell.burgerMenuImageView.highlightedImage = UIImage(named: "play_button_active")
      }
      else if item.typeName == "link_artifact" {
        cell.burgerMenuImageView.image = UIImage(named: "link_artifact_inactive")
        cell.burgerMenuImageView.highlightedImage = UIImage(named: "link_artifact_active")
      }
      if item.name == "Home" {
        cell.burgerMenuImageView.image = UIImage(named: "home_icon_inactive")
        cell.burgerMenuImageView.highlightedImage = UIImage(named: "home_icon_active")
      }
    case 1:
      let item = articleItems[indexPath.row]
      if let text = item as? String {
        if text == "Feedback" {
          cell.burgerCellLabel!.text = text
          cell.burgerMenuImageView.image = UIImage(named: "contact_inactive")
          cell.burgerMenuImageView.highlightedImage = UIImage(named: "contact_active")
        }
      }
      else {
        cell.burgerCellLabel?.text = item.name
        cell.burgerMenuImageView.image = UIImage(named: "info_inactive")
        cell.burgerMenuImageView.highlightedImage = UIImage(named: "info_active")
        if let slugString = item.slug {
          if slugString == "/buy" {
            cell.burgerMenuImageView.image = UIImage(named: "cart_inactive")
            cell.burgerMenuImageView.highlightedImage = UIImage(named: "cart_active")
          }
        }
      }
    default:
      break
    }
    
    let backgroundColorView = SelectedCellBurgerMenuBackgroundColorView(frame: cell.frame)
    cell.selectedBackgroundView = backgroundColorView
    
    cell.burgerCellLabel.highlightedTextColor = UIColor.white
    cell.burgerCellLabel.textColor = UIColor(red: 135/255, green: 139/255, blue: 143/255, alpha: 1.0)

    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      let item = menuItems[indexPath.row]
      if item.name == "Home" {
        self.appDelegate.sendUserToHomeScreen()
      }
      else if item.typeName == "playlist_artifact" || item.typeName == "tag_artifact" || item.typeName == "group_artifact" {
        let viewController = LatestViewController(artifactID: Int(item.id))
        let navigationController = UINavigationController(rootViewController: viewController )
        self.revealViewController().pushFrontViewController(navigationController, animated: true)
        
        // TODO: move out button for reuse
        let revealButtomItem = UIBarButtonItem(image: UIImage(named: "reveal-icon"), style: UIBarButtonItemStyle.plain, target: revealViewController(), action: #selector(self.revealViewController().revealToggle(_:)))
        viewController.navigationItem.leftBarButtonItem = revealButtomItem
        viewController.navigationController?.navigationBar.barTintColor = UIColor(red: 16/255, green: 24/255, blue: 31/255, alpha: 1.0)
        viewController.shouldBeTranslucent(translucent: false)
        viewController.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        viewController.title = item.name
      }
      else if item.typeName == "link_artifact" {
        if var urlString = item.providerURL {
          if !urlString.hasPrefix("http") {
            urlString = "http://\(urlString!)"
          }
          UIApplication.shared.openURL(URL(string: urlString)!)
        }
      }
    case 1:
      let item = articleItems[indexPath.row]
      if let stringValue = item as? String {
        if (stringValue == "Feedback") {
          if (MFMailComposeViewController.canSendMail()) {
            let feedbackController = FeedbackViewController()
            feedbackController.navigationBar.tintColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
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
      else if item.slug == "/buy" {
        appDelegate.throughBurgerMenu = true
        let seasonController = SeasonsViewController()
        let navigationController = UINavigationController(rootViewController: seasonController)
        self.revealViewController().pushFrontViewController(navigationController, animated: true)
        let revealButtomItem = UIBarButtonItem(image: UIImage(named: "reveal-icon"), style: UIBarButtonItemStyle.plain, target: self.revealViewController(), action: #selector(self.revealViewController().revealToggle(_:)))
        seasonController.navigationItem.leftBarButtonItem = revealButtomItem
        seasonController.navigationController?.navigationBar.isTranslucent = false
        seasonController.navigationController?.navigationBar.barTintColor = UIColor(red: 16 / 255, green: 24 / 255, blue: 31 / 255, alpha: 1.0)
        seasonController.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        Property.getProperty("nll_purchasing") { property, error in
          if (error == nil) {
            Group.getGroup("/home", forProperty: Int32(Int((property?.id)!)), onCompletion: { (group, error) in
              if (error == nil) && (group != nil) {
                Artifact.getRelatedArtifacts(Int32(Int((group?.id)!)), forProperty: (group?.propertyID)!, filter: ["count": "20"], onCompletion: { (groups, error) in
                  if (error == nil) {
                    var seasonGroups: [Group] = []
                    for seasonGroup in groups as! [Group] {
                        print("season uid is \(seasonGroup.uid)")
                        Product.query(self.appDelegate.appConfiguration["DEALER_REALM_UUID"] as! String, archivistCategoryUids: [seasonGroup.uid]) { productsByUids, error in
                        var values: [ProductGroup] = []
                          Artifact.getRelatedArtifacts(Int32(Int((seasonGroup.id)!)), forProperty: seasonGroup.propertyID, filter: ["count": "20"]) { items, error in
                            for item in (items! as! [Artifact]) {
                              print("item name is \(item.name) uid is : \(item.uid)")
                              if let products = (productsByUids as! [String:AnyObject])[item.uid] {
                                let productGroup = ProductGroup(artifact: item, products: products as! [Product])
                                values.append(productGroup)
                              }
                            }
                          if (groups as! [Group]).count > 1 {
                            seasonGroups.append(seasonGroup)
                            seasonController.seasonItems = seasonGroups
                            seasonController.tableView.reloadData()
                          }
                          else {
                            let passController = PassTypeViewController()
                            let navigationController = UINavigationController(rootViewController: passController)
                            self.revealViewController().pushFrontViewController(navigationController, animated: true)
        
                            let revealButtomItem = UIBarButtonItem(image: UIImage(named: "reveal-icon"), style: UIBarButtonItemStyle.plain, target: self.revealViewController(), action: #selector(self.revealViewController().revealToggle(_:)))
                            passController.navigationItem.leftBarButtonItem = revealButtomItem
                            passController.navigationController?.navigationBar.isTranslucent = false
                            passController.navigationController?.navigationBar.barTintColor = UIColor(red: 16 / 255, green: 24 / 255, blue: 31 / 255, alpha: 1.0)
                            passController.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
                            let validProductGroups = values.filter({ (productGroup) -> Bool in productGroup.category != nil })
                            passController.subscriptionItems = validProductGroups
                            passController.tableView.reloadData()
                          }
                        }
                      }
                    }
                  }
                })
              }
            })
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
          viewController.navigationController?.navigationBar.barTintColor = UIColor(red: 16/255, green: 24/255, blue: 31/255, alpha: 1.0)
          viewController.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
          viewController.title = item.name
        }
      }
    default:
      break
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 48.0
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = UIView(frame: CGRect(x:0, y:0, width:tableView.frame.size.width, height:8))
    view.backgroundColor = UIColor(red: 51/255, green: 63/255, blue: 74/255, alpha: 1.0)
    
    return view
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return ""
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 1
  }
  
  func userDidSignIn() {
    self.appDelegate.sendUserToHomeScreen()
  }
  
}
