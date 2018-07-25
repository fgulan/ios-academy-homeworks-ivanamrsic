//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Ivana Mrsic on 25/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

let FETCH_SHOW_INFO_URL = "https://api.infinum.academy/api/shows/"

class ShowDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addEpisodeButton: UIButton!
    
    var showId: String?
    var token: String?
    var showInfo: ShowInfo?
    var episodes: [Episode] = []
    
    private let showImageCellIdentifier = "showImageTableViewCell"
    private let episodeCellIdentifier = "episodeTableViewCell"
    private let descriptionCellIdentifier = "descriptionTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        fetchShowInformation()
        fetchEpisodes()
    }

    @IBAction func addEpisodeTapped(_ sender: Any) {
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ShowImageTableViewCell", bundle: nil), forCellReuseIdentifier: showImageCellIdentifier)
        tableView.register(UINib(nibName: "EpisodeTableViewCell", bundle: nil), forCellReuseIdentifier: episodeCellIdentifier)
        tableView.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: descriptionCellIdentifier)
    }
    
    private func fetchShowInformation() {
        SVProgressHUD.show()
        
        guard
            let token = token,
            let showId = showId
        else {
            return
        }
        
        let path = FETCH_SHOW_INFO_URL + showId
        
        Alamofire
            .request(path,
                     method: .get,
                     encoding: URLEncoding.queryString)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<ShowInfo>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let showInfo):
                    self?.showInfo = showInfo
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
    
    private func fetchEpisodes() {
        SVProgressHUD.show()
        
        guard
            let showId = showId
            else {
                return
        }
        
        let path = FETCH_SHOW_INFO_URL + showId + "/episodes"
        
        Alamofire
            .request(path,
                     method: .get,
                     encoding: URLEncoding.queryString)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<[Episode]>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let episodes):
                    self?.episodes = episodes
                    print(episodes)
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
}


extension ShowDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ShowDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentRow = indexPath.row
    
        
        if (currentRow == 0) {
            var cell = tableView.dequeueReusableCell(withIdentifier: showImageCellIdentifier, for: indexPath) as! ShowImageTableViewCell
            return cell
        } else if (currentRow == 1) {
            var cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellIdentifier, for: indexPath) as! DescriptionTableViewCell
            cell.title = showInfo?.title
            cell.count = String(episodes.count)
            cell.setup()
            return cell
        } else {
            var cell: EpisodeTableViewCell
            cell = tableView.dequeueReusableCell(withIdentifier: episodeCellIdentifier, for: indexPath) as! EpisodeTableViewCell
            return cell
        }
   
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + episodes.count
    }
}
