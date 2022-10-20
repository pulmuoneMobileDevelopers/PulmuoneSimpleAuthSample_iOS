//
//  LogUtil.swift
//  modulebio
//
//  Created by lucas on 2022/01/25.
//

import Foundation

/// 생체인증 모듈 Log Class
public class BioLog {
    
    static var _SHOW_LOG = false
    
    /**
     생체인증 모듈용 로그 출력시 선언
     */
    public static func showLog() {
        _SHOW_LOG = true
    }

    static func log(_ object: Any, filename: String = #file, _ line: Int = #line, _ funcname: String = #function) {
        if(!_SHOW_LOG) {
            return
        }
        print("################################################################")
        print("file : \(filename)")
        print("func : \(funcname) line : \(line)")
        print(object)
        print("################################################################")
    }
}
