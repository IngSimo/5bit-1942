//
//  GameManager.swift
//  1942-Remake
//
//  Created by Simone Penna on 08/03/2018.
//  Copyright © 2018 5-bit. All rights reserved.
//

import SpriteKit

class GameManager {

    static let shared = GameManager()

    var score: Int = 0
    var enemiesKilled: Int = 0
    var livesLeft: Int = 2
    //1 World War
    var levelAge: Int = 1

    // Textures
    var allTextures: [SKTexture] = []

    func reset() {
        self.score = 0
        self.livesLeft = 2
        self.levelAge = 1
    }
}
