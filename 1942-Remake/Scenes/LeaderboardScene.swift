//
//  MenuScene.swift
//  SKW
//
//  Copyright © 2018 5-bit. All rights reserved.
//

import SpriteKit

class LeaderboardScene: SKScene, GameKitDelegate {

    func modelUpdated(update: String) {
        if (update=="loadScores") {
            for score in GameKitController.shared().scores {

                highscores[score.rank] = ((score.player?.alias!)!, Int(score.value))

            }
            updateScores()
        }
    }

    func errorUpdating() {

        secondScoreLabel.text = "Can't load scores."

    }

    var logoImage: SKSpriteNode = SKSpriteNode()
    var firstScoreLabel: SKLabelNode = SKLabelNode()
    var secondScoreLabel: SKLabelNode = SKLabelNode()
    var thirdScoreLabel: SKLabelNode = SKLabelNode()
    var yourScoreLabel: SKLabelNode = SKLabelNode()
    var userScoreLabel: SKLabelNode = SKLabelNode()

    var deltaTime: Double = 0
    var lastTime: Double = 0
    var logoIncrement: Float = 5
    var logoRotation: CGFloat = CGFloat.pi*2

    // scores

    var highscores: [Int: (String, Int)] = [:]
    var personalScore: Int = 0

    // Initial Scene
    override func didMove(to view: SKView) {

        GameKitController.shared().delegates.append(self)

        GameKitController.shared().loadScores()

        backgroundColor = .black

        logoImage = SKSpriteNode(imageNamed: "logo")
        logoImage.name = "logo"
        logoImage.position = CGPoint(x: size.width / 2, y: size.height / 1.2)
        logoImage.scale(to: CGSize(width: size.width*3/4, height: (size.width*3/4)*logoImage.size.height/logoImage.size.width ))
        logoImage.zPosition = Z.HUD
        addChild(logoImage)

        //        let gameLabel = SKLabelNode(fontNamed: "Courier")
        //        gameLabel.fontSize = 40
        //        gameLabel.fontColor = .white
        //        gameLabel.text = "1942"
        //        gameLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.2)
        //        addChild(gameLabel)

        //        let highscore = GameManager.shared.statistic?.point
        //        let highscoreLabel = SKLabelNode(fontNamed: "Courier")
        //        highscoreLabel.fontSize = 30
        //        highscoreLabel.fontColor = .black
        //        highscoreLabel.text = "Highscore: \(highscore!)"
        //        highscoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        //        addChild(highscoreLabel)
        //
        //        let monstersKilled = GameManager.shared.statistic?.monstersKills
        //        let monstersLabel = SKLabelNode(fontNamed: "Courier")
        //        monstersLabel.fontSize = 30
        //        monstersLabel.fontColor = .black
        //        monstersLabel.text = "Monsters killed: \(monstersKilled!)"
        //        monstersLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.5)
        //        addChild(monstersLabel)

        //        let buttonStart = SKSpriteNode(imageNamed: "buttonStart-normal")
        //        buttonStart.name = "buttonStart"
        //        buttonStart.position = CGPoint(x: size.width / 2, y: size.height / 2.8)
        //        buttonStart.size = SpriteSize.heart
        //        buttonStart.zPosition = Z.HUD
        //        addChild(buttonStart)

        //        for family: String in UIFont.familyNames
        //        {
        //            print("\(family)")
        //            for names: String in UIFont.fontNames(forFamilyName: family)
        //            {
        //                print("== \(names)")
        //            }
        //        }

        let teamLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
        teamLabel.name = "highscores"
        teamLabel.fontSize = 25
        teamLabel.fontColor = .white
        teamLabel.text = "HIGH SCORES"
        teamLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.5)
        addChild(teamLabel)

        firstScoreLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
        firstScoreLabel.name = "firstScoreLabel"
        firstScoreLabel.fontSize = 16
        firstScoreLabel.fontColor = .white
        firstScoreLabel.numberOfLines = 1
        firstScoreLabel.verticalAlignmentMode = .center
        firstScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        firstScoreLabel.text = ""
        firstScoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.8)
        addChild(firstScoreLabel)

        secondScoreLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
        secondScoreLabel.name = "secondScoreLabel"
        secondScoreLabel.fontSize = 16
        secondScoreLabel.fontColor = .white
        secondScoreLabel.numberOfLines = 1
        secondScoreLabel.verticalAlignmentMode = .center
        secondScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        secondScoreLabel.text = "Loading scores..."
        secondScoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(secondScoreLabel)

        thirdScoreLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
        thirdScoreLabel.name = "thirdScoreLabel"
        thirdScoreLabel.fontSize = 16
        thirdScoreLabel.fontColor = .white
        firstScoreLabel.preferredMaxLayoutWidth = size.width
        thirdScoreLabel.numberOfLines = 1
        thirdScoreLabel.verticalAlignmentMode = .center
        thirdScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        thirdScoreLabel.text = ""
        thirdScoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2.25)
        addChild(thirdScoreLabel)

        yourScoreLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
        yourScoreLabel.name = "yourScore"
        yourScoreLabel.fontSize = 18
        yourScoreLabel.fontColor = .white
        yourScoreLabel.numberOfLines = 1
        yourScoreLabel.verticalAlignmentMode = .center
        yourScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        yourScoreLabel.text = "Your highscore:"
        yourScoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 3.3)
        addChild(yourScoreLabel)

        userScoreLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
        userScoreLabel.name = "userScore"
        userScoreLabel.fontSize = 18
        userScoreLabel.fontColor = .white
        userScoreLabel.numberOfLines = 1
        userScoreLabel.verticalAlignmentMode = .center
        userScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        userScoreLabel.fontColor = UIColor.yellow
        setScoreLabel()
        userScoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 4)
        addChild(userScoreLabel)

        let backLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
        backLabel.name = "back"
        backLabel.fontSize = 20
        backLabel.fontColor = .white
        backLabel.text = "Back"
        backLabel.position = CGPoint(x: size.width / 2, y: size.height / 8)
        addChild(backLabel)

        //        let copyrightLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
        //        copyrightLabel.name = "copyright"
        //        copyrightLabel.fontSize = 16
        //        copyrightLabel.fontColor = .white
        //        copyrightLabel.text = "(c) 2018 5-BIT"
        //        copyrightLabel.position = CGPoint(x: size.width / 2, y: size.height / 8)
        //        addChild(copyrightLabel)

        //        let perna = SKSpriteNode(imageNamed: "perna")
        //        perna.position = CGPoint(x: size.width / 2, y: size.height / 6)
        //        perna.setScale(1.5)
        //        perna.texture?.filteringMode = .nearest
        //        perna.zPosition = Z.sprites
        //        addChild(perna)

        // Reset Local Stats before Game Start
        //        GameManager.shared.resetLocalStats()
    }

    // Single Touch Down
    func touchDown(atPoint pos: CGPoint) {

        // Button Change State
        let touchedNode = self.atPoint(pos)
        if touchedNode.name == "start" {
            //            let button = touchedNode as! SKSpriteNode
            //            button.texture = SKTexture(imageNamed: "buttonStart-pressed")
        }
    }

    // Single Touch Up
    func touchUp(atPoint pos: CGPoint) {
        //
        //        // Return button to normal state
        //        if let button = childNode(withName: "buttonStart") as? SKSpriteNode {
        //            button.texture = SKTexture(imageNamed: "buttonStart-normal")
        //        }

        // Button Action to Start Game
        let touchedNode = self.atPoint(pos)
        if touchedNode.name == "back" {
            //            self.run(SKAction.playSoundFileNamed("good.m4a", waitForCompletion: false))
            let scene = MenuScene(size: size)
            scene.scaleMode = scaleMode
            let transitionType = SKTransition.flipVertical(withDuration: 0.5)
            view?.presentScene(scene, transition: transitionType)
        } else if (touchedNode.name == "logo") {

            let action = SKAction.rotate(byAngle: logoRotation, duration: 0.5)
            logoImage.run(action)
            logoRotation = -logoRotation
        }
    }

    // Multiple Touches Began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.touchDown(atPoint: touch.location(in: self))
    }

    // Multiple Touches Ended
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.touchUp(atPoint: touch.location(in: self))
    }

    override func update(_ currentTime: TimeInterval) {

        deltaTime = currentTime - lastTime

        if(deltaTime>0.79) {
            //            print("deltaTime: \(deltaTime), currentTime: \(currentTime), lastTime: \(lastTime)")

            logoImage.position = CGPoint(x: logoImage.position.x, y: logoImage.position.y + CGFloat(logoIncrement))

            deltaTime = 0
            lastTime = currentTime
            logoIncrement = -logoIncrement
        }

    }

    func updateScores() {

        if let _ = highscores[1] {

            firstScoreLabel.text = "1. \(String(highscores[1]!.0.prefix(12))): \(highscores[1]!.1)"
            if(highscores[1]!.0 == GameKitController.shared().localPlayer.alias) {
                firstScoreLabel.fontColor = UIColor.yellow
            }

        }

        if let _ = highscores[2] {

            secondScoreLabel.text = "2. \(String(highscores[2]!.0.prefix(12))): \(highscores[2]!.1)"
            if(highscores[2]!.0 == GameKitController.shared().localPlayer.alias) {
                secondScoreLabel.fontColor = UIColor.yellow
            }

        }

        if let _ = highscores[3] {

            thirdScoreLabel.text = "3. \(String(highscores[3]!.0.prefix(12))): \(highscores[3]!.1)"
            if(highscores[3]!.0 == GameKitController.shared().localPlayer.alias) {
                thirdScoreLabel.fontColor = UIColor.yellow
            }
        }

        if ((secondScoreLabel.text?.isEmpty)! && (firstScoreLabel.text?.isEmpty)! && (thirdScoreLabel.text?.isEmpty)!) {
            secondScoreLabel.text = "No scores found."
        }

        setScoreLabel()

    }

    func setScoreLabel() {

        // update personal score

        if ( (UserDefaults.standard.integer(forKey: "rank")==0) || (GameKitController.shared().localPlayer.alias == nil) ) {
            // if user still has no rank in the leaderboard or doesnt log in gamecenter, only show score
            userScoreLabel.text = "\(String(UserDefaults.standard.integer(forKey: "highscore")))"
        } else {
            userScoreLabel.text = "\(String(UserDefaults.standard.integer(forKey: "rank"))). \(GameKitController.shared().localPlayer.alias ?? "You"): \(String(UserDefaults.standard.integer(forKey: "highscore")))"
        }

    }
}
