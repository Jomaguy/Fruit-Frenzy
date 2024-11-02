//
//  PlayerNode.swift
//  Fruit_Frenzy
//
//  Created by Jonathan Mahrt Guyou on 10/31/24.
//

import SpriteKit

// Initializing Tommy the Tomato and adding him to the screen
class PlayerNode {
    var node: SKSpriteNode
    
    init(scene: SKScene, tommyCategory: UInt32, enemyCategory: UInt32) {
        node = SKSpriteNode(imageNamed: "Tommy2")
        node.size = CGSize(width: 100, height: 100)
        node.position = CGPoint(x: scene.size.width / 2, y: scene.size.height - 150)
        
        // Add circular physics to Tommy
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        // Allows Tommy to be affected by the physics engine, which makes him responsive to interactions and collisions
        node.physicsBody?.isDynamic = true
        // Sets Tommy's category bitmask to tommyCategory, identifying him for collision detection purposes.
        node.physicsBody?.categoryBitMask = tommyCategory
        
        // Specifies that Tommy should detect contact with any object in the enemyCategory. This triggers collision-related events
        node.physicsBody?.contactTestBitMask = enemyCategory
        
        // No physics- based collision response, Prevents physical collision response, meaning Tommy will not bounce off other objects but can still detect contact
        node.physicsBody?.collisionBitMask = 0
        
        scene.addChild(node)
    }
}

