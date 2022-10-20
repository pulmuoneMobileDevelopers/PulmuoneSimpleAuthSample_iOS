//
//  BioUserDefaults.swift
//  modulebio
//
//  Created by lucas on 2022/01/25.
//

import Foundation

/// 생체인증용 UserDefaults 확장 Class
extension UserDefaults {
   
    /**
     생체인증 정보 등록 여부 조회
     - returns: 등록된 생체인증정보가 존재하는 경우 **true**
     */
    func isRegisterBiometrics() -> Bool {
        let result = bool(forKey: BioUserDefaultsKeys.register.rawValue);
        BioLog.log("isRegisterBiometrics \(result)")
        return result
    }
    
    /**
     생체인증 정보 등록
     - Parameters:
        - type : 생체인증 등록시 사용한 생체인증 유형
     */
    func registerBiometrics() {
        BioLog.log("registerBiometrics")
        set(true, forKey: BioUserDefaultsKeys.register.rawValue)
        set(true, forKey: BioUserDefaultsKeys.use.rawValue)
        synchronize()
    }
    
    /**
     등록된 생체인증 정보 삭제
     */
    func removeBiometrics() {
        BioLog.log("removeBiometrics")
        removeObject(forKey: BioUserDefaultsKeys.register.rawValue)
        removeObject(forKey: BioUserDefaultsKeys.use.rawValue)
        synchronize()
    }

    /**
     등록된 생체인증 사용 여부 조회
     - Returns: 생체인증 사용시 **true**
     */
    func isUseBiometrics() -> Bool {
        return bool(forKey: BioUserDefaultsKeys.use.rawValue);
    }
    
    /**
     등록된 생체인증 사용여부 설정
     - Parameters:
        - use: 사용여부 설정 사용시 **true**
     */
    func changeUseBiometrics(_ use: Bool) {
        set(use, forKey: BioUserDefaultsKeys.use.rawValue);
        synchronize()
    }
    
}
