//
//  Win.swift
//  Kick
//
//  Created by Morris QIN on 16/6/1.
//  Copyright © 2016年 Apportable. All rights reserved.
//

import UIKit

class Win: CCNode {
    func returnToLevelChoose(){
        let trans = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().popSceneWithTransition(trans)
    }
    
    func replay(){
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene, withTransition: CCTransition(fadeWithDuration: 0.5))
    }

    func nextLevel(){
        CCDirector.sharedDirector().popScene()
        CCDirector.sharedDirector().pushScene(self.scene)
        //todo:move to next level
        NUMOFLEVEL.level.setLevel(NUMOFLEVEL.level.levelNum+1)
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene, withTransition: CCTransition(fadeWithDuration: 0.5))
    }
}
