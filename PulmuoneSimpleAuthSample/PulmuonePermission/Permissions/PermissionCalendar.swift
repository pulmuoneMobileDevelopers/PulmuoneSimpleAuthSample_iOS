//
//  File.swift
//  PmoPermissionSample
//
//  Created by PMO on 2022/08/12.
//

import Foundation
import EventKit

class PermissionCalendar {
    let eventStore = EKEventStore()

    func getStatus()-> EKAuthorizationStatus{
        return EKEventStore.authorizationStatus(for: .event)
    }
    
    func requestPermission(onConfirmPermission: @escaping (PmoAuthStatus) -> ()) {
        let authStatus = getStatus()
        if (authStatus == .notDetermined) {
            eventStore.requestAccess(to: .event) { granted, error in
                if (granted) {
                    onConfirmPermission(PmoAuthStatus.authorized)
                }
                else {
                    onConfirmPermission(PmoAuthStatus.denied)
                }
            }
        }
   
        else if (authStatus == .denied || authStatus == .restricted) {
            onConfirmPermission(PmoAuthStatus.denied)
        }
        else if (authStatus == .authorized) {
            onConfirmPermission(PmoAuthStatus.authorized)
        }
    }
    
}
