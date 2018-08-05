//
//  Constants.swift
//  TVShows
//
//  Created by Ivana Mrsic on 30/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import Foundation

enum Constants {
    
    enum URL {
        
        static let baseDomainUrl = "https://api.infinum.academy"
        static let baseUrl = baseDomainUrl + "/api"
        static let registerUser = baseUrl + "/users"
        static let loginUser = baseUrl + "/users/sessions"
        static let fetchShows = baseUrl + "/shows"
     
        static func constructFetchShowInfoUrl(showId: String) -> String {
            return URL.fetchShows + "/" + showId
        }
        
        static func constructFetchShowEpisodesUrl(showId: String) -> String {
            return URL.fetchShows + "/" + showId + "/episodes"
        }
        
        static func constructFetchShowImageUrl(imageUrl: String) -> String {
            return URL.baseDomainUrl + "/" + imageUrl
        }
    }
}
