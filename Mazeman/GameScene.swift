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
    var onScreenStar : SKSpriteNode!
    var star : SKSpriteNode!
    var starLabel : SKLabelNode!
    var onScreenRock : SKSpriteNode!
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
    var foodImage : SKSpriteNode!
    var hBlocks = [Bool](repeating: false, count: 14)
    var wBlocks = [Bool](repeating: false, count: 16)
    var blockCounter = 0
    var numRocks = 10
    var numHearts = 3
    var batteryNum = 100
    var starVisible = false
    var foodVisible = false
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
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
        displayFireBall()
        addRandBlocks()
        displayStar()
        displayFood()
        Timer.scheduledTimer(timeInterval: 15 , target: self, selector: #selector(displayRex), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 12, target: self, selector: #selector(displayFireBall), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 18, target: self, selector: #selector(displayTri), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(displayPtero), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(addRandBlocks), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 25, target: self, selector: #selector(gravityMode), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(addRocks), userInfo: nil, repeats: true)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(subEnergy), userInfo: nil, repeats: true)
        
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
    func gravityMode(){
        label.text = "Gravity is coming soon"
        label.fontColor = SKColor.red
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(caveGravityON), userInfo: nil, repeats: false)
        
    }
    func caveGravityON(){
        caveManNode.physicsBody?.affectedByGravity = true
        label.text = "Gravity ON"
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(caveGravityOFF), userInfo: nil, repeats: false)
    }
    func caveGravityOFF(){
        caveManNode.physicsBody?.affectedByGravity = false
        label.text = "Gravity Off"
        label.fontColor = SKColor.black
    }
    
    func tapBlurButton(_ sender: UITapGestureRecognizer) {
        var touchLocation: CGPoint = sender.location(in: sender.view)
        touchLocation = self.convertPoint(fromView: touchLocation)
        throwRock(touch: touchLocation)
        print("Tapped")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == PhysicsCategory.caveman || contact.bodyB.categoryBitMask == PhysicsCategory.newblock {
            print("caveman hit wall")
            caveManNode.removeAllActions()
        }
        else if contact.bodyA.categoryBitMask == PhysicsCategory.newblock || contact.bodyB.categoryBitMask == PhysicsCategory.caveman {
            print("Wall hit Caveman")
            caveManNode.removeAllActions()
        }
        else{
            print("something else happened")
        }
    }
    
    func handleSwipe(gesture: UISwipeGestureRecognizer){
        
        //caveManNode.physicsBody?.affectedByGravity = true
        var swipeUp = (Int(caveManNode.position.y) - 656) / 100
        var swipeDown = (Int(caveManNode.position.y) - 64) / 100
        var swipeLeft = (32 - Int(caveManNode.position.x)) / 100
        var swipeRight = (992 - Int(caveManNode.position.x)) / 100
        
        if let swipeRecognized = gesture as? UISwipeGestureRecognizer{
            if(swipeRecognized.direction == UISwipeGestureRecognizerDirection.up){
                let move = SKAction.move(to: CGPoint(x: caveManNode.position.x, y: 656), duration: 7)
                self.caveManNode.run(move)
            }
            else if(swipeRecognized.direction == UISwipeGestureRecognizerDirection.down){
                let move = SKAction.move(to: CGPoint(x: caveManNode.position.x, y: 64), duration: 7)
                self.caveManNode.run(move)
            }
            else if(swipeRecognized.direction == UISwipeGestureRecognizerDirection.left){
                let move = SKAction.move(to: CGPoint(x: 32, y: caveManNode.position.y), duration: 7)
                self.caveManNode.run(move)
            }
            else if(swipeRecognized.direction == UISwipeGestureRecognizerDirection.right){
                let move = SKAction.move(to: CGPoint(x: 992, y: caveManNode.position.y), duration: 7)
                self.caveManNode.run(move)
            }
            else{print("not working")}
        }
    }
    
    func addRockAudio(){
        let a = SKAudioNode(fileNamed: "rock.wav")
        a.autoplayLooped = false
        addChild(a)
        a.run(SKAction.playSoundFileNamed("rock.wav", waitForCompletion: false))
        
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
    
    func displayStar(){
        var randHNum = Int(arc4random_uniform(8))
        var randWNum = Int(arc4random_uniform(16))
        
        while(starVisible == false){
            if(hBlocks[randHNum] == false && wBlocks[randWNum] == false){
                var xVal = (randWNum*64) + 30
                var yVal = (randHNum*64) + 94
                addStar(x: xVal, y: yVal)
                hBlocks[randHNum] = true
                wBlocks[randWNum] = true
                starVisible = true
            }
        }
    }
    
    func addStar(x: Int, y: Int){
        onScreenStar = SKSpriteNode(imageNamed: "star")
        onScreenStar.position = CGPoint(x: x, y: y)
        onScreenStar.size = CGSize(width: 64, height: 64)
        onScreenStar.physicsBody = SKPhysicsBody(rectangleOf: onScreenStar.size)
        addStarBitMasks()
        onScreenStar.physicsBody?.isDynamic = false
        onScreenStar.physicsBody?.affectedByGravity = false
        onScreenStar.zPosition = 3.0
        self.addChild(onScreenStar)
    }
    func displayFood(){
        var randHNum = Int(arc4random_uniform(8))
        var randWNum = Int(arc4random_uniform(16))
        
        while(foodVisible == false){
            if(hBlocks[randHNum] == false && wBlocks[randWNum] == false){
                var xVal = (randWNum*64) + 30
                var yVal = (randHNum*64) + 94
                addFood(x: xVal, y: yVal)
                hBlocks[randHNum] = true
                wBlocks[randWNum] = true
                foodVisible = true
            }
        }
    }
    
    func addFood(x: Int, y: Int){
        foodImage = SKSpriteNode(imageNamed: "food")
        foodImage.position = CGPoint(x: x, y: y)
        foodImage.size = CGSize(width: 64, height: 64)
        foodImage.physicsBody = SKPhysicsBody(rectangleOf: foodImage.size)
        foodImage.physicsBody?.isDynamic = false
        foodImage.physicsBody?.affectedByGravity = false
        foodImage.zPosition = 3.0
        self.addChild(foodImage)
    }
    
    func addGroundBlocks(){
        
        for i in 0 ..< 17 {
            
            block = SKSpriteNode(imageNamed: "block")
            waterBlock = SKSpriteNode(imageNamed: "water")
            secondWaterBlock = SKSpriteNode(imageNamed: "water")
            
            var xval = 30 + (i*64)
            
            if(i == 5 || i == 10){
                waterBlock.position = CGPoint(x: 350, y: 33)
                waterBlock.size = CGSize(width: 64, height: 64)
                secondWaterBlock.position = CGPoint(x:670, y:33)
                secondWaterBlock.size = CGSize(width: 64, height: 64)
                waterBlock.physicsBody = SKPhysicsBody(rectangleOf: waterBlock.size)
                secondWaterBlock.physicsBody = SKPhysicsBody(rectangleOf: secondWaterBlock.size)
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
        rockLabel.text = String(numRocks)
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
        heartLabel.text = String(numHearts)
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
        batteryLabel.text = String(batteryNum)
        batteryLabel.fontColor = SKColor.black
        batteryLabel.horizontalAlignmentMode  = .center
        batteryLabel.verticalAlignmentMode = .center
        battery.addChild(batteryLabel)
        batteryLabel.zPosition = 3.0
    }
    
    func addBrick(x: Int, y: Int){
        newBlockImageNode = SKSpriteNode(imageNamed: "block")
        newBlockImageNode.position = CGPoint(x: x, y: y)
        newBlockImageNode.size = CGSize(width: 64, height: 64)
        newBlockImageNode.physicsBody = SKPhysicsBody(rectangleOf: newBlockImageNode.size)
        addNewBlockManBitMasks()
        newBlockImageNode.physicsBody?.isDynamic = false
        newBlockImageNode.physicsBody?.affectedByGravity = false
        newBlockImageNode.zPosition = 3.0
        self.addChild(newBlockImageNode)
    }
    
    
    func addRandBlocks(){
        var randHNum = Int(arc4random_uniform(8))
        var randWNum = Int(arc4random_uniform(16))
        var truther = false
        
        while(truther == false && blockCounter < 15){
            if(hBlocks[randHNum] == false && wBlocks[randWNum] == false && blockCounter < 15){
                var xVal = (randWNum*64) + 30
                var yVal = (randHNum*64) + 94
                addBrick(x: xVal, y: yVal)
                hBlocks[randHNum] = true
                wBlocks[randWNum] = true
                blockCounter += 1
                truther = true
            }
            else if(hBlocks[randHNum] == false && wBlocks[randWNum] == true && blockCounter < 15){
                var xVal = (randWNum*64) + 30
                var yVal = (randHNum*64) + 94
                addBrick(x: xVal, y: yVal)
                hBlocks[randHNum] = true
                wBlocks[randWNum] = true
                blockCounter += 1
                truther = true
            }
            else if(hBlocks[randHNum] == true && wBlocks[randWNum] == false && blockCounter < 15){
                var xVal = (randWNum*64) + 30
                var yVal = (randHNum*64) + 94
                addBrick(x: xVal, y: yVal)
                hBlocks[randHNum] = true
                wBlocks[randWNum] = true
                blockCounter += 1
                truther = true
            }

            else{
                randHNum = Int(arc4random_uniform(8))
                randWNum = Int(arc4random_uniform(16))
            }
        }
    }
    func addCaveMan(){
        caveManNode = SKSpriteNode(imageNamed: "caveman")
        caveManNode.position = CGPoint(x: 37, y: 97)
        caveManNode.size = CGSize(width: 75, height: 75)
        addCaveManBitMasks()
        self.addChild(caveManNode)
        caveManNode.zPosition = 3.0
        caveManNode.physicsBody = SKPhysicsBody(rectangleOf: caveManNode.size)
        caveManNode.physicsBody?.isDynamic = true
        caveManNode.physicsBody?.affectedByGravity = false
        caveManNode.physicsBody?.allowsRotation = false
        
    }
    
    func displayRex(){
        tRexImage = SKSpriteNode(imageNamed: "dino2")
        let randNum = arc4random_uniform(600)+80
        tRexImage.position = CGPoint(x: 1100, y: Int(randNum))
        tRexImage.size = CGSize(width: 64, height: 64)
        tRexImage.physicsBody = SKPhysicsBody(rectangleOf: tRexImage.size)
        addRexBitMasks()
        tRexImage.physicsBody?.isDynamic = false
        tRexImage.physicsBody?.affectedByGravity = false
        tRexImage.zPosition = 3.0
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
        addTriBitMasks()
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
        addFireBallBitMasks()
        fireBall.physicsBody?.isDynamic = false
        fireBall.physicsBody?.affectedByGravity = false
        fireBall.zPosition = 3.0
        
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
    
    func subEnergy(){
        if(batteryNum > 0 && numHearts > 0){
            batteryNum -= 1
            batteryLabel.text = String(batteryNum)
            if(batteryNum == 0){
                numHearts -= 1
                batteryNum = 100
                batteryLabel.text = String(batteryNum)
                heartLabel.text = String(numHearts)
            }
            if(numHearts == 0){
                gameOver()
            }
        }
    }
    
    func gameOver(){
        let flipTransition = SKTransition.doorsCloseHorizontal(withDuration: 1.0)
        let gameOverScene = GameOverScene(size: self.size)
        gameOverScene.scaleMode = .aspectFill
        
        self.view?.presentScene(gameOverScene, transition: flipTransition)
        
    }
    
    func throwRock(touch: CGPoint){
        if(numRocks > 0){
            //throw rock
            numRocks -= 1
            rockLabel.text = String(numRocks)
            addRockAudio()
            dispRock(touch: touch)
        }
            
        else{
            label.text = "Not enough rocks to throw"
            label.fontColor = SKColor.brown
        }
    }
    
    func addRocks(){
        if(numRocks >= 20){
            numRocks = 20
            rockLabel.text = String(numRocks)
            label.text = "Now have 20 Rocks"
            label.fontColor = SKColor.brown
        }
            
        else if(numRocks < 20 && numRocks >= 10){
            numRocks = 20
            rockLabel.text = String(numRocks)
            label.text = "Now have 20 Rocks"
            label.fontColor = SKColor.brown
        }
        else{
            numRocks += 10
            rockLabel.text = String(numRocks)
            label.text = "Gained 10 Rocks"
            label.fontColor = SKColor.brown
        }
    }
    func dispRock(touch: CGPoint){
        onScreenRock = SKSpriteNode(imageNamed: "rock")
        onScreenRock.position = caveManNode.position
        onScreenRock.size = CGSize(width: 32, height: 32)
        onScreenRock.physicsBody = SKPhysicsBody(rectangleOf: onScreenRock.size)
        //        addFireBallBitMasks()
        onScreenRock.physicsBody?.isDynamic = false
        onScreenRock.physicsBody?.affectedByGravity = false
        onScreenRock.zPosition = 3.0
        self.addChild(onScreenRock)
        
        let move = SKAction.move(to: touch, duration: 2)
        onScreenRock.run(move)
        
    }
    
    func addCaveManBitMasks(){
        
        caveManNode.physicsBody?.categoryBitMask = PhysicsCategory.caveman
        caveManNode.physicsBody?.contactTestBitMask = PhysicsCategory.tri | PhysicsCategory.trex | PhysicsCategory.newblock |  PhysicsCategory.fireBall | PhysicsCategory.waterblock | PhysicsCategory.secondwaterblock | PhysicsCategory.star
        caveManNode.physicsBody?.collisionBitMask = PhysicsCategory.newblock
    }
    func addTriBitMasks(){
        
        triImage.physicsBody?.categoryBitMask = PhysicsCategory.tri
        triImage.physicsBody?.contactTestBitMask =  PhysicsCategory.caveman
        triImage.physicsBody?.collisionBitMask = 0
    }
    func addRexBitMasks(){
        tRexImage.physicsBody?.categoryBitMask = PhysicsCategory.trex
        tRexImage.physicsBody?.contactTestBitMask =  PhysicsCategory.caveman
        tRexImage.physicsBody?.collisionBitMask = 0
    }
    func addNewBlockManBitMasks(){
        newBlockImageNode.physicsBody?.categoryBitMask = PhysicsCategory.newblock
        newBlockImageNode.physicsBody?.contactTestBitMask = PhysicsCategory.caveman | PhysicsCategory.steg
        newBlockImageNode.physicsBody?.collisionBitMask = PhysicsCategory.caveman
    }
    func addFireBallBitMasks(){
        fireBall.physicsBody?.categoryBitMask = PhysicsCategory.fireBall
        fireBall.physicsBody?.contactTestBitMask = PhysicsCategory.caveman
        fireBall.physicsBody?.collisionBitMask = 0
    }
    func addStarBitMasks(){
        onScreenStar.physicsBody?.categoryBitMask = PhysicsCategory.star
        onScreenStar.physicsBody?.contactTestBitMask = PhysicsCategory.caveman
        onScreenStar.physicsBody?.collisionBitMask = 0
    }
    
    
    struct PhysicsCategory {
        
        static let caveman: UInt32 = 0x1 << 0
        static let tri: UInt32 = 0x1 << 1
        static let trex: UInt32 = 0x1 << 2
        static let fireBall: UInt32 = 0x1 << 3
        static let steg: UInt32 = 0x1 << 4
        static let ptero: UInt32 = 0x1 << 5
        static let waterblock: UInt32 = 0x1 << 6
        static let secondwaterblock: UInt32 = 0x1 << 7
        static let newblock: UInt32 = 0x1 << 8
        static let star: UInt32 = 0x1 << 9
        static let food: UInt32 = 0x1 << 10
        
    }
    
    
}
























