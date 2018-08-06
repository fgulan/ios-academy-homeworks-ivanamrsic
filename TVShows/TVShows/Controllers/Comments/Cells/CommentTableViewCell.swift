//
//  CommentTableViewCell.swift
//  TVShows
//
//  Created by Ivana Mrsic on 05/08/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit
import Kingfisher

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        usernameLabel.text = ""
        commentLabel.text = ""
    }
 
    func setUp(comment: Comment) {
        let user = arc4random_uniform(3) + 1
        
        userImage.image = UIImage(named: "img-placeholder-user" + String(user))
        usernameLabel.text = comment.userEmail
        commentLabel.text = comment.text
    }
}
