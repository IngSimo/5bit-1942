//
//  Constants.swift
//  1942-Remake
//
//  Created by Walter Purcaro on 07/03/2018.
//  Copyright © 2018 5-bit. All rights reservedd.
//

import SpriteKit

let scaleFactor: Int = 2

enum PhysicsMask {
    static let player: UInt32 = 0x1 << 1    // 2
    static let bullet: UInt32 = 0x1 << 2    // 4
    static let enemy: UInt32 = 0x1 << 3     // 8
    static let world: UInt32 = 0x1 << 4     // 16
    static let bulletEnemy: UInt32 = 0x1 << 5    // 32
    static let power: UInt32 = 0x1 << 6    // 64
}

enum Z {
    static let background: CGFloat = -1.0
    static let sprites: CGFloat = 10.0
    static let HUD: CGFloat = 100.0
    static let clouds: CGFloat = 0
}

enum SpriteSize {
    static let planets = CGSize(width: 100 * scaleFactor, height: 147 * scaleFactor)
    static let background = CGSize(width: 250 * scaleFactor, height: 490 * scaleFactor)
    static let f22 = CGSize(width: 32 * scaleFactor, height: 33 * scaleFactor)
    static let heart = CGSize(width: 16 * scaleFactor, height: 15 * scaleFactor)
    static let enemy = CGSize(width: 50 * scaleFactor, height: 30 * scaleFactor)
    static let Alternativo = CGSize(width: 32 * scaleFactor, height: 32 * scaleFactor)
    static let Bomber = CGSize(width: 50 * scaleFactor, height: 46 * scaleFactor)
    static let Caccia = CGSize(width: 32 * scaleFactor, height: 31 * scaleFactor)
    static let bullet = CGSize(width: 5, height: 12)
    static let explosion = CGSize(width: 30 * scaleFactor, height: 30 * scaleFactor)
    static let cloud0 = CGSize(width: 90 * scaleFactor, height: 25 * scaleFactor )
    static let cloud1 = CGSize(width: 100 * scaleFactor, height: 34 * scaleFactor )
    static let cloud2 = CGSize(width: 100 * scaleFactor, height: 37 * scaleFactor )
    static let power = CGSize(width: 12 * scaleFactor, height: 12 * scaleFactor)
}

struct PhysicsCategories {
    static let None: UInt32 = 0 //0
    static let Player: UInt32 = 0b1 //1
    static let Bullet: UInt32 = 0b10  //2
    static let Enemy: UInt32 = 0b100  //4
    static let BulletEnemy: UInt32 = 0b1000 // 8
    static let Power: UInt32 = 0b10000 // 16
}
