//
//  SceneManager.swift
//  Shooter
//
//  Created by student on 10/6/16.
//  Copyright © 2016 student. All rights reserved.
//

import Foundation

protocol SceneManager {
    func loadHomeScene()
    func loadLevelSelectionScene()
    func loadGameScene(levelNum:String)
    func loadSettingsScene()
    func loadCreditsScene()
}
