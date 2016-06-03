//
//  Player.swift
//  Kick
//
//  Created by Apple on 16/5/27.
//  Copyright © 2016年 Apportable. All rights reserved.
//

import UIKit

class Player: CCSprite {
    func didLoadFromCCb(){
        setPlayer()
    }
    func setPlayer(){
        self.physicsBody.allowsRotation=true
        self.physicsBody.mass = 1.0
    }
}
