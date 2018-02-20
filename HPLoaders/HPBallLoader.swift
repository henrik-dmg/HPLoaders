//
//  HPBallPulse.swift
//  Test Application
//
//  Created by Henrik Panhans on 18.02.18.
//  Copyright © 2018 Henrik Panhans. All rights reserved.
//

import UIKit
import SpriteKit

class HPBallLoader: SKView {
    
    private var loaderScene: HPBallScene?
    public var ball: SKShapeNode?
    
    func startAnimating(withDurations pulse: TimeInterval = 0.3, restore: TimeInterval = 1) {
        loaderScene?.startAnimating(withDurations: pulse, restore: restore)
    }
    
    func stopAnimating() {
        loaderScene?.stopAnimating()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let scene = HPBallScene(size: frame.size)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        loaderScene = scene
        ball = scene.ball
        self.presentScene(scene)
        
        
        self.ignoresSiblingOrder = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HPBallScene: SKScene {
    
    var ball = SKShapeNode()
    
    override init(size: CGSize) {
        super.init(size: size)
        
        ball = SKShapeNode(circleOfRadius: size.width / 2)
        ball.position = CGPoint(x: 0, y: 0)
        ball.alpha = 0
        ball.fillColor = .white
        ball.lineWidth = 0
        ball.setScale(0.7)
        
        self.addChild(ball)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating(withDurations pulse: TimeInterval = 0.5, restore: TimeInterval = 1) {
        ball.run(SKAction.fadeIn(withDuration: 0.5))
        
        let grow = SKAction.scale(to: 1, duration: pulse)
        grow.timingMode = .easeIn
        let restore = SKAction.scale(to: 0.7, duration: restore)
        
        let sequence = SKAction.sequence([grow, restore])
        ball.run(SKAction.repeatForever(sequence))
    }
    
    func stopAnimating() {
        ball.run(SKAction.speed(to: 3, duration: 0.3))
        ball.run(SKAction.fadeOut(withDuration: 0.5)) {
            self.ball.removeAllActions()
            self.ball.speed = 1
            self.ball.setScale(0.7)
        }
    }
}

