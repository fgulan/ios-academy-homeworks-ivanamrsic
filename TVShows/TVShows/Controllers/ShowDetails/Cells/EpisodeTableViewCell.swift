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
    @IBOutlet weak var titleLabel: UILabel!
    
    var episodeNumber: String?
    var title: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        episodeNumber = ""
        episodeNumberLabel.text = ""
        title = ""
        titleLabel.text = ""
    }
    
    func setup() {
        guard let title = title, let episodeNumber = episodeNumber else {
            return
        }
        
        episodeNumberLabel.text = episodeNumber
        titleLabel.text = title
    }
    
    @IBAction func moreInfoTapped(_ sender: Any) {
    }
}
