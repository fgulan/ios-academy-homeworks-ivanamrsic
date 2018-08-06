//
//  DescriptionTableViewCell.swift
//  TVShows
//
//  Created by Ivana Mrsic on 25/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!

    override func prepareForReuse() {
        titleLabel.text = ""
        countLabel.text = ""
        descriptionLabel.text = ""
    }

    func setup(title: String, description: String, episodeCount: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        countLabel.text = episodeCount
    }
}
