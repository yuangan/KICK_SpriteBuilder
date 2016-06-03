//
//  Gameplay.swift
//  Kick
//
//  Created by Morris QIN on 16/5/27.
//  Copyright © 2016年 Apportable. All rights reserved.
//

import UIKit

func normalize(velocity:CGPoint)->CGPoint{
    var v = CGPoint()
    if(velocity.x==0&&velocity.y==0){
        v.x = CGFloat(random())
        v.y = CGFloat(random())
    }
    else{
        v.x = velocity.x
        v.y = velocity.y
    }
    let distance = sqrt(v.x*v.x+v.y*v.y)
    return CGPoint(x: velocity.x/distance,y: velocity.y/distance)
}

class Gameplay: CCNode,CCPhysicsCollisionDelegate {
    internal var NumOfLevel: Int!

    weak var timer:Timer!
    weak var goal:Goal!
    weak var levelNode: CCNode!
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var skill1:CCSprite!
    weak var skill2:CCSprite!
    weak var skill3:CCSprite!
    weak var skill4:CCSprite!
    weak var skill5:CCSprite!
    weak var allSkill:CCNode!
    
    var state=Int(0)
    var count_skill = Int(0)
    var flagGameOver: Bool!
    var center:CGPoint!
    var maxDistance = CGFloat(10.0)
    var force = CGPoint(x:0,y:0)
    
    func didLoadFromCCB(){
        
        let level = CCBReader.load("Levels/Level\(NUMOFLEVEL.level.levelNum) copy 1")
        levelNode.addChild(level)
        gamePhysicsNode.collisionDelegate = self
        
        //gamePhysicsNode.debugDraw = true
        userInteractionEnabled = true
        gamePhysicsNode.space.damping = 0.8
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if(touch.locationInNode(self).x<(self.boundingBox().width/2)){
            center = (touch.locationInNode(self))
        }
        else{
            changePlayer(levelNode.getChildByName("player", recursively: true))
            state = 0
            let tex = CCTexture(file:"Resource/blackSkill.png")
            for child in allSkill.children{
                (child as! CCSprite).texture = tex
            }
            count_skill = 0
        }
    }
    
    override func touchMoved(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        let location = touch.locationInNode(self)
        if(location.x<boundingBox().width/2&&center != nil){
            var dx = (location.x)-center.x
            var dy = (location.y)-center.y
            let distance = hypot(dx, dy)
            if distance > maxDistance {
                dx = (dx/distance)*maxDistance*10
                dy = (dy/distance)*maxDistance*10
            }
            force.x = dx
            force.y = dy
            //手指滑动时才有力作用在球上
            if levelNode.getChildByName("player", recursively: true) != nil{
                levelNode.getChildByName("player", recursively: true).physicsBody?.applyForce(force)
            }
        }
    }
    
    //与火球碰撞＋火
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, fire: Circle_fire!, player: Player) -> Bool {
        if(state&0x1==0){
            count_skill = count_skill+1
            addSkill("Resource/round_fire.png")
            state = state|0x1
        }
        return true
    }
    
    //与水球碰撞＋水
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, water: Circle_water!, player: Player) -> Bool {
        print(state)
        if(state&0x10==0){
            count_skill = count_skill+1
            addSkill("Resource/round_water.png")
            state = state|0x10
        }
        return true
    }
    
    //与物体碰撞
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, player: Player, wildcard: CCNode!) -> Bool {
        let Collition = CCBReader.load("Collision")
        Collition.position = pair.contacts.points.0.pointA
        addChild(Collition)
        return true
    }

    func addSkill(path:String){
        let skill = CCBReader.load("AddSkill") as! CCParticleSystem
        skill.autoRemoveOnFinish = true
        let tex = CCTexture(file: path)
        skill.position = allSkill.children[count_skill-1].position
        //这里是可以强制类型转换的，如果转换的结果正确的话
        (allSkill.children[count_skill-1] as! CCSprite).texture = tex
        self.addChild(skill)
    }
    
    override func update(delta: CCTime) {
        let level = levelNode.children.first as! CCNode
        for tmp_child in level.children{
            let child = tmp_child as! CCNode
            if (child.position.x < 0||child.position.x > self.boundingBox().width||child.position.y < 0||child.position.y>self.boundingBox().height){
                child.removeFromParent()

                //if child.name.compare("player") != NSComparisonResult.OrderedSame{
                if !child.isKindOfClass(Player){
                    goal.setGoal(goal.getValue()-1)
                }
            }
        }
        gameOver()
    }
    
    func pause(){
        CCDirector.sharedDirector().pushScene(self.scene)
        let stop = CCBReader.loadAsScene("Stop")
        CCDirector.sharedDirector().presentScene(stop, withTransition: CCTransition(crossFadeWithDuration: 0.5))
    }
    
    func lose(){
        let lose = CCBReader.loadAsScene("Lose")
        CCDirector.sharedDirector().presentScene(lose, withTransition: CCTransition(crossFadeWithDuration: 0.5))
    }
    
    func win(){
        let win = CCBReader.loadAsScene("Win")
        CCDirector.sharedDirector().presentScene(win, withTransition: CCTransition(crossFadeWithDuration: 0.5))
    }
    
    func changePlayer(player:CCNode){
        switch(state){
        case 0x1:
            var v = CGPoint()
            //print(v.dx)
            v = normalize((player.physicsBody?.velocity)!)
            player.physicsBody?.applyImpulse(CGPoint(x: v.x*80*(player.physicsBody?.mass)!,y: v.y*80*(player.physicsBody?.mass)!)
            )
        //water
        case 0x10:
            player.contentSize = CGSize(width: 15,height: 15)
        //wood
        case 0x100:
            player.physicsBody?.mass = 0.3
            
        case 0x1000:
            let tempMass = player.physicsBody?.mass
            player.contentSize = CGSize(width: 50, height: 50)
            player.physicsBody?.mass = tempMass!
        case 0x10000:
            player.physicsBody?.mass = 3.0
        default:break
        }
    }
    
    func gameOver(){
        if goal.getValue()==0{
            win()
        }
        
        if levelNode.getChildByName("player", recursively: true)==nil||timer.flagGameOver{
            lose()
        }
        
    }
    
}
