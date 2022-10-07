//
//  PermissionCamera.swift
//  PmoPermissionSample
//
//  Created by PMO on 2022/08/11.
//

import Foundation
import Contacts

class PermissionContacts {
    private let contactManager = CNContactStore()
    private let authContactStatus = CNContactStore.authorizationStatus(for: .contacts)
    
    func getStatus()-> CNAuthorizationStatus {
        return authContactStatus
    }
    
    func requestPermission(onConfirmPermission: @escaping (PmoAuthStatus) -> ()) {
        if (authContactStatus == .notDetermined) {
            contactManager.requestAccess(for: .contacts, completionHandler: { success, error in
                // contact 권한 허용 후 callback
                if (success) {
                    onConfirmPermission(PmoAuthStatus.authorized)
                }
                else {
                    onConfirmPermission(PmoAuthStatus.denied)
                }
            })
        }
        else if ( authContactStatus == .denied ||
                  authContactStatus == .restricted) {
            onConfirmPermission(PmoAuthStatus.denied)
        }
        else if ( authContactStatus == .authorized ) {
            onConfirmPermission(PmoAuthStatus.authorized)
        }
    }
}
