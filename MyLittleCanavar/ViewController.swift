//
//  ViewController.swift
//  MyLittleCanavar
//
//  Created by Mehmet Eroğlu on 27.03.2017.
//  Copyright © 2017 Mehmet Eroğlu. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var monsterImage : MonsterImage!
    @IBOutlet weak var foodImage : DragImage!
    @IBOutlet weak var heartImage : DragImage!
    
    @IBOutlet weak var penalty1Image: UIImageView!
    @IBOutlet weak var penalty2Image: UIImageView!
    @IBOutlet weak var penalty3Image: UIImageView!
    
    let DIM_ALFA : CGFloat = 0.2
    let OPAQUE : CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer = Timer()
    var monsterHappy = false
    var currenItem : UInt32 = 0
    
    var musicPlayer : AVAudioPlayer!
    var sfxBite : AVAudioPlayer!
    var sfxSkull : AVAudioPlayer!
    var sfxDeath : AVAudioPlayer!
    var sfxHeart : AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImage.dropTarget = monsterImage
        heartImage.dropTarget = monsterImage
        
        penalty1Image.alpha = DIM_ALFA
        penalty2Image.alpha = DIM_ALFA
        penalty3Image.alpha = DIM_ALFA
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.itemDroppedOnCharacter(notif:)), name: Notification.Name("onTargetDropped"), object: nil)
        
        do {
            let resourcePath = Bundle.main.path(forResource: "cave-music", ofType: "mp3")!
            let url = NSURL(fileURLWithPath: resourcePath)
          try musicPlayer = AVAudioPlayer(contentsOf: url as URL)
            
            try sfxBite = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: "bite", ofType: "wav")!) as URL)
            
            try sfxSkull = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: "skull", ofType: "wav")!) as URL)
            
            try sfxDeath = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: "death", ofType: "wav")!) as URL)
            
            try sfxHeart = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: Bundle.main.path(forResource: "heart", ofType: "wav")!) as URL)
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxSkull.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxHeart.prepareToPlay()
            
        } catch let err as NSError{
            print(err.debugDescription)
        }
        
        startTimer()
        
    }

    func itemDroppedOnCharacter (notif: AnyObject) {
        
        monsterHappy = true
        startTimer()
        
        foodImage.alpha = DIM_ALFA
        foodImage.isUserInteractionEnabled = false
        heartImage.alpha = DIM_ALFA
        heartImage.isUserInteractionEnabled = false
        
        if currenItem == 0 {
            sfxHeart.play()
        }else {
            sfxBite.play()
        }
    }
    
    func startTimer () {
        if timer != nil {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        
        if !monsterHappy{
            
            penalties += 1
            sfxSkull.play()
            
            if penalties == 1{
                penalty1Image.alpha = OPAQUE
                penalty2Image.alpha = DIM_ALFA
            }else if penalties == 2 {
                penalty2Image.alpha = OPAQUE
                penalty3Image.alpha = DIM_ALFA
            }else if penalties >= 3 {
                penalty3Image.alpha = OPAQUE
            }else {
                penalty1Image.alpha = DIM_ALFA
                penalty2Image.alpha = DIM_ALFA
                penalty3Image.alpha = DIM_ALFA
            }
            
            if penalties >= MAX_PENALTIES {
                gameOver()
            }
        }
        
        let rand = arc4random_uniform(2) // 0 and 1
        
        if rand == 0 {
            foodImage.alpha = DIM_ALFA
            foodImage.isUserInteractionEnabled = false
            
            heartImage.alpha = OPAQUE
            heartImage.isUserInteractionEnabled = true
        } else {
            heartImage.alpha = DIM_ALFA
            heartImage.isUserInteractionEnabled = false
            
            foodImage.alpha = OPAQUE
            foodImage.isUserInteractionEnabled = true
        }
        
        currenItem = rand
        monsterHappy = false
       
    }
    
    func gameOver() {
        timer.invalidate()
        monsterImage.playDeathAnimation()
        sfxDeath.play()
    }
}

