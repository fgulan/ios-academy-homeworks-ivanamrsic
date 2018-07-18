//
//  LoginViewController.swift
//  TVShows
//
//  Created by Ivana Mrsic on 15/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var rememberMeButton: UIButton!
    
    private var isRemeberMeButtonChecked: Bool = false
    private var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        usernameTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        
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
    
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            return
        }
        
        registerUser(email: username, password: password)
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            return
        }
        
        loginUser(email: username, password: password)
    }
    
    private func registerUser(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire
            .request(REGISTER_USER_URL,
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseJSON { [weak self] dataResponse in
                
                SVProgressHUD.dismiss()
                
                switch dataResponse.result {
                case .success(let response):
                    
                    guard let jsonDict = response as? Dictionary<String, Any> else {
                        return
                    }
                    
                    guard
                        let dataDict = jsonDict["data"],
                        let dataBinary = try? JSONSerialization.data(withJSONObject: dataDict) else {
                            return
                    }
                    
                    do {
                        let newUser = try JSONDecoder().decode(User.self, from: dataBinary)
                        self?.user = newUser
                        print("Success: \(newUser)")
                    } catch let error {
                        print("Serialization error: \(error)")
                    }
                    
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
    
    private func loginUser(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire
            .request(LOGIN_USER_URL,
                     method: .post,
                     parameters: parameters,
                     encoding: JSONEncoding.default)
            .validate()
            .responseJSON { [weak self] dataResponse in
                
                switch dataResponse.result {
                case .success(let response):
                    guard let jsonDict = response as? Dictionary<String, Any> else {
                        return
                    }
                    
                    guard
                        let dataDict = jsonDict["data"],
                        let dataBinary = try? JSONSerialization.data(withJSONObject: dataDict) else {
                            return
                    }
                    do {
                        let loggedUser = try JSONDecoder().decode(LoginData.self, from: dataBinary)
                        SVProgressHUD.showSuccess(withStatus: "Success")
                        print("Success: \(loggedUser)")
                        self?.navigateToHomeViewController()
                    } catch let error {
                        print("Error: \(error)")
                    }
                case .failure(let error):
                    print("API failure: \(error)")
                    SVProgressHUD.showError(withStatus: "Failure")
                }
        }
    }

    
    private func navigateToHomeViewController() {
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
