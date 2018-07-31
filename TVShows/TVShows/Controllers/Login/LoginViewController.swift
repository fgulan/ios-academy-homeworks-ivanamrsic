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

        usernameTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        
        logInButton.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func remeberMeTapped(_ sender: Any) {
        isRemeberMeButtonChecked = !isRemeberMeButtonChecked
        
        if isRemeberMeButtonChecked {
            rememberMeButton.setImage(UIImage(named: "ic-checkbox-filled"), for: UIControlState.normal)
        } else {
            rememberMeButton.setImage(UIImage(named: "ic-checkbox-empty"), for: UIControlState.normal)
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
            .request(Constants.URL.registerUser,
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
                        
                        self?.loginUser(email: email, password: password)
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
            .request(Constants.URL.loginUser,
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
                            
                            let loggedUser = try JSONDecoder().decode(LoginData.self, from: dataBinary)
                            print("Success: \(loggedUser)")
                            self?.navigateToHomeViewController(loginData: loggedUser)
                            
                        } catch let error {
                            print("Error: \(error)")
                        }
                    
                    case .failure(let error):
                        self?.failedLoginAlert()
                        print("API failure: \(error)")
                    }
        }
    }
    
    private func failedLoginAlert() {
        let alertController = UIAlertController(title: "Login failure", message: "Incorrect email or password", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Try again", style: .cancel, handler: {(alert: UIAlertAction!) in self.resetInputFields()})
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func resetInputFields() {
        self.usernameTextField.text = ""
        self.passwordTextField.text = ""
    }
    
    private func navigateToHomeViewController(loginData: LoginData) {
        let homeViewController = HomeViewController()
        homeViewController.loginData = loginData
        navigationController?.pushViewController(homeViewController, animated: true)
    }
}
