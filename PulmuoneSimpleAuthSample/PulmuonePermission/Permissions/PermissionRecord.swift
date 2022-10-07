//
//  PermissionAudio.swift
//  PmoPermissionSample
//
//  Created by PMO on 2022/08/12.
//

import Foundation
import AVFAudio

class PermissionRecord {
    var audioSession = AVAudioSession.sharedInstance()
    
    func getStatus()-> AVAudioSession.RecordPermission {
        return audioSession.recordPermission
    }
    
    func requestPermission(onConfirmPermission: @escaping (PmoAuthStatus) -> ()) {
        if (audioSession.recordPermission == .undetermined) {
            audioSession.requestRecordPermission { granted in
                // 카메라 권한 허용 후 callback
                if (granted) {
                    onConfirmPermission(PmoAuthStatus.authorized)
                }
                else {
                    onConfirmPermission(PmoAuthStatus.denied)
                }
            }
        }
        else if ( audioSession.recordPermission == .denied) {
            onConfirmPermission(PmoAuthStatus.denied)
        }
        else if ( audioSession.recordPermission == .granted ) {
            onConfirmPermission(PmoAuthStatus.authorized)
        }
    }
}
