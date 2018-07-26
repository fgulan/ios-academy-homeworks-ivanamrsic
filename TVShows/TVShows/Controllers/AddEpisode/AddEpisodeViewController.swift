//
//  AddEpisodeViewController.swift
//  TVShows
//
//  Created by Ivana Mrsic on 26/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

let ADD_EPISODE_URL = "https://api.infinum.academy/api/episodes"

protocol AddEpisodeDelegate {
    func updateEpisodeList(episode: Episode)
}

class AddEpisodeViewController: UIViewController {

    @IBOutlet weak var episodeTitleInputText: UITextField!
    @IBOutlet weak var seasonNumberInputText: UITextField!
    @IBOutlet weak var episodeNumberInputText: UITextField!
    @IBOutlet weak var episodeDescriptionInputText: UITextField!
    
    var delegate: AddEpisodeDelegate?
    
    var showId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewController()
    }
    
    @objc func didSelectCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didSelectAddEpisode() {
        addEpisode()
    }
    
    private func addEpisode() {
        SVProgressHUD.show()
        
        guard let showId = showId,
            let episodeTitleText = episodeTitleInputText.text,
            let episodeDescriptionText = episodeDescriptionInputText.text,
            let episodeNumberText = episodeNumberInputText.text,
            let seasonNumberText = seasonNumberInputText.text
        else {
            return
        }
        
        
        let parameters: [String: String] = [
            "showId": showId,
            "title": episodeTitleText,
            "description": episodeDescriptionText,
            "episodeNumber": episodeNumberText,
            "season": seasonNumberText
        ]
        
        Alamofire
            .request(ADD_EPISODE_URL,
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseJSON { [weak self] dataResponse in
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let response):
                    guard let jsonDict = response as? Dictionary<String, Any> else {
                        return
                    }
                    
                    guard
                        let dataDict = jsonDict["data"],
                        let dataBinary = try? JSONSerialization.data(withJSONObject: dataDict) else {
                            return
                    }
                    
                    do {
                        
                        let episode = try JSONDecoder().decode(Episode.self, from: dataBinary)
                        print("Success: \(episode)")
                        
                        if let delegate = self?.delegate {
                            delegate.updateEpisodeList(episode: episode)
                        }
                        self?.dismiss(animated: true, completion: nil)
                    } catch let error {
                        print("Error: \(error)")
                    }
                    
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
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
