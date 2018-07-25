//
//  ShowDetailsViewController.swift
//  TVShows
//
//  Created by Ivana Mrsic on 25/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit

class ShowDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addEpisodeButton: UIButton!
    
    var showId: String?
    var token: String?
    
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
        var cell: UITableViewCell
        
        if (currentRow == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: showImageCellIdentifier, for: indexPath) as! ShowImageTableViewCell
        } else if (currentRow == 1) {
            cell = tableView.dequeueReusableCell(withIdentifier: descriptionCellIdentifier, for: indexPath) as! DescriptionTableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: episodeCellIdentifier, for: indexPath) as! EpisodeTableViewCell
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
}
