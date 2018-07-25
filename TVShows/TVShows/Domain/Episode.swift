//
//  Episode.swift
//  TVShows
//
//  Created by Ivana Mrsic on 25/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import Foundation

struct Episode: Codable {
    let title: String
    let description: String
    let imageUrl: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case imageUrl
    }
}
