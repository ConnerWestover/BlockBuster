//
//  GameScene.swift
//  Block Buster
//
//  Created by Conner on 11/16/16.
//  Copyright © 2016 Bugz 4 Dayz. All rights reserved.
//

import SpriteKit
import GameplayKit

struct ZPos {
    static let background = 1
    static let blocks = 2
    static let text = 3
    static let overlay = 4
    static let buttons = 5
    static let WinText = 6
}

class GameScene: SKScene {
    
    var levelNum:String = "1"
    var timeTillWin = 5.0

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
    let pauseLabel = SKLabelNode(fontNamed: GameData.font.mainFont);
    var bg = SKSpriteNode(color: SKColor.init(red: 0, green: 1, blue: 0, alpha: 0.5), size:CGSize.zero)
    
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var spritesMoving = false
    
    var tapCount = 0
    var redLeft = 0
    
    var pause:Bool = false{
        didSet{
            if (pause){
                makePaused()
            } else {
                unPause()
            }
        }
    }
    
    var leftFallers = [SKNode]()
    var rightFallers = [SKNode]()
    var upFallers = [SKNode]()
    
    var gameOver = false{
        didSet{
            if gameOver {
                pauseLabel.removeFromParent()
                bg.zPosition = 4
                bg.size = playableRect.size
                bg.color = SKColor.init(red: 1, green: 0, blue: 0, alpha: 0.5)
                bg.position = CGPoint(x:playableRect.midX, y:playableRect.midY)
                if(bg.parent == nil){
                    addChild(bg)
                    
                }
                if(loseLabel.parent == nil){
                    addChild(loseLabel)
                    run(SKAction.playSoundFileNamed("loss.mp3", waitForCompletion: false))
                }
                addButtons()
            }
        }
    }
    var gameWon = false {
        didSet{
            if gameWon {
                pauseLabel.removeFromParent()
                bg.zPosition = 4
                bg.size = playableRect.size
                bg.color = SKColor.init(red: 0, green: 1, blue: 0, alpha: 0.5)
                bg.position = CGPoint(x:playableRect.midX, y:playableRect.midY)
                if(bg.parent == nil){
                    addChild(bg)
                    
                }
                if(winLabel.parent == nil){
                    addChild(winLabel)
                    run(SKAction.playSoundFileNamed("yay.wav", waitForCompletion: false))
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
            grayBox.zPosition = 5
            addChild(grayBox)
            addChild(playAgainLabel)
        }
        if(nextLevelLabel.parent == nil && gameWon){
            let grayBox = SKSpriteNode.init(color: SKColor.lightGray, size: CGSize(width: 300, height: 60))
            grayBox.position = nextLevelLabel.position
            grayBox.zPosition = 5
            addChild(grayBox)
            addChild(nextLevelLabel)
        }
        if(mainMenuLabel.parent == nil){
            let grayBox = SKSpriteNode.init(color: SKColor.lightGray, size: CGSize(width: 300, height: 60))
            grayBox.position = mainMenuLabel.position
            grayBox.zPosition = 5
            addChild(grayBox)
            addChild(mainMenuLabel)
        }
    }
    
    func setupUI(){
        levelLabel.position = CGPoint(x: playableRect.minX + 20,y: playableRect.maxY - 20)
        levelLabel.verticalAlignmentMode = .top
        levelLabel.horizontalAlignmentMode = .left
        levelLabel.text = "Level " + levelNum
        levelLabel.zPosition = 2
        levelLabel.fontName = GameData.font.mainFont
        levelLabel.fontSize = GameData.hud.fontSize
        levelLabel.fontColor = GameData.hud.fontColorWhite
        addChild(levelLabel)
        
        winLabel.position = CGPoint(x: playableRect.midX,y: playableRect.maxY * 0.7)
        winLabel.verticalAlignmentMode = .center
        winLabel.horizontalAlignmentMode = .center
        winLabel.text = "You Win!"
        winLabel.zPosition = 6
        winLabel.fontName = GameData.font.mainFont
        winLabel.fontSize = GameData.hud.fontSize
        winLabel.fontColor = GameData.hud.fontColorWhite
        
        loseLabel.position = CGPoint(x: playableRect.midX,y: playableRect.maxY * 0.7)
        loseLabel.verticalAlignmentMode = .center
        loseLabel.horizontalAlignmentMode = .center
        loseLabel.text = "You Lost!"
        loseLabel.zPosition = 6
        loseLabel.fontName = GameData.font.mainFont
        loseLabel.fontSize = GameData.hud.fontSize
        loseLabel.fontColor = SKColor.black
        
        playAgainLabel.position = CGPoint(x: playableRect.midX,y: playableRect.maxY * 0.4)
        playAgainLabel.verticalAlignmentMode = .center
        playAgainLabel.horizontalAlignmentMode = .center
        playAgainLabel.text = "Play Again"
        playAgainLabel.zPosition = 6
        playAgainLabel.fontSize = GameData.hud.fontSize * 0.75
        playAgainLabel.fontName = GameData.font.mainFont
        playAgainLabel.fontColor = SKColor.white
        
        nextLevelLabel.position = CGPoint(x: playableRect.midX,y: playableRect.maxY * 0.25)
        nextLevelLabel.verticalAlignmentMode = .center
        nextLevelLabel.horizontalAlignmentMode = .center
        nextLevelLabel.text = "Next Level"
        nextLevelLabel.zPosition = 6
        nextLevelLabel.fontSize = GameData.hud.fontSize * 0.75
        nextLevelLabel.fontName = GameData.font.mainFont
        nextLevelLabel.fontColor = SKColor.white
        
        mainMenuLabel.position = CGPoint(x: playableRect.midX,y: playableRect.maxY * 0.55)
        mainMenuLabel.verticalAlignmentMode = .center
        mainMenuLabel.horizontalAlignmentMode = .center
        mainMenuLabel.text = "Main Menu"
        mainMenuLabel.zPosition = 6
        mainMenuLabel.fontSize = GameData.hud.fontSize * 0.75
        mainMenuLabel.fontName = GameData.font.mainFont
        mainMenuLabel.fontColor = SKColor.white
        
        pauseLabel.position = CGPoint(x: playableRect.maxX - 20,y: playableRect.maxY - 20)
        pauseLabel.verticalAlignmentMode = .top
        pauseLabel.horizontalAlignmentMode = .right
        pauseLabel.text = "Pause/Reset"
        pauseLabel.zPosition = 6
        pauseLabel.fontSize = GameData.hud.fontSize * 0.75
        pauseLabel.fontName = GameData.font.mainFont
        pauseLabel.fontColor = SKColor.white
        addChild(pauseLabel)
    }
    
    func makePaused(){
        bg.color = SKColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.7)
        bg.size = playableRect.size
        bg.zPosition = 4
        bg.position = CGPoint(x:playableRect.midX, y:playableRect.midY)
        
        pauseLabel.position = CGPoint(x: playableRect.midX,y: playableRect.maxY * 0.7)
        pauseLabel.verticalAlignmentMode = .center
        pauseLabel.horizontalAlignmentMode = .center
        pauseLabel.text = "Resume"
        
        addChild(bg)
        
        addChild(mainMenuLabel)
        playAgainLabel.text = "Reset"
        addChild(playAgainLabel)
        
        physicsWorld.speed = 0.0
    }
    
    func unPause(){
        pauseLabel.position = CGPoint(x: playableRect.maxX - 20,y: playableRect.maxY - 20)
        pauseLabel.verticalAlignmentMode = .top
        pauseLabel.horizontalAlignmentMode = .right
        pauseLabel.text = "Pause/Reset"
        
        bg.removeFromParent()
        playAgainLabel.text = "Play Again"
        playAgainLabel.removeFromParent()
        mainMenuLabel.removeFromParent()
        
        physicsWorld.speed = 1.0
    }
    
    func setupSpritesAndPhysics(){
        let background = SKSpriteNode(imageNamed: "background")
        background.zPosition = -5
        background.position = CGPoint(x: playableRect.midX, y: playableRect.midY)
        background.size = playableRect.size
        addChild(background)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        
        // HOOK UP TO SPRITES IN SCENE FILES

        for node in children{
            if(node.name != nil){
                if (node.name?.contains("Square"))! {
                    node.zPosition = 1
                    node.physicsBody = SKPhysicsBody(rectangleOf: node.frame.size)
                }
                if node.name!.contains("Circle") {
                    node.zPosition = 1
                    node.physicsBody = SKPhysicsBody(circleOfRadius: node.frame.size.width/2)
                }
                if (node.name?.contains("Stationary"))! {
                    node.zPosition = 1
                    node.physicsBody?.isDynamic = false
                    let n = node as! SKSpriteNode
                    n.color = SKColor.black
                    n.colorBlendFactor = 0.3
                }
                if (node.name?.contains("Triangle"))! {
                    node.zPosition = 1
                    let trianglePath = CGMutablePath()
                    trianglePath.move(to: CGPoint(x:-node.frame.size.width/2, y:-node.frame.size.height/2))
                    trianglePath.addLine(to: CGPoint(x:node.frame.size.width/2,y: -node.frame.size.height/2))
                    trianglePath.addLine(to: CGPoint(x: 0, y:node.frame.size.height/2))
                    trianglePath.addLine(to: CGPoint(x: -node.frame.size.width/2, y:-node.frame.size.height/2))
                    node.physicsBody = SKPhysicsBody(polygonFrom: trianglePath)
                }
                if (node.name?.contains("Red"))! || (node.name?.contains("Blue"))! {
                    BustableShapes.append(node)
                }
                
                if (node.name?.contains("Left"))! {
                    node.physicsBody?.affectedByGravity = false
                    leftFallers.append(node)
                }
                if (node.name?.contains("Right"))! {
                    node.physicsBody?.affectedByGravity = false
                    rightFallers.append(node)
                }
                if (node.name?.contains("Up"))! {
                    node.physicsBody?.affectedByGravity = false
                    upFallers.append(node)
                }
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            
            let location = touch.location(in: self)
            
            if nextLevelLabel.contains(location) && nextLevelLabel.parent != nil {
                sceneManager.loadGameScene(levelNum: (Int(levelNum)! + 1).description)
            }
            
            if playAgainLabel.contains(location) && playAgainLabel.parent != nil {
                sceneManager.loadGameScene(levelNum: levelNum)
            }
            
            if mainMenuLabel.contains(location) && mainMenuLabel.parent != nil {
                sceneManager.loadLevelSelectionScene()
            }
            
            if pauseLabel.contains(location) && pauseLabel.parent != nil {
                pause = !pause
            }
            
            if pause {return;}
            
            for shape in BustableShapes{
                if shape.contains(location) && shape.parent != nil{
                    shape.removeFromParent()
                    tapCount += 1
                    run(SKAction.playSoundFileNamed("pop.wav", waitForCompletion: false))
                }
            }
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if pause {return;}
        var winner = true
        for node in children {
            if (node.name != nil){
                if node.name!.contains("Green") {
                    if node.position.y < playableRect.minY - node.frame.height || node.position.y > playableRect.maxY + node.frame.height || node.position.x < 0 - node.frame.width || node.position.x > playableRect.maxX + node.frame.width {
                        gameOver = true
                    }
                }
                if node.name!.contains("Red") || node.name!.contains("Yellow")  {
                    if node.position.y > playableRect.minY - node.frame.height {
                        winner = false
                    }
                    if node.position.y < playableRect.minY - node.frame.height || node.position.y > playableRect.maxY + node.frame.height || node.position.x < 0 - node.frame.width || node.position.x > playableRect.maxX + node.frame.width {
                        node.removeFromParent()
                    }
                }
            }
        }
        
        for node in leftFallers{
            node.physicsBody!.applyForce(CGVector(dx: -980, dy: 0.0))
        }
        for node in rightFallers{
            node.physicsBody!.applyForce(CGVector(dx: 980, dy: 0.0))
        }
        for node in upFallers{
            node.physicsBody!.applyForce(CGVector(dx: 0.0, dy: 980))
        }
        if winner && !gameOver{
            timeTillWin -= 0.1
        }
        
        gameWon = timeTillWin < 0.0 ? true : false
        
        if gameOver {
            gameWon = false
        }
        
        if gameWon || gameOver {
            physicsWorld.speed = 0.0
        }
    }
}
