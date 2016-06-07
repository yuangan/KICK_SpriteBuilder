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
        NUMOFLEVEL.level.setLevel(1)
        gotoLevel()
    }
    
    func level2(){
        NUMOFLEVEL.level.setLevel(2)
        gotoLevel()
    }
    
    func level3(){
        NUMOFLEVEL.level.setLevel(3)
        gotoLevel()
    }
    
    func level8(){
        NUMOFLEVEL.level.setLevel(8)
        gotoLevel()
    }
    
    func gotoLevel(){
        CCDirector.sharedDirector().pushScene(self.scene)
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene, withTransition: CCTransition(fadeWithDuration: 0.5))
    }
}
