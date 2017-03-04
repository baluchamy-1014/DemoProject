//
// Created by Shovan Joshi on 1/19/17.
// Copyright (c) 2017 Sportsrocket. All rights reserved.
//

import Foundation

class KeymakerOrganizer {

  var path: String!
  let fileManager = FileManager.default
  var documentsDirectory: NSString!
  var environment: String!

  init() {
    environment        = UnimatrixConfiguration.sharedConfig().appEnvironment
    let paths: NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
    documentsDirectory = paths.object(at: 0) as! NSString
    path = documentsDirectory.appendingPathComponent(environment + "_keymaker.plist")
  }

  func clearKeymakerToken() {
    if (fileManager.fileExists(atPath: path)) {
      do {
        try fileManager.removeItem(atPath: path)
      } catch {

      }
    }
  }

  func saveKeymakerToken(_ accessToken: String) {

    var data: NSMutableDictionary

    if (fileManager.fileExists(atPath: path)) {
      data = NSMutableDictionary(contentsOfFile: path)!
    } else {
      data = NSMutableDictionary()
    }

    data.setObject(accessToken, forKey: "token" as NSCopying)
    data.write(toFile: path, atomically: true)

  }

  func fileContents() -> NSMutableDictionary? {
    return NSMutableDictionary(contentsOfFile: path)
  }

}
