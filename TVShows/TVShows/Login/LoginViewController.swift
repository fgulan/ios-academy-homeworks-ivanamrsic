//
//  LoginViewController.swift
//  TVShows
//
//  Created by Ivana Mrsic on 11/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var timeRemainingLabel: UILabel!
    @IBOutlet weak var toggleIndicatorButton: UIButton!
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tapCounterLabel: UILabel!
    
    var timer: Timer = Timer()
    
    var indicatorToggler: Bool = true
    var tapCounter: Int = 0
    var timeRemaining: Int = 3
    
    @IBAction func buttonTap(_ sender: Any) {
        self.tapCounter += 1
        tapCounterLabel.text = String(tapCounter)
        print("tap")
    }

    @IBAction func toggleAnimationButtonTapped(_ sender: Any) {
        toggleIndicator()
    }
    
    func toggleIndicator() {
        if (!self.indicatorToggler) {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        self.indicatorToggler = !self.indicatorToggler
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        tapButton.layer.cornerRadius = 10
        toggleIndicatorButton.layer.cornerRadius = 25
        tapCounterLabel.text = String(tapCounter)
        timeRemaining = 3
        timeRemainingLabel.text = String(timeRemaining)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
    }
    
    @objc
    func timerRunning() {
        timeRemaining -= 1
        timeRemainingLabel.text = String(timeRemaining)

        if(timeRemaining == 0) {
            timer.invalidate()
            toggleIndicator()
        }
    }
}
