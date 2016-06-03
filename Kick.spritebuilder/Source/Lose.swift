//
//  Lose.swift
//  Kick
//
//  Created by Morris QIN on 16/6/1.
//  Copyright © 2016年 Apportable. All rights reserved.
//

import UIKit

class Lose: CCNode {
    func returnToLevelChoose(){
        let trans = CCTransition(fadeWithDuration: 0.5)
        CCDirector.sharedDirector().popSceneWithTransition(trans)
    }

    func replay(){
        let gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene, withTransition: CCTransition(fadeWithDuration: 0.5))
    }

}
