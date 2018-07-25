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
    
    var imageUrl: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let imageUrl = imageUrl else {
            return
        }
        
        //let url = URL(string: imageUrl)
        //showImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "login-logo"))
        
        showImageView.image = UIImage(named: "login-logo")
    }
    
    override func prepareForReuse() {
        imageUrl = ""
    }
}

extension ShowImageTableViewCell : Placeholder {}
