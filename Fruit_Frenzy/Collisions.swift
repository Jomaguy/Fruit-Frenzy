//
//  Collisions.swift
//  Fruit_Frenzy
//
//  Created by Jonathan Mahrt Guyou on 10/31/24.
//

import SpriteKit

// Extends SKPhysicsContact to add a helper method for checking specific collisions.
extension SKPhysicsContact {
    // Takes TommyCategory and EnnemyCategory as parameters and return True/False
    func isCollisionBetweenPlayerAndObstacle(playerCategory: UInt32, obstacleCategory: UInt32) -> Bool {
        // Retrieving the categoryBitMask of both bodies
        let collisionA = self.bodyA.categoryBitMask
        let collisionB = self.bodyB.categoryBitMask
        return (collisionA == playerCategory && collisionB == obstacleCategory) ||
               (collisionA == obstacleCategory && collisionB == playerCategory)
    }
}

