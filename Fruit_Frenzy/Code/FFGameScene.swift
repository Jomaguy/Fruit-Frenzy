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
    
    //Adding coins
    var coins: [CoinNode] = []
    var coinCount: Int = 0
    let coinCategory: UInt32 = 0x1 << 2
    var coinCountLabel: SKLabelNode!
    
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
        
        // View the physics body outline to visually inspect during simulator
        // Use for debug purposes
        //view.showsPhysics = true
        

        
        // Instantiates all the different objects used
        //player = PlayerNode(scene: self, tommyCategory: tommyCategory, enemyCategory: enemyCategory)
       // backgroundManager = BackgroundManager(scene: self)
        //obstacleManager = ObstacleManager(scene: self)
        //speedController = SpeedController(scene: self, backgroundSpeed: 100.0, obstacleSpeed: 100.0)
        //gameOverHandler = GameOverHandler(scene: self)

        
        //setupUI()
        //setupTimers()
        
        setupGame()
    }
    
    func setupGame() {
            physicsWorld.gravity = .zero
            physicsWorld.contactDelegate = self
            
        player = PlayerNode(scene: self, tommyCategory: tommyCategory, enemyCategory: enemyCategory, coinCategory: coinCategory)
            backgroundManager = BackgroundManager(scene: self)
            obstacleManager = ObstacleManager(scene: self)
            speedController = SpeedController(scene: self, backgroundSpeed: 100.0, obstacleSpeed: 100.0)
            gameOverHandler = GameOverHandler(scene: self)
            
            setupUI()
            setupTimers()
            startCoinSpawning()
        }
    
    // Add this function to spawn coins
        func startCoinSpawning() {
            let spawnCoin = SKAction.run { [weak self] in
                guard let self = self else { return }
                let coin = CoinNode(scene: self, coinCategory: self.coinCategory, playerCategory: self.tommyCategory, speed: self.speedController.obstacleSpeed)
                self.coins.append(coin)
            }
            
            let waitAction = SKAction.wait(forDuration: 3.0) // Adjust this value to change coin spawn frequency
            let spawnSequence = SKAction.sequence([spawnCoin, waitAction])
            run(SKAction.repeatForever(spawnSequence), withKey: "spawnCoins")
            print("Coin spawning started") // Add this line
        }
    
    
    func setupUI() {
        
        // Add this block to create the coin count label
        coinCountLabel = SKLabelNode(fontNamed: "Arial")
        coinCountLabel.fontSize = 24
        coinCountLabel.fontColor = .white
        coinCountLabel.position = CGPoint(x: size.width - 20, y: size.height - 70) // Adjust position as needed
        coinCountLabel.horizontalAlignmentMode = .right
        coinCountLabel.text = "Coins: 0"
        addChild(coinCountLabel)
        
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
        obstacleManager.update(speed: speedController.obstacleSpeed)
        
        player.update(in: self)
    }
    
    

    func didBegin(_ contact: SKPhysicsContact) {
                if contact.isCollisionBetweenPlayerAndObstacle(playerCategory: tommyCategory, obstacleCategory: enemyCategory) {
                    handleCollision()
                } else if contact.bodyA.categoryBitMask == coinCategory || contact.bodyB.categoryBitMask == coinCategory {
                    handleCoinCollection(contact: contact)
                }
            
        }

    // Add this function to handle coin collection
        func handleCoinCollection(contact: SKPhysicsContact) {
            let coinNode: SKNode
            guard let coinNode = (contact.bodyA.categoryBitMask == coinCategory ? contact.bodyA.node : contact.bodyB.node) else {
                    print("Error: Coin node is nil") // ADDED: Debug print
                    return
                }
            
            coinNode.removeFromParent()
            coins.removeAll { $0.node == coinNode }
            coinCount += 1
            
            // Update UI to show collected coins
            updateCoinCountLabel()
        }
        
        // Add this function to update the coin count label
        func updateCoinCountLabel() {
            // Assuming you have a label for coin count in your UI
            coinCountLabel.text = "Coins: \(coinCount)"
        }
        
        // Modify the existing handleCollision function
        func handleCollision() {
            isGameOver = true
            
            
            gameOverHandler.triggerGameOver(startTime: startTime, coinCount: coinCount)
        }

    
    
}

