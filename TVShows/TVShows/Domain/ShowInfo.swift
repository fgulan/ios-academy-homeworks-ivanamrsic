//
//  ShowInfo.swift
//  TVShows
//
//  Created by Ivana Mrsic on 25/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import Foundation

struct ShowInfo: Codable {
    let type: String
    let title: String
    let description: String
    let id: String
    let likesCount: Int?
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case type
        case title
        case description
        case likesCount
        case imageUrl
    }
}
