//
//  Collisions.swift
//  Fruit_Frenzy
//
//  Created by Jonathan Mahrt Guyou on 10/31/24.
//

import SpriteKit

extension SKPhysicsContact {
    func isCollisionBetweenPlayerAndObstacle(playerCategory: UInt32, obstacleCategory: UInt32) -> Bool {
        let collisionA = self.bodyA.categoryBitMask
        let collisionB = self.bodyB.categoryBitMask
        return (collisionA == playerCategory && collisionB == obstacleCategory) ||
               (collisionA == obstacleCategory && collisionB == playerCategory)
    }
}

