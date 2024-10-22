//
//  FFGameScene.swift
//  Fruit_Frenzy
//
//  Created by Jonathan Mahrt Guyou on 10/31/24.
//
import Foundation
import SpriteKit
// Provides classes and tools to create 2D games and animations
// Example SKScene, SKPhysicsContactDelegate, SKSpriteNode
import GameplayKit
// A set of tools for complex gameplay features, like Al and pathfinding
// Not currently used




class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Declare instances of supporting classes 
    var player: PlayerNode!
    var backgroundManager: BackgroundManager!
    var obstacleManager: ObstacleManager!
    var speedController: SpeedController!
    var gameOverHandler: GameOverHandler!
    
    var timerLabel: SKLabelNode!
    var speedLabel: SKLabelNode!
    var obstacleSpeedLabel: SKLabelNode!
    
    var startTime: TimeInterval = 0
    var isGameOver = false
    var isTouchingTommy = false
    
    // Define category bitmasks for collision detection
    // Bitmasks in SpriteKit are used to specify which physics bodies can interact with each other
    let tommyCategory: UInt32 = 0x1 << 0
    let enemyCategory: UInt32 = 0x1 << 1
    
    /*How Bitmasks Work in Collision Detection
    These bitmasks will be used in the contactTestBitMask and
    collisionBitMask properties of each physics body to specify which
    objects should trigger contact events or physical collisions with each
    other. By setting up unique bitmasks, the game can selectively
    detect contacts, which is essential for triggering actions like ending
    the game when Tommy collides with an obstacle. */

    // Used to initialize and configure all elements in the scene
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero // Disables gravity so objects in the scene don’t fall automatically.
        physicsWorld.contactDelegate = self
        /* Setting GameScene as the contact delegate for the physics
        world enables it to monitor all interactions between physics bodies.
        This means that GameScene will be alerted whenever obiects
        collide, and it can handle these events by implementing the
        didBegin(_:) function, which responds to the start of each contact
        setupTommy) */
        
        // Instantiates all the different objects used
        player = PlayerNode(scene: self, tommyCategory: tommyCategory, enemyCategory: enemyCategory)
        backgroundManager = BackgroundManager(scene: self)
        obstacleManager = ObstacleManager(scene: self)
        speedController = SpeedController(scene: self, backgroundSpeed: 100.0, obstacleSpeed: 50.0)
        gameOverHandler = GameOverHandler(scene: self)

        
        setupUI()
        setupTimers()
    }
    

    func setupUI() {
        timerLabel = SKLabelNode(fontNamed: "Arial")
        timerLabel.fontSize = 24
        timerLabel.fontColor = .white
        timerLabel.position = CGPoint(x: size.width - 20, y: size.height - 40)
        timerLabel.horizontalAlignmentMode = .right
        addChild(timerLabel)
        
        speedLabel = SKLabelNode(fontNamed: "Arial")
        speedLabel.fontSize = 24
        speedLabel.fontColor = .white
        speedLabel.position = CGPoint(x: 20, y: size.height - 40)
        speedLabel.horizontalAlignmentMode = .left
        addChild(speedLabel)
        
        obstacleSpeedLabel = SKLabelNode(fontNamed: "Arial")
        obstacleSpeedLabel.fontSize = 24
        obstacleSpeedLabel.fontColor = .white
        obstacleSpeedLabel.position = CGPoint(x: 20, y: size.height - 70)
        obstacleSpeedLabel.horizontalAlignmentMode = .left
        addChild(obstacleSpeedLabel)
    }

    func setupTimers() {
        startTime = Date().timeIntervalSinceReferenceDate
        
        let increaseBackgroundSpeed = SKAction.run { [weak self] in
            self?.speedController.increaseBackgroundSpeed()
            self?.speedLabel.text = "Speed: \(Int(self?.speedController.backgroundSpeed ?? 0))"
        }
        
        let increaseObstacleSpeed = SKAction.run { [weak self] in
            self?.speedController.increaseObstacleSpeed()
            self?.obstacleSpeedLabel.text = "Obstacle Speed: \(Int(self?.speedController.obstacleSpeed ?? 0))"
        }
        
        run(SKAction.repeatForever(SKAction.sequence([increaseBackgroundSpeed, .wait(forDuration: 20)])))
        run(SKAction.repeatForever(SKAction.sequence([increaseObstacleSpeed, .wait(forDuration: 20)])))
        
        let spawnObstacles = SKAction.run { [weak self] in
            guard let self = self else { return }
            self.obstacleManager.spawnObstacle(scene: self, speed: self.speedController.obstacleSpeed)
        }
        
        run(SKAction.repeatForever(SKAction.sequence([spawnObstacles, .wait(forDuration: Double.random(in: 1...2))])))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isGameOver { return }
        
        let elapsedTime = Date().timeIntervalSinceReferenceDate - startTime
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        
        backgroundManager.update(speed: speedController.backgroundSpeed)
        obstacleManager.update()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.isCollisionBetweenPlayerAndObstacle(playerCategory: tommyCategory, obstacleCategory: enemyCategory) {
            gameOverHandler.triggerGameOver(startTime: startTime)
            isGameOver = true
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if player.node.contains(location) {
                isTouchingTommy = true
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouchingTommy, let touch = touches.first {
            let location = touch.location(in: self)
            player.node.position = location
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchingTommy = false
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchingTommy = false
    }
}

