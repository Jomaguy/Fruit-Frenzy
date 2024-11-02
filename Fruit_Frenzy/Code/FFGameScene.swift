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
        speedController = SpeedController(scene: self, backgroundSpeed: 100.0, obstacleSpeed: 100.0)
        gameOverHandler = GameOverHandler(scene: self)

        
        setupUI()
        setupTimers()
    }
    
    
    func setupUI() {
        // Setting the time label on the top right corner of the screen
        timerLabel = SKLabelNode(fontNamed: "Arial")
        timerLabel.fontSize = 24
        timerLabel.fontColor = .white
        timerLabel.position = CGPoint(x: size.width - 20, y: size.height - 40)
        timerLabel.horizontalAlignmentMode = .right
        addChild(timerLabel)
        
        // Setting up the speed label for the background screen on the top left corner of the screen
        speedLabel = SKLabelNode(fontNamed: "Arial")
        speedLabel.fontSize = 24
        speedLabel.fontColor = .white
        speedLabel.position = CGPoint(x: 20, y: size.height - 40)
        speedLabel.horizontalAlignmentMode = .left
        addChild(speedLabel)
        
        // Setting up the speed label for obstacles on the top left corner underneath the speed of the background
        // Currently all obstacles go at the same speed, but in the future we
        obstacleSpeedLabel = SKLabelNode(fontNamed: "Arial")
        obstacleSpeedLabel.fontSize = 24
        obstacleSpeedLabel.fontColor = .white
        obstacleSpeedLabel.position = CGPoint(x: 20, y: size.height - 70)
        obstacleSpeedLabel.horizontalAlignmentMode = .left
        addChild(obstacleSpeedLabel)
    }

    func setupTimers() {
        
        // Starting the timer that keeps track of the time the character is alive
        startTime = Date().timeIntervalSinceReferenceDate
        
        // Increase the background speed every 20 seconds
        let increaseBackgroundSpeed = SKAction.run { [weak self] in
            self?.speedController.increaseBackgroundSpeed()
            self?.speedLabel.text = "Speed: \(Int(self?.speedController.backgroundSpeed ?? 0))"
        }
        
        // Increase the obstacle speed every 20 seconds
        let increaseObstacleSpeed = SKAction.run { [weak self] in
            self?.speedController.increaseObstacleSpeed()
            self?.obstacleSpeedLabel.text = "Obstacle Speed: \(Int(self?.speedController.obstacleSpeed ?? 0))"
        }
        
        // The two lines run repeat the speed increasing actionsIn
        run(SKAction.repeatForever(SKAction.sequence([increaseBackgroundSpeed, .wait(forDuration: 20)])))
        run(SKAction.repeatForever(SKAction.sequence([increaseObstacleSpeed, .wait(forDuration: 20)])))
        
        let spawnObstacles = SKAction.run { [weak self] in
            guard let self = self else { return }
            self.obstacleManager.spawnObstacle(scene: self)
        }
        
        run(SKAction.repeatForever(SKAction.sequence([spawnObstacles, .wait(forDuration: Double.random(in: 1...2))])))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isGameOver { return }
        
        // Updating the time
        let elapsedTime = Date().timeIntervalSinceReferenceDate - startTime
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        
        // // Formats the string% indicates the start of a formatted string
        // 0 ensures that single digit numbers are padded with leading zeros
        // 2 specifies a mininum width of 2 characters
        // d indicates that the data type is an integer

        
        // Updating background and obstacle manager
        backgroundManager.update(speed: speedController.backgroundSpeed)
        obstacleManager.update()
    }
    
    

    func didBegin(_ contact: SKPhysicsContact) {
        if contact.isCollisionBetweenPlayerAndObstacle(playerCategory: tommyCategory, obstacleCategory: enemyCategory) {
            gameOverHandler.triggerGameOver(startTime: startTime)
            isGameOver = true
        }
    }
    
    // Extracts the first touch from the touches set. In this game, we're only concerned with the first touch event
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Gets the location of the touch within the scene's
        // Check if Tommy is touched
        // Checks if the touch was on Tommy by seeing if the touch location is inside tommyNode's bounds if tommyNode.contains(location) {
        // If true, isTouching Tommy = true is set, indicating that Tommy is currently being touched, enabling Tommy to be dragged in the touchesMoved function
        if let touch = touches.first {
            let location = touch.location(in: self)
            if player.node.contains(location) {
                isTouchingTommy = true
            }
        }
    }
    
    // Move Tommy only if he is being touched
    // Updates Tommy's position to match the new touch location, allowing the player to "drag" Tommy by moving their finger across the screen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTouchingTommy, let touch = touches.first {
            let location = touch.location(in: self)
            player.node.position = location
        }
    }
    
    // Reset the flag when the touch ends
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchingTommy = false
    }
    
    // Reset the flag if the touch is cancelled
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchingTommy = false
    }
}

