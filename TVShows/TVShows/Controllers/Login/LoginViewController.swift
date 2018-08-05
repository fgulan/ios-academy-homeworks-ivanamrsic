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

    // MARK: - IBOutlets
    @IBOutlet private weak var logoImage: UIImageView!
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var rememberMeButton: UIButton!
    @IBOutlet private weak var rememberMeStack: UIStackView!
    @IBOutlet private weak var logInStack: UIStackView!
    
    // MARK: - private variables
    private var isRemeberMeButtonChecked: Bool = false
    private var user: User?
    private var loginData: LoginData?
    
    // MARK: - lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.setBottomBorder()
        passwordTextField.setBottomBorder()
        
        logInButton.layer.cornerRadius = 10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        prepareForAnimation()
        resetInputFields()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animateEverythingIn()
    }
    
    
    // MARK: - IBActions
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
    
    // MARK: - private functions
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
                            
                            self?.loginData = loggedUser
                            print("Success: \(loggedUser)")
                            self?.animateEverythingOut()
                            
                        } catch let error {
                            print("Error: \(error)")
                        }
                    
                    case .failure(let error):
                        self?.failedLoginAlert()
                        print("API failure: \(error)")
                        self?.usernameTextField.shake()
                        self?.passwordTextField.shake()
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
    
    // MARK: - animation methods
    
    private func prepareForAnimation() {
        
        logoImage.transform = CGAffineTransform.identity
        usernameTextField.transform = CGAffineTransform.identity
        passwordTextField.transform = CGAffineTransform.identity
        rememberMeStack.transform = CGAffineTransform.identity
        logInStack.transform = CGAffineTransform.identity
    
        logoImage.alpha = 0
        logoImage.transform = CGAffineTransform(scaleX: 0, y: 0)
        usernameTextField.alpha = 0
        passwordTextField.alpha = 0
        rememberMeStack.alpha = 0
        logInStack.alpha = 0
    }
    
    private func animateEverythingIn() {
        UIView.animate(withDuration: 2.0, animations: {
            self.logoImage.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.logoImage.alpha = 1
        })
        
        UIView.animate(withDuration: 1.5, delay: 0.20, options: [.curveEaseInOut], animations: {
            
            self.usernameTextField.transform = CGAffineTransform(translationX: 50, y: 0)
            self.usernameTextField.alpha = 1
        })
        
        UIView.animate(withDuration: 1.5, delay: 0.30, options: [.curveEaseInOut], animations: {
            
            self.passwordTextField.transform = CGAffineTransform(translationX: 50, y: 0)
            self.passwordTextField.alpha = 1
        })
        
        UIView.animate(withDuration: 1.5, delay: 0.40, options: [.curveEaseInOut], animations: {
            
            self.rememberMeStack.transform = CGAffineTransform(translationX: 50, y: 0)
            self.rememberMeStack.alpha = 1
        })
        
        UIView.animate(withDuration: 1.5, delay: 0.50, options: [.curveEaseInOut], animations: {
            
            self.logInStack.transform = CGAffineTransform(translationX: 50, y: 0)
            self.logInStack.alpha = 1
        })

    }
    
    private func animateEverythingOut() {
        UIView.animate(withDuration: 1.5, animations: {
            self.logoImage.transform = CGAffineTransform(translationX: 0, y: -1000)
            self.logoImage.alpha = 0
        })
        
        UIView.animate(withDuration: 1, delay: 0.3, options: [.curveEaseInOut], animations: {
            self.usernameTextField.transform = CGAffineTransform(translationX: 0, y: -1000)
            self.usernameTextField.alpha = 0
        })
        
        UIView.animate(withDuration: 1, delay: 0.4, options: [.curveEaseInOut], animations: {
            self.passwordTextField.transform = CGAffineTransform(translationX: 0, y: -1000)
            self.passwordTextField.alpha = 0
        })
        
        UIView.animate(withDuration: 1, delay: 0.5, options: [.curveEaseInOut], animations: {
            self.rememberMeStack.transform = CGAffineTransform(translationX: 0, y: -1000)
            self.rememberMeStack.alpha = 0
        })
        
        UIView.animate(withDuration: 1, delay: 0.6, options: [.curveEaseInOut], animations: {
            self.logInStack.transform = CGAffineTransform(translationX: 0, y: -1000)
            self.logInStack.alpha = 0
        }) { _ in
            guard let loginData = self.loginData else {
                return
            }
            
            self.navigateToHomeViewController(loginData: loginData)

        }
    }
}
