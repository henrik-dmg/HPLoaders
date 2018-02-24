//
//  HPCircleLoader.swift
//  Test Application
//
//  Created by Henrik Panhans on 16.02.18.
//  Copyright © 2018 Henrik Panhans. All rights reserved.
//

import UIKit
import SpriteKit

@IBDesignable public class HPCircleLoader: SKView {

    private var loaderScene: HPCircleScene?
    public var isAnimating: Bool = false
    
    @IBInspectable public var ringColor: UIColor = UIColor.white {
        didSet {
            loaderScene?.circleNodes.forEach({ (node) in
                node.color = ringColor
                node.colorBlendFactor = 1
            })
        }
    }
    
    public func startAnimating(with cycleDuration: TimeInterval = 5) {
        if !isAnimating {
            isAnimating = true
            loaderScene?.startAnimating(with: cycleDuration)
        }
    }
    
    public func stopAnimating() {
        isAnimating = false
        loaderScene?.stopAnimating()
    }

    func setupScene() {
        let scene = HPCircleScene(size: frame.size)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        loaderScene = scene
        self.presentScene(scene)
        self.ignoresSiblingOrder = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupScene()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupScene()
    }
}

class HPCircleScene: SKScene {
    public var circleNodes = [SKSpriteNode]()
    private static let textures = [HPCircleKit.imageOfCircle0(),
                                   HPCircleKit.imageOfCircle1(),
                                   HPCircleKit.imageOfCircle2(),
                                   HPCircleKit.imageOfCircle3(),
                                   HPCircleKit.imageOfCircle4()]
    
    override func didMove(to view: SKView) {
        for i in 0...4 {
            let image = HPCircleScene.textures[i]
            let texture = SKTexture(image: image)
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
