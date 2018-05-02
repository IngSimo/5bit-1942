//
//  Planets.swift
//  1942-Remake
//
//  Created by Luigi De Marco on 15/03/2018.
//  Copyright © 2018 5-bit. All rights reserved.
//

import SpriteKit

public class Planets: SKSpriteNode {

    init() {

        super.init(texture: SKTexture(imageNamed: "Planets0"), color: .red, size: SpriteSize.planets)
        self.zPosition = Z.clouds

    }

    init(imageNamed: String) {

        super.init(texture: SKTexture(imageNamed: imageNamed), color: .red, size: SpriteSize.planets)
        self.zPosition = Z.clouds

    }

    func setup(view: SKView) {
        let screenWidth = UInt32(frame.width)
        self.position = CGPoint(x: CGFloat(arc4random_uniform(screenWidth)), y: size.height)
    }

    func moveTo(destination pos: CGPoint) {
        position = pos
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
