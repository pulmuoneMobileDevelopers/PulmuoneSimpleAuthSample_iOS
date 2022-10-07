//
//  BioOrNumberLoginBgVC.swift
//  mcfs
//
//  Created by 이주한 on 2022/08/29.v//  Copyright © 2022 pulmuone. All rights reserved.
//

import Foundation
import UIKit

class BioOrNumberLoginBgVC: PmoViewController {

    @IBOutlet weak var msgTitle: UILabel!
    @IBOutlet weak var msgLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //msgTitle.adjustsFontSizeToFitWidth = true
        msgLabel.minimumScaleFactor = 0.5
        msgTitle.minimumScaleFactor = 0.5
        
        self.view.backgroundColor = PasscodeViewController.config.backgroundColor
        msgLabel.textColor = PasscodeViewController.config.msgColor
        msgLabel.adjustsFontSizeToFitWidth = true
        msgLabel.minimumScaleFactor = 0.5
        msgLabel.font = PasscodeViewController.config.msgLabelFont
        
        msgTitle.textColor = PasscodeViewController.config.titleColor
        msgTitle.adjustsFontSizeToFitWidth = true
        msgTitle.minimumScaleFactor = 0.5
        msgTitle.font = PasscodeViewController.config.msgTItleFont
    }
    
    override func viewWillAppear(_ animated: Bool) {
        log.verbose("viewWillAppear")
        self.setLanguage()
        
    }
        
    private func setLanguage() {
        log.verbose("setLanguage")
        
        let bundle = self.initLanguage()
        msgTitle.text = bundle?.localizedString(forKey: I18NStrings.BioAuth, value: nil, table: nil)
        msgLabel.text = bundle?.localizedString(forKey: I18NStrings.PlzAuthBioInfo, value: nil, table: nil)
        
        log.verbose("msgTitle: \(String(describing: msgTitle))")
    }
}
