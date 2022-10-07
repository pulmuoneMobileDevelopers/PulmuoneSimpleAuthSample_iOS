//
//  BioUserDefaultsKeys.swift
//  modulebio
//
//  Created by lucas on 2022/01/25.
//

import Foundation

/// 생체인증 저장키 열거 타입
/// > 생체인증 모듈에서 저장시 사용되는 저장키 유형
/// - **register** : 생체 인증 등록 여부
/// - **use** : 등록된 생체인증 사용 여부
enum BioUserDefaultsKeys: String {
    case register = "#Plumuone_Bio_register"
    case use = "#Plumuone_Bio_use"
}
