//
//  User.swift
//  Uber Clone Tutorial
//
//  Created by Nima on 2020-06-10.
//  Copyright © 2020 Azrieli. All rights reserved.
//

struct User {
    let fullname: String
    let email: String
    let accountType: Int
    
    init(dictionary: [String: Any]) {
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.accountType = dictionary["accountType"] as? Int ?? -1
    }
}
