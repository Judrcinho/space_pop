//
//  SettingsViewController.swift
//  SpacePop
//
//  Created by Evgeniya Yureva on 4/5/19.
//  Copyright © 2019 Evgeniya Yureva. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var gameTime: UILabel!
    @IBOutlet weak var numberOfBubbles: UILabel!
    @IBOutlet weak var gameTimeSlider: UISlider!
    @IBOutlet weak var numberOfBubblesSlider: UISlider!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(60, forKey: "Game time")
        UserDefaults.standard.set(15, forKey: "Maximum number of bubbles")
        
        gameTimeSlider.value = Float(UserDefaults.standard.integer(forKey: "Game time"))
        numberOfBubblesSlider.value = Float(UserDefaults.standard.integer(forKey: "Maximum number of bubbles"))
        
    }

    @IBAction func SaveGameSettings(_ sender: Any) {
        UserDefaults.standard.set(Int(gameTimeSlider.value), forKey: "Game time")
        UserDefaults.standard.set(Int(numberOfBubblesSlider.value), forKey: "Maximum number of bubbles")
    }
    
    @IBAction func GameTimeChanged(_ sender: Any) {
        gameTime.text = String(Int(gameTimeSlider.value))
    }
    
    @IBAction func NumberOfBubblesChanged(_ sender: Any) {
        numberOfBubbles.text = String(Int(numberOfBubblesSlider.value))
    }
}
