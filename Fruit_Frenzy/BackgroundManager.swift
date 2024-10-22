//
//  BackgroundManager.swift
//  Fruit_Frenzy
//
//  Created by Jonathan Mahrt Guyou on 10/31/24.
//

import SpriteKit

class BackgroundManager {
    var backgroundNode1: SKSpriteNode!
    var backgroundNode2: SKSpriteNode!
    var backgroundSpeed: CGFloat

    init(scene: SKScene) {
        backgroundNode1 = SKSpriteNode(imageNamed: "fridgeBackground")
        backgroundNode1.size = scene.size
        backgroundNode1.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        backgroundNode1.zPosition = -1
        scene.addChild(backgroundNode1)

        backgroundNode2 = SKSpriteNode(imageNamed: "fridgeBackground")
        backgroundNode2.size = scene.size
        backgroundNode2.position = CGPoint(x: scene.size.width / 2, y: scene.size.height * 1.5)
        backgroundNode2.zPosition = -1
        scene.addChild(backgroundNode2)
        
        self.backgroundSpeed = 100.0
    }
    
    func update(speed: CGFloat) {
        backgroundSpeed = speed
        backgroundNode1.position.y += backgroundSpeed * CGFloat (1.0 / 60.0)

        backgroundNode2.position.y += backgroundSpeed * CGFloat (1.0 / 60.0)
        
        if backgroundNode1.position.y >= backgroundNode1.size.height * 1.5 {
            backgroundNode1.position.y = backgroundNode2.position.y - backgroundNode2.size.height
        }
        
        if backgroundNode2.position.y >= backgroundNode2.size.height * 1.5 {
            backgroundNode2.position.y = backgroundNode1.position.y - backgroundNode1.size.height
        }
    }
}

