//
//  ViewController.swift
//  PulmuoneSimpleAuthSample
//
//  Created by 이주한 on 2022/09/30.
//

import UIKit
import SwiftKeychainWrapper
import SwiftyUserDefaults
import SwiftUI //앱 접근권한 화면은 SwiftUI로 작성되어서 추가해야 함.

class ViewController: PmoViewController, BioLoginSelectVCDelegate {
    
    @IBOutlet weak var btnBioAuth: UIButton!
    @IBOutlet weak var btnCreateSimpleNumber: UIButton!
    @IBOutlet weak var btnVerifySimpleNumber: UIButton!
    @IBOutlet weak var btnAppPermissionList: UIButton!
    @IBOutlet weak var btnAppPermission: UIButton!
    
    private var bioOrNumberLoginBgVC: BioOrNumberLoginBgVC?
    private var bioLoginSelectVC: BioLoginSelectVC?
    
    // 문자열
    private var authCompleteMessage = ""
    private var pinNumberSetMessage = ""
    private var failedPINNumberCountMessage = ""
    private var authFailedMessage = ""
    private var plzAuthBioMessage = ""
    private var deviceLockOutMessage = ""
    private var deviceNotEnrolledMessage = ""
    private var deviceNotAvailableMessage = ""
    private var deviceNotSupportedMessage = ""
    private var appBioNotRegisterMessage = ""
    private var existBiometricsMessage = ""
    private var cancelMessage = ""
    private var confirmMessage = ""
    
    private var retryCount = 0
    
    // 테스트를 위한 계정 설정
    private let userId = "test"
    private let loginPw = "1234"
    
    private var permissionNecessary : [Permissions] = [.camera, .photos]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setObserver()
        self.setLanguage()
        
        // 로그인 정보가 일치한다고 가정하고 키체인에 저장하여 로그인 시도할 때 비교
        KeychainWrapper.standard.set(userId, forKey: Constants.LoginInfoKeychain.userIdKey)
        KeychainWrapper.standard.set(loginPw, forKey: Constants.LoginInfoKeychain.userPwKey)
        
