//
//  GameScene.swift
//  MazeMan
//
//  Created by Aditya on 4/3/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    var caveManNode : SKSpriteNode!
    var blockImageNode : SKSpriteNode!
    var count = 0
    var label : SKLabelNode!
    var title : SKSpriteNode!
    var randNum = Int(arc4random_uniform(1366))
    var star : SKSpriteNode!
    var starLabel : SKLabelNode!
    var rock : SKSpriteNode!
    var rockLabel : SKLabelNode!
    var heart : SKSpriteNode!
    var heartLabel : SKLabelNode!
    var battery : SKSpriteNode!
    var batteryLabel : SKLabelNode!
    var tRexImage : SKSpriteNode!
    var triImage : SKSpriteNode!
    var pteroImage : SKSpriteNode!
    var stegImage : SKSpriteNode!
    var fireBall: SKSpriteNode!
    var newBlockImageNode : SKSpriteNode!
    var block : SKSpriteNode!
    var waterBlock : SKSpriteNode!
    var secondWaterBlock : SKSpriteNode!
    var hBlocks = [Bool](repeating: false, count: 14)
    var wBlocks = [Bool](repeating: false, count: 16)
    var blockCounter = 0
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "bg")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.alpha = 0.8
        background.zPosition = -9.0
        self.addChild(background)
        addTopBricks()
        addGroundBlocks()
        addCaveMan()
        
        displayRex()
        displayTri()
        displayPtero()
        Timer.scheduledTimer(timeInterval: 15 , target: self, selector: #selector(displayRex), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 12, target: self, selector: #selector(displayFireBall), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 18, target: self, selector: #selector(displayTri), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(displayPtero), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(addRandBlocks), userInfo: nil, repeats: true)
        
        
        let swipeUp = UISwipeGestureRecognizer()
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        swipeUp.addTarget(self, action: #selector(handleSwipe))
        self.view?.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer()
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        swipeDown.addTarget(self, action: #selector(handleSwipe))
        self.view?.addGestureRecognizer(swipeDown)
        
        let swipeLeft = UISwipeGestureRecognizer()
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        swipeLeft.addTarget(self, action: #selector(handleSwipe))
        self.view?.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer()
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        swipeRight.addTarget(self, action: #selector(handleSwipe))
        self.view?.addGestureRecognizer(swipeRight)
        
        let tap = UITapGestureRecognizer()
        //        tap.numberOfTouchesRequired = 1
        tap.addTarget(self, action: #selector(self.tapBlurButton(_:)))
        self.view?.addGestureRecognizer(tap)
        
    }
    
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        
        print("Tapped")
    }
    
    func handleSwipe(gesture: UISwipeGestureRecognizer){
        
        //caveManNode.physicsBody?.affectedByGravity = true
        
        
        if let swipeRecognized = gesture as? UISwipeGestureRecognizer{
            if(swipeRecognized.direction == UISwipeGestureRecognizerDirection.up){
                let move = SKAction.move(to: CGPoint(x: caveManNode.position.x, y: 1000), duration: 7)
                self.caveManNode.run(move)
            }
            else if(swipeRecognized.direction == UISwipeGestureRecognizerDirection.down){
                let move = SKAction.move(to: CGPoint(x: caveManNode.position.x, y: 0), duration: 7)
                self.caveManNode.run(move)
            }
            else if(swipeRecognized.direction == UISwipeGestureRecognizerDirection.left){
                let move = SKAction.move(to: CGPoint(x: 0, y: caveManNode.position.y), duration: 7)
                self.caveManNode.run(move)
            }
            else if(swipeRecognized.direction == UISwipeGestureRecognizerDirection.right){
                let move = SKAction.move(to: CGPoint(x: 1024, y: caveManNode.position.y), duration: 7)
                self.caveManNode.run(move)
            }
            else{print("not working")}
        }
    }
    
    
    func addTopBricks(){
        for i in 0 ..< 17 {
            
            let blockTop = SKSpriteNode(imageNamed: "block")
            let blockTop2 = SKSpriteNode(imageNamed: "block")
            
            var xval = 30 + (i*64)
            
            blockTop.position = CGPoint(x: xval, y: 740)
            blockTop.size = CGSize(width: 64, height: 64)
            
            blockTop2.position = CGPoint(x: xval, y: 676)
            blockTop2.size = CGSize(width: 64, height: 64)
            blockTop2.physicsBody = SKPhysicsBody(rectangleOf: blockTop2.size)
            blockTop2.physicsBody?.affectedByGravity = false
            blockTop2.physicsBody?.isDynamic = false
            self.addChild(blockTop)
            self.addChild(blockTop2)
            blockTop.zPosition = -8.0
            blockTop2.zPosition = -8.0
        }
        title = SKSpriteNode(imageNamed: "game-status-panel")
        title.position = CGPoint(x: 532, y: 705)
        title.size = CGSize(width: 925, height: 120)
        title.physicsBody?.isDynamic = false
        title.physicsBody?.affectedByGravity = false
        title.zPosition = -7.0
        self.addChild(title)
        
        
        label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = "Welcome to MazeMan"
        label.fontColor = SKColor.black
        label.horizontalAlignmentMode  = .center
        label.verticalAlignmentMode = .center
        label.zPosition = 1.0
        title.addChild(label)
    }
    
    func addCaveMan(){
        caveManNode = SKSpriteNode(imageNamed: "caveman")
        caveManNode.position = CGPoint(x: 37, y: 97)
        caveManNode.size = CGSize(width: 75, height: 75)
        self.addChild(caveManNode)
        caveManNode.physicsBody = SKPhysicsBody(rectangleOf: caveManNode.size)
        caveManNode.physicsBody?.affectedByGravity = false
        caveManNode.physicsBody?.allowsRotation = false
    }
    
    func addGroundBlocks(){
        
        for i in 0 ..< 17 {
            
            let block = SKSpriteNode(imageNamed: "block")
            let waterBlock = SKSpriteNode(imageNamed: "water")
            let secondWaterBlock = SKSpriteNode(imageNamed: "water")
            
            var xval = 30 + (i*64)
            
            if(i == 5 || i == 10){
                waterBlock.position = CGPoint(x: 350, y: 33)
                waterBlock.size = CGSize(width: 64, height: 64)
                secondWaterBlock.position = CGPoint(x:670, y:33)
                secondWaterBlock.size = CGSize(width: 64, height: 64)
                waterBlock.physicsBody?.isDynamic = false
                waterBlock.physicsBody?.affectedByGravity = false
                secondWaterBlock.physicsBody?.isDynamic = false
                secondWaterBlock.physicsBody?.affectedByGravity = false
                self.addChild(waterBlock)
                self.addChild(secondWaterBlock)
            }
            else{
                
                block.position = CGPoint(x: xval, y: 33)
                block.size = CGSize(width: 64, height: 64)
                block.zPosition = 1.0
                self.addChild(block)
                block.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 54, height: 64))
                block.physicsBody?.affectedByGravity = false
                block.physicsBody?.isDynamic = false
            }
            
        }
        star = SKSpriteNode(imageNamed: "star")
        star.position = CGPoint(x: 30, y: 33)
        star.size = CGSize(width: 64, height: 64)
        star.zPosition = 2.0
        self.addChild(star)
        
        starLabel = SKLabelNode(fontNamed: "Chalkduster")
        starLabel.text = "0"
        starLabel.fontColor = SKColor.black
        starLabel.horizontalAlignmentMode  = .center
        starLabel.verticalAlignmentMode = .center
        star.addChild(starLabel)
        starLabel.zPosition = 3.0
        
        rock = SKSpriteNode(imageNamed: "rock")
        rock.position = CGPoint(x: 94, y: 33)
        rock.size = CGSize(width: 64, height: 64)
        rock.zPosition = 2.0
        self.addChild(rock)
        
        rockLabel = SKLabelNode(fontNamed: "Chalkduster")
        rockLabel.text = "10"
        rockLabel.fontColor = SKColor.black
        rockLabel.horizontalAlignmentMode  = .center
        rockLabel.verticalAlignmentMode = .center
        rock.addChild(rockLabel)
        rockLabel.zPosition = 3.0
        
        heart = SKSpriteNode(imageNamed: "heart")
        heart.position = CGPoint(x: 158, y: 33)
        heart.size = CGSize(width: 64, height: 64)
        heart.zPosition = 2.0
        self.addChild(heart)
        
        heartLabel = SKLabelNode(fontNamed: "Chalkduster")
        heartLabel.text = "3"
        heartLabel.fontColor = SKColor.black
        heartLabel.horizontalAlignmentMode  = .center
        heartLabel.verticalAlignmentMode = .center
        heart.addChild(heartLabel)
        heartLabel.zPosition = 3.0
        
        battery = SKSpriteNode(imageNamed: "battery")
        battery.position = CGPoint(x: 222, y: 33)
        battery.size = CGSize(width: 64, height: 64)
        battery.zPosition = 2.0
        self.addChild(battery)
        
        batteryLabel = SKLabelNode(fontNamed: "Chalkduster")
        batteryLabel.text = "100"
        batteryLabel.fontColor = SKColor.black
        batteryLabel.horizontalAlignmentMode  = .center
        batteryLabel.verticalAlignmentMode = .center
        battery.addChild(batteryLabel)
        batteryLabel.zPosition = 3.0
    }
    
    
    
    
    
    func displayRex(){
        tRexImage = SKSpriteNode(imageNamed: "dino2")
        let randNum = arc4random_uniform(600)+80
        tRexImage.position = CGPoint(x: 1100, y: Int(randNum))
        tRexImage.size = CGSize(width: 64, height: 64)
        tRexImage.physicsBody = SKPhysicsBody(rectangleOf: tRexImage.size)
        tRexImage.physicsBody?.isDynamic = false
        tRexImage.physicsBody?.affectedByGravity = false
        tRexImage.zPosition = 2.0
        self.addChild(tRexImage)
        animateRex(yVal: randNum)
        
    }
    
    
    func animateRex(yVal: UInt32){
        
        let move = SKAction.move(to: CGPoint(x: 5, y: Int(yVal)), duration: 6)
        let reverse = SKAction.scaleX(to: -1.0, duration: 0)
        let flipMove = SKAction.move(to: CGPoint(x:1100, y: Int(yVal)), duration: 6)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move,reverse,flipMove,remove])
        self.tRexImage.run(sequence)
        
    }
    
    func displayTri(){
        triImage = SKSpriteNode(imageNamed: "dino1")
        let triRandNum = arc4random_uniform(2)+1
        if(triRandNum == 1){triImage.position = CGPoint(x: 350, y: -34)}
        if(triRandNum == 2){triImage.position = CGPoint(x: 670, y: -34)}
        triImage.size = CGSize(width: 64, height: 64)
        triImage.physicsBody = SKPhysicsBody(rectangleOf: tRexImage.size)
        triImage.physicsBody?.isDynamic = false
        triImage.physicsBody?.affectedByGravity = false
        triImage.zPosition = 3.0
        self.addChild(triImage)
        animateTri(yVal: triRandNum)
        
    }
    
    
    func animateTri(yVal: UInt32){
        if(yVal == 1){
            let move = SKAction.move(to: CGPoint(x: 350, y: 630), duration: 7)
            let reverse = SKAction.scaleX(to: -1.0, duration: 0)
            let flipMove = SKAction.move(to: CGPoint(x:350, y: -34), duration: 7)
            let wait = SKAction.wait(forDuration: 3)
            let sequence = SKAction.sequence([move,reverse,flipMove,wait])
            self.triImage.run(sequence)
        }
        else{
            let move = SKAction.move(to: CGPoint(x: 670, y: 630), duration: 7)
            let reverse = SKAction.scaleX(to: -1.0, duration: 0)
            let flipMove = SKAction.move(to: CGPoint(x:670, y: -34), duration: 7)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([move,reverse,flipMove,remove])
            self.triImage.run(sequence)
        }
        
    }
    
    func displayPtero(){
        pteroImage = SKSpriteNode(imageNamed: "dino4")
        pteroImage.position = CGPoint(x: 1000, y: 650)
        pteroImage.size = CGSize(width: 75, height: 64)
        pteroImage.physicsBody = SKPhysicsBody(rectangleOf: pteroImage.size)
        pteroImage.physicsBody?.isDynamic = false
        pteroImage.physicsBody?.affectedByGravity = false
        pteroImage.zPosition = 3.0
        self.addChild(pteroImage)
        animatePtero()
        
    }
    
    func displayFireBall(){
        fireBall = SKSpriteNode(imageNamed: "fire")
        fireBall.position = pteroImage.position
        fireBall.size = CGSize(width: 64, height: 64)
        fireBall.physicsBody = SKPhysicsBody(rectangleOf: fireBall.size)
        fireBall.physicsBody?.isDynamic = false
        fireBall.physicsBody?.affectedByGravity = false
        fireBall.zPosition = 4.0
        self.addChild(fireBall)
        animateFire()
        Timer.scheduledTimer(timeInterval: 12, target: self, selector: #selector(animateFire), userInfo: nil, repeats: true)
    }
    
    
    func animateFire(){
        let drop = SKAction.move(to: CGPoint(x:fireBall.position.x, y: -5), duration: 5)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([drop, remove])
        self.fireBall.run(sequence)
    }
    
    func animatePtero(){
        let move = SKAction.move(to: CGPoint(x: 0, y: 650), duration: 10)
        let flipMove = SKAction.move(to: CGPoint(x:1000, y: 650), duration: 10)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move,flipMove,remove])
        self.pteroImage.run(sequence)
        
    }
    
    func addBrick(x: Int, y: Int){
        newBlockImageNode = SKSpriteNode(imageNamed: "block")
        newBlockImageNode.position = CGPoint(x: x, y: y)
        newBlockImageNode.size = CGSize(width: 64, height: 64)
        newBlockImageNode.physicsBody = SKPhysicsBody(rectangleOf: newBlockImageNode.size)
        newBlockImageNode.physicsBody?.isDynamic = false
        newBlockImageNode.physicsBody?.affectedByGravity = false
        newBlockImageNode.zPosition = 4.0
        self.addChild(newBlockImageNode)
    }
    
    
    func addRandBlocks(){
        hBlocks = [Bool](repeating: false, count: 14)
        wBlocks = [Bool](repeating: false, count: 16)
        var randHNum = Int(arc4random_uniform(8))
        var randWNum = Int(arc4random_uniform(16))
        
        
        if(hBlocks[randHNum] == false && wBlocks[randWNum] == false && blockCounter < 15){
            var xVal = (randWNum*64) + 30
            var yVal = (randHNum*64) + 94
            addBrick(x: xVal, y: yVal)
            hBlocks[randHNum] = true
            wBlocks[randWNum] = true
            blockCounter += 1
        }
    }
    
//    func addBitMasks(){
//        
//        newBlockImageNode.physicsBody?.categoryBitMask = PhysicsCategory.newblock.rawValue
//        newBlockImageNode.physicsBody?.contactTestBitMask = PhysicsCategory.caveman.rawValue
//        newBlockImageNode.physicsBody?.collisionBitMask =  PhysicsCategory.caveman.rawValue
//        
//        caveManNode.physicsBody?.categoryBitMask = PhysicsCategory.caveman.rawValue
//        caveManNode.physicsBody?.contactTestBitMask = PhysicsCategory.dino1.rawValue
//        caveManNode.physicsBody?.collisionBitMask = PhysicsCategory.dino1.rawValue | PhysicsCategory.dino2.rawValue | PhysicsCategory.dino3.rawValue | PhysicsCategory.fireBall.rawValue | PhysicsCategory.newblock.rawValue
//        
//    }
//
//    enum PhysicsCategory : UInt32 {
//        case caveman = 1
//        case dino1 = 2
//        case dino2 = 4
//        case dino3 = 8
//        case fireBall = 16
//        case newblock = 32
//        case groundBlock = 64
//        case topblock = 128
//    }


}
























