//
//  Comment.swift
//  TVShows
//
//  Created by Ivana Mrsic on 05/08/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let text: String
    let episodeId: String
    let userEmail: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case text
        case episodeId
        case userEmail
    }
}
