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
   
    let maxObstacles = 4 // Limits the amount of obstacles on the screen simultaneously
    
    var baseSpeed = 100.0  // Accessed from BackgroundManager for consistent speed
    
    init(scene: SKScene) {}

    func spawnObstacle(scene: SKScene) {
        if obstacles.count >= maxObstacles { return }
        
        // Create a new Node
        let obstacle = SKSpriteNode(color: .red, size: CGSize(width: 50, height: 50))
        obstacle.position = CGPoint(x: CGFloat.random(in: 0...scene.size.width), y: 0)
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = true
        obstacle.physicsBody?.categoryBitMask = GameScene().enemyCategory
        obstacle.physicsBody?.contactTestBitMask = GameScene().tommyCategory
        obstacle.physicsBody?.collisionBitMask = 0

        // Add the Node to the scene
        scene.addChild(obstacle)
        // Add to the list
        obstacles.append(obstacle)
        
        // Randomly determine if the obstacle will be moving or stationary
        let isMovingObstacle = Bool.random()
        // Conditional statement. If the condition is meet then the code on the left of the colon is executed otherwise the code on the right is
        let speedMultiplier = isMovingObstacle ? CGFloat.random(in: 1.5...2.0) : 1.0
        let obstacleSpeed = baseSpeed * speedMultiplier

        // Define upward movement
        let moveUp = SKAction.moveBy(x: 0, y: scene.size.height + obstacle.size.height, duration: TimeInterval(scene.size.height / obstacleSpeed))
                
        // For moving obstacles, apply a wider, more intense zigzag pattern
        if isMovingObstacle {
            // Define the zigzag action with random horizontal offsets and varied durations
            let zigzagAction = SKAction.run { [weak self] in
                guard let self = self else { return }
                        
            let randomHorizontalOffset = CGFloat.random(in: -scene.size.width / 2...scene.size.width / 2)
            let randomDuration = Double.random(in: 0.5...1.5)
                        
                let zigzagMove = SKAction.moveBy(x: randomHorizontalOffset, y:scene.size.height / 10, duration: randomDuration); obstacle.run(zigzagMove)
                }
                    
            // Repeat the zigzag action to create continuous movement
            let repeatZigzag = SKAction.repeatForever(SKAction.sequence([zigzagAction, .wait(forDuration: 0.1)]))
            let removeAction = SKAction.run { [weak self] in
                self?.obstacles.removeAll { $0 == obstacle }
                obstacle.removeFromParent()
                }
                    
            // Combine upward movement and zigzag for moving obstacles
            let moveUpAndZigZag = SKAction.group([moveUp, repeatZigzag])
            obstacle.run(SKAction.sequence([moveUpAndZigZag, removeAction]))
            }
            else {
                // For stationary obstacles, only apply the upward movement
                let removeAction = SKAction.run { [weak self] in
                    self?.obstacles.removeAll { $0 == obstacle }
                    obstacle.removeFromParent()
                }
                obstacle.run(SKAction.sequence([moveUp, removeAction]))
                }
            }
    func update() {
        obstacles = obstacles.filter { $0.position.y <= UIScreen.main.bounds.height }
            }
}

