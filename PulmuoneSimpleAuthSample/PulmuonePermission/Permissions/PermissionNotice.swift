//
//  PermissionNotice.swift
//  PmoPermissionSample
//
//  Created by PMO on 2022/08/11.
//

import Foundation
import UserNotifications

class PermissionNotice {
    private let notificationManager = UNUserNotificationCenter.current()
    
    func getStatus(callback: @escaping (PmoAuthStatus)->()) {
        notificationManager.getNotificationSettings(completionHandler: { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional, .ephemeral:
                callback(PmoAuthStatus.authorized)
            case .denied :
                callback(PmoAuthStatus.denied)
            case .notDetermined :
                callback(PmoAuthStatus.notDetermined)
            @unknown default:
                callback(PmoAuthStatus.notDetermined)
            }
        })
    }
    
    func requestPermission(onConfirmPermission: @escaping (PmoAuthStatus) -> ()) {
        getStatus(callback: { status in
            if (status == .notDetermined) {
                self.notificationManager.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if (granted) {
                        onConfirmPermission(PmoAuthStatus.authorized)
                    }
                    else {
                        onConfirmPermission(PmoAuthStatus.denied)
                    }
                }
            }
            else {
                onConfirmPermission(status)
            }
        })
    }
}
