//
//  LoginViewController.swift
//  TVShows
//
//  Created by Ivana Mrsic on 12/07/2018.
//  Copyright © 2018 Ivana Mrsic. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var secondsLeftLabel: UILabel!
    @IBOutlet weak var toggleIndicatorButton: UIButton!
    @IBOutlet weak var tapCounterLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var timer: Timer = Timer()
    
    var indicatorToggler: Bool = true
    var tapCounter: Int = 0
    var timeRemaining: Int = 3
    
    @IBAction func toggleIndicatorTapped(_ sender: Any) {
        self.toggleIndicator()
    }
    
    @IBAction func addOneTapped(_ sender: Any) {
        self.tapCounter += 1
        tapCounterLabel.text = String(tapCounter)
        print("tap")
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
        
        timeRemaining = 3
        secondsLeftLabel.text = String(timeRemaining)
        activityIndicator.startAnimating()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerRunning), userInfo: nil, repeats: true)
        
        toggleIndicatorButton.layer.cornerRadius = 25
        tapCounterLabel.text = String(tapCounter)
    }
    
    @objc
    func timerRunning() {
        timeRemaining -= 1
        secondsLeftLabel.text = String(timeRemaining)
        
        if(timeRemaining < 1) {
            timer.invalidate()
            toggleIndicator()
        }
    }
}
