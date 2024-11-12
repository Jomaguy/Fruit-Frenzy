//
//  CoinNode.swift
//  Fruit_Frenzy
//
//  Created by Jonathan Mahrt Guyou on 11/12/24.
//

import Foundation
import SpriteKit

class CoinNode {
    var node: SKSpriteNode
    
    init(scene: SKScene, coinCategory: UInt32, playerCategory: UInt32, speed: CGFloat) {
        // Create the coin sprite
        node = SKSpriteNode(imageNamed: "Coin")
        node.size = CGSize(width: 50, height: 50)
        
        // Randomly position the coin on the screen
        let randomX = CGFloat.random(in: node.size.width/2...scene.size.width-node.size.width/2)
        node.position = CGPoint(x: randomX, y: 0)
        
        // Set up physics body for the coin
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.categoryBitMask = coinCategory
        node.physicsBody?.contactTestBitMask = playerCategory
        node.physicsBody?.collisionBitMask = 0
        
        // Add the coin to the scene
        scene.addChild(node)
        
            
        
        // Animate the coin
        animateCoin(scene: scene, speed: speed)
    }
    
    func animateCoin(scene: SKScene, speed: CGFloat) {
        // Create a rotation action
        let rotateAction = SKAction.rotate(byAngle: .pi * 2, duration: 1)
        
        // Create a move action
        let duration = TimeInterval(scene.size.height / speed)
        let moveAction = SKAction.moveBy(x:0, y: scene.size.height + node.size.height, duration: duration)
        
        // Combine rotate and move actions
        let groupAction = SKAction.group([SKAction.repeatForever(rotateAction), moveAction])
        
        // Remove the coin when it's off screen
        let removeAction = SKAction.removeFromParent()
        
        // Run the sequence of actions
        node.run(SKAction.sequence([groupAction,removeAction]))
    }
}

// End of file. No additional code.
