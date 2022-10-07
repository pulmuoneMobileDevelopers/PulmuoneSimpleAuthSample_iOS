//
//  BioResult.swift
//  modulebio
//
//  Created by lucas on 2022/01/26.
//

import Foundation

/// 생체인증 응답 Class
public class BioResult {
    
    /**
     BioResult 생성자
     - Parameters:
        - success : 성공 실패 여부 성공시 **true**
        - errorType : 성공 실패에 따른 오류별 유형
        - error : 오류발생시 원본 데이터
     */
    internal init(success: Bool = false,
                  errorType: BioErrorType = BioErrorType.error,
                  error: NSError? = nil) {
        self._success = success
        self._errorType = success ? BioErrorType.success : errorType
        
        self._errorCode = error?.code ?? BioErrorType.success.rawValue
        self._errorMsg = error?.localizedDescription ?? ""
        
        BioLog.log("BioResult \(_success) / \(_errorType) /  \(_errorCode) / \(_errorMsg)")
    }
    
    var _success: Bool
    var _errorType: BioErrorType
    var _errorCode: Int
    var _errorMsg: String
    
    /// 성공 실패 여부 성공시 **true**
    public var success: Bool {
        get {
            return _success
        }
    }
    
    /// 성공 실패에 따른 오류별 유형
    public var errorType: BioErrorType {
        get {
            return _errorType
        }
    }
    
    /// 오류 발생시 원본 에러코드
    public var errorCode: Int {
        get {
            return _errorCode
        }
    }
    
    /// 오류 발생시 원본 에러 메시지
    public var errorMsg: String {
        get {
            return _errorMsg
        }
    }
    
    public func toMap() -> [String: Any?] {
        return [
            "success": _success,
            "errorType": _errorType.rawValue,
            "errorCode": _errorCode,
            "errorMsg": _errorMsg
        ]
    }
}
