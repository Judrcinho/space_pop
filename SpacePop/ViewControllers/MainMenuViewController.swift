//
//  ViewController.swift
//  SpacePop
//
//  Created by Evgeniya Yureva on 4/5/19.
//  Copyright © 2019 Evgeniya Yureva. All rights reserved.
//

import UIKit

var warningHasShown: Bool = false

class MainMenuViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var warningMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        warningMessageLabel.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (warningHasShown == false) {
            warningCompatibilityAlert()
            warningHasShown = true
        }
    }
    
    @IBAction func playGameButtonPushed(_ sender: Any) {
        
        if playerNameTextField.text == "" {
            warningMessageLabel.isHidden = false
        }
        else {
                UserDefaults.standard.set(playerNameTextField.text, forKey: "Current player")
                performSegue(withIdentifier: "PlayGameSegue", sender: nil)
        }
    }
    
    func warningCompatibilityAlert() {
        let alertController = UIAlertController(title: "Warning", message: "This version of the game was designed for iPhone XR device. We will improve compatibility in the next build! ", preferredStyle: .alert)
        let actionOk = UIAlertAction(title: "OK",
                                     style: .default,
                                     handler: nil)
        
        alertController.addAction(actionOk)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

