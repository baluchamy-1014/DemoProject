//
//  ApplePay.swift
//  iOSTemplate
//
//  Created by Shovan Joshi on 6/4/17.
//  Copyright © 2017 Sportsrocket. All rights reserved.
//

import Foundation
import PassKit
import Stripe

extension CNPostalAddress {
  func billingInfo() -> [String: String] {
    return [
      "address_postal_code": self.postalCode,
      "address_country": self.country,
      "address_region": self.state,
      "address_city": self.city,
      "address_line_1": self.street,
      "address_line_2": ""
    ]
  }
}

extension STPToken {
  func transactionInfo() -> [String: String] {
    let liveMode = (self.livemode == true) ? "true" : "false"
    let createdAt = (self.created != nil) ? "\(self.created!.timeIntervalSince1970)" : ""
    return [
      "id": self.tokenId,
      "object": "token",
      "created": createdAt,
      "livemode": liveMode,
      "type": "card",
    ]
  }
}
