//
//  Background.swift
//  1942-Remake
//
//  Created by Simone Penna on 08/03/2018.
//  Copyright © 2018 5-bit. All rights reserved.
//

import SpriteKit

public class Background: SKSpriteNode {

    init() {

        super.init(texture: SKTexture(imageNamed: "background_snow"), color: .red, size: SpriteSize.background)
        self.zPosition = Z.background

    }

    init(imageNamed: String) {

        super.init(texture: SKTexture(imageNamed: imageNamed), color: .red, size: SpriteSize.background)
        self.zPosition = Z.background

    }

    func setup(view: SKView) {
//        self.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }

    func moveTo(destination pos: CGPoint) {
        position = pos
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
