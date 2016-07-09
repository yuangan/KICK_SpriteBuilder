//
//  Goal.swift
//  Kick
//
//  Created by Morris QIN on 16/5/28.
//  Copyright © 2016年 Apportable. All rights reserved.
//

import UIKit

class Goal: CCLabelTTF {
    
    func didLoadFromCCB(){
        switch(NUMOFLEVEL.level.levelNum){
        case 1:
            self.setGoal(1)
        case 2:
            self.setGoal(13)
        case 3:
            self.setGoal(7)
        case 4:
            self.setGoal(7)
        case 5:
            self.setGoal(2)
        case 6:
            self.setGoal(2)
        case 7:
            self.setGoal(2)
        case 8:
            self.setGoal(1)
        default :
            self.setGoal(10)
        }
    }
    func setGoal(leftGoal:Int){
        
        let str = string.componentsSeparatedByString(":")

        string = String(str[0]+":"+String(leftGoal))
    }
    func getValue()->Int{
        
        let str = string.componentsSeparatedByString(":")

        return (str[1] as NSString).integerValue
    }
}
