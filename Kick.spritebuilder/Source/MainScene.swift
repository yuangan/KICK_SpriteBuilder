import Foundation

class MainScene: CCNode {
    func play(){
        OALSimpleAudio.sharedInstance().playEffect("Resource/button.wav")
        let gameplayScene = CCBReader.loadAsScene("LevelChoose")
        CCDirector.sharedDirector().presentScene(gameplayScene, withTransition: CCTransition(fadeWithDuration: 0.5))
    }
}
