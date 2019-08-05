//
//  GameViewController.swift
//  SpacePop
//
//  Created by Evgeniya Yureva on 4/5/19.
//  Copyright © 2019 Evgeniya Yureva. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var bestScoresLabel: UILabel!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var welcomMessageLabel: UILabel!
    
    var scoresDictionary: Dictionary = [String : Float]()
    var bestScores: Float?
    var countDownValue: Int = 3
    var gameTime: Int = 0
    var gameTimeLeft: Int = 60
    var maxNumberOfBubbles: Int = 15
    var bubblesCounter: Int = 0
    var attemptsToCreateBubble: Int = 0
    var bubbles: [BubbleView] = []
    var countDownTimer: Timer?
    var gameTimer: Timer?
    var bubbleViewTimer: Timer?
    var currentScores: Float = 0
    var lastPopedBubbleType: BubbleType = BubbleType.undefined
    var currentPlayerName: String = "Player"
    var bubbleSpeed: CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bestScores = getBestScore()
        bestScoresLabel.text = String(bestScores!)
        
        let preSettedMaxBubblesNumber = UserDefaults.standard.string(forKey: "Maximum number of bubbles")
        let preSettedGameTime = UserDefaults.standard.string(forKey: "Game time")
        
        if preSettedMaxBubblesNumber != nil {
            maxNumberOfBubbles = Int(preSettedMaxBubblesNumber!)!
        }
        
        if preSettedGameTime != nil {
            gameTimeLeft = Int(preSettedGameTime!)!
            gameTime = gameTimeLeft
        }
            
        timeLeftLabel.text = String(gameTimeLeft)
        currentScoreLabel.text = "0"
        
        currentPlayerName = UserDefaults.standard.string(forKey: "Current player") ?? "Player"
        welcomMessageLabel.text = "\(currentPlayerName), be ready in:"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        countDownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountDownLabel), userInfo: nil, repeats: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.gameTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateGameScene), userInfo: nil, repeats: true)
            self.bubbleViewTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.updateBubblesView), userInfo: nil, repeats: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchedPoint = touch.location(in: self.view)
            
            for bubble in self.view.subviews {
                if (bubble.layer.presentation()?.hitTest(touchedPoint) != nil) {
                    let bubbleCastedView = bubble as! BubbleView
                    calculatePoints(popedBubble: bubbleCastedView)
                    bubbleCastedView.bubbleExplodeAnimation()
                }
            }
        }
    }
    
    @objc func updateCountDownLabel() {
        countDownValue -= 1
        
        if (countDownValue == 0) {
            welcomMessageLabel.isHidden = true           
            countDownLabel.textColor = #colorLiteral(red: 0.809882462, green: 0.8112345338, blue: 0.07343512028, alpha: 1)
            countDownLabel.text = "START!"
        }
        else if (countDownValue < 0) {
            countDownLabel.isHidden = true
            countDownTimer?.invalidate()
            self.initialGameSceneFill()
        }
        else {
            countDownLabel.text = String(countDownValue)
        }
    }
    
    @objc func updateGameScene() {
        if let countDownIsOn = countDownTimer?.isValid {
            guard !countDownIsOn else {
                return
            }
        }
        else {
            print("Count down timer value is not defined.")
            }
        
        if (gameTimeLeft > 0)
        {
            gameTimeLeft -= 1
            timeLeftLabel.text = String(gameTimeLeft)
            
            if (gameTimeLeft == gameTime / 2) {
                bubbleSpeed = 2
            }
            
            addMoreBubbles()
            removeSeveralBubbles()
        }
        else
        {
            gameTimer?.invalidate()
            saveScores()
            let alertController = UIAlertController(title: "Game Over", message: "Congratulations! You have scored \(currentScores) points.", preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "OK",
                                         style: .default,
                                         handler: { action in self.performSegue(withIdentifier: "BestScoresViewSegue", sender: self) })
            
            alertController.addAction(actionOk)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func initialGameSceneFill() {
        for _ in 1...maxNumberOfBubbles {
            print("The ball was added: \(addBubble())")
        }
    }
    
    func addBubble() -> Bool {
        let xCoordinate = Float.random(in: 0...1) * Float(self.view.frame.width - 85)
        let yCoordinate = Float.random(in: 0...0.5) * Float(self.view.frame.height - 300) + 100
        
        let newBubble = BubbleView(frame: CGRect(x: CGFloat(xCoordinate), y: CGFloat(yCoordinate), width: 90, height: 90))
        
        if (!isNewBubbleOverlaps(newBubble: newBubble)) {
            self.view.addSubview(newBubble)
            self.view.bringSubviewToFront(newBubble)
            bubbles.append(newBubble)
            bubblesCounter += 1
            attemptsToCreateBubble = 0
            
            return true
        }
        else
        {
            if (attemptsToCreateBubble < 50)
            {
                attemptsToCreateBubble += 1
                print("One more attempt to add bubble: \(self.addBubble())")
            }
        }
        
        return false
    }
    
    func addMoreBubbles() {
        if bubblesCounter < maxNumberOfBubbles {
            let maximumBubblesToAdd = maxNumberOfBubbles - bubblesCounter
            let minimumBubblesToAdd = maximumBubblesToAdd / 2
            let bubblesToAdd = Int.random(in: minimumBubblesToAdd...maximumBubblesToAdd)
            
            for _ in (0...bubblesToAdd) {
                print ("Add more bubbles: \(addBubble())")
            }
        }
    }
    
    
    func removeSeveralBubbles() {
        for i in stride(from: bubblesCounter - 1, to: 0, by: -1) {
            if (Int.random(in: 0...4) > 3) {
                let bubbleToRemove = bubbles[i]
                bubbles.remove(at: i)
                bubblesCounter -= 1
                
                bubbleToRemove.bubbleDisappearAnimation()
            }
        }
    }
    
    func isNewBubbleOverlaps(newBubble: BubbleView) -> Bool {
        for existingBubble in bubbles {
            if newBubble.frame.intersects(existingBubble.frame) {
                return true
            }
        }
        
        return false
    }
    
    @objc func updateBubblesView() {
        if (gameTimeLeft > 0) {
            for subview in self.view.subviews {
                if subview is BubbleView {
                    subview.center.y += self.bubbleSpeed
                    if subview.frame.maxY < 0 {
                        subview.removeFromSuperview()
                        bubblesCounter -= 1
                    }
                }
            }
        }
        else {
            bubbleViewTimer?.invalidate()
        }
    }
    
    func getBestScore() -> Float {
        let existingScoresBoard = UserDefaults.standard.dictionary(forKey: "Scores board")
        scoresDictionary = existingScoresBoard as? Dictionary<String, Float> ?? Dictionary<String, Float>()
        
        if (scoresDictionary.count >= 1) {
            let sortedDictionary = scoresDictionary.sorted(by: {$0.value > $1.value})
            
            return sortedDictionary[0].value
        }
        
        return 0;
    }
    
    func saveScores() {
        if (scoresDictionary[currentPlayerName] != nil)
        {
            if (scoresDictionary[currentPlayerName]!  < currentScores) {
                scoresDictionary.updateValue(currentScores, forKey: "\(currentPlayerName)")
                UserDefaults.standard.set(scoresDictionary, forKey: "Scores board")
            }
        }
        else
        {
            scoresDictionary.updateValue(currentScores, forKey: "\(currentPlayerName)")
            UserDefaults.standard.set(scoresDictionary, forKey: "Scores board")
        }
        
    }
    
    func calculatePoints (popedBubble: BubbleView) {
        var scoresForPoppedBubble = Double(popedBubble.score)
        
        if (popedBubble.bubbleType == lastPopedBubbleType) {
            scoresForPoppedBubble = scoresForPoppedBubble * 1.5
        }
        
        currentScores += Float(scoresForPoppedBubble)
        lastPopedBubbleType = popedBubble.bubbleType ?? BubbleType.undefined
        
        currentScoreLabel.text = String(currentScores)
    }    
}
