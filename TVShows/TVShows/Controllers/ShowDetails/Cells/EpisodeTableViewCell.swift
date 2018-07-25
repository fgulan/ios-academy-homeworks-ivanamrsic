//
//  EpisodeTableViewCell.swift
//  TVShows
//
//  Created by Ivana Mrsic on 25/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {

    @IBOutlet weak var episodeNumberLabel: UILabel!

    var episodeNumber: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let episodeNumber = episodeNumber else {
            return
        }
        
        episodeNumberLabel.text = episodeNumber
    }

    override func prepareForReuse() {
        episodeNumber = ""
        episodeNumberLabel.text = ""
    }
    
    @IBAction func moreInfoTapped(_ sender: Any) {
    }
}
