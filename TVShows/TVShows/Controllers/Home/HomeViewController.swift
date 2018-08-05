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
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.title = "Shows"
        navigationItem.setHidesBackButton(true, animated: false)
        
        showsTableView.separatorColor = .white
        
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
            .request(Constants.URL.fetchShows,
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
    
    private func navigateToShowDetails(row: Int) {
        let showDetailsViewController = ShowDetailsViewController()
        showDetailsViewController.showId = shows[row].id
        showDetailsViewController.token = self.loginData?.token
        self.navigationController?.pushViewController(showDetailsViewController, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (action, indexPath) in
            self?.shows.remove(at: indexPath.row)
            self?.showsTableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigateToShowDetails(row: indexPath.row)
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
