//
//  SpeedController.swift
//  Fruit_Frenzy
//
//  Created by Jonathan Mahrt Guyou on 10/31/24.
//

import SpriteKit

class SpeedController {
    var backgroundSpeed: CGFloat
    var obstacleSpeed: CGFloat
    let maxBackgroundSpeed: CGFloat = 300.0
    let maxObstacleSpeed: CGFloat = 300.0

    init(scene: SKScene, backgroundSpeed: CGFloat, obstacleSpeed: CGFloat) {
        self.backgroundSpeed = backgroundSpeed
        self.obstacleSpeed = obstacleSpeed
    }
    
    func increaseBackgroundSpeed() {
        backgroundSpeed = min(backgroundSpeed + 20.0, maxBackgroundSpeed)
    }
    
    func increaseObstacleSpeed() {
        obstacleSpeed = min(obstacleSpeed + 20.0, maxObstacleSpeed)
    }
}

