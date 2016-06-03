//
//  NUMOFLEVEL.swift
//  Kick
//
//  Created by Morris QIN on 16/5/28.
//  Copyright © 2016年 Apportable. All rights reserved.
//

import Foundation

class NUMOFLEVEL{
    var levelNum:Int!
    
    static let level = NUMOFLEVEL()
    
    func setLevel(level:Int){
        levelNum = level
    }
}