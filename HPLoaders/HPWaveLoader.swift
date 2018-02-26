//
//  HPWaveLoader.swift
//  Test Application
//
//  Created by Henrik Panhans on 19.02.18.
//  Copyright © 2018 Henrik Panhans. All rights reserved.
//

import UIKit
import SpriteKit

@objc public enum WaveAmplitude: Int {
    case full = 2;
    case half = 4;
    case quarter = 8;
}

@IBDesignable public class HPWaveLoader: SKView {
    
    private var loaderScene: HPWaveScene?
    public var isAnimating: Bool = false
    
    @IBInspectable public var dotColor: UIColor = UIColor.white {
        didSet {
            loaderScene?.dotColor = dotColor
        }
    }
    
    @IBInspectable public var amplitude: WaveAmplitude = WaveAmplitude.full {
        didSet {
            loaderScene?.amplitude = amplitude
        }
    }
    
    @IBInspectable public var numberOfDots: Int = 3 {
        didSet {
            loaderScene?.makeDots(count: numberOfDots)
        }
    }
    
    public func startAnimating(with waveSpeed: TimeInterval = 3) {
        if !isAnimating {
            isAnimating = true
            loaderScene?.startAnimating(with: waveSpeed)
        }
    }
    
    public func stopAnimating() {
        isAnimating = false
        loaderScene?.stopAnimating()
    }
    
    func setupScene() {
        let scene = HPWaveScene(size: frame.size)
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

class HPWaveScene: SKScene {
    
    var dots = [SKShapeNode]()
    var numberOfDots = 5
    
    var dotColor = UIColor.white {
        didSet {
            dots.forEach { (dot) in
                dot.fillColor = dotColor
            }
        }
    }
    
    private var dotWidth: CGFloat = 10.00
    public var amplitude: WaveAmplitude = WaveAmplitude.full
    
    func makeDots(count: Int) {
        dots.forEach { (dot) in
            dot.removeFromParent()
        }
        dots.removeAll()
        
        let dotWidth = self.size.width / CGFloat(2 * count - 1)
        self.dotWidth = dotWidth
        for i in 0...(count - 1) {
            let dot = SKShapeNode(circleOfRadius: dotWidth / 2)
            let pos = CGPoint(x: (self.size.width) - (dotWidth / 2 + (dotWidth * 2 * CGFloat(i))), y: 0)
            dot.position = pos
            dot.lineWidth = 0
            dot.alpha = 0
            dot.fillColor = dotColor
            dots.append(dot)
            self.addChild(dot)
        }
        
        print("number of balls", dots.count)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        makeDots(count: numberOfDots)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimating(with waveSpeed: TimeInterval = 3) {
        let initial = SKAction.moveTo(y: (self.size.height / CGFloat(amplitude.rawValue)) - (dotWidth / 2), duration: waveSpeed / 4)
        initial.timingMode = .easeOut
        
        let down = SKAction.moveTo(y: (-self.size.height / CGFloat(amplitude.rawValue)) + (dotWidth / 2), duration: waveSpeed / 2)
        down.timingMode = .easeInEaseOut
        let up = initial
        up.duration = waveSpeed / 2
        up.timingMode = .easeInEaseOut
        let sequence = SKAction.sequence([down, up])
        
        for i in 0...(dots.count - 1) {
            let dot = dots[i]
            let delay = SKAction.wait(forDuration: Double(i) * (waveSpeed / Double(numberOfDots * 2)))
            
            dot.fadeIn()
            dot.run(SKAction.sequence([delay, initial]), completion: {
                dot.run(SKAction.repeatForever(sequence))
            })
        }
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

extension SKNode {
    func fadeIn(_ duration: TimeInterval = 0.5) {
        self.run(SKAction.fadeIn(withDuration: duration))
    }
    
    func fadeOut(_ duration: TimeInterval = 0.5) {
        self.run(SKAction.fadeOut(withDuration: duration))
    }
}


