//
//  Win.swift
//  Kick
//
//  Created by Morris QIN on 16/6/1.
//  Copyright © 2016年 Apportable. All rights reserved.
//

import UIKit

class Win: CCNode {
    func didLoadFromCCB(){
        OALSimpleAudio.sharedInstance().playEffect("Resource/win.wav")
    }
    
    func returnToLevelChoose(){
        OALSimpleAudio.sharedInstance().stopAllEffects()
        OALSimpleAudio.sharedInstance().playEffect("Resource/button.wav")
        let trans = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().popSceneWithTransition(trans)
    }
    
    func replay(){
        OALSimpleAudio.sharedInstance().stopAllEffects()
        OALSimpleAudio.sharedInstance().playEffect("Resource/button.wav")
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene, withTransition: CCTransition(fadeWithDuration: 0.5))
    }

    func nextLevel(){
        OALSimpleAudio.sharedInstance().stopAllEffects()
        OALSimpleAudio.sharedInstance().playEffect("Resource/button.wav")
        if(NUMOFLEVEL.level.levelNum != 8){
            CCDirector.sharedDirector().popScene()
            CCDirector.sharedDirector().pushScene(self.scene)
            //todo:move to next level
            NUMOFLEVEL.level.setLevel(NUMOFLEVEL.level.levelNum+1)
            let gameplayScene = CCBReader.loadAsScene("Gameplay")
            CCDirector.sharedDirector().presentScene(gameplayScene, withTransition: CCTransition(fadeWithDuration: 0.5))
        }
        else{
            returnToLevelChoose()
        }
        
    }
}
