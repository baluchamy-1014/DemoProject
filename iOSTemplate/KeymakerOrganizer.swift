//
// Created by Shovan Joshi on 1/19/17.
// Copyright (c) 2017 Sportsrocket. All rights reserved.
//

import Foundation

class KeymakerOrganizer {

  var path: String!
  let fileManager = NSFileManager.defaultManager()
  var documentsDirectory: NSString!
  var environment: String!

  init() {
    let appConfiguration = NSBundle.mainBundle().infoDictionary! as NSDictionary
    environment    = appConfiguration["AppEnvironment"] as! String
    let paths: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    documentsDirectory = paths.objectAtIndex(0) as! NSString
    path = documentsDirectory.stringByAppendingPathComponent(environment + "_keymaker.plist")
  }

  func clearKeymakerToken() {
    if (fileManager.fileExistsAtPath(path)) {
      do {
        try fileManager.removeItemAtPath(path)
      } catch {

      }
    }
  }

  func saveKeymakerToken(accessToken: String) {

    var data: NSMutableDictionary

    if (fileManager.fileExistsAtPath(path)) {
      data = NSMutableDictionary(contentsOfFile: path)!
    } else {
      data = NSMutableDictionary()
    }

    data.setObject(accessToken, forKey: "token")
    data.writeToFile(path, atomically: true)

  }

  func fileContents() -> NSMutableDictionary? {
    return NSMutableDictionary(contentsOfFile: path)
  }

}