        // 테스트를 위해 앱 실행시 항상 제거
        removeKeyChain()
    }
    
    // MARK: - 생체 인증 통과 이벤트를 수신하기 위한 Observer 등록 및 이벤트 수신
    private func setObserver() {
        //BioLoginSelectVC에서 생체인증 성공할 경우 이벤트
        NotificationCenter.default.addObserver(forName: Constants.CustomNotification.bioAuthSuccessNoti, object: nil, queue: .main, using: bioAuthSuccessReceived(_:))
        //BioLoginSelectVC에서 생체인증 실패할 경우 이벤트
        NotificationCenter.default.addObserver(forName: Constants.CustomNotification.bioAuthFailNoti, object: nil, queue: .main, using: bioAuthFailReceived(_:))
        //BioLoginSelectVC에서 생체인증을 선택할 경우 이벤트
        NotificationCenter.default.addObserver(forName: Constants.CustomNotification.touchCheckBioAuth, object: nil, queue: .main, using: touchCheckBioAuthReceived(_:))
        //BioLoginSelectVC에서 간편번호(PIN)을 선택할 경우 이벤트
        NotificationCenter.default.addObserver(forName: Constants.CustomNotification.touchCheckNumberAuth, object: nil, queue: .main, using: touchCheckNumberAuthReceived(_:))
        
        //포어그라운드 진입 체크
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main, using: foregroundStateReceived(_:))
        //백그라운드 진입 체크
        NotificationCenter.default.addObserver(forName: UIApplication.willResignActiveNotification, object: nil, queue: .main, using: backgroundStateReceived(_:))
    }
    
    private func setLanguage() {
        log.verbose("setLanguage")
        
        let bundle = self.initLanguage()
        self.authCompleteMessage = (bundle?.localizedString(forKey: I18NStrings.AuthComplete, value: nil, table: nil))!
        self.pinNumberSetMessage = (bundle?.localizedString(forKey: I18NStrings.PINNumberSet, value: nil, table: nil))!
        self.authFailedMessage = (bundle?.localizedString(forKey: I18NStrings.AuthFailed, value: nil, table: nil))!
        self.plzAuthBioMessage = (bundle?.localizedString(forKey: I18NStrings.PlzAuthBioInfo, value: nil, table: nil))!
        self.failedPINNumberCountMessage = (bundle?.localizedString(forKey: I18NStrings.FailedPINNumberCount, value: nil, table: nil))!
        self.deviceLockOutMessage = (bundle?.localizedString(forKey: I18NStrings.DeviceLockOut, value: nil, table: nil))!
        self.deviceNotEnrolledMessage = (bundle?.localizedString(forKey: I18NStrings.DeviceNotEnrolled, value: nil, table: nil))!
        self.deviceNotAvailableMessage = (bundle?.localizedString(forKey: I18NStrings.DeviceNotAvailable, value: nil, table: nil))!
        self.deviceNotSupportedMessage = (bundle?.localizedString(forKey: I18NStrings.DeviceNotSupported, value: nil, table: nil))!
        self.appBioNotRegisterMessage = (bundle?.localizedString(forKey: I18NStrings.AppBioNotRegister, value: nil, table: nil))!
        self.existBiometricsMessage = (bundle?.localizedString(forKey: I18NStrings.ExistBiometrics, value: nil, table: nil))!
        self.cancelMessage = (bundle?.localizedString(forKey: I18NStrings.Cancel, value: nil, table: nil))!
        self.confirmMessage = (bundle?.localizedString(forKey: I18NStrings.Confirm, value: nil, table: nil))!
        
        log.verbose("authCompleteMessage: \(authCompleteMessage)")
        log.verbose("pinNumberSetMessage: \(pinNumberSetMessage)")
        log.verbose("authFailedMessage: \(authFailedMessage)")
        log.verbose("failedPINNumberCountMessage: \(failedPINNumberCountMessage)")
        log.verbose("deviceLockOutMessage: \(deviceLockOutMessage)")
        log.verbose("deviceNotEnrolledMessage: \(deviceNotEnrolledMessage)")
        log.verbose("deviceNotAvailableMessage: \(deviceNotAvailableMessage)")
        log.verbose("deviceNotSupportedMessage: \(deviceNotSupportedMessage)")
        log.verbose("appBioNotRegisterMessage: \(appBioNotRegisterMessage)")
        log.verbose("existBiometricsMessage: \(existBiometricsMessage)")
        log.verbose("cancelMessage: \(cancelMessage)")
        log.verbose("confirmMessage: \(confirmMessage)")
    }
    
    // MARK: - 생체 인증 성공 이벤트 수신
    @objc func bioAuthSuccessReceived(_ notification: Notification) {
        log.verbose("생체 인증 성공 이벤트 수신")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.showToast(vc: self.getTopMostViewController()!, message: self.authCompleteMessage)
        }
        self.dismiss(animated: false)
        self.getTopMostViewController()?.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - 생체 인증 실페 이벤트 수신
    @objc func bioAuthFailReceived(_ notification: Notification) {
        log.error("생체 인증 실패 이벤트 수신")
        
        self.removeKeyChain()
        //self.isBioOrPassCodeLogin = false
        
        var _message = ""
        
        if let result = notification.object as? BioErrorType {
            print("BioErrorType: \(result)")
            print("생체 인증 실패 이벤트 수신: bioLoginSelectVC: \(String(describing: bioLoginSelectVC))")
            
            switch result {
            case BioErrorType.cancel:  //사용자가 인증을 취소 하였습니다.
                break
            case BioErrorType.deviceLockout: //생체인증 시도한 실패 횟수가 너무 많아 생체인증을 사용할수 없습니다.
                _message = self.deviceLockOutMessage
                break
            case BioErrorType.deviceNotEnrolled: //기기에 등록된 생체 인증 정보가 없습니다. 기기에 생체인증 등록후 이용 가능합니다.
                _message = self.deviceNotEnrolledMessage
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                    self.showToast(vc: self.getTopMostViewController()!, message: self.authFailedMessage)
                }
                
                self.showAlertPopup(popupText: _message, okBtnName: self.confirmMessage, cancelBtnName: self.cancelMessage) { Bool in
                    // 생체인증 및 간편번호 설정값 초기화
                    Defaults[key: Constants.userDefault_BioAuthLoginKey] = false
                    Defaults[key: Constants.userDefault_PinCodeLoginKey] = false
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        self.getRootViewController()?.dismiss(animated: false, completion: nil)
                        if (Bool) {
                            BioManager.shared.moveSetting() //Device 설정 화면 이동
                        }
                    }
                    Defaults[key: Constants.userDefault_IsLoginKey] = false
                    self.getTopMostViewController()?.dismiss(animated: false, completion: nil)
                }
                
                return
            case BioErrorType.deviceNotAvailable: //기기에서 생체 인식을 사용할 수 없습니다.
                _message = self.deviceNotAvailableMessage
                break
            case BioErrorType.deviceNotSupported: //생체인증을 지원하지 않는 기기입니다.
                _message = self.deviceNotSupportedMessage
                break
            case BioErrorType.appBioNotRegister: //앱에 등록된 생체인증 정보가 없습니다. 앱에 생체인증 등록후 이용해 주세요.
                _message = self.appBioNotRegisterMessage
                break
            case BioErrorType.existBiometrics: //이미 등록된 생체인증 정보가 존재 합니다.
                _message = self.existBiometricsMessage
                break
            case BioErrorType.optionOff: //앱내 생체인증 사용 여부 Off 상태임
                break
            case BioErrorType.error: //공통 에러(NSError에 상세 코드 확인)
                _message = self.authFailedMessage
                break
            default:
                break
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                if (!_message.isEmpty && _message.count > 0) {
                    self.showAlertPopup(popupText: _message, okBtnName: self.confirmMessage) { Bool in
                        self.getRootViewController()?.dismiss(animated: false, completion: nil)
                    }
                } else {
                    self.getRootViewController()?.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    
    // MARK: - 생체 인증 등록 요청 이벤트 수신
    @objc func bioAuthRegisterReceived(_ notification: Notification) {
        log.verbose("생체 인증 등록 요청 이벤트 수신")
        //self.moveToLoginPage()
        BioManager.shared.registerBiometrics(message: self.plzAuthBioMessage) { result in
            
        }
    }
    
    // MARK: - 로그인 방법 선택 (간편번호, 생체인증) 화면에서 생체인증 버튼 선택했을 경우
    @objc func touchCheckBioAuthReceived(_ notification: Notification) {
        log.verbose("생체 인증 버튼 선택")
        //self.isTouchIDFaceIDProcessing = true
        
        if (self.bioOrNumberLoginBgVC == nil) {
            self.bioOrNumberLoginBgVC = BioOrNumberLoginBgVC()
        }
        
        self.bioOrNumberLoginBgVC!.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.getTopMostViewController()?.present(self.bioOrNumberLoginBgVC!, animated: false) {}
        }
        
        // 생체인증 or 간편번호 선택 여부 저장, 앱 실행시 체크해서 생체인증 or 간편번호 화면을 보임
        Defaults[key: Constants.userDefault_BioAuthLoginKey] = true
        Defaults[key: Constants.userDefault_PinCodeLoginKey] = false
    }
    
    // MARK: - 로그인 방법 선택 (간편번호, 생체인증) 화면에서 간편번호 버튼 선택했을 경우
    @objc func touchCheckNumberAuthReceived(_ notfication: Notification) {
        log.verbose("간편번호 버튼 선택")
        self.showPassCodeVC(mode: .CREATE)
    }
    
    // MARK: - 앱이 포어그라운드(앱 실행) 상태 수신
    @objc func foregroundStateReceived(_ notfication: Notification) {
        log.verbose("foregroundStateReceived")
        //앱이 백그라운드에서 포어그라운드로 진입할 때 설정된 간편인증 화면(생체/간편번호)을 보이는 시간을 설정하여 처리 필요.
    }
    
    // MARK: - 앱이 백그라운드 상태 수신
    @objc func backgroundStateReceived(_ notfication: Notification) {
        log.verbose("backgroundStateReceived")
        //앱이 백그라운드에서 포어그라운드로 진입할 때 설정된 간편인증 화면(생체/간편번호)을 보이는 시간을 설정하여 처리 필요.
    }
    
    // MARK: - 간편번호 입력 화면 보임
    private func showPassCodeVC(mode: PasscodeViewController.Mode) {
        var passCodeFailCount = 0
        
        DispatchQueue.main.async {
            if let vc = PasscodeViewController.instance(with: mode) {
                vc.modalPresentationStyle = .fullScreen
                self.getTopMostViewController()?.present(vc, animated: false)
                vc.show { passcode, newPasscode, mode in
                    self.log.verbose("passcode: \(passcode), newPasscode: \(newPasscode), mode: \(mode)")
                    
                    // 간편번호 생성
                    if (mode == .CREATE) {
                        self.log.verbose("PassCode Creeate")
                        //키체인에 4자리 간편번호 저장
                        KeychainWrapper.standard.set(passcode, forKey: Constants.LoginInfoKeychain.passCodeKey)
                        
                        // 생체인증 or 간편번호 선택 여부 저장, 앱 실행시 체크해서 생체인증 or 간편번호 화면을 보임
                        Defaults[key: Constants.userDefault_BioAuthLoginKey] = false
                        Defaults[key: Constants.userDefault_PinCodeLoginKey] = true
                        
                        self.showToast(vc: self.getTopMostViewController()!, message: self.pinNumberSetMessage)
                        
                        // 토스트 메시지 보여주고 바로 간편번호 화면을 닫지 말고 2초후에 닫히도록 함.
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                            vc.dismiss(animated: false)
                            self.getRootViewController()?.dismiss(animated: false, completion: nil)
                        }
                        
                    }
                    // 간편번호 생성 후 검증
                    else if (mode == .VERIFY) {
                        self.log.verbose("PassCode Verify")
                        let savedPassCode: String? = KeychainWrapper.standard.string(forKey: Constants.LoginInfoKeychain.passCodeKey) ?? ""
                        //키체인에 저장된 4자리 간편번호와 현재 입력한 간편번호와 비교
                        if (passcode == savedPassCode) {
                            self.log.verbose("PassCode Verify Pass!!!")
                            //self.isBioOrPassCodeLogin = true
                            passCodeFailCount = 0
                            
                            /**
                             TODO: 간편번호가 매칭되어 성공이 될 경우 할 일...
                             */
                            DispatchQueue.main.async {
                                self.showToast(vc: self.getTopMostViewController()!, message: self.authCompleteMessage)
                            }
                        } else {
                            passCodeFailCount += 1
                            
                            self.log.verbose("PassCode Verify passCodeFailCount: \(passCodeFailCount)!!!")
                            let passCodeFailCountMsg = String(format: self.failedPINNumberCountMessage, passCodeFailCount, Constants.passCodeFailMaxCount)
                            //AppSnackBar.make(in: (self.getTopMostViewController()?.view)!, message: passCodeFailCountMsg, duration: .lengthShort).show()
                            self.showToast(vc: self.getTopMostViewController()!, toastMode: .WARNING, message: passCodeFailCountMsg)
                            
                            if(passCodeFailCount >= Constants.passCodeFailMaxCount) {
                                self.log.verbose("PassCode Verify FailCount Over!!!")
                                Defaults[key: Constants.userDefault_PinCodeLoginKey] = false
                                
                                /**
                                 TODO: 간편번호가 매칭안되어 실패할 경우 할 일...
                                 */
                                passCodeFailCount = 0
                            }
                        }
                    }
                    vc.startProgressing()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                        vc.stopProgress()
                        if (mode == .VERIFY && passCodeFailCount <= 0) {
                            vc.dismiss(animated: false, completion: nil)
                        }
                    }
                } notMatchCallback: { notMatchCount in // 일치하지 않는 횟수 콜백, 최대 5번 시도
                    self.log.error("notMatchCount: \(notMatchCount)")
                    
                    if (notMatchCount >= Constants.passCodeFailMaxCount) {
                        self.removeKeyChain()
                        
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                            vc.dismiss(animated: false)
                            self.getRootViewController()?.dismiss(animated: false, completion: nil)
                        }
                    }
                    
                    self.showToast(vc: self.getTopMostViewController()!, toastMode: .WARNING, message: String(format: self.failedPINNumberCountMessage, (notMatchCount), Constants.passCodeFailMaxCount))
                }
            }
        }
    }
    
    // MARK: - 간편인증 초기화 될 경우, 생체인증/간편번호 선택 화면 보임
    private func showBioLoginSelectVC(isBackButtonHidden: Bool = true, completion: @escaping () -> Void) {
        log.verbose("isBackButtonHidden: \(isBackButtonHidden)")
        DispatchQueue.main.async {
            if (self.bioLoginSelectVC == nil) {
                self.bioLoginSelectVC = BioLoginSelectVC()
            }
            self.bioLoginSelectVC?.delegate = self
            self.bioLoginSelectVC?.isBackButtonHidden = isBackButtonHidden
            
            self.bioLoginSelectVC?.modalPresentationStyle = .fullScreen
            self.present(self.bioLoginSelectVC!, animated: false) {
                completion()
            }
        }
    }
    
    // MARK: - 생체인증 기능 제공 및 등록 여부 조회, 등록 요청
    private func checkKeyChianSaved(completion: @escaping () -> Void) {
        let retrievedUserId: String? = KeychainWrapper.standard.string(forKey: Constants.LoginInfoKeychain.userIdKey)
        log.verbose("retrievedUserId = \(String(describing: retrievedUserId))")
        
        // 생체인증과 간편번호 인증이 아닐 경우, 또는 저장된 로그인 아이디 (user id)가 없을 경우
        if ((!Defaults[key: Constants.userDefault_BioAuthLoginKey] && !Defaults[key: Constants.userDefault_PinCodeLoginKey]) || retrievedUserId == nil || retrievedUserId == "") {
            DispatchQueue.main.async {
                /**
                 간편인증 선택 화면 좌측 상단 백 버튼 안보이기
                 */
//                self.showBioLoginSelectVC() {
//                    completion()
//                }
                /**
                 간편인증 선택 화면 좌측 상단 백 버튼 보이기 (초기화 화면에서 보이게 처리하면 좋을 듯)
                 */
                self.showBioLoginSelectVC(isBackButtonHidden: false) {
                    completion()
                }

            }
        } else {
            log.verbose("bioOrNumberLoginBgVC show")
            if (self.getTopMostViewController() != nil) {
                log.verbose("getTopMostViewController(): \(String(describing: self.getTopMostViewController()))")
            }
            
            DispatchQueue.main.async {
                self.bioOrNumberLoginBgVC = BioOrNumberLoginBgVC()
                self.bioOrNumberLoginBgVC!.modalPresentationStyle = .fullScreen
                self.getTopMostViewController()?.present(self.bioOrNumberLoginBgVC!, animated: false) {
                    completion()
                }
            }
            
            let result = BioManager.shared.isSupportBiometrics() //생체인증 기능 제공 여부 조회
            
            if (result.success) {
                let register = BioManager.shared.isRegisterBiometrics() //생체인증 등록여부 조회
                if (register) {
                    //생체인증 서명 요청
                    BioManager.shared.signBiometrics(message: self.plzAuthBioMessage) { result in
                        if(result.success) {
                            self.log.verbose("생체인증 통과")
                            self.retryCount = 0
                            
                            DispatchQueue.main.async {
                                self.showToast(vc: self.getTopMostViewController()!, message: self.authCompleteMessage)
                            }
                            
                        } else {
                            self.log.verbose("생체인증 실패")
                            
                            DispatchQueue.main.async {
                                self.removeKeyChain()
                                self.showToast(vc: self.getTopMostViewController()!, toastMode: .WARNING, message: self.authFailedMessage)
                            }
                        }
                    }
                } else {
                    //생체인증 등록 요청
                    BioManager.shared.registerBiometrics(message: self.plzAuthBioMessage) { result in
                        self.log.verbose("생체인증 등록 요청, result: \(result)")
                    }
                }
            } else {
                log.verbose("\(result.errorType) / \(result.errorMsg) / \(result.errorCode)")
                
                var notification = Notification(name: Constants.CustomNotification.bioAuthFailNoti)
                notification.object = result.errorType
                self.bioAuthFailReceived(notification)
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0) {
                self.getRootViewController()?.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    // MARK: - 앱 접근권한 목록 보여주기
    private func showPermissionList() {
        var contentView: UIHostingController<PermissionContentView>?
        // 퍼미션 팝업 호출을 Observe 하는 ObservedObject 생성
        @ObservedObject var popupState = PopupState()
        popupState.setShow(showing: true)
        
        // 퍼미션 팝업 설정.
        let permissionContentView = PermissionContentView (popupState: popupState,
                               // 팝업에 노출될 필수 권한 리스트
                               permissionListNecessary: [Permissions.contacts,
                                                         Permissions.history,
                                                         Permissions.location,
                                                         Permissions.callkit,
                                                         Permissions.camera],
                               // 팝업에 노출 될 선택 권한 리스트
                               permissionListOptional: [Permissions.media_library,
                                                        Permissions.photos,
                                                        Permissions.microphone,
                                                        Permissions.calendar],
                                                           
                               /**
                                * 정의 되어 있는 권한 외에 노출해야할 내용이 있을 경우
                                * permissionListNecessaryEtc, permissionListOptionalEtc 를 통해 정의 가능
                                */
                               permissionListNecessaryEtc: [
                                PermissionItem(
                                    // 노출할 이미지 (asset 에 추가 되어 있어야 함.
                                    permissionImgString: "camera",
                                    titleMain: "메인 텍스트 1",
                                    titleSub: "서브 텍스트 2"
                                )],
                               permissionListOptionalEtc: [
                                PermissionItem(
                                    // 노출할 이미지 (asset 에 추가 되어 있어야 함.
                                    permissionImgString: "contacts",
                                    titleMain: "메인 텍스트 1",
                                    titleSub: "서브 텍스트 2"
                                )],
                                
                               // 접근권한 수동 변경 방법에 표시될 문구
                               permissionSettingDesc: "앱 설정 위치",
                               // 변경할 이미지 리스트 (Dictionary 형태, Permissions: 노출할 Icon text, 필수 값은 아니며 입력 없을 시 기본 아이콘 노출 됨
//                               permissionImage: [Permissions.camera: "camera_test",
//                                                 Permissions.photos: "photo_test",
//                                                 Permissions.microphone: "mic_test",
//                                                 Permissions.location: "location_test"],
                               // 아이콘 색상 및 백그라운드 색상, 필수 값 아니며 입력 없을 시 기본 색상 노출 됨.
//                               iconForegroundColor: Color.black,
//                               iconBackgroundColor: Color.pulmuone_def,
                               // 확인 버튼 선택 시 수행할 작업.
                               onConfirmPermission: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                contentView!.view.removeFromSuperview()
            }
        })
        
        contentView = UIHostingController(rootView: permissionContentView)
        contentView!.view.backgroundColor = UIColor.clear
        contentView!.modalPresentationStyle = .fullScreen
        self.addChild(contentView!)
        self.view.addSubview((contentView?.view)!)
        
        contentView?.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView!.view.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            contentView!.view.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            contentView!.view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            contentView!.view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])
    }
    
    // MARK: - 앱 접근 권한 요청하기
    private func requestNecessaryPermissions() {
        let permissionManager = PermissionManager()

        for permissionItem in permissionNecessary {
            let permissionData = permissionManager.getPermissionAuth(permissionItem: permissionItem)
            
            if (permissionData != .authorized ) {
                
                permissionManager
                    .requestPermissions(permission: [permissionItem],
                                        isNacessary: true,
                                        onConfirmPermission: { isSuccess, callbackMessage, isNecessary in
                        if (isSuccess) {
                            self.requestNecessaryPermissions()
                        }
                        else {
                            let nessaryMessage = "다음의 필수 권한이 거절 되었습니다. [" + permissionItem.toString + "] 권한 요청을 위해 설정 화면으로 이동합니다."
                            self.showAlertPopup(popupText: nessaryMessage, okBtnName: self.confirmMessage, cancelBtnName: self.cancelMessage) { Bool in
                                
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                                    self.getRootViewController()?.dismiss(animated: false, completion: nil)
                                    if (Bool) {
                                        self.toAppSetting() //Device 설정 화면 이동
                                    }
                                }
                                
                                self.getTopMostViewController()?.dismiss(animated: false, completion: nil)
                            }
                        }
                    })
                return
            }
        }
    }
    
    // MARK: - 앱 설정 페이지로 이동
    private func toAppSetting() {
      if let url = URL(string: UIApplication.openSettingsURLString) {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }
    }
    
    // MARK: - 키체인에 저장된 사용자 아이디, 비번 정보 삭제
    private func removeKeyChain() {
        KeychainWrapper.standard.removeObject(forKey: Constants.LoginInfoKeychain.userIdKey)
        KeychainWrapper.standard.removeObject(forKey: Constants.LoginInfoKeychain.userPwKey)
    }
    
    // MARK: - BioLoginSelectVC의 Back Button 터치 이벤트 수신
    func bioLoginSelectBackButtonTouched() {
        self.log.verbose("bioLoginSelectBackButtonTouched")
        self.removeKeyChain()
    }
    
    // MARK: - 생체 인증 버튼 터치 이벤트 수신
    @IBAction func touchedBioAuthBtn(_ sender: UIButton) {
        self.checkKeyChianSaved {
            self.log.verbose("touchedBioAuthBtn")
        }
    }
    
    // MARK: - 간편번호 생성 버튼 터치 이벤트 수신
    @IBAction func touchedCreateSimpleAuthBtn(_ sender: UIButton) {
        self.log.verbose("touchedCreateSimpleAuthBtn")

        self.showPassCodeVC(mode: .CREATE)
    }
    
    // MARK: - 간편번호 인증 버튼 터치 이벤트 수신
    @IBAction func touchedVeritySimpleAuthBtn(_ sender: Any) {
        self.log.verbose("touchedCreateSimpleAuthBtn")
        
        self.showPassCodeVC(mode: .VERIFY)
    }
    
    // MARK: - 앱 접근권한 목록 화면 버튼 터치 이벤트 수신
    @IBAction func touchedAppPermissionListBtn(_ sender: Any) {
        self.log.verbose("touchedAppPermissionListBtn")
                
        self.showPermissionList()
    }
    
    // MARK: - 앱 접근권한 화면 버튼 터치 이벤트 수신
    @IBAction func touchedAppPermissionBtn(_ sender: Any) {
        self.log.verbose("touchedAppPermissionBtn")
        DispatchQueue.main.async {
            self.requestNecessaryPermissions()
        }
    }
}

