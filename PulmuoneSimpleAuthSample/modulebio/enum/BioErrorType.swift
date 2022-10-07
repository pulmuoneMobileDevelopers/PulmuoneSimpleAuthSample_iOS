//
//  BioErrorType.swift
//  modulebio
//
//  Created by lucas on 2022/01/26.
//

import Foundation

/// 생체인증 오류 열거 타입
/// > 생체인증 모듈 사용시 발생하는 오류별 유형
/// - **success** : 성공
/// - **cancel** : 사용자가 인증을 취소 하였습니다.
/// - **deviceLockout** : 생체인증 시도한 실패 횟수가 너무 많아 생체인증을 사용할수 없습니다.
/// - **deviceNotEnrolled** : 기기에 등록된 생체 인증 정보가 없습니다. 기기에 생체인증 등록후 이용 가능합니다.
/// - **deviceNotAvailable** : 기기에서 생체 인식을 사용할 수 없습니다.
/// - **deviceNotSupported** : 생체인증을 지원하지 않는 기기입니다.
/// - **appBioNotRegister** : 앱에 등록된 생체인증 정보가 없습니다. 앱에 생체인증 등록후 이용해 주세요.
/// - **existBiometrics** : 이미 등록된 생체인증 정보가 존재 합니다.
/// - **optionOff** : 앱내 생체인증 사용 여부 Off 상태임
/// - **error** : 공통 에러(NSError에 상세 코드 확인)
public enum BioErrorType : Int {
    case success = 0
    case cancel = 1
    case deviceLockout = 2
    case deviceNotEnrolled = 3
    case deviceNotAvailable = 4
    case deviceNotSupported = 5
    case appBioNotRegister = 6
    case existBiometrics = 7
    case optionOff = 8
    case error = 9
}
