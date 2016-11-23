//
//  HomeScene.swift
//  Shooter
//
//  Created by student on 9/22/16.
//  Copyright © 2016 student. All rights reserved.
//

import SpriteKit

class HomeScene: SKScene {
    //MARK: - ivars -
    let sceneManager:SceneManager
    let button:SKLabelNode = SKLabelNode(fontNamed: GameData.font.mainFont)
    
    //MARK: - Initialization - 
    init(size: CGSize, scaleMode: SKSceneScaleMode, sceneManager: SceneManager){
        self.sceneManager = sceneManager
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
        let label2 = SKLabelNode(fontNamed: GameData.font.mainFont)
        
        label.text = "Block"
        label2.text = "Buster"
        
        label.fontSize = 200
        label2.fontSize = 200
        
        label.position = CGPoint(x:size.width/2, y:size.height/2 + 100)
        label2.position = CGPoint(x:size.width/2, y:size.height/2 - 100)
        
        label.zPosition = 1
        label2.zPosition = 2
        addChild(label)
        addChild(label2)
        
        
        let label4 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label4.text = "Tap To Continue"
        label4.fontColor = UIColor.red
        label4.fontSize = 70
        label4.position = CGPoint(x:size.width/2, y:size.height/2 - 250)
        addChild(label4)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneManager.loadLevelSelectionScene()
    }
}
