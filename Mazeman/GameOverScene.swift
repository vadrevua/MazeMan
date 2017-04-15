//
//  GameOverScene.swift
//  MazeMan
//
//  Created by Aditya on 4/14/17.
//  Copyright © 2017 Aditya. All rights reserved.
//


import UIKit
import SpriteKit

class GameOverScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.text = ("Game Over")
        gameOverLabel.fontSize = 60
        
        gameOverLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        self.addChild(gameOverLabel)
        
        let button = UIButton(frame: CGRect(x: size.width/2, y: size.height/2 - 50, width: 100, height: 50))
        button.titleLabel?.text = "Try again?"
        button.titleLabel?.textColor = UIColor.white
        self.view?.addSubview(button)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
    
//        let button = UIButton(frame: CGRect(x: size.width/2, y: size.height/2 - 50, width: 100, height: 50))
//        button.titleLabel?.text = "Try again?"
//        button.titleLabel?.textColor = UIColor.white
//        self.view?.addSubview(button)
//        
//        let button = UIButton(frame: CGRect(x: 200, y: 100, width: 100, height: 50))
//        button.backgroundColor = UIColor.blue
//        button.titleLabel?.textColor = UIColor.white
//        button.titleLabel!.text = "Button"
//        
//        self.view?.addSubview(button)
        
    }

}
