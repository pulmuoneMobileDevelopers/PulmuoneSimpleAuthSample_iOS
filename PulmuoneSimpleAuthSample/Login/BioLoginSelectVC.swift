//
//  BioLoginSelectVC.swift
//  mcfs
//
//  Created by 이주한 on 2022/08/29.
//  Copyright © 2022 pulmuone. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

protocol BioLoginSelectVCDelegate {
    func bioLoginSelectBackButtonTouched()
}

class BioLoginSelectVC: PmoViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var passCodeView: CustomView!
    @IBOutlet weak var bioAuthView: CustomView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var simpleNumberLabel: UILabel!
    @IBOutlet weak var bioAuthLabel: UILabel!
    
    @IBOutlet weak var bioAuthImage: UIImageView!
    @IBOutlet weak var simpleNumberImage: UIImageView!
    
    var isBackButtonHidden = true
    var delegate: BioLoginSelectVCDelegate?
    
    var plzAuthBioMessage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log.verbose("viewDidLoad")
        
        titleLabel.minimumScaleFactor = 0.5
        simpleNumberLabel.minimumScaleFactor = 0.5
        bioAuthLabel.minimumScaleFactor = 0.5
        
        bioAuthLabel.adjustsFontSizeToFitWidth = true
        
        backButton.setTitle("", for: .normal)
        
        let passCodeTapGesture = UITapGestureRecognizer(target: self, action: #selector(passCodeTap(sender:)))
        passCodeTapGesture.delegate = self
        passCodeView.addGestureRecognizer(passCodeTapGesture)
        
        let bioAuthTapGesture = UITapGestureRecognizer(target: self, action: #selector(bioAuthTap(sender:)))
        bioAuthTapGesture.delegate = self
        bioAuthView.addGestureRecognizer(bioAuthTapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        log.verbose("viewWillAppear, isBackButtonHidden: \(isBackButtonHidden)")
        self.setLanguage()
        backButton.isHidden = isBackButtonHidden
        
        initButtons()        
        
        let bundle = self.initLanguage()
        plzAuthBioMessage = (bundle?.localizedString(forKey: I18NStrings.PlzAuthBioInfo, value: nil, table: nil))!
    }
    
    @objc func passCodeTap(sender: UITapGestureRecognizer) {
        NotificationCenter.default.post(name: Constants.CustomNotification.touchCheckNumberAuth, object: nil)        
    }
    
    @objc func bioAuthTap(sender: UITapGestureRecognizer) {
        self.checkBioAuth()
    }
    
    @IBAction func backButtonTap(_ sender: Any) {
        print("backButtonTap")
        self.delegate?.bioLoginSelectBackButtonTouched()
        
        //let tappedImage = sender.view as! UIImageView
        //tappedImage.tintColor = UIColor.lightGray
        self.dismiss(animated: false)
    }
    
    private func checkNumberAuth() {
        NotificationCenter.default.post(name: Constants.CustomNotification.touchCheckBioAuth, object: nil)
    }
    
    private func checkBioAuth() {
        NotificationCenter.default.post(name: Constants.CustomNotification.touchCheckBioAuth, object: nil)
        
        let result = BioManager.shared.isSupportBiometrics() //생체인증 기능 제공 여부 조회
        log.verbose("result: \(result.toMap())")
        if (result.success) {
            let register = BioManager.shared.isRegisterBiometrics() //생체인증 등록여부 조회
            self.log.verbose("register: \(register)")
            if (register) {
                //생체인증 서명 요청
                BioManager.shared.signBiometrics(message: "test") { result in
                    if(result.success) {
                        self.log.verbose("생체인증 성공")
                        
                        DispatchQueue.main.async {
                            //self.dismiss(animated: false)
                            NotificationCenter.default.post(name: Constants.CustomNotification.bioAuthSuccessNoti, object: nil)
                        }
                    } else {
                        self.log.verbose("생체인증 실패1")
                        //                        switch result.errorType {
                        //                        case BioErrorType.cancel:  //사용자가 인증을 취소 하였습니다.
                        //                            break
                        //                        case BioErrorType.deviceLockout: //생체인증 시도한 실패 횟수가 너무 많아 생체인증을 사용할수 없습니다.
                        //                            break
                        //                        case BioErrorType.deviceNotEnrolled: //기기에 등록된 생체 인증 정보가 없습니다. 기기에 생체인증 등록후 이용 가능합니다.
                        //                            break
                        //                        case BioErrorType.deviceNotAvailable: //기기에서 생체 인식을 사용할 수 없습니다.
                        //                            break
                        //                        case BioErrorType.deviceNotSupported: //생체인증을 지원하지 않는 기기입니다.
                        //                            break
                        //                        case BioErrorType.appBioNotRegister: //앱에 등록된 생체인증 정보가 없습니다. 앱에 생체인증 등록후 이용해 주세요.
                        //                            break
                        //                        case BioErrorType.existBiometrics: //이미 등록된 생체인증 정보가 존재 합니다.
                        //                            break
                        //                        case BioErrorType.optionOff: //앱내 생체인증 사용 여부 Off 상태임
                        //                            break
                        //                        case BioErrorType.error: //공통 에러(NSError에 상세 코드 확인)
                        //                            break
                        //                        default:
                        //                            break
                        //                        }
                        //                        DispatchQueue.main.async {
                        //                            bioOrNumberLoginBgVC.dismiss(animated: false)
                        //                        }
                        NotificationCenter.default.post(name: Constants.CustomNotification.bioAuthFailNoti, object: result.errorType)
                    }
                }
            } else {
                //생체인증 등록 요청
                BioManager.shared.registerBiometrics(message: self.plzAuthBioMessage) { result in
                    self.log.verbose("생체인증 등록 요청 result.success: \(result.success)")
                    
                    if (result.success) {
                        NotificationCenter.default.post(name: Constants.CustomNotification.bioAuthSuccessNoti, object: nil)
                    } else {
                        NotificationCenter.default.post(name: Constants.CustomNotification.bioAuthFailNoti, object: result.errorType)
                    }
                }
                //NotificationCenter.default.post(name: Constants.CustomNotification.bioAuthRegisterNoti, object: nil)
            }
        } else {
            log.verbose("생체인증 실패2")
            //BioManager.shared.moveSetting() //Device 설정 화면 이동
            log.verbose("\(result.errorType) / \(result.errorMsg) / \(result.errorCode)")
            NotificationCenter.default.post(name: Constants.CustomNotification.bioAuthFailNoti, object: result.errorType)
        }
    }
    
    private func setLanguage() {
        log.verbose("setLanguage")
        
        let bundle = self.initLanguage()
        
        var paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        paragraphStyle.alignment = .center
        
        let titleText = bundle?.localizedString(forKey: I18NStrings.PlzSelectAuthMethod, value: nil, table: nil)
        titleLabel.font = PasscodeViewController.config.pretendard_Regular_23
        titleLabel.attributedText = NSMutableAttributedString(string: titleText!, attributes: [NSAttributedString.Key.kern: -0.44, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.26
        paragraphStyle.alignment = .left
        
        let simpleNumberText = bundle?.localizedString(forKey: I18NStrings.PINNumber, value: nil, table: nil)
        simpleNumberLabel.font = PasscodeViewController.config.pretendard_Regular_17
        simpleNumberLabel?.textColor = PasscodeViewController.config.touchUpTextColor
        simpleNumberLabel.attributedText = NSMutableAttributedString(string: simpleNumberText!, attributes: [NSAttributedString.Key.kern: -0.44, NSAttributedString.Key.paragraphStyle: paragraphStyle])

        let bioAuthText = bundle?.localizedString(forKey: I18NStrings.BioAuth, value: nil, table: nil)
        bioAuthLabel.font = PasscodeViewController.config.pretendard_Regular_17
        bioAuthLabel?.textColor = PasscodeViewController.config.touchUpTextColor
        bioAuthLabel.attributedText = NSMutableAttributedString(string: bioAuthText!, attributes: [NSAttributedString.Key.kern: -0.44, NSAttributedString.Key.paragraphStyle: paragraphStyle])
                
        log.verbose("titleLabel: \(String(describing: titleLabel))")
    }
    
    private func initButtons() {
        bioAuthView.borderColor = PasscodeViewController.config.touchUpColor
        bioAuthLabel?.textColor = PasscodeViewController.config.touchUpTextColor
        bioAuthImage.image = UIImage(named: "ic_bio")
        
        passCodeView.borderColor = PasscodeViewController.config.touchUpColor
        simpleNumberLabel?.textColor = PasscodeViewController.config.touchUpTextColor
        simpleNumberImage.image = UIImage(named: "ic_pincode")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.first?.view == passCodeView) {
            passCodeView.borderColor = PasscodeViewController.config.touchDownColor
            simpleNumberLabel?.textColor = PasscodeViewController.config.touchDownTextColor
            simpleNumberImage.image = UIImage(named: "ic_pincode_green")
            
            bioAuthView.borderColor = PasscodeViewController.config.touchUpColor
            bioAuthLabel?.textColor = PasscodeViewController.config.touchUpTextColor
            bioAuthImage.image = UIImage(named: "ic_bio")
        } else {
            bioAuthView.borderColor = PasscodeViewController.config.touchDownColor
            bioAuthLabel?.textColor = PasscodeViewController.config.touchDownTextColor
            bioAuthImage.image = UIImage(named: "ic_bio_green")
            
            passCodeView.borderColor = PasscodeViewController.config.touchUpColor
            simpleNumberLabel?.textColor = PasscodeViewController.config.touchUpTextColor
            simpleNumberImage.image = UIImage(named: "ic_pincode")
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if (touches.first?.view == passCodeView) {
//            passCodeView.borderColor = PasscodeViewController.config.touchUpColor
//            simpleNumberLabel?.textColor = PasscodeViewController.config.touchUpTextColor
//            simpleNumberImage.image = UIImage(named: "ic_pincode")
//        } else {
//            bioAuthView.borderColor = PasscodeViewController.config.touchUpColor
//            bioAuthLabel?.textColor = PasscodeViewController.config.touchUpTextColor
//            bioAuthImage.image = UIImage(named: "ic_bio")
//        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if (touches.first?.view == passCodeView) {
//            passCodeView.borderColor = PasscodeViewController.config.touchUpColor
//            simpleNumberLabel?.textColor = PasscodeViewController.config.touchUpTextColor
//            simpleNumberImage.image = UIImage(named: "ic_pincode")
//        } else {
//            bioAuthView.borderColor = PasscodeViewController.config.touchUpColor
//            bioAuthLabel?.textColor = PasscodeViewController.config.touchUpTextColor
//            bioAuthImage.image = UIImage(named: "ic_bio")
//        }
    }
}


