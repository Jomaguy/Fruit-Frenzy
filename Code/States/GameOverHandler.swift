//
//  GameOverHandler.swift
//  Fruit_Frenzy
//
//  Created by Jonathan Mahrt Guyou on 10/31/24.
//

import SpriteKit

class GameOverHandler {
    let scene: SKScene
    
    init(scene: SKScene) {
        // Stores a reference to to the main game scene (SKScene), allowing the handler to modify scene elements directly.
        self.scene = scene
    }

    func triggerGameOver(startTime: TimeInterval) {
        // Pauses the screen stopping all actions and animations
        scene.isPaused = true
        // Creates a semi lucant transparent background
        let darkOverlay = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.8), size: scene.size)
        darkOverlay.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        darkOverlay.zPosition = 100
        scene.addChild(darkOverlay)
        
        // Displays a large Juiced
        let juicedLabel = SKLabelNode(text: "JUICED!")
        juicedLabel.fontSize = 100
        juicedLabel.fontColor = .yellow
        juicedLabel.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 1.5)
        juicedLabel.zPosition = 101
        scene.addChild(juicedLabel)
        
        // Shows the players Final time
        let finalTimeLabel = SKLabelNode(fontNamed: "Arial")
        finalTimeLabel.fontSize = 32
        finalTimeLabel.fontColor = .white
        finalTimeLabel.position = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2 - 20)
        finalTimeLabel.zPosition = 101
        
        let elapsedTime = Date().timeIntervalSinceReferenceDate - startTime
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        finalTimeLabel.text = String(format: "You were alive for: %02d:%02d", minutes, seconds)
        scene.addChild(finalTimeLabel)
    }
}

