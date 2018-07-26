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

        episodeTitleInputText.setBottomBorder()
        seasonNumberInputText.setBottomBorder()
        episodeNumberInputText.setBottomBorder()
        episodeDescriptionInputText.setBottomBorder()
    }
}
