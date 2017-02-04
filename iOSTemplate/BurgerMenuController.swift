//
// Created by Shovan Joshi on 1/30/17.
// Copyright (c) 2017 Sportsrocket. All rights reserved.
//

import Foundation
import UIKit

class BurgerMenuController: UITableViewController {
  var moreItems: [AnyObject] = Array()
  // TODO: use mutidimensional array for sections data
  var artifactItems: [AnyObject] = Array()
  var otherItems: [AnyObject] = Array()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Menu"
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
              self.artifactItems.insert("Buy Content" as AnyObject, at: 0)
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
