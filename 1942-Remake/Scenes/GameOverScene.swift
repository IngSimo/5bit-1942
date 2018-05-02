//
//  GameOverScene.swift
//  1942-Remake
//
//  Created by Simone Penna on 14/03/2018.
//  Copyright © 2018 5-bit. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene, GameKitDelegate {

    func modelUpdated(update: String) {

        if (update=="loadScores") {

            if ( (UserDefaults.standard.integer(forKey: "rank")==0) || (GameKitController.shared().localPlayer.alias == nil) ) {
                // if user still has no rank in the leaderboard or doesnt log in gamecenter, only show score
                highScoreLabel.text = "\(String(UserDefaults.standard.integer(forKey: "highscore")))"
                newRecordLabel.text = "\(String(UserDefaults.standard.integer(forKey: "highscore")))"
            } else {
                highScoreLabel.text = "\(String(UserDefaults.standard.integer(forKey: "rank"))). \(GameKitController.shared().localPlayer.alias ?? "You"): \(String(UserDefaults.standard.integer(forKey: "highscore")))"
                newRecordLabel.text = "\(String(UserDefaults.standard.integer(forKey: "rank"))). \(GameKitController.shared().localPlayer.alias ?? "You"): \(String(UserDefaults.standard.integer(forKey: "highscore")))"
            }

        } else if (update=="saveScore") {

            // reload scores and update rank and leaderboard
            GameKitController.shared().loadScores()

        }
    }

    func errorUpdating() {

    }

    let restartLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
    let mainMenu = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
    var highScoreLabel = SKLabelNode()
    var highScoreTextLabel = SKLabelNode()
    var newRecordLabel = SKLabelNode()
    var newRecordTextLabel = SKLabelNode()

    override func didMove(to view: SKView) {

        GameKitController.shared().delegates.append(self)

        // start music
        let dictToSend: [String: String] = ["fileToPlay": "Menu" ]  //would play a file named "MusicOrWhatever.mp3"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "PlayBackgroundSound"), object: self, userInfo: dictToSend) //posts the notification

        let background = SKSpriteNode()
        background.color = .black
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = 0
        background.size = UIScreen.main.bounds.size
        self.addChild(background)

        let gameOverLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 40
        gameOverLabel.fontColor = SKColor.white
        gameOverLabel.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.77)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)

        if(UserDefaults.standard.integer(forKey: "highscore")<GameManager.shared.score) {

            let newRecordTextLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
            newRecordTextLabel.text = "NEW RECORD!"
            newRecordTextLabel.fontSize = 18
            newRecordTextLabel.fontColor = SKColor.white
            newRecordTextLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.53)
            newRecordTextLabel.zPosition = 1
            self.addChild(newRecordTextLabel)

            newRecordLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
            newRecordLabel.text = "\(GameManager.shared.score)"
            newRecordLabel.fontSize = 18
            newRecordLabel.fontColor = SKColor.yellow
            newRecordLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.48)
            newRecordLabel.zPosition = 1
            self.addChild(newRecordLabel)

        } else {

            let scoreTextLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
            scoreTextLabel.text = "Score:"
            scoreTextLabel.fontSize = 18
            scoreTextLabel.fontColor = SKColor.white
            scoreTextLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.59)
            scoreTextLabel.zPosition = 1
            self.addChild(scoreTextLabel)

            let scoreLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
            scoreLabel.text = "\(GameManager.shared.score)"
            scoreLabel.fontSize = 18
            scoreLabel.fontColor = SKColor.yellow
            scoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.54)
            scoreLabel.zPosition = 1
            self.addChild(scoreLabel)

            let highScoreTextLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
            highScoreTextLabel.text = "High Score:"
            highScoreTextLabel.fontSize = 18
            highScoreTextLabel.fontColor = SKColor.white
            highScoreTextLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.47)
            highScoreTextLabel.zPosition = 1
            self.addChild(highScoreTextLabel)

            highScoreLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
            highScoreLabel.text = "\(String(UserDefaults.standard.integer(forKey: "highscore")))"
            highScoreLabel.fontSize = 18
            highScoreLabel.fontColor = SKColor.yellow
            highScoreLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.42)
            highScoreLabel.zPosition = 1
            self.addChild(highScoreLabel)
        }

        restartLabel.text = "Restart"
        restartLabel.fontSize = 25
        restartLabel.fontColor = SKColor.white
        restartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height*0.25)
        restartLabel.zPosition = 1
        self.addChild(restartLabel)

        mainMenu.text = "Main Menu"
        mainMenu.fontSize = 25
        mainMenu.fontColor = SKColor.white
        mainMenu.position = CGPoint(x: self.size.width/2, y: self.size.height*0.17)
        mainMenu.zPosition = 1
        self.addChild(mainMenu)

        GameKitController.shared().saveScore(newScore: GameManager.shared.score)

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        for touch: AnyObject in touches {

            let pointOfTouch = touch.location(in: self)

            if restartLabel.contains(pointOfTouch) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "StopBackgroundSound"), object: self)
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(sceneToMoveTo, transition: myTransition)
            }

            if mainMenu.contains(pointOfTouch) {
                let sceneToMoveTo = MenuScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view?.presentScene(sceneToMoveTo, transition: myTransition)
            }

        }
    }
}
