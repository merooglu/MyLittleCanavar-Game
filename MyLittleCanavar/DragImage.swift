//
//  DragImage.swift
//  MyLittleCanavar
//
//  Created by Mehmet Eroğlu on 28.03.2017.
//  Copyright © 2017 Mehmet Eroğlu. All rights reserved.
//

import Foundation
import UIKit

class DragImage: UIImageView {
    
    var originalPosition : CGPoint!
    var dropTarget : UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        originalPosition = self.center
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self.superview)
            self.center = CGPoint(x: position.x, y: position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first , let target = dropTarget {
            let position = touch.location(in: self.superview)
            if target.frame.contains(position){
                
                NotificationCenter.default.post(name: Notification.Name("onTargetDropped"), object: nil)
                
                
            }
        }
        
        self.center = originalPosition
    }
    
}
