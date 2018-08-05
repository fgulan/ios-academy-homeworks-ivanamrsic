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

let NUMBER_OF_INFO_CELLS = 2

class ShowDetailsViewController: UIViewController {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addEpisodeButton: UIButton!
    
    //MARK:- public atributes
    
    var showId: String?
    var token: String?
    
    //MARK:- private atributes
    
    private let showImageCellIdentifier = "showImageTableViewCell"
    private let episodeCellIdentifier = "episodeTableViewCell"
    private let descriptionCellIdentifier = "descriptionTableViewCell"
    private var showInfo: ShowInfo?
    private var episodes: [Episode] = []

    //MARK:- lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        tableView.separatorColor = .white
        
        fetchShowInformation()
        fetchEpisodes()
    }
    
    //MARK:- IBActions
    
    @IBAction func addEpisodeTapped(_ sender: Any) {
        let addEpisodeViewController = AddEpisodeViewController()
        addEpisodeViewController.delegate = self
        addEpisodeViewController.showId = showId
        addEpisodeViewController.token = token
        
        let navigationController = UINavigationController(rootViewController:
            addEpisodeViewController)
        
        present(navigationController, animated: true, completion: nil)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
     // MARK: - api calls
    private func fetchShowInformation() {
        SVProgressHUD.show()
        
        guard
            let token = token,
            let showId = showId
        else {
            return
        }
        
        let path = Constants.URL.constructFetchShowInfoUrl(showId: showId)
        
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
        
        guard let showId = showId, let token = token else {
            return
        }
        
        let path = Constants.URL.constructFetchShowEpisodesUrl(showId: showId)
        
        let headers = ["Authorization": token]
        
        Alamofire
            .request(path,
                     method: .get,
                     encoding: URLEncoding.queryString,
                     headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (dataResponse: DataResponse<[Episode]>) in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let episodes):
                    self?.episodes = episodes
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
}

//MARK:- tableView
extension ShowDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ShowDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBER_OF_INFO_CELLS + episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentRow = indexPath.row
        
        if (currentRow == 0) {
            let cell = setUpImageCell(indexPath: indexPath)
            return cell
        } else if (currentRow == 1) {
            let cell = setUpDescriptionCell(indexPath: indexPath)
            return cell
        } else {
            let cell = setUpEpisodeCell(indexPath: indexPath)
            return cell
        }
    }
}

extension ShowDetailsViewController : AddEpisodeDelegate {
    func updateEpisodeList(episode: Episode) {
        episodes.append(episode)
        
        tableView.reloadData()
    }
}


// MARK:- setup
extension ShowDetailsViewController {
    func setUpImageCell(indexPath: IndexPath) -> ShowImageTableViewCell {
        let imageUrl = showInfo?.imageUrl ?? ""
        
        let cell = tableView.dequeueReusableCell(withIdentifier: showImageCellIdentifier, for: indexPath) as! ShowImageTableViewCell
        cell.setup(imageUrl: imageUrl)
        return cell
    }
    
    func setUpDescriptionCell(indexPath: IndexPath) -> DescriptionTableViewCell {
        let showTitle = showInfo?.title ?? ""
        let showDescription = showInfo?.description ?? ""
        
        let cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellIdentifier, for: indexPath) as! DescriptionTableViewCell
        cell.setup(title: showTitle, description: showDescription, episodeCount: String(episodes.count))
        return cell
    }
    
    func setUpEpisodeCell(indexPath: IndexPath) -> EpisodeTableViewCell {
        let episodeNumber = String(indexPath.row - NUMBER_OF_INFO_CELLS + 1)
        let title = episodes[indexPath.row - NUMBER_OF_INFO_CELLS].title
        
        let cell = tableView.dequeueReusableCell(withIdentifier: episodeCellIdentifier, for: indexPath) as! EpisodeTableViewCell
        cell.setup(episodeNumber: episodeNumber, episodeTitle: title)
        return cell
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ShowImageTableViewCell", bundle: nil), forCellReuseIdentifier: showImageCellIdentifier)
        tableView.register(UINib(nibName: "EpisodeTableViewCell", bundle: nil), forCellReuseIdentifier: episodeCellIdentifier)
        tableView.register(UINib(nibName: "DescriptionTableViewCell", bundle: nil), forCellReuseIdentifier: descriptionCellIdentifier)
    }
}
