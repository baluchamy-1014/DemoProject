//
//  SubscriptionsViewController.swift
//  iOSTemplate
//
//  Created by Shovan Joshi on 2/21/17.
//  Copyright © 2017 Sportsrocket. All rights reserved.
//

import UIKit

class SubscriptionsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {

  var subscriptionItems: [AnyObject] = Array()

  @IBOutlet weak var subscriptionsTableView: UITableView!
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return subscriptionItems.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "subscriptionOptionCell")

    if (cell == nil) {
      cell = UITableViewCell(style: .default, reuseIdentifier:"subscriptionOptionCell")
    }

    let item = subscriptionItems[indexPath.row] as! Product
    cell?.textLabel?.text = item.name
    
    return cell!
  }

}
