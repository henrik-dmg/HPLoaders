//
//  HPProgressLoader.swift
//  HPLoaders
//
//  Created by Henrik Panhans on 21.02.18.
//  Copyright © 2018 Henrik Panhans. All rights reserved.
//

import UIKit
import SpriteKit

@IBDesignable class HPProgressLoader: SKView {
    
    private var loaderScene: HPProgressScene?
    
    func startAnimating() {
        loaderScene?.startAnimating()
    }
    
    func stopAnimating() {
        loaderScene?.stopAnimating()
    }
    
    func setupScene() {
        let scene = HPProgressScene(size: frame.size)
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
    
    required init?(coder aDecoder: NSCoder) {
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
    
    private var line: SKShapeNode?
    
    override init(size: CGSize) {
        super.init(size: size)
        setupScene()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScene() {
        let line = SKShapeNode(rectOf: CGSize(width: self.size.width, height: 2), cornerRadius: 1)
        line.fillColor = lineColor
        line.lineWidth = 0
        line.position = CGPoint(x: self.size.width / 2, y: 0)
        self.addChild(line)
    }
    
    func startAnimating(withDurations pulse: TimeInterval = 0.5, restore: TimeInterval = 1) {
        
    }
    
    func stopAnimating() {
        
    }
}
