//
//  Service.swift
//  Uber Clone Tutorial
//
//  Created by Nima on 2020-06-09.
//  Copyright © 2020 Azrieli. All rights reserved.
//

import Firebase

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")

struct Service {
    
    static let shared = Service()
    
    
    func fetchUserData(completion: @escaping(User) -> Void){
        guard let currenUid = Auth.auth().currentUser?.uid else { return }
        REF_USERS.child(currenUid).observeSingleEvent(of: .value) { (snap) in
            guard let dictionary = snap.value as? [String: Any] else { return }
            let user = User(dictionary: dictionary)
            
            completion(user)
        }
    }
}
