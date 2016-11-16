//
//  GameScene.swift
//  Block Buster
//
//  Created by Conner on 11/16/16.
//  Copyright © 2016 Bugz 4 Dayz. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var levelNum:String = "1"

    var totalScore:Int = 0
    // FIXME: ** Not crazy about having to initialize a GameViewController here **
    var sceneManager:SceneManager = GameViewController()
    
    var playableRect = CGRect.zero
    var totalSprites = 0
    
    let levelLabel = SKLabelNode(fontNamed: "Futura")
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var spritesMoving = false
    
    var tapCount = 0
    
    var redLeft = 0
    
    var gameOver = false
    var gameWon = true
    
    var BustableShapes = [SKNode]()
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    // MARK: - Initialization -
    
    // can't override SKScene(fileNamed:) easily, so we'll
    // create a class factory method to handle initialization
    class func loadLevel(_ levelNum: String, size: CGSize, scaleMode:SKSceneScaleMode, sceneManager:SceneManager) -> GameScene?{
        let scene = GameScene(fileNamed: "Level\(levelNum)")!
        scene.levelNum = levelNum
        scene.size = size
        scene.scaleMode = scaleMode
        scene.sceneManager = sceneManager
        return scene
    }

    
    override func didMove(to view: SKView) {
        playableRect = getPlayableRectPhonePortrait(size: size)
        setupSpritesAndPhysics()
    }
    
    func setupSpritesAndPhysics(){
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        
        // HOOK UP TO SPRITES IN SCENE FILES

        for node in children{
            print("we checking a node")
            print(node.name)
            if node.name == "RedSquare" || node.name == "GreenSquare" || node.name == "BlueSquare"{
                node.physicsBody = SKPhysicsBody(rectangleOf: node.frame.size)
            }
            if node.name == "RedCircle" || node.name == "GreenCircle" || node.name == "BlueCircle"{
                node.physicsBody = SKPhysicsBody(circleOfRadius: node.frame.size.width/2)
            }
            if node.name == "RedTriangle" || node.name == "GreenTriangle" || node.name == "BlueTriangle"{
                let trianglePath = CGMutablePath()
                trianglePath.move(to: CGPoint(x:-node.frame.size.width/2, y:-node.frame.size.height/2))
                trianglePath.addLine(to: CGPoint(x:node.frame.size.width/2,y: -node.frame.size.height/2))
                trianglePath.addLine(to: CGPoint(x: 0, y:node.frame.size.height/2))
                trianglePath.addLine(to: CGPoint(x: -node.frame.size.width/2, y:-node.frame.size.height/2))
                node.physicsBody = SKPhysicsBody(polygonFrom: trianglePath)
            }
            if node.name == "RedSquare" || node.name == "BlueSquare" || node.name == "RedCircle" || node.name == "BlueCircle" || node.name == "RedTriangle" ||  node.name == "BlueTriangle"{
                BustableShapes.append(node)
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            for shape in BustableShapes{
                if shape.contains(location){
                    shape.removeFromParent()
                }
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        var winner = true
        for node in children {
            if node.name == "GreenSquare" || node.name == "GreenCircle" || node.name == "GreenTriangle"{
                if node.position.y < playableRect.minY - node.frame.height{
                    gameOver = true
                }
            }
            if node.name == "RedSquare" || node.name == "RedCircle" || node.name == "RedTriangle" {
                if node.position.y > playableRect.minY - node.frame.height{
                    winner = false
                }
            }
        }
        gameWon = winner
        
        if gameWon || gameOver {
            physicsWorld.speed = 0.0
        }
    }
}
