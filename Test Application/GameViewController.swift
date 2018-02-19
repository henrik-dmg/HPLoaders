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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hpView = HPCircleLoader(frame: CGRect(x: 0, y: 100, width: self.view.frame.width / 4, height: self.view.frame.width / 4))
        self.view.addSubview(hpView)
        
        hpBall = HPBallLoader(frame: CGRect(x: self.view.frame.width / 4, y: 100, width: self.view.frame.width / 4, height: self.view.frame.width / 4))
        self.view.addSubview(hpBall)
    }

    @IBAction func start(_ sender: Any) {
        hpView.startAnimating()
        hpBall.startAnimating()
    }
    
    @IBAction func stop(_ sender: Any) {
        hpView.stopAnimating()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
