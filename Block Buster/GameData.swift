//
//  GameData
//  Shooter
//
//  Created by jefferson on 9/15/16.
//  Copyright © 2016 tony. All rights reserved.
//

import SpriteKit

struct GameData{
    init(){
        fatalError("The GameData struct is a singleton")
        
    }
    struct font{
        static let mainFont = "Molot"
    }
    
    struct hud{
        static let backgroundColor = SKColor.blue
        static let fontSize = CGFloat(64.0)
        static let fontColorWhite = SKColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0)
        static let marginV = CGFloat(12.0)
        static let marginH = CGFloat(12.0)
    }
    
    struct scene {
        static let backgroundColor = SKColor(red: 0, green: 0.1, blue: 1.0, alpha: 1.0)
    }
    
}

