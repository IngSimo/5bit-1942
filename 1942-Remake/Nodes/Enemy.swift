//
//  Enemy.swift
//  1942-Remake
//
//  Created by Simone Penna on 08/03/2018.
//  Copyright © 2018 5-bit. All rights reserved.
//

import SpriteKit

class Enemy: SKSpriteNode, SKPhysicsContactDelegate {

    var reward: Int = 0

    // Textures
    var textureIdle: [SKTexture] = []

    // Automatic Movement
    var destination = CGPoint()
    let velocity: CGFloat = 150

    let gameArea = UIScreen.main.bounds

//    var ageLevel = 0

    init(type: EnemyType, age: String) {
//        ageLevel = GameManager.shared.levelAge
        self.textureIdle = GameManager.shared.allTextures.filter { $0.description.contains("\(age)_\(type)") }
        super.init(texture: textureIdle[0], color: .clear, size: giveSize(type: type))
        reward = self.giveReward(type: type)
        self.name = giveName(type: type)
        self.texture?.filteringMode = .nearest
        self.zRotation = .pi*2
    }

    func setup(view: SKView) {
        self.position = CGPoint(x: view.frame.midX, y: 600)
        destination = position
    }

    func animate() {

        let animation = SKAction.animate(with: textureIdle, timePerFrame: 1.0 / 10.0)
        self.run(SKAction.repeatForever(animation))
    }

    func moveTo(destination pos: CGPoint) {
        self.destination = pos
        let move = SKAction.moveTo(x: pos.x, duration: 0.3)
        move.timingMode = .easeOut
        let animation = SKAction.sequence([move])
        self.run(animation)
    }

    func giveReward(type: EnemyType) -> Int {
        var reward = 0
        if type == .Alternativo {
            reward = 10
        } else if type == .Caccia {
            reward = 20
        } else if type == .Bomber {
            reward = 50
        }
        return reward
    }

    func giveName(type: EnemyType) -> String {
        var nodeName = ""
        if type == .Alternativo {
            nodeName = "Alternativo"
        } else if type == .Caccia {
            nodeName = "Caccia"
        } else if type == .Bomber {
            nodeName = "Bomber"
        }
        return nodeName
    }

    func giveSize(type: EnemyType) -> CGSize {
        var size = SpriteSize.enemy

        if type == .Alternativo {
            size = SpriteSize.Alternativo
        } else if type == .Caccia {
            size = SpriteSize.Caccia
        } else if type == .Bomber {
            size = SpriteSize.Bomber
        }

        return size
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
        bullet.physicsBody?.categoryBitMask = PhysicsCategories.BulletEnemy
        bullet.physicsBody?.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody?.contactTestBitMask = PhysicsCategories.Player
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
        if let _ = self.parent {
            let moveBullet = SKAction.moveTo(y: -(self.parent?.scene?.size.height)! - bullet.size.height, duration: 4)
            let deleteBullet = SKAction.removeFromParent()
            let bulletSequence = SKAction.sequence([moveBullet, deleteBullet])
            bullet.run(bulletSequence)
            parent?.addChild(bullet)
        }

        // Add to Scene
        //        parent?.addChild(bullet)
    }

    func giveBullet() -> String {
        var bullet = ""
        if GameManager.shared.levelAge != 4 {
            bullet = "BulletEnemy"
        } else {
            bullet = "LaserEnemyV20"
        }

        return bullet
    }

    // Swift requires this initializer
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

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

enum EnemyType {
    case Alternativo
    case Caccia
    case Bomber
}
