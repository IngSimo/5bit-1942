//
//  SoundManager.swift
//  1942-Remake
//
//  Created by Walter Purcaro on 14/03/2018.
//  Copyright © 2018 5-bit. All rights reserved.
//

import SpriteKit

class SoundManager {

    static let shared = SoundManager()

    let menu = SKAction.playSoundFileNamed("Menu.wav", waitForCompletion: false)
    let explosion = SKAction.playSoundFileNamed("Explosion.wav", waitForCompletion: false)
    let gunF22 = SKAction.playSoundFileNamed("Shot.wav", waitForCompletion: false)

}
