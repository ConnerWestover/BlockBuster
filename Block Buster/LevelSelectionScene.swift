//
//  LevelSelectionScene.swift
//  Block Buster
//
//  Created by Conner on 11/16/16.
//  Copyright © 2016 Bugz 4 Dayz. All rights reserved.
//

import SpriteKit

class LevelSelectionScene: SKScene {
    //MARK: - ivars -
    let sceneManager:SceneManager
    var buttons:[SKSpriteNode]
    var labels:[SKLabelNode]
    //MARK: - Initialization -
    init(size: CGSize, scaleMode: SKSceneScaleMode, sceneManager: SceneManager){
        self.sceneManager = sceneManager
        var index = 0
        var lArray = [SKLabelNode]()
        var bArray = [SKSpriteNode]()
        repeat {
            let button1 = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100, height: 100))
            let button = SKLabelNode()
            
            button.fontColor = UIColor.white
            button.fontSize = 60
            button.fontName = GameData.font.mainFont
            
            if index < 10{
                var posX = size.width - 300
                posX = posX/9
                posX = posX*CGFloat(index)
                posX = posX + 150
                button.position = CGPoint(x: posX, y: size.height/2)
            } else if index < 20 {
                var posX = size.width - 300
                posX = posX/9
                posX = posX*CGFloat(index-10)
                posX = posX + 150
                button.position = CGPoint(x: posX, y: size.height/2 - 200)
            }
            else if index < 30 {
                var posX = size.width - 300
                posX = posX/9
                posX = posX*CGFloat(index-20)
                posX = posX + 150
                button.position = CGPoint(x: posX, y: size.height/2 - 400)
            }
            
            button1.position = button.position
            button1.position.y = button1.position.y + 20
            
            index += 1
            button.text = index.description
            button1.name = index.description
            
            if pullAvailabilityForLevel(num: index){
                if pullCompletedForLevel(num: index){
                    if pullParClicksForLevel(num: index) >= pullFewestClicksForLevel(num: index){
                        button1.color = SKColor.yellow
                    } else {
                        button1.color = SKColor.green
                    }
                } else {
                    button1.color = SKColor.red
                }
            } else {
                button1.color = SKColor.lightGray
            }
            
            lArray.append(button)
            bArray.append(button1)
        } while (index < 30)
        
        buttons = bArray
        labels = lArray
        
        super.init(size:size)

        self.scaleMode = scaleMode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.zPosition = -5
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size = size
        addChild(background)
        
        backgroundColor = GameData.scene.backgroundColor
        
        let label = SKLabelNode(fontNamed: GameData.font.mainFont)
        label.text = "Block Buster"
        label.fontSize = 100
        label.position = CGPoint(x:size.width/2, y:size.height * 0.85)
        label.zPosition = 1
        addChild(label)
        
        let color1 = SKSpriteNode(color: SKColor.lightGray, size: CGSize(width: 100, height: 100))
        let color2 = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100, height: 100))
        let color3 = SKSpriteNode(color: SKColor.green, size: CGSize(width: 100, height: 100))
        let color4 = SKSpriteNode(color: SKColor.yellow, size: CGSize(width: 100, height: 100))
        
        color1.position = CGPoint(x: size.width/6, y: size.height/2 + 200)
        color2.position = CGPoint(x: size.width*2/6 + 30, y: size.height/2 + 200)
        color3.position = CGPoint(x: size.width*3/6 + 120, y: size.height/2 + 200)
        color4.position = CGPoint(x: size.width*4/6 + 180, y: size.height/2 + 200)
        
        addChild(color1)
        addChild(color2)
        addChild(color3)
        addChild(color4)
        
        let colorLabel1 = SKLabelNode(fontNamed: GameData.font.mainFont)
        let colorLabel2 = SKLabelNode(fontNamed: GameData.font.mainFont)
        let colorLabel3 = SKLabelNode(fontNamed: GameData.font.mainFont)
        let colorLabel4 = SKLabelNode(fontNamed: GameData.font.mainFont)
        
        colorLabel1.text = "= Locked"
        colorLabel2.text = "= Unlocked"
        colorLabel3.text = "= Passed"
        colorLabel4.text = "= Perfected"
        
        colorLabel1.horizontalAlignmentMode = .left
        colorLabel2.horizontalAlignmentMode = .left
        colorLabel3.horizontalAlignmentMode = .left
        colorLabel4.horizontalAlignmentMode = .left
        
        colorLabel1.verticalAlignmentMode = .center
        colorLabel2.verticalAlignmentMode = .center
        colorLabel3.verticalAlignmentMode = .center
        colorLabel4.verticalAlignmentMode = .center
        
        colorLabel1.fontSize = 40
        colorLabel2.fontSize = 40
        colorLabel3.fontSize = 40
        colorLabel4.fontSize = 40
        
        colorLabel1.position = CGPoint(x: size.width/5, y: size.height/2 + 200)
        colorLabel2.position = CGPoint(x: size.width/3 + 100, y: size.height/2 + 200)
        colorLabel3.position = CGPoint(x: size.width/2 + 200, y: size.height/2 + 200)
        colorLabel4.position = CGPoint(x: size.width * 4/5, y: size.height/2 + 200)
        
        addChild(colorLabel1)
        addChild(colorLabel2)
        addChild(colorLabel3)
        addChild(colorLabel4)
        
        for l in labels
        {
            addChild(l)
        }
        
        for b in buttons
        {
            addChild(b)
            if pullAvailabilityForLevel(num: Int(b.name!)!){
                if pullCompletedForLevel(num: Int(b.name!)!){
                    if pullParClicksForLevel(num: Int(b.name!)!) >= pullFewestClicksForLevel(num: Int(b.name!)!){
                        b.color = SKColor.yellow
                    } else {
                        b.color = SKColor.green
                    }
                } else {
                    b.color = SKColor.red
                }
            } else {
                b.color = SKColor.lightGray
            }
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            for b in buttons{
                if b.contains(location){
                    if pullAvailabilityForLevel(num: Int(b.name!)!){
                        sceneManager.loadGameScene(levelNum: b.name!)
                    }
                }
            }
        }
    }
    
}
