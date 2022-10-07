//
//  PermissionCamera.swift
//  PmoPermissionSample
//
//  Created by PMO on 2022/08/11.
//

import Foundation
import AVFoundation

class PermissionCamera {
    private let authCameraStatus = AVCaptureDevice.authorizationStatus(for: .video)
    
    func getStatus()-> AVAuthorizationStatus {
        return authCameraStatus
    }
    
    func requestPermission(onConfirmPermission: @escaping (PmoAuthStatus) -> ()) {
        if (authCameraStatus == .notDetermined) {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                // 카메라 권한 허용 후 callback
                if (granted) {
                    onConfirmPermission(PmoAuthStatus.authorized)
                }
                else {
                    onConfirmPermission(PmoAuthStatus.denied)
                }
            })
        }
        else if ( authCameraStatus == .denied ||
                  authCameraStatus == .restricted) {
            onConfirmPermission(PmoAuthStatus.denied)
        }
        else if ( authCameraStatus == .authorized ) {
            onConfirmPermission(PmoAuthStatus.authorized)
        }
    }
}
