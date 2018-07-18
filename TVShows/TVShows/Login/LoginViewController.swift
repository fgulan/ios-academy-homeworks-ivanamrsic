//
//  LoginViewController.swift
//  TVShows
//
//  Created by Ivana Mrsic on 15/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var rememberMeButton: UIButton!
    
    var isRemeberMeButtonChecked: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        usernameLabel.setBottomBorder()
        passwordLabel.setBottomBorder()
        
        logInButton.layer.cornerRadius = 10
    }
    
    @IBAction func remeberMeTapped(_ sender: Any) {
        isRemeberMeButtonChecked = !isRemeberMeButtonChecked
        
        if(isRemeberMeButtonChecked) {
            rememberMeButton.setImage( UIImage(named: "ic-checkbox-filled"), for: UIControlState.normal )
        } else {
            rememberMeButton.setImage( UIImage(named: "ic-checkbox-empty"), for: UIControlState.normal )
        }
        
    }
    @IBAction func createAccountTapped(_ sender: Any) {
        navigateToHomeViewController()
    }
    @IBAction func logInTapped(_ sender: Any) {
        navigateToHomeViewController()
    }
    
    
    func navigateToHomeViewController() {
        let homeViewController = HomeViewController()
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 0.0
    }
}
