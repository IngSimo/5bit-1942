//
//  Clouds.swift
//  1942-Remake
//
//  Created by Luigi De Marco on 13/03/2018.
//  Copyright © 2018 5-bit. All rights reserved.
//

import SpriteKit

public class Cloud: SKSpriteNode {

    init(imageName: String) {

        super.init(texture: SKTexture(imageNamed: imageName), color: .red, size: SpriteSize.cloud0)
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

//    func generateRandomWidthNumber() -> (CGFloat) {
//
//        let screenWidth = UInt32(UIScreen.main.bounds.width)
//        let randomWidthNumber = arc4random_uniform(screenWidth)
////        print("random width \(randomWidthNumber)")
//        return CGFloat(randomWidthNumber)
//
//    }
//
//
//
//
//    func generateRandomHeightNumber() -> (CGFloat) {
//        let spriteSize = UInt32(size.height)
//        let screenHeight = UInt32(UIScreen.main.bounds.height) - spriteSize
//        let randomHeightNumber = arc4random_uniform(screenHeight) + spriteSize
//        print("random \(randomHeightNumber)")
//        return CGFloat(randomHeightNumber + spriteSize)
//
//
//    }
}
