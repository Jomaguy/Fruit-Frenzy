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

    init(scene: SKScene, initialSpeed: CGFloat = 100.0) {
        // backgroundNode1 and backgroundNode 2 are two instances representing two images used to create a seamless scrolling background.
        self.backgroundSpeed = initialSpeed
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
        
    }
    
    // This updates the background screen as one Node moves out of the screen it is placed right above the one currently on the background
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

