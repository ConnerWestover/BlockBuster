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
import AVFoundation

class GameViewController: UIViewController, SceneManager {
    
    //MARK: - ivars -
    var gameScene: GameScene?
    var skView:SKView!
    let showDebugData = true
    let screenSize = CGSize(width: 1920, height: 1080)
    let scaleMode = SKSceneScaleMode.aspectFit
    var audioPlayer:AVAudioPlayer! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "background", ofType: "wav")!))
            audioPlayer.prepareToPlay()
        } catch {
            print("can't find background music")
        }

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
        
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
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
    
    func loadSettingsScene(){
        
    }
    func loadCreditsScene(){
        
    }
    
    func setupLevelData(){
        updateAvailabilityForLevel(num: 1, avail: true)
        //Par Clicks for levels
        updateParClicksForLevel(num: 1, clicks: 3)
        updateParClicksForLevel(num: 2, clicks: 3)
        updateParClicksForLevel(num: 3, clicks: 1)
        updateParClicksForLevel(num: 4, clicks: 2)
        updateParClicksForLevel(num: 5, clicks: 2)
        updateParClicksForLevel(num: 6, clicks: 1)
        updateParClicksForLevel(num: 7, clicks: 2)
        updateParClicksForLevel(num: 8, clicks: 3)
        updateParClicksForLevel(num: 9, clicks: 4)
        updateParClicksForLevel(num: 10, clicks: 2)
        updateParClicksForLevel(num: 11, clicks: 6)
        updateParClicksForLevel(num: 12, clicks: 3)
        updateParClicksForLevel(num: 13, clicks: 2)
        updateParClicksForLevel(num: 14, clicks: 4)
        updateParClicksForLevel(num: 15, clicks: 3)
        updateParClicksForLevel(num: 16, clicks: 2)
        updateParClicksForLevel(num: 17, clicks: 3)
        updateParClicksForLevel(num: 18, clicks: 13)
        updateParClicksForLevel(num: 19, clicks: 1)
        updateParClicksForLevel(num: 20, clicks: 2)
        updateParClicksForLevel(num: 21, clicks: 1)
        updateParClicksForLevel(num: 22, clicks: 2)
        updateParClicksForLevel(num: 23, clicks: 8)
        updateParClicksForLevel(num: 24, clicks: 8)
        updateParClicksForLevel(num: 25, clicks: 3)
        updateParClicksForLevel(num: 26, clicks: 3)
        updateParClicksForLevel(num: 27, clicks: 3)
        updateParClicksForLevel(num: 28, clicks: 3)
        updateParClicksForLevel(num: 29, clicks: 3)
        updateParClicksForLevel(num: 30, clicks: 3)
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
