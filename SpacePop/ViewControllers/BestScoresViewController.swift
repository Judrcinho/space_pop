//
//  BestScoresViewController.swift
//  SpacePop
//
//  Created by Evgeniya Yureva on 4/5/19.
//  Copyright © 2019 Evgeniya Yureva. All rights reserved.
//

import UIKit

class BestScoresViewController: UIViewController {
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var thirdNameLabel: UILabel!
    @IBOutlet weak var firstScoreLabel: UILabel!
    @IBOutlet weak var secondScoreLabel: UILabel!
    @IBOutlet weak var thirdScoreLabel: UILabel!
    
    var scoresBoard: Dictionary<String, Float>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideUndefinedValues()
        
        let existingScoresBoard = UserDefaults.standard.dictionary(forKey: "Scores board")
        
        if (existingScoresBoard != nil) {
            scoresBoard = existingScoresBoard as? Dictionary<String, Float>
            displayTopResults()
        }
    }
    
    func displayTopResults() {
        let sortedDictionary = scoresBoard?.sorted(by: {$0.value > $1.value})
        
        if (sortedDictionary?.indices.contains(0) == true) {
            firstNameLabel.text = sortedDictionary?[0].key
            firstScoreLabel.text = String(sortedDictionary?[0].value ?? 0)
            firstNameLabel.isHidden = false
            firstScoreLabel.isHidden = false
        }
        if (sortedDictionary?.indices.contains(1) == true) {
            secondNameLabel.text = sortedDictionary?[1].key
            secondScoreLabel.text = String(sortedDictionary?[1].value ?? 0)
            secondNameLabel.isHidden = false
            secondScoreLabel.isHidden = false
        }
        if (sortedDictionary?.indices.contains(2) == true){
            thirdNameLabel.text = sortedDictionary?[2].key
            thirdScoreLabel.text = String(sortedDictionary?[2].value ?? 0)
            thirdNameLabel.isHidden = false
            thirdScoreLabel.isHidden = false
        }
    }
    
    func hideUndefinedValues() {
        if (firstNameLabel.text == "non")
        {
            firstNameLabel.isHidden = true
        }
        if (secondNameLabel.text == "non")
        {
            secondNameLabel.isHidden = true
        }
        if (thirdNameLabel.text == "non")
        {
            thirdNameLabel.isHidden = true
        }
        if (firstScoreLabel.text == "non")
        {
            firstScoreLabel.isHidden = true
        }
        if (secondScoreLabel.text == "non")
        {
            secondScoreLabel.isHidden = true
        }
        if (thirdScoreLabel.text == "non")
        {
            thirdScoreLabel.isHidden = true
        }
    }
    
}
