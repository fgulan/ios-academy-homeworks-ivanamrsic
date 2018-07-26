//
//  AddEpisodeViewController.swift
//  TVShows
//
//  Created by Ivana Mrsic on 26/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit

class AddEpisodeViewController: UIViewController {

    @IBOutlet weak var episodeTitleInputText: UITextField!
    @IBOutlet weak var seasonNumberInputText: UITextField!
    @IBOutlet weak var episodeNumberInputText: UITextField!
    
    @IBOutlet weak var episodeDescriptionInputText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
    }
    
    @objc func didSelectCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didSelectAddEpisode() {
        
    }
    
    private func addEpisode() {
        
    }
    
    private func setupViewController() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didSelectCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(didSelectAddEpisode))
        navigationItem.title = "Add episode"
        
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false

        episodeTitleInputText.setBottomBorder()
        seasonNumberInputText.setBottomBorder()
        episodeNumberInputText.setBottomBorder()
        episodeDescriptionInputText.setBottomBorder()
    }
}
