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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        episodeNumberLabel.text = ""
        titleLabel.text = ""
    }
    
    func setup(episodeNumber: String, episodeTitle: String) {
        episodeNumberLabel.text = episodeNumber
        titleLabel.text = episodeTitle
    }
}
