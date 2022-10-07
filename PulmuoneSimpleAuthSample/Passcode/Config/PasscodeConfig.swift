//
//  PasscodeConfig.swift
//  Passcode
//
//  Created by hb on 08/05/20.
//  Copyright © 2020 hb. All rights reserved.
//

import UIKit

class PasscodeConfig: NSObject {
    var logoImg: UIImage?
    var backspaceImg: UIImage? = UIImage(named: "arrow_back")
    var touchIdImg: UIImage? = UIImage(named: "btn_biometric")
    var faceIdImg: UIImage? = UIImage(named: "btn_faceid")

    var backgroundColor: UIColor = .white//UIColor(rgb: 0xF5F5F5)//.darkGray
    var msgColor: UIColor = UIColor(rgb: 0x262626)//.white
    var titleColor: UIColor = UIColor(rgb: 0x262626)//.white
    var keyPadColor: UIColor = UIColor(rgb: 0x262626)
    var msgFontSize: CGFloat = 22
    var titleFontSize: CGFloat = 50
    //var msgFontName: String = "PulmuoneLOHASOTFBold"
    //var titleFontName: String = "PulmuoneLOHASOTFBold"
    var keyTintColor: UIColor = .black//.white
    var keyHighlitedTintColor: UIColor = UIColor(rgb: 0x79AA0D)
    var keyHighlitedBackgroundColor: UIColor = UIColor(rgb: 0x79AA0D).withAlphaComponent(0.2)

    var digitBgColor: UIColor = UIColor(rgb: 0xC7CDD3) //.darkGray//.white
    var digitTapColor: UIColor = UIColor(rgb: 0x79AA0D) //.darkGray//.white
    
    var msgLabelFont: UIFont = UIFont(name: "Pretendard-Regular", size: 23)!
    var msgTItleFont: UIFont = UIFont(name: "Pretendard-SemiBold", size: 19)!
    var keyPadTitleFont: UIFont = UIFont(name: "Pretendard-Medium", size: 29)!
    var keyPadClearBtnFont: UIFont = UIFont(name: "Pretendard-Regular", size: 15)!
    
    var touchDownColor: UIColor = UIColor(rgb: 0x79AA0D)
    var touchUpColor: UIColor = UIColor(rgb: 0xC7CDD3)
    var touchDownTextColor: UIColor = UIColor(rgb: 0x79AA0D)
    var touchUpTextColor: UIColor = UIColor(rgb: 0x5F6973)
    
    var pretendard_Regular_23: UIFont = UIFont(name: "Pretendard-Regular", size: 23)!
    var pretendard_Regular_17: UIFont = UIFont(name: "Pretendard-Regular", size: 17)!

    var noOfDigits: Int = 4
    var isRandomKeyEnabled = false
    
    //var EnterCurrentPasscodeMessage = NSLocalizedString("등록한 PIN 번호를 입력하세요.", comment: "")//NSLocalizedString("Enter PIN", comment: "")
    //var EnterNewPasscodeMessage = NSLocalizedString("새로운 PIN 번호를 입력하세요.", comment: "")//NSLocalizedString("Please enter a new PIN", comment: "")
    //var ReEnterPasscodeMessage = NSLocalizedString("한번 더 입력해주세요.", comment: "")//NSLocalizedString("Confirm your PIN", comment: "")
    //var PasscodeNotMatchMessage = NSLocalizedString("PIN 번호가 일치하지 않습니다.", comment: "")//NSLocalizedString("Confirm PIN doesn't match", comment: "")
}
