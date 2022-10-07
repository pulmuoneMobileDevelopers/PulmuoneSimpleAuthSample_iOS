//
//  PermissionNotice.swift
//  PmoPermissionSample
//
//  Created by PMO on 2022/08/11.
//

import Foundation
import Photos

class PermissionPhotoLibrary {
    
    func getStatus()-> PHAuthorizationStatus {
        
        return PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    func requestPermission(onConfirmPermission: @escaping (PmoAuthStatus) -> ()) {
        let rwStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if (rwStatus == .notDetermined) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                if (status == .restricted || status == .denied) {
                    onConfirmPermission(PmoAuthStatus.denied)
                }
                else if (status == .authorized || status == .limited) {
                    onConfirmPermission(PmoAuthStatus.authorized)
                }
            }
        }
        else if (rwStatus == .denied || rwStatus == .restricted) {
            onConfirmPermission(PmoAuthStatus.denied)
        }
        else if (rwStatus == .authorized || rwStatus == .limited) {
            onConfirmPermission(PmoAuthStatus.authorized)
        }
    }
}
