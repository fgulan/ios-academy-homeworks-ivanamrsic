//
//  ShowTableViewCell.swift
//  TVShows
//
//  Created by Ivana Mrsic on 24/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit

class ShowTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
    }

    func setup(show: Show) {
        titleLabel.text = show.title
    }
}
