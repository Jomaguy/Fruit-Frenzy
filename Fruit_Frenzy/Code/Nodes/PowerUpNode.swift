//
//  PowerUpNode.swift
//  Fruit_Frenzy
//
//  Created by Jonathan Mahrt Guyou on 11/12/24.
//

import Foundation
import SpriteKit

class PowerUpNode {
    var node: SKSpriteNode
    var type: PowerUpType

    // Define different types of power-ups
    enum PowerUpType {
        case extraLife
        // ADD: Extra life power-up type
        // case speedBoost
        // case shield
        // case magnet
        // Other power-up types can be added later
    }

    init(scene: SKScene, powerUpCategory: UInt32, playerCategory: UInt32, speed: CGFloat) {
        // For now, always create an extra life power-up
        type = .extraLife

        // Create the power-up sprite
        node = SKSpriteNode(imageNamed: "Heart")
        node.size = CGSize(width: 50, height: 50)

        // Randomly position the power-up on the screen
        let randomX = CGFloat.random(in: node.size.width/2...scene.size.width-node.size.width/2)
        node.position = CGPoint(x: randomX, y: 0)

        // Set up physics body for the power-up
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.categoryBitMask = powerUpCategory
        node.physicsBody?.contactTestBitMask = playerCategory
        node.physicsBody?.collisionBitMask = 0

        // Add the power-up to the scene
        scene.addChild(node)

        // Animate the power-up
        animatePowerUp(scene: scene, speed: speed)
    }

    func animatePowerUp(scene: SKScene, speed: CGFloat) {
        // Create a rotation action
        let rotateAction = SKAction.rotate(byAngle: .pi * 2, duration: 1)

        // Create a move action
        let duration = TimeInterval(scene.size.height / speed)
        let moveAction = SKAction.moveBy(x: 0, y: scene.size.height + node.size.height, duration: duration)

        // Combine rotate and move actions
        let groupAction = SKAction.group([SKAction.repeatForever(rotateAction), moveAction])

        // Remove the power-up when it's off screen
        let removeAction = SKAction.removeFromParent()

        // Run the sequence of actions
        node.run(SKAction.sequence([groupAction, removeAction]))
    }
}

// End of file. No additional code.
