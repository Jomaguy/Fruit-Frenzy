//
//  ObstacleManager.swift
//  Fruit_Frenzy
//
//  Created by Jonathan Mahrt Guyou on 10/31/24.
//

import SpriteKit

class ObstacleManager {
    // obstacles: An array of SKSpriteNode objects that represent the obstacles currently in the scene. Each time an obstacle is spawned, it's added to this array, allowing the code to manage them collectively.
    var obstacles: [SKSpriteNode] = []
    let maxObstacles = 4
    var baseSpeed: CGFloat = 50.0
    
    
    
    init(scene: SKScene) { }

    func spawnObstacle(scene: SKScene, speed: CGFloat) {
        if obstacles.count >= maxObstacles { return }
        
        let obstacle = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        obstacle.position = CGPoint(x: CGFloat.random(in: 0...scene.size.width), y: 0)
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = true
        obstacle.physicsBody?.categoryBitMask = GameScene().enemyCategory
        obstacle.physicsBody?.contactTestBitMask = GameScene().tommyCategory
        obstacle.physicsBody?.collisionBitMask = 0

        scene.addChild(obstacle)
        obstacles.append(obstacle)

        let moveUp = SKAction.moveBy(x: 0, y: scene.size.height + obstacle.size.height, duration: TimeInterval(scene.size.height / speed))
        let removeAction = SKAction.run { [weak self] in
            self?.obstacles.removeAll { $0 == obstacle }
            obstacle.removeFromParent()
        }
        obstacle.run(SKAction.sequence([moveUp, removeAction]))
    }
    
    func update() {
        obstacles = obstacles.filter { $0.position.y <= UIScreen.main.bounds.height }
    }
}

