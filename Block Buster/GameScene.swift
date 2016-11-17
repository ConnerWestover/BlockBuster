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
    
    let levelLabel = SKLabelNode(fontNamed: GameData.font.mainFont)
    let winLabel = SKLabelNode(fontNamed: GameData.font.mainFont);
    let loseLabel = SKLabelNode(fontNamed: GameData.font.mainFont);
    let nextLevelLabel = SKLabelNode(fontNamed: GameData.font.mainFont);
    let playAgainLabel = SKLabelNode(fontNamed: GameData.font.mainFont);
    let mainMenuLabel = SKLabelNode(fontNamed: GameData.font.mainFont);
    var bg = SKSpriteNode(color: SKColor.init(red: 0, green: 1, blue: 0, alpha: 0.5), size:CGSize.zero)
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var spritesMoving = false
    
    var tapCount = 0
    var redLeft = 0
    
    var gameOver = false{
        didSet{
            if gameOver {
                bg.size = playableRect.size
                bg.color = SKColor.init(red: 1, green: 0, blue: 0, alpha: 0.5)
                bg.position = CGPoint(x:playableRect.midX, y:playableRect.midY)
                if(bg.parent == nil){
                    addChild(bg)
                    
                }
                if(loseLabel.parent == nil){
                    addChild(loseLabel)
                }
                addButtons()
            }
        }
    }
    var gameWon = false {
        didSet{
            if gameWon {
                bg.size = playableRect.size
                bg.color = SKColor.init(red: 0, green: 1, blue: 0, alpha: 0.5)
                bg.position = CGPoint(x:playableRect.midX, y:playableRect.midY)
                if(bg.parent == nil){
                    addChild(bg)
                    
                }
                if(winLabel.parent == nil){
                    addChild(winLabel)
                }
                addButtons()
                updateCompletedForLevel(num: Int(levelNum)!, comp: true)
                updateClicksForLevel(num: Int(levelNum)!, clicks: tapCount)
                updateAvailabilityForLevel(num: (Int(levelNum)!) + 1, avail: true)
            }
        }
    }
    
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
        setupUI()
        setupSpritesAndPhysics()
    }
    
    func addButtons(){
        if(playAgainLabel.parent == nil){
            let grayBox = SKSpriteNode.init(color: SKColor.lightGray, size: CGSize(width: 300, height: 60))
            grayBox.position = playAgainLabel.position
            addChild(grayBox)
            addChild(playAgainLabel)
        }
        if(nextLevelLabel.parent == nil){
            let grayBox = SKSpriteNode.init(color: SKColor.lightGray, size: CGSize(width: 300, height: 60))
            grayBox.position = nextLevelLabel.position
            addChild(grayBox)
            addChild(nextLevelLabel)
        }
        if(mainMenuLabel.parent == nil){
            let grayBox = SKSpriteNode.init(color: SKColor.lightGray, size: CGSize(width: 300, height: 60))
            grayBox.position = mainMenuLabel.position
            addChild(grayBox)
            addChild(mainMenuLabel)
        }
    }
    
    func setupUI(){
        levelLabel.position = CGPoint(x: playableRect.minX + 20,y: playableRect.maxY - 20)
        levelLabel.verticalAlignmentMode = .top
        levelLabel.horizontalAlignmentMode = .left
        levelLabel.text = "Level " + levelNum
        levelLabel.fontName = GameData.font.mainFont
        levelLabel.fontSize = GameData.hud.fontSize
        levelLabel.fontColor = GameData.hud.fontColorWhite
        addChild(levelLabel)
        
        winLabel.position = CGPoint(x: playableRect.midX,y: playableRect.maxY * 0.7)
        winLabel.verticalAlignmentMode = .center
        winLabel.horizontalAlignmentMode = .center
        winLabel.text = "You Win!"
        winLabel.fontName = GameData.font.mainFont
        winLabel.fontSize = GameData.hud.fontSize
        winLabel.fontColor = GameData.hud.fontColorWhite
        
        loseLabel.position = CGPoint(x: playableRect.midX,y: playableRect.maxY * 0.7)
        loseLabel.verticalAlignmentMode = .center
        loseLabel.horizontalAlignmentMode = .center
        loseLabel.text = "You Lost!"
        loseLabel.fontName = GameData.font.mainFont
        loseLabel.fontSize = GameData.hud.fontSize
        loseLabel.fontColor = SKColor.black
        
        playAgainLabel.position = CGPoint(x: playableRect.midX,y: playableRect.maxY * 0.4)
        playAgainLabel.verticalAlignmentMode = .center
        playAgainLabel.horizontalAlignmentMode = .center
        playAgainLabel.text = "Play Again"
        playAgainLabel.fontSize = GameData.hud.fontSize * 0.75
        playAgainLabel.fontName = GameData.font.mainFont
        playAgainLabel.fontColor = SKColor.white
        
        nextLevelLabel.position = CGPoint(x: playableRect.midX,y: playableRect.maxY * 0.55)
        nextLevelLabel.verticalAlignmentMode = .center
        nextLevelLabel.horizontalAlignmentMode = .center
        nextLevelLabel.text = "Next Level"
        nextLevelLabel.fontSize = GameData.hud.fontSize * 0.75
        nextLevelLabel.fontName = GameData.font.mainFont
        nextLevelLabel.fontColor = SKColor.white
        
        mainMenuLabel.position = CGPoint(x: playableRect.midX,y: playableRect.maxY * 0.25)
        mainMenuLabel.verticalAlignmentMode = .center
        mainMenuLabel.horizontalAlignmentMode = .center
        mainMenuLabel.text = "Main Menu"
        mainMenuLabel.fontSize = GameData.hud.fontSize * 0.75
        mainMenuLabel.fontName = GameData.font.mainFont
        mainMenuLabel.fontColor = SKColor.white
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
                    tapCount += 1
                }
            }
            
            if nextLevelLabel.contains(location) {
                sceneManager.loadGameScene(levelNum: (Int(levelNum)! + 1).description)
            }
            
            if playAgainLabel.contains(location) {
                sceneManager.loadGameScene(levelNum: levelNum)
            }
            
            if mainMenuLabel.contains(location) {
                sceneManager.loadLevelSelectionScene()
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
