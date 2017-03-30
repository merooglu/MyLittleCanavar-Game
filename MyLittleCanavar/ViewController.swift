//
//  ViewController.swift
//  MyLittleCanavar
//
//  Created by Mehmet Eroğlu on 27.03.2017.
//  Copyright © 2017 Mehmet Eroğlu. All rights reserved.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        foodImage.dropTarget = monsterImage
        heartImage.dropTarget = monsterImage
        
        penalty1Image.alpha = DIM_ALFA
        penalty2Image.alpha = DIM_ALFA
        penalty3Image.alpha = DIM_ALFA
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.itemDroppedOnCharacter(notif:)), name: Notification.Name("onTargetDropped"), object: nil)
        
        startTimer()
        
    }

    func itemDroppedOnCharacter (notif: AnyObject) {
        print("item drop on character")
    }
    
    func startTimer () {
        if timer != nil {
            timer.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(ViewController.changeGameState), userInfo: nil, repeats: true)
    }
    
    func changeGameState() {
        penalties += 1
        
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
    
    func gameOver() {
        timer.invalidate()
        monsterImage.playDeathAnimation()
    }
}

