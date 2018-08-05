//
//  Media.swift
//  TVShows
//
//  Created by Ivana Mrsic on 05/08/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import Foundation

struct Media: Codable {
    let id: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
    }
}
