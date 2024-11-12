//
//  PlayerNode.swift
//  Fruit_Frenzy
//
//  Created by Jonathan Mahrt Guyou on 10/31/24.
//

import SpriteKit
import CoreMotion

class PlayerNode {
    var node: SKSpriteNode
    let motionManager = CMMotionManager()
    
    init(scene: SKScene, tommyCategory: UInt32, enemyCategory: UInt32, coinCategory: UInt32) {
        node = SKSpriteNode(imageNamed: "Tommy2")
        node.size = CGSize(width: 100, height: 100)
        
        // Position Tommy at the bottom center of the screen
        node.position = CGPoint(x: scene.size.width / 2, y: scene.size.height - 150)
        
        // Create a texture-based physics body to match Tommy's image shape
        let tommyTexture = SKTexture(imageNamed: "Tommy2")
        node.physicsBody = SKPhysicsBody(texture: tommyTexture, size: node.size)
        
        // Allows Tommy to be affected by the physics engine, which makes him responsive to interactions and collisions
        node.physicsBody?.isDynamic = true
        
        // Sets Tommy's category bitmask to tommyCategory, identifying him for collision detection purposes.
        node.physicsBody?.categoryBitMask = tommyCategory
        
        // Specifies that Tommy should detect contact with any object in the enemyCategory. This triggers collision-related events
        node.physicsBody?.contactTestBitMask = enemyCategory | coinCategory
        
        // No physics-based collision response, Prevents physical collision response, meaning Tommy will not bounce off other objects but can still detect contact
        node.physicsBody?.collisionBitMask = 0
        
        scene.addChild(node)
        
        // Start motion updates
        startMotionUpdates()
    }
    
    func startMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
            motionManager.startDeviceMotionUpdates()
        }
    }
    
    func update(in scene: SKScene) {
            if let data = motionManager.deviceMotion {
                // Get both x and y tilt
                let tiltX = data.gravity.x
                let tiltY = data.gravity.y // Invert y-axis for correct screen orientation
                
                // Adjust these multipliers to control sensitivity
                let moveAmountX = CGFloat(tiltX * 15)
                let moveAmountY = CGFloat(tiltY * 6)
                
                var newPosition = node.position
                newPosition.x += moveAmountX
                newPosition.y += moveAmountY
                
                // Clamp the new position within the scene bounds
                newPosition.x = max(node.size.width / 2, min(scene.size.width - node.size.width / 2, newPosition.x))
                newPosition.y = max(node.size.height / 2, min(scene.size.height - node.size.height / 2, newPosition.y))
                
                node.position = newPosition
            }
        }
}

// End of file. No additional code.

