//
//  BigGoal.swift
//  Kick
//
//  Created by nju on 16/7/9.
//  Copyright © 2016年 Apportable. All rights reserved.
//
import UIKit

class BigGoal: CCLabelTTF {
    
    func didLoadFromCCB(){
        if(NUMOFLEVEL.level.levelNum==7)
        {
         self.setGoal(100)   
        }
    }
    func setGoal(leftGoal:Int){
        string = String(String(leftGoal))
    }
    func getValue()->Int{
        return (string as NSString).integerValue
    }
}
