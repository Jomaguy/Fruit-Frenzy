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
    let maxObstacles = 4// Limits the amount of obstacles on the screen simultaneously
    var obstacleSpeed: CGFloat = 100.0  // Accessed from BackgroundManager for consistent speed
    
    // Reference to SpeedController (make sure to initialize this in your setup)
    var speedController: SpeedController?
    
    // Image name for obstacles
    let movingObstacleImages = ["ZombiePineapple", "ZombieWatermelon"]
    let staticObstacleImages = ["StaticBanana", "StaticBrocoli"]
    
    init(scene: SKScene) {}

    func spawnObstacle(scene: SKScene) {
        if obstacles.count >= maxObstacles { return }
        
        // Randomly determine if the obstacle will be moving or stationary
        let isMovingObstacle = Bool.random()
        
        // Select an image based on the obstacle type
        let obstacleImageName = isMovingObstacle ? movingObstacleImages.randomElement()! : staticObstacleImages.randomElement()!
        
        // Create a new Node with a randomly selected texture
        let obstacleTexture = SKTexture(imageNamed: obstacleImageName)
        let baseSize = CGSize(width: 100, height: 100) // Adjust the base size if needed
        
        // Adjust the size based on obstacle type
        let obstacleSize = isMovingObstacle ? baseSize : CGSize(width: baseSize.width * 1.5, height: baseSize.height * 1.5)
        let obstacle = SKSpriteNode(texture: obstacleTexture)
        obstacle.size = obstacleSize
        obstacle.position = CGPoint(x: CGFloat.random(in: 0...scene.size.width), y: 0)
                
        obstacle.physicsBody = SKPhysicsBody(texture: obstacleTexture, size: obstacle.size)
        obstacle.physicsBody?.isDynamic = true
        obstacle.physicsBody?.categoryBitMask = GameScene().enemyCategory
        obstacle.physicsBody?.contactTestBitMask = GameScene().tommyCategory
        obstacle.physicsBody?.collisionBitMask = 0

        // Add the Node to the scene
        scene.addChild(obstacle)
        // Add to the list
        obstacles.append(obstacle)
        
        
        // Conditional statement. If the condition is meet then the code on the left of the colon is executed otherwise the code on the right is
        let speedMultiplier = isMovingObstacle ? CGFloat.random(in: 2...2.5) : 1.0
        let obstacleSpeed = obstacleSpeed * speedMultiplier

        // Define upward movement
        let moveUp = SKAction.moveBy(x: 0, y: scene.size.height + obstacle.size.height, duration: TimeInterval(scene.size.height / obstacleSpeed))
                
        // For moving obstacles, apply a wider, more intense zigzag pattern
        if isMovingObstacle {
            // Define the zigzag action with random horizontal offsets and varied durations
            
            let zigzagAction = SKAction.run { [weak self] in
                        guard let self = self else { return }
                        
                    // NEW: Calculate a safe horizontal offset to keep within bounds
                    let maxOffset = (scene.size.width - obstacle.size.width) / 2
                        
                    // NEW: Generate a random horizontal offset within the bounds
                    let randomHorizontalOffset = CGFloat.random(in: -maxOffset...maxOffset)
                    let newXPosition = obstacle.position.x + randomHorizontalOffset
                        
                    // NEW: Clamp the new position within scene bounds
                    let clampedXPosition = max(obstacle.size.width / 2, min(scene.size.width - obstacle.size.width / 2, newXPosition))
                        
                    // NEW: Use moveTo(x:) to precisely control the x position within bounds
                let zigzagMove = SKAction.moveTo(x: clampedXPosition, duration: Double.random(in: 0.5...1.5))
                obstacle.run(zigzagMove)
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
    func update(speed: CGFloat) {
        // Update obstacle speed from SpeedController
        obstacleSpeed = speed
        
        
        obstacles = obstacles.filter { $0.position.y <= UIScreen.main.bounds.height }
            }
}

