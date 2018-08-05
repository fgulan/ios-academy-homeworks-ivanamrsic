//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Ivana Mrsic on 05/08/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import CodableAlamofire
import Kingfisher

class EpisodeDetailsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var episodeImageView: UIImageView!
    @IBOutlet private weak var episodeNameLabel: UILabel!
    @IBOutlet private weak var episodeNumberLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - private variables
    private var episode: Episode?
    
    // MARK: - class variables
    var episodeId: String?
    
    // MARK: - lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchEpisodeInfo()
    }
    
    // MARK: - IBActions
    @IBAction func commentsTapped(_ sender: Any) {
        let commentsViewController = CommentsViewController()
        commentsViewController.episodeId = episodeId
        
        navigationController?.pushViewController(commentsViewController, animated: true)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - api calls functions
    private func fetchEpisodeInfo() {
        SVProgressHUD.show()
        
        guard let episodeId = episodeId else {
            return
        }
        
        let path = Constants.URL.constructFetchEpisodeInfoUrl(episodeId: episodeId)
        
        Alamofire
            .request(path,
                     method: .get,
                     encoding: URLEncoding.queryString)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<Episode>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let episode):
                    print(episode)
                    self?.episode = episode
                    self?.setUp()
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
    
    private func setUp() {
        guard let episode = self.episode else {
            return
        }
        
        episodeNameLabel.text = episode.title
        descriptionLabel.text = episode.description
        episodeNumberLabel.text = constructSeasonAndEpisodeNumber()
        
        let url = URL(string: Constants.URL.constructFetchShowImageUrl(imageUrl: episode.imageUrl))
        episodeImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "login-logo"))
    }
    
    private func constructSeasonAndEpisodeNumber() -> String {
        guard let episode = episode, let season = episode.season, let episodeNumber = episode.episodeNumber else {
            return ""
        }
        
        return "S" + season + " Ep" + episodeNumber;
    }
}
