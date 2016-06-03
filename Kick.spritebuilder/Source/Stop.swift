//
//  stop.swift
//  Kick
//
//  Created by Morris QIN on 16/5/31.
//  Copyright © 2016年 Apportable. All rights reserved.
//

import UIKit

class Stop: CCNode {
    func returnToLevelChoose(){
        CCDirector.sharedDirector().popScene()
        let trans = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().popSceneWithTransition(trans)
    }
    func continueGame(){
        CCDirector.sharedDirector().popSceneWithTransition(CCTransition(crossFadeWithDuration: 0.5))
    }
    func replay(){
        CCDirector.sharedDirector().popScene()
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene, withTransition: CCTransition(fadeWithDuration: 0.5))
    }
}
