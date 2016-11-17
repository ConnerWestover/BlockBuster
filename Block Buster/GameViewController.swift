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
            
            setupLevelData()
            
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
    
    func setupLevelData(){
        updateAvailabilityForLevel(num: 1, avail: true)
        //Par Clicks for levels
        updateParClicksForLevel(num: 1, clicks: 3)
        updateParClicksForLevel(num: 2, clicks: 0)
        updateParClicksForLevel(num: 3, clicks: 3)
        updateParClicksForLevel(num: 4, clicks: 3)
        updateParClicksForLevel(num: 5, clicks: 3)
        updateParClicksForLevel(num: 6, clicks: 3)
        updateParClicksForLevel(num: 7, clicks: 3)
        updateParClicksForLevel(num: 8, clicks: 3)
        updateParClicksForLevel(num: 9, clicks: 3)
        updateParClicksForLevel(num: 10, clicks: 3)
        updateParClicksForLevel(num: 11, clicks: 3)
        updateParClicksForLevel(num: 12, clicks: 3)
        updateParClicksForLevel(num: 13, clicks: 3)
        updateParClicksForLevel(num: 14, clicks: 3)
        updateParClicksForLevel(num: 15, clicks: 3)
        updateParClicksForLevel(num: 16, clicks: 3)
        updateParClicksForLevel(num: 17, clicks: 3)
        updateParClicksForLevel(num: 18, clicks: 3)
        updateParClicksForLevel(num: 19, clicks: 3)
        updateParClicksForLevel(num: 20, clicks: 3)
        updateParClicksForLevel(num: 21, clicks: 3)
        updateParClicksForLevel(num: 22, clicks: 3)
        updateParClicksForLevel(num: 23, clicks: 3)
        updateParClicksForLevel(num: 24, clicks: 3)
        updateParClicksForLevel(num: 25, clicks: 3)
        updateParClicksForLevel(num: 26, clicks: 3)
        updateParClicksForLevel(num: 27, clicks: 3)
        updateParClicksForLevel(num: 28, clicks: 3)
        updateParClicksForLevel(num: 29, clicks: 3)
        updateParClicksForLevel(num: 30, clicks: 3)
        updateParClicksForLevel(num: 31, clicks: 3)
        updateParClicksForLevel(num: 32, clicks: 3)
        updateParClicksForLevel(num: 33, clicks: 3)
        updateParClicksForLevel(num: 34, clicks: 3)
        updateParClicksForLevel(num: 35, clicks: 3)
        updateParClicksForLevel(num: 36, clicks: 3)
        updateParClicksForLevel(num: 37, clicks: 3)
        updateParClicksForLevel(num: 38, clicks: 3)
        updateParClicksForLevel(num: 39, clicks: 3)
        updateParClicksForLevel(num: 40, clicks: 3)
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
