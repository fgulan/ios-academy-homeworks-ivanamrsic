//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Ivana Mrsic on 05/08/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import CodableAlamofire

class CommentsViewController: UIViewController {
    
    var episodeId: String?
    var comments: [Comment] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchComments()
    }

    private func fetchComments() {
        SVProgressHUD.show()
        
        guard let episodeId = episodeId else {
            return
        }
        
        let url = Constants.URL.constructFetchEpisodeCommentsUrl(episodeId: episodeId)
        
        Alamofire
            .request(url,
                     method: .get,
                     encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<[Comment]>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let comments):
                    self?.comments = comments
                    print(comments)
                    //self?.showsTableView.reloadData()
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }

    }
}
