//
//  GameViewController.swift
//  Block Buster
//
//  Created by Conner on 11/16/16.
//  Copyright © 2016 Bugz 4 Dayz. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, SceneManager {
    
    //MARK: - ivars -
    var gameScene: GameScene?
    var skView:SKView!
    let showDebugData = true
    let screenSize = CGSize(width: 1920, height: 1080)
    let scaleMode = SKSceneScaleMode.aspectFill

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            super.viewDidLoad()
            print(#function)
            skView = self.view as! SKView
            loadHomeScene()
            
            //debug stuff
            skView.ignoresSiblingOrder = true
            skView.showsFPS = showDebugData
            skView.showsNodeCount = showDebugData

        }
    }
    
    func loadHomeScene(){
        let scene = HomeScene(size: screenSize, scaleMode:scaleMode, sceneManager: self)
        let reveal = SKTransition.crossFade(withDuration: 1)
        skView.presentScene(scene, transition:reveal)
    }
    
    func loadLevelSelectionScene(){
        let scene = LevelSelectionScene(size: screenSize, scaleMode:scaleMode, sceneManager: self)
        let reveal = SKTransition.crossFade(withDuration: 1)
        skView.presentScene(scene, transition:reveal)
    }
    
    func loadGameScene(levelNum:String){
        gameScene = GameScene.loadLevel(levelNum,size:screenSize,scaleMode: scaleMode,sceneManager: self)
        let reveal = SKTransition.crossFade(withDuration: 1)
        skView.presentScene(gameScene!, transition:reveal)
    }
    
    func loadLevelFinishScene(results:LevelResults){
        
    }
    
    func loadGameOverScene(results:LevelResults){
        
    }
    
    func loadSettingsScene(){
        
        
    }
    func loadCreditsScene(){
        
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
