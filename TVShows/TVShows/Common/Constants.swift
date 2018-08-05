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
        static let episodes = baseUrl + "/episodes"
     
        static func constructFetchShowInfoUrl(showId: String) -> String {
            return fetchShows + "/" + showId
        }
        
        static func constructFetchShowEpisodesUrl(showId: String) -> String {
            return fetchShows + "/" + showId + "/episodes"
        }
        
        static func constructFetchShowImageUrl(imageUrl: String) -> String {
            return baseDomainUrl + "/" + imageUrl
        }
        
        static func constructFetchEpisodeInfoUrl(episodeId: String) -> String {
            return episodes + "/" + episodeId
        }
        
        static func constructFetchEpisodeCommentsUrl(episodeId: String) -> String {
            let baseEpisodeUrl = constructFetchEpisodeInfoUrl(episodeId: episodeId)
            
            return baseEpisodeUrl + "/comments"
        }
    }
}
