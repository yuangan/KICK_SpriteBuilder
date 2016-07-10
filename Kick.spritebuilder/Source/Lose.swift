//
//  Lose.swift
//  Kick
//
//  Created by Morris QIN on 16/6/1.
//  Copyright © 2016年 Apportable. All rights reserved.
//

import UIKit

class Lose: CCNode {
    func didLoadFromCCB(){
        OALSimpleAudio.sharedInstance().playEffect("Resource/failed.wav")
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

}
