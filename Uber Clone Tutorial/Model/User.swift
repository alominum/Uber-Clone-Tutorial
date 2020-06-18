//
//  User.swift
//  Uber Clone Tutorial
//
//  Created by Nima on 2020-06-10.
//  Copyright © 2020 Azrieli. All rights reserved.
//
import CoreLocation

enum AccountType : Int {
    case passenger
    case driver
}

struct User {
    let fullname: String
    let email: String
    let accountType: AccountType!
    let uid : String
    var location : CLLocation?
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.accountType = AccountType(rawValue: dictionary["accountType"] as? Int ?? 0)
    }
}
