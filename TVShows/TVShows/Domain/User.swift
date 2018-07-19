//
//  User.swift
//  TVShows
//
//  Created by Ivana Mrsic on 18/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import Foundation

struct User: Codable {
    let email: String
    let type: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case type
        case id = "_id"
    }
}
