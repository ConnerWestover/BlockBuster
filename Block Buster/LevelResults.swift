//
//  LevelResults.swift
//  Shooter
//
//  Created by student on 9/26/16.
//  Copyright © 2016 student. All rights reserved.
//

import Foundation
class LevelResults{
    let levelNum:Int
    let levelComplete:Bool
    let totalBlocksRemoved:Int
    init(levelNum:Int, levelComplete:Bool, totalBlocksRemoved:Int){
        self.levelNum = levelNum
        self.levelComplete = levelComplete
        self.totalBlocksRemoved = totalBlocksRemoved
    }
}
