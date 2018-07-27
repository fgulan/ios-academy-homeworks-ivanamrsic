//
//  Show.swift
//  TVShows
//
//  Created by Ivana Mrsic on 24/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import Foundation

struct Show: Codable {
    let title: String
    let imageUrl: String
    let likesCount: Int?
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case imageUrl
        case likesCount
    }
}
