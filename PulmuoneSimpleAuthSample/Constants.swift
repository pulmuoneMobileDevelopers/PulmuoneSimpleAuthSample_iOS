//
//  Constants.swift
//  mcfs
//
//  Created by 이주한 on 2022/08/26.
//  Copyright © 2022 pulmuone. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

struct Constants {
    static let URL = ServerURL.devURL
    static let loginProcessURL = ServerURL.devLoginProcessURL
    static let loginURL = ServerURL.devLoginURL
    static let mainURLString = ServerURL.devMainURLString
    static let bioLoginErrorKey = "bioLoginErrorKey"
    
    static let userDefault_PinCodeLoginKey = DefaultsKey<Bool>("pinCodeLoginKey", defaultValue: false)
    static let userDefault_BioAuthLoginKey = DefaultsKey<Bool>("bioAuthLoginKey", defaultValue: false)
    static let userDefault_IsLoginKey = DefaultsKey<Bool>("IsLoginKey", defaultValue: false)
    
    static let passCodeFailMaxCount = 5
    // 백그라운드에서 포어그라운드로 전환될 경우 최대 설정된 초를 초과할 경우 간편인증을 시도
    static let authActiveMaxSeconds = 10 //초 60 * 30
    
    static var currentLang = "ko"
    
    struct JSMsgHandlerName {
        static let jsMsgHandlerName_bioOpen = "bioOpen" //생체인식 호출
        static let jsMsgHandlerName_initBio = "initBio" //생체인식 초기화
        static let jsMsgHandlerName_bioLoginCheck = "bioLoginCheck" //로그인 가능 여부 체크 (퇴사자가 로그인 하지 못하도록)
    }
    
    struct CustomNotification {
        static let bioAuthSuccessNoti = Notification.Name("BioAuthSuccess")
        //static let bioAuthRegisterNoti = Notification.Name("BioAuthRegister")
        static let bioAuthFailNoti = Notification.Name("BioAuthFail")
        static let touchCheckBioAuth = Notification.Name("touchCheckBioAuth")
        static let touchCheckNumberAuth = Notification.Name("touchCheckNumberAuth")
        static let backgroundState = Notification.Name("backgroundState")
        static let foregroundState = Notification.Name("foregroundState")
        static let center = NotificationCenter.default
    }
    
    struct LoginInfoKeychain {
        static let userIdKey = "userIdKey"
        static let userPwKey = "userPwKey"
        //static let userLangKey = "userLangKey"
        static let passCodeKey = "passCodeKey"
    }
    
//    static let AuthCompleteMessage = NSLocalizedString("인증이 완료되었습니다.", comment: "")
//    static let AuthFailMessage = NSLocalizedString("인증이 실패되었습니다.", comment: "")
//    static let PassCodeCompleteMessage = NSLocalizedString("간편번호가 설정되었습니다.", comment: "")
//    static let PassCodeFailCountMessage = NSLocalizedString("%@회 간편번호 입력 실패", comment: "")
}

struct ServerURL {
    static let devURL = URL(string: "http://10.21.7.27") // dev IP
    static let devLoginProcessURL = URL(string: "http://10.21.7.27/login_process") // dev IP
    static let devLoginURL = URL(string: "http://10.21.7.27/login") // dev IP
    static let devMainURLString = "http://10.21.7.27/?lang="
    
    static let liveURL = URL(string: "https://rmffhqjftldpvmdptm.pulmuone.com") // live DNS 이게 진짜 라이브임
    static let liveLoginProcessURL = URL(string: "https://rmffhqjftldpvmdptm.pulmuone.com/login_process") // live DNS 이게 진짜 라이브임
    static let liveLoginURL = URL(string: "http://rmffhqjftldpvmdptm.pulmuone.com/login") // dev IP
    static let liveMainURLString = "http://rmffhqjftldpvmdptm.pulmuone.com/?lang="
}
