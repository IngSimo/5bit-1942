//
//  GameScene.swift
//  1942-Remake
//
//  Created by Simone Penna on 08/03/2018.
//  Copyright © 2018 5-bit. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    //    var lastUpdateTime: TimeInterval = 0

    // Textures
    var textureIdle: [SKTexture] = []

    //Actors
    var player = Player(age: "WWI")
    var hud = HUD()
    var enemy = Enemy(type: .Bomber, age: "WWI")
    var enemies: [Enemy] = []
    var playerFiring = false
    
    var isPoweredUp = false

    // touchMovedDistanceThreshold
    let touchMovedDistanceThreshold: CGFloat = 22

    //Backgrounds
    var midBackground = Background()
    var background = Background(imageNamed: "background_sea")
    var background2 = Background(imageNamed: "background_sea")
    var changedMidBackground = false
    var changedFirstBackground = false
    var changedSecondBackground = false
    var backgroundLevel: Int = 1

    let gameArea = UIScreen.main.bounds
    let explosionSound = SoundManager.shared.explosion

    //to increase velocity
    var levelNumber = 0

    //gameover
    enum gameState {
        case inGame
        case afterGame
    }

    //planets
    var planets = Planets()

    //level started
    var firstStarted = false
    var secondStarted = false
    var thirdStarted = false
    var fourthStarted = false

    var currentGameState = gameState.inGame

    // Weather Generator
    var cloudSpawing = true
    var lastCloudSpawingTime: TimeInterval = 0

    func updateClouds(_ currentTime: TimeInterval) {
        let cloudSpawingDeltaThreshold = Double.random(min: 0.1, max: 2.0)
        if cloudSpawing && currentTime - lastCloudSpawingTime > cloudSpawingDeltaThreshold {
            spawnCloud()
            lastCloudSpawingTime = currentTime
        }
    }

    func spawnCloud() {

        let scale = CGFloat.random(min: 0.5, max: 1.5)
        let plusmove = 50 + scale * 30

        let randomXStart = CGFloat.random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = CGFloat.random(min: randomXStart - plusmove, max: randomXStart + plusmove)

        let startPoint = CGPoint(x: randomXStart, y: self.size.height + 200)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.1)

        let cloudImageNames = ["Cloud_0", "Cloud_1", "Cloud_2"]
        let randomIndex = Int(arc4random_uniform(UInt32(cloudImageNames.count)))
        let imageName = cloudImageNames[randomIndex]

        let cloud = Cloud(imageName: imageName)

        cloud.setScale(scale)
        cloud.position = startPoint

        self.addChild(cloud)

        let moveCloud = SKAction.move(to: endPoint, duration: TimeInterval(6 / scale))
        moveCloud.timingMode = .easeIn

        let deleteCloud = SKAction.removeFromParent()

        let cloudSequence = SKAction.sequence([moveCloud, deleteCloud])

        if currentGameState == gameState.inGame {
            cloud.run(cloudSequence)
        }
    }

        //Cloud
