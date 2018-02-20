//
//  GameViewController.swift
//  Test Application
//
//  Created by Henrik Panhans on 16.02.18.
//  Copyright © 2018 Henrik Panhans. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var hpView: HPCircleLoader!
    var hpBall: HPBallLoader!
    var hpWave: HPWaveLoader!
    var hpPulse: HPSquarePulseLoader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hpView = HPCircleLoader(frame: CGRect(x: 0, y: 100, width: self.view.frame.width / 4, height: self.view.frame.width / 4))
        self.view.addSubview(hpView)
        
        hpBall = HPBallLoader(frame: CGRect(x: self.view.frame.width / 3, y: 100, width: self.view.frame.width / 4, height: self.view.frame.width / 4))
        self.view.addSubview(hpBall)
        
        hpWave = HPWaveLoader(frame: CGRect(x: self.view.frame.width - self.view.frame.width / 4, y: 100, width: self.view.frame.width / 4, height: self.view.frame.width / 4))
        self.view.addSubview(hpWave)
        
        hpPulse = HPSquarePulseLoader(frame: CGRect(x: 0, y: 300, width: self.view.frame.width / 4, height: self.view.frame.width / 4))
        self.view.addSubview(hpPulse)
    }

    @IBAction func start(_ sender: Any) {
        hpView.startAnimating(with: 2)
        hpBall.startAnimating(withDurations: 0.2, restore: 1.3)
        hpWave.startAnimating(with: 1, amplitude: .half)
        hpPulse.startAnimating(with: 8, contractionFactor: 0.5)
    }
    
    @IBAction func stop(_ sender: Any) {
        hpView.stopAnimating()
        hpBall.stopAnimating()
        hpWave.stopAnimating()
    }
    
    @IBAction func randomizeWave(_ sender: Any) {
        hpBall.ball?.fillColor = .randomColor(type: .Red)
        hpWave.numberOfDots = Int(arc4random_uniform(10) + 1)
        hpWave.dotColor = .random
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension SKColor {
    enum ColorType {
        case Red
        case Blue
        case Green
    }
    
    class var random: SKColor {
        let red = CGFloat(arc4random_uniform(256))
        let green = CGFloat(arc4random_uniform(256))
        let blue = CGFloat(arc4random_uniform(256))
        
        return SKColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    class func randomColor(type: ColorType) -> SKColor {
        let major = GKRandomDistribution(randomSource: GKRandomSource(), lowestValue: 100, highestValue: 255)
        let minor = GKRandomDistribution(randomSource: GKRandomSource(), lowestValue: 0, highestValue: 70)
        
        var postRed = CGFloat(minor.nextInt())
        var postGreen = CGFloat(minor.nextInt())
        var postBlue = CGFloat(minor.nextInt())
        
        switch type {
        case .Red:
            postRed = CGFloat(major.nextInt())
        case .Green:
            postGreen = CGFloat(major.nextInt())
        case .Blue:
            postBlue = CGFloat(major.nextInt())
        }
        
        return SKColor(red: postRed/255, green: postGreen/255, blue: postBlue/255, alpha: 1)
    }
}
