//
//  LoginViewController.swift
//  TVShows
//
//  Created by Ivana Mrsic on 12/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBAction func addOneTapped(_ sender: Any) {
        self.tapCounter += 1
        tapCounterLabel.text = String(tapCounter)
        print("tap")
    }
    @IBOutlet weak var secondsLeftLabel: UILabel!
    
    @IBOutlet weak var toggleIndicatorButton: UIButton!
    @IBOutlet weak var tapCounterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    
    @IBAction func toggleIndicatorTapped(_ sender: Any) {
        self.toggleIndicator()
    }
    
    var timer: Timer = Timer()
    
    var indicatorToggler: Bool = true
    var tapCounter: Int = 0
    var timeRemaining: Int = 3
    
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
        toggleIndicatorButton.layer.cornerRadius = 25
        tapCounterLabel.text = String(tapCounter)
        timeRemaining = 3
        secondsLeftLabel.text = String(timeRemaining)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
    }
    
    @objc
    func timerRunning() {
        timeRemaining -= 1
        secondsLeftLabel.text = String(timeRemaining)
        
        if(timeRemaining == 0) {
            timer.invalidate()
            toggleIndicator()
        }
    }
}
