//
//  HomeViewController.swift
//  TVShows
//
//  Created by Ivana Mrsic on 18/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

let FETCH_SHOWS_URL = "https://api.infinum.academy/api/shows"

class HomeViewController: UIViewController {
    
    var token: String?
    var shows: [Show] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        
        fetchTvShows()
    }
    
    private func fetchTvShows() {
        SVProgressHUD.show()
        
        guard let token = token else {
            return
        }
        
        let headers = ["Authorization": token]
     
        Alamofire
            .request(FETCH_SHOWS_URL,
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<[Show]>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let shows):
                    self?.shows = shows
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
        
    }
        
}
