//
//  Bubble.swift
//  SpacePop
//
//  Created by Evgeniya Yureva on 4/5/19.
//  Copyright © 2019 Evgeniya Yureva. All rights reserved.
//

import UIKit

class BubbleView: UIImageView {
    var bubbleType: BubbleType?
    var score: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bubbleType = getBubbleType()
        score = getBubbleScore(bubbleType: bubbleType!)
        
        self.image = getBubbleImage(bubbleType: bubbleType!)
        
       bubbleAppearsAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }  
    
    func getBubbleType() -> BubbleType {
        let randomNumber = Int.random(in: 1...100)
        print("Random number for bubble type is \(randomNumber).")
        var bubbleType: BubbleType
        
        switch randomNumber {
        case 1...40:
            bubbleType = BubbleType.yellow
        case 41...70:
            bubbleType = BubbleType.red
        case 71...85:
            bubbleType = BubbleType.green
        case 86...95:
            bubbleType = BubbleType.blue
        case 96...100:
            bubbleType = BubbleType.black
        default:
            print("Error! Bubble color can't be defined.")
            bubbleType = BubbleType.yellow
        }
        
        return bubbleType
    }
    
    func getBubbleImage(bubbleType: BubbleType) -> UIImage {
        var bubbleImage: UIImage?
        
        switch bubbleType {
        case .red:
            bubbleImage = UIImage(named: "red_ball.png")
        case .yellow:
            bubbleImage = UIImage(named: "yellow_ball.png")
        case .green:
            bubbleImage = UIImage(named: "green_ball.png")
        case .blue:
            bubbleImage = UIImage(named: "blue_ball.png")
        case .black:
            bubbleImage = UIImage(named: "black_ball.png")
        case .undefined:
            print("Type of bubble is undefined.")
        }
        
        return bubbleImage!
    }
    
    func getBubbleScore(bubbleType: BubbleType) -> Int {
        var score = 0
        
        switch bubbleType {
        case BubbleType.red:
            score = 1
        case BubbleType.yellow:
            score = 2
        case BubbleType.green:
            score = 5
        case BubbleType.blue:
            score = 8
        case BubbleType.black:
            score = 10
        case .undefined:
            score = 0
        }
        
        return score
    }
    
    func bubbleAppearsAnimation() {
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.7, animations: {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }){ (finished) in
            UIView.animate(withDuration: 0.5, animations: {
                self.transform = CGAffineTransform.identity
            })
        }
    }
    
    func bubbleDisappearAnimation()
    {
        UIView.animate(withDuration: 0.7, animations: {
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }){ (finished) in
            self.removeFromSuperview()
        }
    }
    
    func bubbleExplodeAnimation()
    {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }){ (finished) in
            self.image = UIImage(named: "explosion.png")
            UIView.animate(withDuration: 0.3, animations: {
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }){ (finished) in
                UIView.animate(withDuration: 0.4, animations: {
                    self.alpha = 0.0
                }){ (finished) in
                    self.removeFromSuperview()
                }
            }
        }
    }
    
    func moveBubble()
    {
        
    }
}

enum BubbleType {
    case red
    case green
    case blue
    case black
    case yellow
    case undefined
}
