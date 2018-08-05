//
//  ShowImageTableViewCell.swift
//  TVShows
//
//  Created by Ivana Mrsic on 25/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit
import Kingfisher

class ShowImageTableViewCell: UITableViewCell {

    @IBOutlet weak var showImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setup(imageUrl: String) {
        let url = URL(string: Constants.URL.constructFetchShowImageUrl(imageUrl: imageUrl))
        showImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "login-logo"))
    }
}

extension ShowImageTableViewCell : Placeholder {}
