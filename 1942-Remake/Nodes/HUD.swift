//
//  HUD.swift
//  1942-Remake
//
//  Created by Simone Penna on 08/03/2018.
//  Copyright © 2018 5-bit. All rights reserved.
//

import SpriteKit

class HUD: SKNode {

    let scoreLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
    let posLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
    let lifeLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
    let lifeImage = SKSpriteNode(imageNamed: "life")
    let levelLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")

    var score: Int {
        get {
            return GameManager.shared.score
        }
        set {
            GameManager.shared.score += newValue

            scoreLabel.attributedText = NSMutableAttributedString(string: "Score: \(GameManager.shared.score)", attributes: [
                NSAttributedStringKey.strokeWidth: -3,
                NSAttributedStringKey.strokeColor: UIColor.black,
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.font: UIFont.init(name: "Atari-Font-Full-Version", size: 21)!
                ])

        }
    }

    var life: Int {
        get {
            return GameManager.shared.livesLeft
        }
        set {
            GameManager.shared.livesLeft -= newValue
            lifeLabel.text = "x0\(GameManager.shared.livesLeft)"
        }
    }

    override init() {
        super.init()
        self.name = "HUD"

        scoreLabel.attributedText = NSMutableAttributedString(string: "Score: 0", attributes: [
                NSAttributedStringKey.strokeWidth: -3,
                NSAttributedStringKey.strokeColor: UIColor.black,
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.font: UIFont.init(name: "Atari-Font-Full-Version", size: 21)!
                ])
        scoreLabel.zPosition = Z.HUD

        lifeLabel.attributedText = NSMutableAttributedString(string: "x0\(GameManager.shared.livesLeft)", attributes: [
            NSAttributedStringKey.strokeWidth: -3,
            NSAttributedStringKey.strokeColor: UIColor.black,
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.init(name: "Atari-Font-Full-Version", size: 21)!
        ])
        lifeLabel.zPosition = Z.HUD

        lifeImage.name = "livesLeft"
        lifeImage.anchorPoint = CGPoint.zero
        lifeImage.zPosition = Z.HUD

        levelLabel.attributedText = NSMutableAttributedString(string: "\(giveAge(ageLevel: GameManager.shared.levelAge))", attributes: [
            NSAttributedStringKey.strokeWidth: -3,
            NSAttributedStringKey.strokeColor: UIColor.black,
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.init(name: "Atari-Font-Full-Version", size: 21)!
            ])
        levelLabel.zPosition = Z.HUD

//        posLabel.text = "posLabel"
        posLabel.numberOfLines = 0
        posLabel.fontSize = 15
        posLabel.zPosition = Z.HUD
    }

    func setup(size: CGSize) {
        let spacing: CGFloat = 10
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: spacing, y: size.height - scoreLabel.frame.height - spacing)
        scoreLabel.position = CGPoint(x: size.width * 0.02, y: size.height * 0.96)
        scoreLabel.attributedText = NSMutableAttributedString(string: "Score: 0", attributes: [
            NSAttributedStringKey.strokeWidth: -3,
            NSAttributedStringKey.strokeColor: UIColor.black,
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.init(name: "Atari-Font-Full-Version", size: 21)!
            ])
        addChild(scoreLabel)

        lifeLabel.horizontalAlignmentMode = .right
        lifeLabel.position = CGPoint(x: size.width - spacing, y: size.height - lifeLabel.frame.height - spacing)
        lifeLabel.position = CGPoint(x: size.width * 0.98, y: size.height * 0.96)
        lifeLabel.attributedText = NSMutableAttributedString(string: "x0\(GameManager.shared.livesLeft)", attributes: [
            NSAttributedStringKey.strokeWidth: -3,
            NSAttributedStringKey.strokeColor: UIColor.black,
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.init(name: "Atari-Font-Full-Version", size: 21)!
            ])
        addChild(lifeLabel)

        levelLabel.horizontalAlignmentMode = .center
        levelLabel.position = CGPoint(x: size.width - spacing, y: size.height - lifeLabel.frame.height - spacing)
        levelLabel.position = CGPoint(x: size.width/2, y: size.height * 0.8)
        levelLabel.attributedText = NSMutableAttributedString(string: "\(giveAge(ageLevel: GameManager.shared.levelAge))", attributes: [
            NSAttributedStringKey.strokeWidth: -3,
            NSAttributedStringKey.strokeColor: UIColor.black,
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.init(name: "Atari-Font-Full-Version", size: 40)!
            ])
        levelLabel.alpha = 0
        addChild(levelLabel)

//        lifeImage.position = CGPoint(x: 292, y: 632)
        lifeImage.position = CGPoint(x: size.width * 0.78, y: size.height * 0.95)
        lifeImage.zPosition = 1
        lifeImage.size = SpriteSize.heart
        addChild(lifeImage)

                posLabel.horizontalAlignmentMode = .center
                posLabel.position = CGPoint(x: size.width/2, y: size.height/2)
                addChild(posLabel)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func giveAge(ageLevel: Int) -> String {
        var age = ""
        if ageLevel == 1 {
            age = "1916"
        } else if ageLevel == 2 {
            age = "1942"
        } else if ageLevel == 3 {
            age = "2019"
        } else if ageLevel == 4 {
            age = "2054"
        }

        return age

    }

    func showAge() {
        let fadeActionShow = SKAction.fadeAlpha(to: 1, duration: 2.0)
        let fadeActionHide = SKAction.fadeAlpha(to: 0, duration: 2.0)
        let sequenceLevelLabel = SKAction.sequence([fadeActionShow, fadeActionHide])
        levelLabel.attributedText = NSMutableAttributedString(string: "\(giveAge(ageLevel: GameManager.shared.levelAge))", attributes: [
            NSAttributedStringKey.strokeWidth: -3,
            NSAttributedStringKey.strokeColor: UIColor.black,
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.init(name: "Atari-Font-Full-Version", size: 40)!
            ])
        levelLabel.run(sequenceLevelLabel)
    }
}
