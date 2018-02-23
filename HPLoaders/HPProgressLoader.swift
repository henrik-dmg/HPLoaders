//
//  HPProgressLoader.swift
//  HPLoaders
//
//  Created by Henrik Panhans on 21.02.18.
//  Copyright © 2018 Henrik Panhans. All rights reserved.
//

import UIKit
import SpriteKit

@IBDesignable public class HPProgressLoader: SKView {
    
    @IBInspectable public var lineColor: UIColor = UIColor.white {
        didSet {
            loaderScene?.lineColor = lineColor
        }
    }
    
    @IBInspectable public var barColor: UIColor = UIColor.cyan {
        didSet {
            loaderScene?.barColor = barColor
        }
    }
    
    public var animationDuration: TimeInterval = 2 {
        didSet {
            loaderScene?.animationDuration = animationDuration
        }
    }
    
    private var loaderScene: HPProgressScene?
    
    public func startAnimating(_ duration: TimeInterval = 2) {
        loaderScene?.startAnimating(duration: duration)
    }
    
    public func stopAnimating() {
        loaderScene?.stopAnimating()
    }
    
    func setupScene() {
        let scene = HPProgressScene(size: frame.size)
        scene.scaleMode = .aspectFill
        scene.backgroundColor = .clear
        scene.anchorPoint = CGPoint(x: 0, y: 0.5)
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

class HPProgressScene: SKScene {
    var lineColor: UIColor = UIColor.white {
        didSet {
            line?.fillColor = lineColor
        }
    }
    
    var barColor: UIColor = UIColor.cyan {
        didSet {
            bar?.fillColor = barColor
        }
    }
    
    var animationDuration: TimeInterval = 2 {
        didSet {
            makeAnimations(animationDuration)
        }
    }
    
    
    private var line: SKShapeNode?
    private var bar: SKShapeNode?
    private var scaleSequence: SKAction?
    private var moveSequence: SKAction?
    
    override init(size: CGSize) {
        super.init(size: size)
        setupScene()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScene() {
        let line = SKShapeNode(rectOf: CGSize(width: self.size.width, height: 1), cornerRadius: 1)
        line.fillColor = lineColor
        line.lineWidth = 0
        line.alpha = 0
        line.position = CGPoint(x: self.size.width / 2, y: 0)
        self.line = line
        self.addChild(line)
        
        let bar = SKShapeNode(rectOf: CGSize(width: self.size.width, height: 2), cornerRadius: 1)
        bar.fillColor = barColor
        bar.alpha = 0
        bar.xScale = 0
        bar.lineWidth = 0
        bar.position = CGPoint(x: 0, y: 0)
        self.bar = bar
        self.addChild(bar)
    }
    
    private func makeAnimations(_ duration: TimeInterval) {
        let sizeUp = SKAction.scaleX(to: 1, duration: duration / 2)
        sizeUp.timingMode = .easeIn
        
        let sizeDown = SKAction.scaleX(to: 0, duration: duration / 2)
        sizeDown.timingMode = .easeOut
        
        self.scaleSequence = SKAction.sequence([sizeUp, sizeDown])
        
        let moveX = SKAction.moveTo(x: self.size.width, duration: duration)
        moveX.timingMode = .easeInEaseOut
        
        let resetX = SKAction.moveTo(x: 0, duration: 0)
        
        self.moveSequence = SKAction.sequence([moveX, resetX])
    }
    
    func startAnimating(duration: TimeInterval = 2) {
        if let scale = self.scaleSequence, let move = self.moveSequence {
            line?.fadeIn()
            bar?.fadeIn()
            bar?.run(SKAction.repeatForever(scale))
            bar?.run(SKAction.repeatForever(move))
        } else {
            makeAnimations(self.animationDuration)
            startAnimating(duration: duration)
        }
    }
    
    func stopAnimating() {
        line?.fadeOut()
        bar?.run(SKAction.speed(to: 3, duration: 0.3))
        bar?.run(SKAction.fadeOut(withDuration: 0.5), completion: {
            self.bar?.xScale = 0
            self.bar?.position = CGPoint(x: 0, y: 0)
        })
    }
}
