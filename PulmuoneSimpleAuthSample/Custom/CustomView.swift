//
//  CustomView.swift
//  mcfs
//
//  Created by 이주한 on 2022/09/20.
//  Copyright © 2022 pulmuone. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CustomView: UIView {
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        //self.backgroundColor = UIColor.groupTableViewBackground
    //
    //        let touch = touches.first!
    //        if (touch.view?.tag == 1000) { //passCodeView
    //            print("passCodeView")
    //        } else {
    //            print("bioAuthView")
    //        }
    //        self.borderColor = PasscodeViewController.config.touchDownColor
    //    }
    //
    //    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        UIView.animate(withDuration: 0.15, animations: { () -> Void in
    //            //self.backgroundColor = UIColor.clear
    //            self.borderColor = PasscodeViewController.config.touchUpColor
    //        })
    //    }
    //
    //    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        UIView.animate(withDuration: 0.15, animations: { () -> Void in
    //            //self.backgroundColor = UIColor.clear
    //            self.borderColor = PasscodeViewController.config.touchUpColor
    //        })
    //    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            
            // If masksToBounds is true, subviews will be
            // clipped to the rounded corners.
            layer.masksToBounds = (newValue > 0)
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: cgColor)
        }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
}
