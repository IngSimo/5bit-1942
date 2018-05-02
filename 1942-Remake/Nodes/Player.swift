//
//  Player.swift
//  1942-Remake
//
//  Created by Walter Purcaro on 09/03/2018.
//  Copyright © 2018 5-bit. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode, SKPhysicsContactDelegate {

    // Textures
    var textureIdle: [SKTexture] = []

    // Manual Movement friction
    let friction = 0.07

    //Bullet Sound
    let bulletSound = SoundManager.shared.gunF22

    init(age: String) {
        self.textureIdle = GameManager.shared.allTextures.filter { $0.description.contains("\(age)_Player") }
        super.init(texture: textureIdle[0], color: .clear, size: SpriteSize.f22)
        self.name = "player"
        self.texture?.filteringMode = .nearest
        self.zPosition = 2
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: CGSize(width: (self.texture?.size().width)!*2, height: (self.texture?.size().height)!*2))
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = PhysicsCategories.Player
        self.physicsBody?.collisionBitMask = PhysicsCategories.None
        self.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy
    }

    func setup(view: SKView) {
//        self.position = CGPoint(x: view.frame.midX, y: self.size.height)
        self.position = CGPoint(x: view.frame.midX, y: 0 - self.size.height)
        movePlayer()
    }

    func fire() {

        //TUTORIAL Bullet
        var bulletImage = giveBullet()
        let bullet = SKSpriteNode(imageNamed: bulletImage)
        bullet.name = "Bullet"
        bullet.setScale(1)
        bullet.position = self.position
        bullet.zPosition = 1
        bullet.size = SpriteSize.bullet
        bullet.physicsBody = SKPhysicsBody(texture: bullet.texture!, size: CGSize(width: (bullet.texture?.size().width)!*2, height: (bullet.texture?.size().height)!*2))
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody?.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy
//        let bullet = SKShapeNode(circleOfRadius: 5)
//
//        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 5)
//        bullet.fillColor = SKColor.red

        //let bullet = SKSpriteNode(color: SKColor.red, size: SpriteSize.bullet)
//        bullet.name = "bullet"

        // Physics
        //bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
//        bullet.firephysicsBody!.isDynamic = true
//        bullet.physicsBody!.affectedByGravity = false
//        bullet.physicsBody!.categoryBitMask = PhysicsMask.bullet
//        bullet.physicsBody!.collisionBitMask = 0

        // Positioning
//        bullet.position = CGPoint(x: position.x, y: position.y + frame.size.height / 2 + bullet.frame.size.height / 2)
//        let bulletDestination = CGPoint(x: position.x, y: (parent?.frame.size.height)! + bullet.frame.size.height)
//
//        // Animation
//        let bulletAction = SKAction.sequence([
//            SKAction.move(to: bulletDestination, duration: 0.6),
//            SKAction.wait(forDuration: 0.2),
//            SKAction.removeFromParent()
//            ])
//        bullet.run(bulletAction)

        //TUTORIAL Animation
        let moveBullet = SKAction.moveTo(y: (self.parent?.scene?.size.height)! + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)

        parent?.addChild(bullet)
        // Add to Scene
//        parent?.addChild(bullet)
    }
    
    func fireSuper() {
        
        //TUTORIAL Bullet
        var bulletImage = giveBullet()
        let bullet = SKSpriteNode(imageNamed: bulletImage)
        bullet.name = "Bullet"
        bullet.setScale(1)
        bullet.position = self.position
        bullet.zPosition = 1
        bullet.size = SpriteSize.bullet
        bullet.physicsBody = SKPhysicsBody(texture: bullet.texture!, size: CGSize(width: (bullet.texture?.size().width)!*2, height: (bullet.texture?.size().height)!*2))
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody?.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy
        
        //TUTORIAL Animation
        let moveBullet = SKAction.moveTo(y: (self.parent?.scene?.size.height)! + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
        
        parent?.addChild(bullet)
        // Add to Scene
        //        parent?.addChild(bullet)
        
        let bullet2 = SKSpriteNode(imageNamed: bulletImage)
        bullet2.name = "Bullet"
        bullet2.setScale(1)
        bullet2.position = self.position
        bullet2.zPosition = 1
        bullet2.size = SpriteSize.bullet
        bullet2.physicsBody = SKPhysicsBody(texture: bullet2.texture!, size: CGSize(width: (bullet2.texture?.size().width)!*2, height: (bullet2.texture?.size().height)!*2))
        bullet2.physicsBody?.affectedByGravity = false
        bullet2.physicsBody?.categoryBitMask = PhysicsCategories.Bullet
        bullet2.physicsBody?.collisionBitMask = PhysicsCategories.None
        bullet2.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy
        
        //TUTORIAL Animation
        let moveBullet2 = SKAction.moveTo(y: (self.parent?.scene?.size.height)! + bullet2.size.height, duration: 1)
        let moveBulletSide2 = SKAction.moveTo(x: (self.parent?.scene?.size.width)! + bullet2.size.width, duration: 1)
        let deleteBullet2 = SKAction.removeFromParent()
        let bulletSequence2 = SKAction.sequence([moveBulletSide2, moveBullet2, deleteBullet2])
        bullet2.run(bulletSequence2)
        parent?.addChild(bullet2)
        
        let bullet3 = SKSpriteNode(imageNamed: bulletImage)
        bullet3.name = "Bullet"
        bullet3.setScale(1)
        bullet3.position = self.position
        bullet3.zPosition = 1
        bullet3.size = SpriteSize.bullet
        bullet3.physicsBody = SKPhysicsBody(texture: bullet3.texture!, size: CGSize(width: (bullet3.texture?.size().width)!*2, height: (bullet3.texture?.size().height)!*2))
        bullet3.physicsBody?.affectedByGravity = false
        bullet3.physicsBody?.categoryBitMask = PhysicsCategories.Bullet
        bullet3.physicsBody?.collisionBitMask = PhysicsCategories.None
        bullet3.physicsBody?.contactTestBitMask = PhysicsCategories.Enemy
        
        //TUTORIAL Animation
        let moveBullet3 = SKAction.moveTo(y: (self.parent?.scene?.size.height)! + bullet3.size.height, duration: 1)
        let moveBulletSide3 = SKAction.moveTo(x: -(self.parent?.scene?.size.width)! - bullet3.size.width, duration: 1)
        let deleteBullet3 = SKAction.removeFromParent()
        let bulletSequence3 = SKAction.sequence([moveBulletSide3, moveBullet3, deleteBullet3])
        bullet3.run(bulletSequence3)
        parent?.addChild(bullet3)
        
    }

    // Swift requires this initializer
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func animate() {
        let animation = SKAction.animate(with: textureIdle, timePerFrame: 1.0 / 10.0)
        self.run(SKAction.repeatForever(animation))
        print("animation player")
    }

    func movePlayer() {
        let moveOn = SKAction.moveTo(y: self.size.height*0.9, duration: 0.5)
        self.run(moveOn)
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

    func giveBullet() -> String {
        var bullet = ""
        if GameManager.shared.levelAge != 4 {
            bullet = "bullet"
        } else {
            bullet = "LaserV20"
        }

        return bullet
    }

}
