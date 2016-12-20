//
//  TeamsFilterListViewController.swift
//  iOSTemplate
//
//  Created by Nichole Radman on 9/26/16.
//  Copyright © 2016 Sportsrocket. All rights reserved.
//

import UIKit

class TeamsFilterListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  @IBOutlet weak var teamsTableView: UITableView!
  var activityIndicator: UIActivityIndicatorView!
  var items = [AnyObject]()
  var teamID = Int()
  var teamName = String()
  var selectedRow: NSIndexPath?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupActivitySpinner()
    
    // TODO: theme
    self.view.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
    
    teamsTableView.delegate = self
    teamsTableView.dataSource = self
    teamsTableView.allowsMultipleSelection = false

    Session.sharedSession().getProperty { property, error in
      if (error == nil) {
        Group.getGroup("/team-filter", forProperty: Int32(Int(property.id))) { (group, error) in
          if (error == nil) && (group != nil) {
            Artifact.getRelatedArtifacts(Int32(Int(group.id)), forProperty: group.propertyID, filter: [:], onCompletion: { (menuItems, error) in
              self.items = menuItems as! [AnyObject]
              self.items.insert("NLL TV", atIndex: 0)
              self.teamsTableView.reloadData()
            })
          }
        }
      }

    }

  }

  func setupActivitySpinner() {
    activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    teamsTableView.addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))

    activityIndicator.startAnimating()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.items.count;
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("teamsCell", forIndexPath: indexPath)
    // TODO: theme
    tableView.backgroundColor = UIColor(red: 37/255, green: 35/255, blue: 38/255, alpha: 1.0)
    tableView.separatorColor = UIColor(red: 37/255, green: 35/255, blue: 38/255, alpha: 1.0)
    cell.preservesSuperviewLayoutMargins = false
    cell.separatorInset = UIEdgeInsetsZero
    cell.layoutMargins = UIEdgeInsetsZero
    cell.textLabel?.textColor = UIColor.whiteColor()
    cell.backgroundColor = UIColor(red: 37/255, green: 35/255, blue: 38/255, alpha: 1.0)
    
    let backgroundColorView = SelectedCellBackgroundColorView(frame: cell.frame)
    cell.selectedBackgroundView = backgroundColorView
    
    let item = self.items[indexPath.row]
    if indexPath.row == 0 {
      cell.textLabel?.text = "NLL TV"
      tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
    }
    else {
      cell.textLabel!.text = item.name
      Swift.print(item.id)
      self.teamID = Int(item.id)
      
      tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
    }
    activityIndicator.stopAnimating()
    return cell
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "selectTeamSegue" {
      let selectedPath: NSIndexPath = self.teamsTableView.indexPathForCell(sender as! UITableViewCell)!
      self.selectedRow = selectedPath
      if selectedPath.row == 0 {
        let item = "NLL TV"
        self.teamName = item
      }
      else {
        let item = (self.items[selectedPath.row] as! Artifact)
        self.teamID = Int(item.id)
        self.teamName = item.name
      }
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
  }

  func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
  }

}
