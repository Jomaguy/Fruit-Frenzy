//
//  PlayerNode.swift
//  Fruit_Frenzy
//
//  Created by Jonathan Mahrt Guyou on 10/31/24.
//

import SpriteKit

class PlayerNode {
    var node: SKSpriteNode
    
    init(scene: SKScene, tommyCategory: UInt32, enemyCategory: UInt32) {
        node = SKSpriteNode(imageNamed: "Tommy2")
        node.size = CGSize(width: 100, height: 100)
        node.position = CGPoint(x: scene.size.width / 2, y: scene.size.height - 150)
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
        node.physicsBody?.isDynamic = true
        node.physicsBody?.categoryBitMask = tommyCategory
        node.physicsBody?.contactTestBitMask = enemyCategory
        node.physicsBody?.collisionBitMask = 0
        
        scene.addChild(node)
    }
}

