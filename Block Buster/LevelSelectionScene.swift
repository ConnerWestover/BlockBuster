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
    let buttons:[SKSpriteNode]
    let labels:[SKLabelNode]
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
                button.position = CGPoint(x: posX, y: size.height/2 + 200)
            } else if index < 20 {
                var posX = size.width - 300
                posX = posX/9
                posX = posX*CGFloat(index-10)
                posX = posX + 150
                button.position = CGPoint(x: posX, y: size.height/2)
            } else if index < 30 {
                var posX = size.width - 300
                posX = posX/9
                posX = posX*CGFloat(index-20)
                posX = posX + 150
                button.position = CGPoint(x: posX, y: size.height/2 - 200)
            } else if index < 40 {
                var posX = size.width - 300
                posX = posX/9
                posX = posX*CGFloat(index-30)
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
        } while (index < 40)
        
        buttons = bArray
        labels = lArray
        
        super.init(size:size)

        self.scaleMode = scaleMode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        backgroundColor = GameData.scene.backgroundColor
        
        let label = SKLabelNode(fontNamed: GameData.font.mainFont)
        label.text = "Block Buster"
        label.fontSize = 100
        label.position = CGPoint(x:size.width/2, y:size.height * 0.85)
        label.zPosition = 1
        addChild(label)
        
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
                    sceneManager.loadGameScene(levelNum: b.name!)
                }
            }
        }
    }
    
}
