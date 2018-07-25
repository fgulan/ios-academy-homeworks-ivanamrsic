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
    
    @IBOutlet weak var showsTableView: UITableView!
    
    var loginData: LoginData?
    private var shows: [Show] = []
    
    let cellReuseIdentifier = "showTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTvShows()
    }
    
    private func setupTableView() {
        showsTableView.delegate = self
        showsTableView.dataSource = self
        showsTableView.register(UINib(nibName: "ShowTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    private func fetchTvShows() {
        SVProgressHUD.show()
        
        guard let loginData = loginData else {
            return
        }
        
        let headers = ["Authorization": loginData.token]
     
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
                    self?.showsTableView.reloadData()
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ShowTableViewCell
        
        let show = shows[indexPath.row];
        
        cell.setup(show: show);
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
}
