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
    let maxSpeedBackground: CGFloat = 800.0
    let maxSpeedObstacles: CGFloat = 400.0


    init(scene: SKScene, backgroundSpeed: CGFloat, obstacleSpeed: CGFloat) {
        self.backgroundSpeed = backgroundSpeed
        self.obstacleSpeed = obstacleSpeed
    }
    
    func increaseBackgroundSpeed() {
        backgroundSpeed = min(backgroundSpeed + 100.0, maxSpeedBackground)
    }
    
    func increaseObstacleSpeed() {
        obstacleSpeed = min(obstacleSpeed + 25.0, maxSpeedObstacles)
    }
}

