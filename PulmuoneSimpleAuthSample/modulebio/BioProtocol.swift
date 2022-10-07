//
//  BioProtocol.swift
//  modulebio
//
//  Created by lucas on 2022/01/27.
//

import Foundation

protocol BioProtocol {
    
    /**
     Device 생체인증 기능 제공 여부 조회
     - returns: BioResult
     */
    func isSupportBiometrics() -> BioResult

    /**
     Device 설정 화면 이동
     */
    func moveSetting()

    /**
     생체인증 등록여부 조회
     - Returns: 생체인증 등록여부 등록시 **true**
     */
    func isRegisterBiometrics() -> Bool

    /**
     생체인증 등록 요청
     - Parameters:
        - message : 생체인증 팝업 노출 메세지
        - closure : 등록시 발생한 결과값
     */
    func registerBiometrics(message: String, closure: @escaping (BioResult)->())

    /**
     생체인증 서명 요청
     - Parameters:
        - message : 생체인증 팝업 노출 메세지
        - closure : 서명시 발생한 결과값
     */
    func signBiometrics(message: String, closure: @escaping (BioResult)->())
    
    /**
     등록된 생체인증 정보 삭제 요청
     */
    func removeBiometrics()

    /**
     등록된 생체인증 사용여부 설정값 조회
     - Returns: 샤용여부 가능인경우 **true**
     */
    func isUseBiometrics() -> Bool
    
    /**
     등록된 생체인증 사용여부 설정
     - Parameters:
        - use : 사용여부 설정 사용시 **true**
     - Returns: 사용여부 설정 변경에 따른 결과값 변경 성공시 **true** 생체인증 등록후 변경이 가능
     */
    func changeUseBiometrics(use: Bool) -> Bool
}
