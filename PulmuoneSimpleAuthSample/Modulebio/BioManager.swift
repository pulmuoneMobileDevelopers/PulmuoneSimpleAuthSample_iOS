//
//  BioManager.swift
//  modulebio
//
//  Created by lucas on 2022/01/25.
//
import UIKit
import Foundation
import LocalAuthentication

/// 생체인증 모듈 Manager Singleton Class
public class BioManager : BioProtocol {
    
    
    private init() { }
    public static let shared = BioManager()

    /**
     Device 생체인증 기능 제공 여부 조회
     - Parameters:
        - type: 사용하고자 하는 생체인증 유형
     - returns: BioResult
     */
    public func isSupportBiometrics() -> BioResult {
        var success = false;
        var errorType: BioErrorType = BioErrorType.error
        var error: NSError?
        let authContext = LAContext()
        authContext.localizedFallbackTitle = ""
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if #available(iOS 11.0, *) {
                switch authContext.biometryType {
                case .faceID:
                    BioLog.log("faceID 를 지원하는 단말입니다.")
                    success = true;
                    break;
                case .touchID:
                    BioLog.log("touchID 를 지원하는 단말입니다.")
                    success = true;
                    break;
                default:
                    BioLog.log("생체인증을 미지원하는 단말입니다.")
                    errorType = BioErrorType.deviceNotSupported
                    break;
                }
            }else {
                BioLog.log("11 미만 버전으로 touchID 만 제공하는 단말입니다.")
                success = true;
            }
        }else {
            return errorToBioResult(error)
        }
        
        return BioResult(success: success, errorType: errorType, error: error);
    }

    /**
     Device 설정 화면 이동
     */
    public func moveSetting() {
        let uri = UIApplication.openSettingsURLString
        if let url = URL(string: uri) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            }else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    /**
     생체인증 등록여부 조회
     - Returns: 생체인증 등록여부 등록시 **true**
     */
    public func isRegisterBiometrics() -> Bool {
        return UserDefaults.standard.isRegisterBiometrics()
    }

    /**
     생체인증 등록 요청
     - Parameters:
        - type : 등록할 생체인증 유형
        - message : 생체인증 팝업 노출 메세지
        - closure : 등록시 발생한 결과값
     */
    public func registerBiometrics(message: String, closure: @escaping (BioResult)->()) {
        if(isRegisterBiometrics()) {
            BioLog.log("이미 등록된 생체인증 정보가 존재 합니다.")
            closure(BioResult(success: false, errorType: BioErrorType.existBiometrics))
            return
        }
        
        let result = isSupportBiometrics()
        if(!result.success) {
            closure(result)
        }else {
            let authContext = LAContext()
            authContext.localizedFallbackTitle = ""
            authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: message) { (success, err) in
                if(success) {
                    BioLog.log(success)
                    UserDefaults.standard.registerBiometrics()
                    closure(BioResult(success: true, errorType: BioErrorType.success))
                }else {
                    let error = err as NSError?
                    if(error != nil) {
                        BioLog.log(error!.localizedDescription)
                    }
                    closure(self.errorToBioResult(error))
                }
            }
        }
    }

    /**
     생체인증 서명 요청
     - Parameters:
        - message : 생체인증 팝업 노출 메세지
        - closure : 서명시 발생한 결과값
     */
    public func signBiometrics(message: String, closure: @escaping (BioResult)->()) {
        if(!isRegisterBiometrics()) {
            BioLog.log("생체정보 등록후 이용 가능합니다.")
            closure(BioResult(success: false, errorType: BioErrorType.appBioNotRegister))
            return
        }
        let use = UserDefaults.standard.isUseBiometrics()
        if(!use) {
            BioLog.log("앱내 생체인증 사용이 Off 입니다.")
            closure(BioResult(success: false, errorType: BioErrorType.appBioNotRegister))
            return
        }
        let authContext = LAContext()
        authContext.localizedFallbackTitle = ""
        authContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: message) { (success, err) in
            if(success) {
                closure(BioResult(success: true, errorType: BioErrorType.success))
            }else {
                let error = err as NSError?
                if(error != nil) {
                    BioLog.log(error!.localizedDescription)
                }
                closure(self.errorToBioResult(error))
            }
        }
    }
    
    /**
     등록된 생체인증 정보 삭제 요청
     */
    public func removeBiometrics() {
        UserDefaults.standard.removeBiometrics()
    }

    /**
     등록된 생체인증 사용여부 설정값 조회
     - Returns: 샤용여부 가능인경우 **true**
     */
    public func isUseBiometrics() -> Bool {
        return UserDefaults.standard.isUseBiometrics()
    }
    
    /**
     등록된 생체인증 사용여부 설정
     - Parameters:
        - use : 사용여부 설정 사용시 **true**
     - Returns: 사용여부 설정 변경에 따른 결과값 변경 성공시 **true** 생체인증 등록후 변경이 가능
     */
    public func changeUseBiometrics(use: Bool) -> Bool {
        if(!isRegisterBiometrics()) {
            return false
        }else {
            UserDefaults.standard.changeUseBiometrics(use)
            return true
        }
    }
    
    // error to BioResut Convert
    func errorToBioResult(_ error: NSError?) -> BioResult {
        var errorType: BioErrorType = BioErrorType.error
        if let error = error {
            switch Int32(error.code) {
            case kLAErrorAppCancel:// LAError.appCancel.rawValue:
                // 앱에서 인증을 취소했습니다.
                BioLog.log("appCancel")
                errorType = BioErrorType.cancel
                break;
            case kLAErrorSystemCancel:// LAError.systemCancel.rawValue:
                // 시스템에서 인증을 취소했습니다.
                BioLog.log("systemCancel")
                errorType = BioErrorType.cancel
                break;
            case kLAErrorUserCancel://LAError.userCancel.rawValue:
                // 사용자 인증 대화 상자에서 취소 버튼을 택했습니다.
                BioLog.log("userCancel")
                errorType = BioErrorType.cancel
                break;
            case kLAErrorAuthenticationFailed:// LAError.authenticationFailed.rawValue:
                // 사용자가 유효한 자격 증명을 제공하지 못했습니다.
                BioLog.log("authenticationFailed")
                break;
            case kLAErrorInvalidContext:// LAError.invalidContext.rawValue:
                // 컨텍스트가 이전에 무효화되었습니다.
                BioLog.log("invalidContext")
                break;
            case kLAErrorNotInteractive:// LAError.notInteractive.rawValue:
                // 필수 인증 사용자 인터페이스를 표시하는 것은 금지되어 있습니다.
                BioLog.log("notInteractive")
                break;
            case kLAErrorPasscodeNotSet:// LAError.passcodeNotSet.rawValue:
                // 장치에 암호가 설정되어 있지 않습니다.
                BioLog.log("passcodeNotSet")
                break;
            case kLAErrorUserFallback:// LAError.userFallback.rawValue:
                // 사용자가 인증 대화 상자에서 대체 버튼을 탭했지만 인증 정책에 사용할 수 있는 대체가 없습니다.
                BioLog.log("userFallback")
                break;
            default:
                BioLog.log("\(error.code) : \(error.localizedDescription)")
                break
            }
            if #available(iOS 11.0, *) {
                switch Int32(error.code) {
                case kLAErrorBiometryLockout:// LAError.biometryLockout.rawValue:
                    // 실패한 시도가 너무 많아 생체 인식이 잠겨 있습니다.
                    BioLog.log("biometryLockout")
                    errorType = BioErrorType.deviceLockout
                    break;
                case kLAErrorBiometryNotAvailable:// LAError.biometryNotAvailable.rawValue:
                    // 기기에서 생체 인식을 사용할 수 없습니다.
                    BioLog.log("biometryNotAvailable")
                    errorType = BioErrorType.deviceNotAvailable
                    break;
                case kLAErrorBiometryNotEnrolled:// LAError.biometryNotEnrolled.rawValue:
                    // 단말에 등록된 생체인증 정보가 없습니다.
                    BioLog.log("biometryNotEnrolled")
                    errorType = BioErrorType.deviceNotEnrolled
                    break;
                default:
                    BioLog.log("\(error.code) : \(error.localizedDescription)")
                    break
                }
            } else {
                switch Int32(error.code) {
                case kLAErrorTouchIDLockout:// LAError.touchIDLockout.rawValue:
                    // 실패한 시도가 너무 많아 TouchID가 잠겨 있습니다.
                    BioLog.log("touchIDLockout")
                    errorType = BioErrorType.deviceLockout
                    break;
                case kLAErrorTouchIDNotAvailable:// LAError.touchIDNotAvailable.rawValue:
                    // 장치에서 TouchID를 사용할 수 없습니다.
                    BioLog.log("touchIDNotAvailable")
                    errorType = BioErrorType.deviceNotAvailable
                    break;
                case kLAErrorTouchIDNotEnrolled:// LAError.touchIDNotEnrolled.rawValue:
                    // 단말에 등록된 생체인증 정보가 없습니다.
                    BioLog.log("touchIDNotEnrolled")
                    errorType = BioErrorType.deviceNotEnrolled
                    break;
                default:
                    BioLog.log("\(error.code) : \(error.localizedDescription)")
                    break
                }
            }
            
        }
        return BioResult(success: false, errorType: errorType, error: error);
    }
}
