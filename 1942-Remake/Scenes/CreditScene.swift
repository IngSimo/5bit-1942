//
//  MenuScene.swift
//  SKW
//
//  Copyright © 2018 5-bit. All rights reserved.
//

import SpriteKit

class CreditScene: SKScene {

    var logoImage: SKSpriteNode = SKSpriteNode()

    var deltaTime: Double = 0
    var lastTime: Double = 0
    var logoIncrement: Float = 5
    var logoRotation: CGFloat = CGFloat.pi*2

    // Initial Scene
    // FIXME: Customize this scene!
    override func didMove(to view: SKView) {
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
        teamLabel.name = "team"
        teamLabel.fontSize = 25
        teamLabel.fontColor = .white
        teamLabel.text = "5-bit team:"
        teamLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.5)
        addChild(teamLabel)

        let namesLabel = SKLabelNode(fontNamed: "Atari-Font-Full-Version")
        namesLabel.name = "names"
        namesLabel.fontSize = 18
        namesLabel.fontColor = .white
        namesLabel.numberOfLines = 5
        namesLabel.verticalAlignmentMode = .center
        namesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        namesLabel.text = "Walter Purcaro\n\nSimone Penna\n\nLuigi De Marco\n\nDaniele Franzutti\n\nMirko Pennone"
        namesLabel.position = CGPoint(x: size.width / 2, y: size.height / 2.3)
        addChild(namesLabel)

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
}
