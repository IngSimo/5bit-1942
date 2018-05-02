//
//  Enemy.swift
//  1942-Remake
//
//  Created by Simone Penna on 08/03/2018.
//  Copyright © 2018 5-bit. All rights reserved.
//

import SpriteKit

class Power: SKSpriteNode, SKPhysicsContactDelegate {
    
    var reward: Int = 0
    
    // Textures
    var textureIdle: [SKTexture] = []
    
    // Automatic Movement
    var destination = CGPoint()
    let velocity: CGFloat = 150
    
    let gameArea = UIScreen.main.bounds
    
    //    var ageLevel = 0
    
    init() {
        //        ageLevel = GameManager.shared.levelAge
        self.textureIdle = [SKTexture.init(imageNamed: "power")]
        super.init(texture: textureIdle[0], color: .clear, size: SpriteSize.power)
        self.name = "power"
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

    
    
    // Swift requires this initializer
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
}
