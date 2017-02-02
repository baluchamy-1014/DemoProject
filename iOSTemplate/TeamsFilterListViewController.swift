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
  var selectedRow: IndexPath?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupActivitySpinner()
    
    // TODO: theme
    self.view.backgroundColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0)
    
    teamsTableView.delegate = self
    teamsTableView.dataSource = self
    teamsTableView.allowsMultipleSelection = false

    Session.shared().getProperty { property, error in
      if (error == nil) {
        Group.getGroup("/team-filter", forProperty: Int32(Int((property?.id)!))) { (group, error) in
          if (error == nil) && (group != nil) {
            Artifact.getRelatedArtifacts(Int32(Int((group?.id)!)), forProperty: (group?.propertyID)!, filter: [:], onCompletion: { (menuItems, error) in
              self.items = menuItems as! [AnyObject]
              self.items.insert("All Teams" as AnyObject, at: 0)
              self.teamsTableView.reloadData()
            })
          }
        }
      }

    }

  }

  func setupActivitySpinner() {
    activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    teamsTableView.addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: activityIndicator, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))

    activityIndicator.startAnimating()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.items.count;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "teamsCell", for: indexPath)
    // TODO: theme
    tableView.backgroundColor = UIColor(red: 37/255, green: 35/255, blue: 38/255, alpha: 1.0)
    tableView.separatorColor = UIColor(red: 37/255, green: 35/255, blue: 38/255, alpha: 1.0)
    cell.preservesSuperviewLayoutMargins = false
    cell.separatorInset = UIEdgeInsets.zero
    cell.layoutMargins = UIEdgeInsets.zero
    cell.textLabel?.textColor = UIColor.white
    cell.backgroundColor = UIColor(red: 37/255, green: 35/255, blue: 38/255, alpha: 1.0)
    
    let backgroundColorView = SelectedCellBackgroundColorView(frame: cell.frame)
    cell.selectedBackgroundView = backgroundColorView
    
    let item = self.items[indexPath.row]
    if indexPath.row == 0 {
      cell.textLabel?.text = "All Teams"
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    else {
      cell.textLabel!.text = item.name
      Swift.print(item.id)
      self.teamID = Int(item.id)
      
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    activityIndicator.stopAnimating()
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "selectTeamSegue" {
      let selectedPath: IndexPath = self.teamsTableView.indexPath(for: sender as! UITableViewCell)!
      self.selectedRow = selectedPath
      if selectedPath.row == 0 {
        let item = "All Teams"
        self.teamName = item
      }
      else {
        let item = (self.items[selectedPath.row] as! Artifact)
        self.teamID = Int(item.id)
        self.teamName = item.name
      }
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
  }

  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    tableView.cellForRow(at: indexPath)?.accessoryType = .none
  }

}
