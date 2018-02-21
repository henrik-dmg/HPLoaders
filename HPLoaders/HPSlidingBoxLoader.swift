//
//  HPSlidingBoxLoader.swift
//  HPLoaders
//
//  Created by Henrik Panhans on 20.02.18.
//  Copyright © 2018 Henrik Panhans. All rights reserved.
//

import UIKit
import SpriteKit

@IBDesignable class HPSlidingBoxLoader: SKView {
    
    private var loaderScene: HPSlidingBoxScene?
    
    @IBInspectable var boxColor: UIColor = UIColor.white {
        didSet {
            loaderScene?.boxColor = boxColor
        }
    }
    
    func startAnimating() {
        loaderScene?.startAnimating()
    }
    
    func stopAnimating() {
        loaderScene?.stopAnimating()
    }
    
    func setupScene() {
        let scene = HPSlidingBoxScene(size: frame.size)
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupScene()
    }
}

class HPSlidingBoxScene: SKScene {
    
    public var boxColor = UIColor.white {
        didSet {
            setupScene()
        }
    }
    
    var boxes = [SKShapeNode]()
    var i: Int = 0
    private var timer: Timer?
    private var xPositions = [CGFloat]()
    private var boxHeight = 10
    
    override init(size: CGSize) {
        super.init(size: size)
        setupScene()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScene() {
        xPositions.removeAll()
        boxes.forEach { (box) in
            box.removeFromParent()
        }
        boxes.removeAll()
        
        let boxSize = CGSize(width: (self.scene!.size.width) / 9, height: (self.scene!.size.width) / 9)
        boxHeight = Int(boxSize.height)
        
        for i in 0...4 {
            let square = SKShapeNode(rectOf: boxSize, cornerRadius: boxSize.height / 4)
            if i == 0 {
                square.fillColor = boxColor
            }
            
            square.strokeColor = boxColor
            square.alpha = 0
            square.position = CGPoint(x: (boxSize.width / 2) + (boxSize.width * 2 * CGFloat(i)), y: 0)
            self.addChild(square)
            boxes.append(square)
            xPositions.append(square.position.x)
        }
    }
    
    func startAnimating() {
        i = 0
        boxes.forEach { (box) in
            box.fadeIn()
            if box.position.x == self.xPositions[0] {
                box.fillColor = boxColor
            } else {
                box.fillColor = .clear
            }
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(iterateThroughBoxes), userInfo: nil, repeats: true)
    }
    
    @objc func iterateThroughBoxes() {
        if let firstNode = self.atPoint(CGPoint(x: self.xPositions[self.i], y: 0)) as? SKShapeNode {
            if self.i == self.boxes.count - 1 {
                shiftBoxes()
            } else {
                firstNode.fillColor = .clear
                self.i += 1
                if let nextNode = self.atPoint(CGPoint(x: self.xPositions[self.i], y: 0)) as? SKShapeNode {
                    nextNode.fillColor = boxColor
                }
            }
        }
    }
    
    private func shiftBoxes() {
        timer?.invalidate()
        if let firstNode = self.atPoint(CGPoint(x: self.xPositions[self.i], y: 0)) as? SKShapeNode {
            let moveUp = SKAction.moveBy(x: 0, y: CGFloat(self.boxHeight + 10), duration: 0.25)
            let moveToBeginning = SKAction.moveTo(x: xPositions[0], duration: 0.5)
            let moveDown = moveUp.reversed()
            let sequence = SKAction.sequence([moveUp, moveToBeginning, moveDown])
            firstNode.run(sequence, completion: {
                self.i = 0
                self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.iterateThroughBoxes), userInfo: nil, repeats: true)
            })
            
            for i in 0...boxes.count - 2 {
                if let firstNode = self.atPoint(CGPoint(x: self.xPositions[i], y: 0)) as? SKShapeNode {
                    firstNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.25), SKAction.moveTo(x: self.xPositions[i + 1], duration: 0.3)]))
                }
            }
        }
    }
    
    func stopAnimating() {
        timer?.invalidate()
        i = 0
        boxes.forEach { (box) in
            box.run(SKAction.fadeOut(withDuration: 0.5), completion: {
                if box.position.x == self.xPositions[0] {
                    box.fillColor = self.boxColor
                } else {
                    box.fillColor = .clear
                }
            })
        }
    }
}


