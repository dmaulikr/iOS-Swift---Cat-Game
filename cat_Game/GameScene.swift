//
//  GameScene.swift
//  cat_Game
//
//  Created by Tomomi Tamura on 5/6/16.
//  Copyright (c) 2016 Tomomi Tamura. All rights reserved.
//

typealias CMAccelerometerHandler = (CMAccelerometerData?, NSError?) -> Void

import SpriteKit
import CoreMotion
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let manager = CMMotionManager()
    var player = SKSpriteNode()
    //var wall = SKSpriteNode()
    var cat = SKSpriteNode()
    var dog = SKSpriteNode()
    var endNode = SKSpriteNode()
    var welcomeMessage = SKLabelNode(fontNamed:"Mosamosa")
    var dogMessage = SKLabelNode()
    var catMeowSound = SKAction.playSoundFileNamed("cat7.wav", waitForCompletion: false)
    let tryAgainLabel = SKLabelNode(fontNamed: "Hiragino KAku Gothic proN")
    var resetLabel = SKLabelNode()
    var gameoverFlag = false
    
    
    override func didMoveToView(view: SKView) {
        
        
        self.physicsWorld.contactDelegate = self
        
        player = self.childNodeWithName("player") as! SKSpriteNode
        //wall = self.childNodeWithName("wall") as! SKSpriteNode
        cat = self.childNodeWithName("cat") as! SKSpriteNode
        
        endNode = self.childNodeWithName("endNode") as! SKSpriteNode
        
       // dog = self.childNodeWithName("dog") as! SKSpriteNode
        
        welcomeMessage = self.childNodeWithName("welcomeMessage") as! SKLabelNode
        welcomeMessage.fontColor = UIColor.greenColor();
        welcomeMessage.text = "Get your igloo!"
        welcomeMessage.fontSize = 80
        welcomeMessage.position = CGPoint(x: 500, y: 1600)
        self.welcomeMessage.hidden = true
        
        // initial position of cat
        //cat.position = CGPoint (x: 205.914, y: 178.794)

        manager.startAccelerometerUpdates()
        if manager.accelerometerAvailable
        {
            manager.accelerometerUpdateInterval = 0.1
        }
        
        manager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()){ (data, error) in
            
            self.physicsWorld.gravity = CGVectorMake(CGFloat((data?.acceleration.x)!) * 10, CGFloat((data?.acceleration.y)!) * 10)
            
        }
        
    }
    
    func didBeginContact(contact: SKPhysicsContact){
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        
        if bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 2 || bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 1{
            //end message
            print("You won!")
            welcomeMessage.text = "Welcome Home!"
            welcomeMessage.fontColor = UIColor.blueColor();
            welcomeMessage.hidden = false
            manager.accelerometerUpdateInterval = 0.5

        }
        else{
            welcomeMessage.hidden = true
        }
        didDogContact(contact)
    }

    
    func didDogContact(contact: SKPhysicsContact){

        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        
        if bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 3 || bodyA.categoryBitMask == 3 && bodyB.categoryBitMask == 1 {
            
            
            runAction(catMeowSound)
            
            //Action when cat touches the dogs
            welcomeMessage.text = "Try Again!"
            welcomeMessage.fontColor = UIColor.redColor();
            welcomeMessage.hidden = false
//            if manager.accelerometerAvailable
//            {
//                manager.accelerometerUpdateInterval = 4.0
//            }
            
            gameoverFlag = true;
            
            
        }
        else{
            welcomeMessage.hidden = false
        }

    }
    
    func reset(){
        gameoverFlag = false
        // set position of cat to original
        cat.position = CGPoint (x: 205.914, y: 178.794)

        welcomeMessage.text = "Get the igloo!"
        welcomeMessage.fontColor = UIColor.greenColor();
    }
    
    override func update(currentTime: CFTimeInterval){
        if(gameoverFlag == true){
            self.reset()
        }
    }

    
    //override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        
    //}
    
    //override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    //}
}
