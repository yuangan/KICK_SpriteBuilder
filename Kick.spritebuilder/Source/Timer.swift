//
//  Timer.swift
//  Kick
//
//  Created by Morris QIN on 16/5/28.
//  Copyright © 2016年 Apportable. All rights reserved.
//

import UIKit

class Timer: CCLabelTTF {
    var flagGameOver = Bool(false)
    
    func didLoadFromCCB(){
        switch(NUMOFLEVEL.level.levelNum){
        case 1:
            self.string = "01:00"
        case 2:
            self.string = "01:00"
        case 3:
            self.string = "01:00"
        case 8:
            self.string = "03:00"
        default :
            self.string = "00:10"
        }
    }
    
    override func onEnter() {
        self.schedule(#selector(decreseLabel), interval: CCTime(1.0))
    }
    
    func decreseLabel(){
        
        let str = string.componentsSeparatedByString(":")
        if(str[1]=="00"){
            //gameOver
            if(str[0]=="00"){
                flagGameOver = true
            }
            else{
                var min:Int = ((str[0] as NSString?)?.integerValue)!
                min = min-1
                if(min>9){
                    string = String(min)+":59"
                }
                else {
                    string = "0"+String(min)+":59"
                }
            }
        }
        else{
            var sec = Int(str[1])
            sec! -= 1
            if(sec>9){
                string = String(str[0]+":"+String(sec!))
            }
            else {
                string = String(str[0]+":0"+String(sec!))
            }
        }
    }

}
