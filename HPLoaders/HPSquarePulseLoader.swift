//
//  HPSquarePulseLoader.swift
//  HPLoaders
//
//  Created by Henrik Panhans on 20.02.18.
//  Copyright © 2018 Henrik Panhans. All rights reserved.
//

import Foundation
import SpriteKit

class HPSquarePulseLoader: SKView {
    
    private var loaderScene: HPSquarePulseScene?
    public var dotColor = UIColor.darkGray {
        didSet {
            loaderScene?.dots.forEach({ (dot) in
                dot.fillColor = dotColor
            })
        }
    }
    
    public var amplitude = WaveAmplitude.full
    public var numberOfDots = 3 {
        didSet {
            loaderScene?.makeDots()
        }
    }
    
    func startAnimating(with speed: TimeInterval, contractionFactor: CGFloat) {
        loaderScene?.startAnimating(with: speed, contractionFactor: contractionFactor)
    }
    
    func stopAnimating() {
        loaderScene?.stopAnimating()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let scene = HPSquarePulseScene(size: frame.size)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        loaderScene = scene
        self.presentScene(scene)
        
        
        self.ignoresSiblingOrder = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HPSquarePulseScene: SKScene {
    
    var dots = [SKShapeNode]()
    var dotColor = UIColor.red {
        didSet {
            dots.forEach { (dot) in
                dot.fillColor = dotColor
            }
        }
    }
    
    private var containerNode: SKSpriteNode?
    public var dotWidth: CGFloat = 10.00
    
    func makeDots() {
        containerNode?.removeFromParent()
        dots.removeAll()
        
        containerNode = SKSpriteNode(color: .clear, size: self.size)
        containerNode?.size = self.size
        containerNode?.position = CGPoint(x: 0, y: 0)
        
        for i in 1...4 {
            let circle = SKShapeNode(circleOfRadius: dotWidth / 2)
            switch i {
            case 1, 3:
                if i == 1 {
                    circle.position = CGPoint(x: (self.size.width / 2) - (dotWidth / 2), y: 0)
                } else if i == 3 {
                    circle.position = CGPoint(x: -(self.size.width / 2) + (dotWidth / 2), y: 0)
                }
            case 2, 4:
                if i == 2 {
                    circle.position = CGPoint(x: 0, y: (self.size.width / 2) - (dotWidth / 2))
                } else if i == 4 {
                    circle.position = CGPoint(x: 0, y: -(self.size.width / 2) + (dotWidth / 2))
                }
            default:
                break
            }
            
            containerNode!.addChild(circle)
            dots.append(circle)
        }
        
        self.addChild(containerNode!)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        makeDots()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating(with speed: TimeInterval = 8, contractionFactor: CGFloat) {
        dots.forEach { (dot) in
            let initialPosition = dot.position
            let target = initialPosition.multiply(with: contractionFactor)
            
            let moveIn = SKAction.move(to: target, duration: speed / 8)
            let moveBack = SKAction.move(to: initialPosition, duration: speed / 8)
            let sequence = SKAction.sequence([moveIn, moveBack])
            
            dot.fadeIn()
            dot.run(SKAction.repeatForever(sequence))
        }
        
        let spin = SKAction.rotate(byAngle: CGFloat(Double.pi * 2), duration: speed)
        containerNode?.run(SKAction.repeatForever(spin))
    }
    
    func stopAnimating() {
        dots.forEach { (dot) in
            dot.run(SKAction.fadeOut(withDuration: 0.5), completion: {
                dot.removeAllActions()
                dot.position.y = 0
                dot.speed = 1
            })
        }
    }
}

extension CGPoint {
    func multiply(with factor: CGFloat) -> CGPoint {
        return CGPoint(x: self.x * factor, y: self.y * factor)
    }
}
