//
//  LevelChoose.swift
//  Kick
//
//  Created by Morris QIN on 16/5/27.
//  Copyright © 2016年 Apportable. All rights reserved.
//

import UIKit

class LevelChoose: CCNode {
    func level1(){
        CCDirector.sharedDirector().pushScene(self.scene)
        NUMOFLEVEL.level.setLevel(1)
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene, withTransition: CCTransition(fadeWithDuration: 0.5))
    }
    
    func level8(){
        CCDirector.sharedDirector().pushScene(self.scene)
        NUMOFLEVEL.level.setLevel(8)
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene, withTransition: CCTransition(fadeWithDuration: 0.5))
    }
}
