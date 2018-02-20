//
//  HPCircleLoader.swift
//  Test Application
//
//  Created by Henrik Panhans on 16.02.18.
//  Copyright © 2018 Henrik Panhans. All rights reserved.
//

import UIKit
import SpriteKit

class HPCircleLoader: SKView {

    private var loaderScene: HPCircleScene?
    var ringColor: UIColor = UIColor.white {
        didSet {
            loaderScene?.circleNodes.forEach({ (node) in
                node.color = ringColor
                node.colorBlendFactor = 1
            })
        }
    }
    
    func startAnimating(with cycleDuration: TimeInterval = 5) {
        loaderScene?.startAnimating(with: cycleDuration)
    }
    
    func stopAnimating() {
        loaderScene?.stopAnimating()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let scene = HPCircleScene(size: frame.size)
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

class HPCircleScene: SKScene {
    public var circleNodes = [SKSpriteNode]()
    
    override func didMove(to view: SKView) {
        for i in 0...4 {
            let texture = SKTexture(imageNamed: "circle-\(i)")
            let node = SKSpriteNode.init(texture: texture, color: .white, size: self.size)
            node.color = .white
            node.colorBlendFactor = 1
            node.position = CGPoint(x: 0, y: 0)
            node.zRotation = CGFloat(Double.pi / 4)
            node.alpha = 0
            self.circleNodes.append(node)
            self.addChild(node)
        }
    }
    
    func startAnimating(with cycleDuration: TimeInterval = 3) {
        for i in 0...4 {
            self.circleNodes[i].run(SKAction.fadeIn(withDuration: 0.5))
            let action = SKAction.rotate(byAngle: CGFloat(Double.pi * 2), duration: cycleDuration / Double(i + 1))
            self.circleNodes[i].run(SKAction.repeatForever(action), withKey: "rotation")
        }
    }
    
    func stopAnimating() {
        circleNodes.forEach { (node) in
            node.run(SKAction.speed(to: 3, duration: 0.25))
            node.run(SKAction.fadeOut(withDuration: 0.5), completion: {
                node.removeAllActions()
                node.speed = 1
                node.zRotation = CGFloat(Double.pi / 4)
            })
        }
    }
}
