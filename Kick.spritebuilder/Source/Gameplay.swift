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
    //music
    let audio = OALSimpleAudio.sharedInstance()
    
    weak var timer:Timer!
    weak var goal:Goal!
    weak var levelNode: CCNode!
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var bigGoal:BigGoal!
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
        
        let level = CCBReader.load("Levels/Level\(NUMOFLEVEL.level.levelNum)")
        levelNode.addChild(level)
        gamePhysicsNode.collisionDelegate = self
        
        //gamePhysicsNode.debugDraw = true
        userInteractionEnabled = true
        //移动阻力
        gamePhysicsNode.space.damping = 0.65
        
    }
    
    override func onEnterTransitionDidFinish() {
        audio.playEffect("Resource/background.wav",loop: true)
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
        if(state&0x10==0){
            count_skill = count_skill+1
            addSkill("Resource/round_water.png")
            state = state|0x10
        }
        return true
    }
    
    //与土球碰撞＋土
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, land: Circle_land!, player: Player) -> Bool {
        if(state&0x1000==0){
            count_skill = count_skill+1
            addSkill("Resource/round_land.png")
            state = state|0x1000
        }
        return true
    }
    
    //与木球碰撞＋木
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, wood: Circle_wood!, player: Player) -> Bool {
        if(state&0x100==0){
            count_skill = count_skill+1
            addSkill("Resource/round_wood.png")
            state = state|0x100
        }
        return true
    }
    
    //与金球碰撞＋金
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, gold: Circle_wood!, player: Player) -> Bool {
        if(state&0x10000==0){
            count_skill = count_skill+1
            addSkill("Resource/round_gold.png")
            state = state|0x10000
        }
        return true
    }
    
    //与木条碰撞
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, bar: Bar!, player: Player) -> Bool {
        if(player.physicsBody.mass>3.0){
            audio.playEffect("Resource/bar_remove.wav")
            bar.removeFromParent()
        }
        else{
            audio.playEffect("Resource/kick_bar.wav")
        }
        return true
    }
    
    //与大球碰撞
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, bigBall: BigBall!, wildcard: CCNode!) -> Bool {
        audio.playEffect("Resource/kick_ball.wav")
        goal.setGoal(goal.getValue()-1)
        bigGoal.setGoal(bigGoal.getValue()-1)
        let boom = CCBReader.load("BigBallBoom")
        boom.position = bigBall.position
        addChild(boom)
        return true
    }
    
    //与物体碰撞
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, player: Player, wildcard: CCNode!) -> Bool {
        if wildcard != nil{
            if (!wildcard.isKindOfClass(Bar))&&(!wildcard.isKindOfClass(BigBall)){
                audio.playEffect("Resource/kick_little_ball.wav")
            }
        }
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

                if !child.isKindOfClass(Player){
                    goal.setGoal(goal.getValue()-1)
                }
            }
        }
        gameOver()
    }
    
    func pause(){
        audio.stopAllEffects()
        OALSimpleAudio.sharedInstance().playEffect("Resource/button.wav")
        CCDirector.sharedDirector().pushScene(self.scene)
        let stop = CCBReader.loadAsScene("Stop")
        CCDirector.sharedDirector().presentScene(stop, withTransition: CCTransition(crossFadeWithDuration: 0.5))
    }
    
    func lose(){
        audio.stopAllEffects()
        let lose = CCBReader.loadAsScene("Lose")
        CCDirector.sharedDirector().presentScene(lose, withTransition: CCTransition(crossFadeWithDuration: 0.5))
    }
    
    func win(){
        audio.stopAllEffects()

        let win = CCBReader.loadAsScene("Win")
        CCDirector.sharedDirector().presentScene(win, withTransition: CCTransition(crossFadeWithDuration: 0.5))
    }
    
    func changePlayer(player:CCNode){
        let mass = player.physicsBody.mass
        switch(state){
            //fire
        case 0x0:
            break;
        case 0x1:
            audio.playEffect("Resource/fire.wav")
            var v = CGPoint()
            //print(v.dx)
            v = normalize((player.physicsBody?.velocity)!)
            player.physicsBody?.applyImpulse(CGPoint(x: v.x*200*(player.physicsBody?.mass)!,y: v.y*200*(player.physicsBody?.mass)!)
            )
        //water
        case 0x10:
            audio.playEffect("Resource/change_size.wav")
            player.mySetScale(0.5)
            player.physicsBody.mass = mass
            //player.physicsBody.
        //wood
        case 0x100:
            audio.playEffect("Resource/change_size.wav")
            player.physicsBody?.mass = 0.3
        //land
        case 0x1000:
            audio.playEffect("Resource/change_size.wav")
            player.mySetScale(2.0)
            player.physicsBody?.mass = mass
        //gold
        case 0x10000:
            audio.playEffect("Resource/change_size.wav")
            player.physicsBody?.mass = 3.1
        //null
        case 0x01111:
            audio.playEffect("Resource/fire.wav")
            let boom = CCBReader.load("boom")
            boom.position = player.position
            addChild(boom)
            EffectOfBoom(player)
        case 0x11111:
            audio.playEffect("Resource/fire.wav")
            let boom = CCBReader.load("boom")
            boom.position = player.position
            addChild(boom)
            EffectOfAll(player)
        default:
            audio.playEffect("Resource/skill_null.wav")
            let boom = CCBReader.load("NullBoom")
            boom.position = player.position
            addChild(boom)
        }
    }
    
    func EffectOfBoom(player:CCNode){
        let level = levelNode.children.first as! CCNode
        for tmp_child in level.children{
            let child = tmp_child as! CCNode
            if (child.physicsBody.type==CCPhysicsBodyType.Dynamic){
                //距离
                let w = child.position.x-player.position.x
                let h = child.position.y-player.position.y
                let dis = sqrt(w*w+h*h+1)
                child.physicsBody.applyImpulse(CGPoint(x: w*500.0/dis,y: h*500.0/dis))
            }
        }
    }
    
    func EffectOfAll(player:CCNode){
        let level = levelNode.children.first as! CCNode
        for tmp_child in level.children{
            let child = tmp_child as! CCNode
            if (child.physicsBody.type==CCPhysicsBodyType.Dynamic||child.physicsBody.type==CCPhysicsBodyType.Static){
                child.physicsBody.elasticity = 1.01
            }
        }
        gamePhysicsNode.space.damping = 1.0
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