//        cloud0.setup(view: self.view!)
//        cloud0.moveTo(destination: CGPoint(x: cloud0.position.x , y: (100 + size.height)))
//        addChild(cloud0)
//
//        cloud1.setup(view: self.view!)
//        cloud1.moveTo(destination: CGPoint(x: cloud1.position.x , y: ((size.height * 2) + cloud0.size.height)))
//        self.addChild(cloud1)
//        cloud2.setup(view: self.view!)
//        cloud2.moveTo(destination: CGPoint(x: cloud2.position.x , y: ((size.height * 2) + cloud0.size.height)))
//        self.addChild(cloud2)
//
//
//        if GameManager.shared.levelAge < 4 || (((cloud0.position.y > (1 - SpriteSize.cloud0.height)) && (cloud1.position.y > (1 - SpriteSize.cloud1.height))) && (cloud2.position.y > (1 - SpriteSize.cloud2.height ))){
//
//            cloud0.moveTo(destination: CGPoint(x: cloud0.position.x, y: cloud0.position.y - 1.5))
//            cloud1.moveTo(destination: CGPoint(x: cloud1.position.x, y: cloud1.position.y - 1.5))
//            cloud2.moveTo(destination: CGPoint(x: cloud2.position.x, y: cloud2.position.y - 1.5))
//            if(cloud0.position.y < (0 - SpriteSize.cloud0.height))
//            {
//                cloud0.moveTo(destination: CGPoint(x: cloud0.generateRandomWidthNumber(), y: (UIScreen.main.bounds.height) +  cloud0.generateRandomHeightNumber() ))
//            }
//
//            if (cloud1.position.y < (0 - SpriteSize.cloud1.height)) {
//                cloud1.moveTo(destination: CGPoint(x: cloud0.generateRandomWidthNumber(), y: (UIScreen.main.bounds.height) +  cloud0.generateRandomHeightNumber()))
//            }
//            if (cloud2.position.y < (0 - SpriteSize.cloud2.height)) {
//                cloud2.moveTo(destination: CGPoint(x: cloud0.generateRandomWidthNumber(), y: (UIScreen.main.bounds.height) +  cloud0.generateRandomHeightNumber()))
//            }
//        }
//        else if (cloud0.position.y < (0 - SpriteSize.cloud0.height)) {
//            cloud0.removeFromParent()
//        }
//        else if (cloud1.position.y < (0 - SpriteSize.cloud1.height)) {
//            cloud1.removeFromParent()
//        }
//        else if (cloud2.position.y < (0 - SpriteSize.cloud2.height)) {
//            cloud2.removeFromParent()
//        }
//    }

    override func didMove(to view: SKView) {

        // start music
        let dictToSend: [String: String] = ["fileToPlay": "GameMusic" ]  //would play a file named "MusicOrWhatever.mp3"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "PlayBackgroundSound"), object: self, userInfo: dictToSend) //posts the notification

        self.physicsWorld.contactDelegate = self

        GameManager.shared.reset()

        // Background
        //        background.setup(view: self.view!)
        background.moveTo(destination: CGPoint(x: size.width / 2, y: size.height / 2))
        addChild(background)

        //        background2.setup(view: self.view!)
        background2.moveTo(destination: CGPoint(x: size.width / 2, y: ((size.height/2) + background.size.height)))
        self.addChild(background2)

        //Player
        player.setup(view: self.view!)
        addChild(player)
        player.animate()

        //HUD
        hud.setup(size: size)
        addChild(hud)

        //planets
        planets.setup(view: self.view!)
        planets.moveTo(destination: CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height + 200 ))
        addChild(planets)
        //schedula nemici ogni secondo
        //        scheduleEnemy()

    }

    func touchDown(atPoint pos: CGPoint) {
        if currentGameState != gameState.inGame { return }

        let destination = CGPoint(x: pos.x, y: pos.y + 50)

        let move = SKAction.move(to: destination, duration: 0.5)
        move.timingMode = .easeOut

        let animation = SKAction.sequence([move])
        player.run(animation)

        playerFiring = true

        //        if player.position.distanceToPoint(pos) > touchMovedDistanceThreshold {
        //            player.moveTo(destination: destination)
        //        } else {
        //            player.fire()
        //        }
    }

    func touchMoved(toPoint pos: CGPoint) {
        if currentGameState != gameState.inGame { return }

        let destination = CGPoint(x: pos.x, y: pos.y + 50)

        let move = SKAction.move(to: destination, duration: 0.05)
        move.timingMode = .easeIn

        let animation = SKAction.sequence([move])
        player.run(animation)

        //player.position = destination

        playerFiring = true

        //        if player.position.distanceToPoint(destination) > touchMovedDistanceThreshold {
        //            player.moveTo(destination: destination)
        //            player.fire()
        //        }
    }

    func touchUp(atPoint pos: CGPoint) {
        playerFiring = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.touchDown(atPoint: touch.location(in: self))
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.touchMoved(toPoint: touch.location(in: self))

        //TUTORIAL
        //        for touch: AnyObject in touches {
        //            let pointOfTouch = touch.location(in: self)
        //            let previousPointOfTouch = touch.previousLocation(in: self)
        //
        //            let amountDraggedX = pointOfTouch.x - previousPointOfTouch.x
        //            let amountDraggedY = pointOfTouch.y - previousPointOfTouch.y
        //
        //            if currentGameState == gameState.inGame {
        //                player.position.x += amountDraggedX
        //                player.position.y += amountDraggedY
        //            }
        //
        //            if player.position.x > gameArea.maxX - player.size.width/2 {
        //                player.position.x = gameArea.maxX - player.size.width/2
        //            }
        //
        //            if player.position.x < gameArea.minX + player.size.width/2 {
        //                player.position.x = gameArea.minX + player.size.width/2
        //            }
        //
        //            if player.position.y > gameArea.maxY - player.size.height/2 {
        //                player.position.y = gameArea.maxY - player.size.height/2
        //            }
        //
        //            if player.position.y < gameArea.minY + player.size.height/2 {
        //                player.position.y = gameArea.minY + player.size.height/2
        //            }
        //        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        self.touchUp(atPoint: touch.location(in: self))
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    var lastFiringTime: TimeInterval = 0
    var lastEnemyFiringTime: TimeInterval = 0

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

        if currentGameState != gameState.inGame { return }

        if(GameManager.shared.levelAge != backgroundLevel) {

            // level has changed, change background

            if (!intersects(background) && !changedFirstBackground) {

                print("Changing background (\(GameManager.shared.levelAge))")

                chooseBackground(background: background, level: GameManager.shared.levelAge)

                changedFirstBackground = true

            }

            if (!intersects(background2) && !changedSecondBackground) {

                print("Changing background 2 (\(GameManager.shared.levelAge))")

                chooseBackground(background: background2, level: GameManager.shared.levelAge)

                changedSecondBackground = true

            }

            if (changedFirstBackground && changedSecondBackground) {
                if(!intersects(midBackground)) {
                    backgroundLevel = GameManager.shared.levelAge
                    chooseBackground(background: background, level: backgroundLevel)
                    chooseBackground(background: background2, level: backgroundLevel)
                    changedFirstBackground = false
                    changedSecondBackground = false
                    changedMidBackground = false
                }
            }
            //
        }

        //        if GameManager.shared.levelAge == 1 {
        //            background = Background(imageNamed: "background_sea")
        //        }

        // scroll background
        background.moveTo(destination: CGPoint(x: background.position.x, y: background.position.y - 2))
        background2.moveTo(destination: CGPoint(x: background2.position.x, y: background2.position.y - 2))

        if(background.position.y <= -background2.position.y) {
            if (background.position.y<=0) {
                background.moveTo(destination: CGPoint(x: background.position.x, y: ((background2.size.height/2) + background.size.height)) )
            } else if (background2.position.y<0) {
                background2.moveTo(destination: CGPoint(x: background2.position.x, y: ((background.size.height/2) + background2.size.height)) )
            }
        }

        if playerFiring && currentTime - lastFiringTime > 0.2 {
            if (isPoweredUp){
                player.fireSuper()
            } else {
                player.fire()
            }
            lastFiringTime = currentTime
        }

        if (currentTime - lastEnemyFiringTime > 1) {
            for enemy in enemies {
                enemy.fire()
                lastEnemyFiringTime = currentTime
            }
        }

        //        if(background2.position.y < -background.position.y)
        //        {
        //            print("hey2")
        //            background2.position = CGPoint(x: background2.position.x, y: ((size.height/2) + background2.size.height))
        //
        //        }
        //        print("background1: \(background.position)\nbackground2: \(background2.position)")
        //        hud.posLabel.text = "background1: \(background.position)\nbackground2: \(background2.position)"

        updateClouds(currentTime)

//        if GameManager.shared.levelAge == 4{
//            planets.moveTo(destination: CGPoint(x: planets.position.x, y: planets.position.y - 2.5))
//
//            if(planets.position.y < (0 - SpriteSize.planets.height))
//            {
//                planets.moveTo(destination: CGPoint(x: cloud0.generateRandomWidthNumber(), y: (UIScreen.main.bounds.height) +  cloud0.generateRandomHeightNumber() ))
//            }
//        }

        if GameManager.shared.levelAge == 1 {
            if firstStarted == false {
                hud.showAge()
                firstStarted = true
                let waitToSpawn = SKAction.wait(forDuration: 3)
                let schedule = SKAction.run {
                    self.scheduleEnemy()
                }
                let animation = SKAction.sequence([waitToSpawn, schedule])
                self.run(animation)
            }
        } else if GameManager.shared.levelAge == 2 {
            if secondStarted == false {
                hud.showAge()
                secondStarted = true
                let waitToSpawn = SKAction.wait(forDuration: 5)
                let schedule = SKAction.run {
                    self.scheduleEnemy()
                }
                let changePlayer = SKAction.run {
                    self.player.removeFromParent()

                    self.player = Player(age: "WWII")
                    self.addChild(self.player)
                    self.player.animate()

                }

                let animation = SKAction.sequence([waitToSpawn, schedule])
                let finalAnimation = SKAction.group([animation, changePlayer])
                self.run(finalAnimation)
            }
        } else if GameManager.shared.levelAge == 3 {
            if thirdStarted == false {
                hud.showAge()
                thirdStarted = true
                let waitToSpawn = SKAction.wait(forDuration: 5)
                let schedule = SKAction.run {
                    self.scheduleEnemy()
                }
                let changePlayer = SKAction.run {

                    self.player.removeFromParent()
                    self.player = Player(age: "Moderno")
                    self.addChild(self.player)
                    self.player.animate()
                }

                let animation = SKAction.sequence([waitToSpawn, schedule])
                let finalAnimation = SKAction.group([animation, changePlayer])
                self.run(finalAnimation)
            }
        } else if GameManager.shared.levelAge == 4 {
            if fourthStarted == false {
                hud.showAge()
                fourthStarted = true
                let waitToSpawn = SKAction.wait(forDuration: 5)
                let schedule = SKAction.run {
                    self.scheduleEnemy()
                }
                let changePlayer = SKAction.run {
                    self.player.removeFromParent()

                    self.player = Player(age: "Futuro")
                    self.addChild(self.player)
                    self.player.animate()
                }

                let animation = SKAction.sequence([waitToSpawn, schedule])
                let finalAnimation = SKAction.group([animation, changePlayer])
                self.run(finalAnimation)
            }
        }

    }

    func chooseBackground(background: Background, level: Int) {

        if(!changedMidBackground) {
            midBackground = background
        }

        switch(level) {

        case 1:
            
            background.texture = SKTexture(imageNamed: "background_sea")
            
        case 2:
            if(!changedMidBackground) {
                background.texture = SKTexture(imageNamed: "background_sea-desert")
                changedMidBackground = true
            } else {
                background.texture = SKTexture(imageNamed: "background_desert")
            }
        case 3:
            if(!changedMidBackground) {
                background.texture = SKTexture(imageNamed: "background_desert-snow")
                changedMidBackground = true
            } else {
                background.texture = SKTexture(imageNamed: "background_snow")
            }
        case 4:
            if(!changedMidBackground) {
                background.texture = SKTexture(imageNamed: "background_snow-space")
                changedMidBackground = true
            } else {
                background.texture = SKTexture(imageNamed: "background_space")
            }
        default:
            background.texture = SKTexture(imageNamed: "background_sea")
        }

    }

    //TUTORIAL
    func spawnEnemy() {

        let randomXStart = CGFloat.random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = CGFloat.random(min: gameArea.minX, max: gameArea.maxX)

        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)

        var typeEnemy = randomEnemy()
        var ageLevel = giveAge(ageLevel: GameManager.shared.levelAge)

        let enemy = Enemy(type: typeEnemy, age: ageLevel)
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(texture: enemy.texture!, size: CGSize(width: (enemy.texture?.size().width)!*2, height: (enemy.texture?.size().height)!*2))
        enemy.physicsBody?.affectedByGravity = false
        enemy.physicsBody?.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody?.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody?.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        enemy.animate()
        self.addChild(enemy)
        enemies.append(enemy)

        let moveEnemy = SKAction.move(to: endPoint, duration: 5)
        let deleteEnemy = SKAction.removeFromParent()
        //        let loseALifeAction = SKAction.run(loseALife)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])

        if currentGameState == gameState.inGame {
            enemy.run(enemySequence)
        }

    }

    func scheduleEnemy() {

        levelNumber += 1
        if self.action(forKey: "spawningEnemies") != nil {
            self.removeAction(forKey: "spawningEnemies")
        }

        var levelDuration = TimeInterval()

        switch levelNumber {
        case 1: levelDuration = 1
        case 2: levelDuration = 0.8
        case 3: levelDuration = 0.6
        case 4: levelDuration = 0.4
        default:
            levelDuration = 0.5
        }

        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
    }

    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()

        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }

        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy {
            //if the player has hit the enemy

            self.loseALife()
            if GameManager.shared.livesLeft < 0 {
                if body1.node != nil {
                    spawnExplosion(spawnPosition: body1.node!.position)
                    body1.node?.removeFromParent()
                    runGameOver()
                }
            }

            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }

            body2.node?.removeFromParent()
        }

        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy && (body2.node?.position.y)! < self.size.height {
            //if the bullet has hit the enemy

            let nodeName = body2.node?.name
            let reward = giveReward(nameNode: nodeName!)
            addScore(scoreEnemy: reward)

            // disable clouds if future age was reached
            if GameManager.shared.levelAge >= 4 { cloudSpawing = false }

            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
                print("removing enemy \(body2.node!)")
                enemies = enemies.filter() { $0 !== body2.node! }
                print("enemies:\(enemies)")
            }
            
            let diceRoll = Int(arc4random_uniform(50))
            if(diceRoll == 25) {
                spawnPower(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }

        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.BulletEnemy {
            //if the player hits an enemy bullet

            self.loseALife()
            if GameManager.shared.livesLeft < 0 {
                if body1.node != nil {
                    spawnExplosion(spawnPosition: body1.node!.position)
                    body1.node?.removeFromParent()
                    runGameOver()
                }
            }

            if body2.node != nil {
                body2.node?.removeFromParent()
            }

        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Power {
            //if the player hits an enemy bullet
            
            isPoweredUp = true
            
            if body2.node != nil {
                body2.node?.removeFromParent()
            }
            
        }
    }

    func spawnExplosion(spawnPosition: CGPoint) {

        self.textureIdle = GameManager.shared.allTextures.filter { $0.description.contains("Explosionv2") }
        let animation = SKAction.animate(with: textureIdle, timePerFrame: 1.0 / 40.0)
        let explosion = SKSpriteNode(texture: textureIdle[0], color: .clear, size: SpriteSize.explosion)

        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(1)

        self.addChild(explosion)

        self.run(SKAction.repeatForever(animation))
        print("animation explosion")

        //        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()

        let explosionSequence = SKAction.sequence([explosionSound, animation, fadeOut, delete])
        explosion.run(explosionSequence)

    }
    
    func spawnPower(spawnPosition: CGPoint) {
        
        
        let power = Power()
        power.setScale(1)
        power.position = spawnPosition
        power.zPosition = 2
        power.physicsBody = SKPhysicsBody(texture: power.texture!, size: CGSize(width: (power.texture?.size().width)!*2, height: (power.texture?.size().height)!*2))
        power.physicsBody?.affectedByGravity = false
        power.physicsBody?.categoryBitMask = PhysicsCategories.Power
        power.physicsBody?.collisionBitMask = PhysicsCategories.None
        power.physicsBody?.contactTestBitMask = PhysicsCategories.Player
        power.animate()
        self.addChild(power)
        
    }

    func addScore(scoreEnemy: Int) {
        hud.score = scoreEnemy
        var firstLevelIsSelected = false
        var secondLevelIsSelected = false
        var thirdLevelIsSelected = false

        if (hud.score >= 500 && hud.score < 1250 && firstLevelIsSelected == false) || (hud.score >= 1250 && hud.score < 2500 && secondLevelIsSelected == false) || (hud.score >= 2500 && thirdLevelIsSelected == false) {

            if hud.score >= 500 && hud.score < 1250 {
                firstLevelIsSelected = true
                levelNumber += 1
            } else if hud.score >= 1250 && hud.score < 2500 {
                secondLevelIsSelected = true
                levelNumber += 1
            } else {
                thirdLevelIsSelected = true
                levelNumber += 1
            }

            //            scheduleEnemy()

        }

        //gestisce i livelli del gioco 1. WW1  2. WW2  3. MODERN  4. FUTURE
        if GameManager.shared.score < 1500 {
            GameManager.shared.levelAge = 1
        } else if GameManager.shared.score >= 1500 && GameManager.shared.score < 3000 {
            GameManager.shared.levelAge = 2
        } else if GameManager.shared.score >= 3000 && GameManager.shared.score < 4500 {
            GameManager.shared.levelAge = 3
        } else if GameManager.shared.score >= 4500 {
            GameManager.shared.levelAge = 4
        }

        //        if GameManager.shared.score < 500 {
        //            background = Background(imageNamed: "background_sea")
        //            background2 = Background(imageNamed: "background_sea")
        //        } else {
        //            background = Background(imageNamed: "background_snow")
        //            background2 = Background(imageNamed: "background_snow")
        //        }

    }

    //se vogliamo far perdere una vita non quando escono fuori schermo ma quando viene colpito spostare questa funzione
    func loseALife() {
        
        isPoweredUp = false
        GameManager.shared.livesLeft -= 1
        hud.lifeLabel.attributedText = NSMutableAttributedString(string: "x0\(GameManager.shared.livesLeft)", attributes: [
            NSAttributedStringKey.strokeWidth: -3,
            NSAttributedStringKey.strokeColor: UIColor.black,
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont.init(name: "Atari-Font-Full-Version", size: 21)!
            ])

        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        hud.lifeImage.run(scaleSequence)
        if GameManager.shared.livesLeft == -1 {
            hud.lifeLabel.attributedText = NSMutableAttributedString(string: "x00", attributes: [
                NSAttributedStringKey.strokeWidth: -3,
                NSAttributedStringKey.strokeColor: UIColor.black,
                NSAttributedStringKey.foregroundColor: UIColor.white,
                NSAttributedStringKey.font: UIFont.init(name: "Atari-Font-Full-Version", size: 21)!
                ])
        }

    }

    func runGameOver() {

        currentGameState = gameState.afterGame

        NotificationCenter.default.post(name: Notification.Name(rawValue: "StopBackgroundSound"), object: self)

        changedMidBackground = false
        changedFirstBackground = false
        changedSecondBackground = false

        self.removeAllActions()
        self.enumerateChildNodes(withName: "Bullet", using: {bullet, stop in bullet.removeAllActions()})

        self.enumerateChildNodes(withName: "Alternativo", using: {alternativo, stop in alternativo.removeAllActions()})
        self.enumerateChildNodes(withName: "Caccia", using: {caccia, stop in caccia.removeAllActions()})
        self.enumerateChildNodes(withName: "Bomber", using: {bomber, stop in bomber.removeAllActions()})

        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, changeSceneAction])

        self.run(changeSceneSequence)

    }

    func changeScene() {
        let sceneToMoveTo = GameOverScene(size: CGSize(width: self.size.width, height: self.size.height))
        sceneToMoveTo.scaleMode = scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view?.presentScene(sceneToMoveTo, transition: myTransition)
    }

    func giveReward(nameNode: String) -> Int {
        var reward = 0
        if nameNode == "Alternativo" {
            reward = 10
        } else if nameNode == "Caccia" {
            reward = 20
        } else if nameNode == "Bomber" {
            reward = 50
        }
        return reward
    }

    func randomEnemy() -> EnemyType {
        var type: EnemyType = .Bomber
        var enemyType = ""
        let enemies = ["Alternativo", "Caccia", "Bomber"]
        let randomIndex = Int(arc4random_uniform(UInt32(enemies.count)))
        enemyType = enemies[randomIndex]
        if enemyType == "Alternativo" {
            type = .Alternativo
        } else if enemyType == "Caccia" {
            type = .Caccia
        } else {
            type = .Bomber
        }
        return type
    }

    func giveAge(ageLevel: Int) -> String {
        var age = ""
        if ageLevel == 1 {
            age = "WWI"
        } else if ageLevel == 2 {
            age = "WWII"
        } else if ageLevel == 3 {
            age = "Moderno"
        } else if ageLevel == 4 {
            age = "Futuro"
        }

        return age

    }

}
