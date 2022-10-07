//
//  PermissionManager.swift
//  PmoPermissionSample
//
//  Created by PMO on 2022/08/08.
//

import Foundation
import CoreLocation
import UserNotifications
import Photos

import SwiftUI
import Contacts
import CoreBluetooth
import EventKit

@available(iOS 8, *)
public enum PmoAuthStatus : Int, @unchecked Sendable {
    
    @available(iOS 8, *)
    case notDetermined = 0 // User has not yet made a choice with regards to this application

    @available(iOS 8, *)
    case denied = 2 // User has explicitly denied this application access to data.

    @available(iOS 8, *)
    case authorized = 3 // User has authorized this application to access data.
    
    @available(iOS 8, *)
    case notNecessary = 4 // Request is not necessary
    
    @available(iOS 8, *)
    case notSupported = 5
    
    @available(iOS 8, *)
    case unknown = 6
}

class PermissionManager {

//    var permission : [Permissions] = []
    
    private let permissionCamera = PermissionCamera()
    private let permissionContacts = PermissionContacts()
    private let permissionLocation = PermissionLocation()
    private let permissionNoti = PermissionNotice()
    private let permissionPhotoLibrary = PermissionPhotoLibrary()
    private let permissionRecord = PermissionRecord()
    private let permissionHealthKit = PermissionHealthKit()
    private let permissionCalendar = PermissionCalendar()
    
    private var permissionDeniedList = Dictionary <Permissions, PmoAuthStatus>()
    //    @Published let authStatus : [CLAuthorizationStatus] = []
    
    private var permission : [Permissions] = []
    private var isNecessary : Bool = false
    private var callback : ((_ isSuccess: Bool,_ message: String, _ isNecessary: Bool)-> ())?
    
    private var permissionAuthNotice = PmoAuthStatus.unknown
    
    private var permissionNecessary : [Permissions] =
        [.location, .camera, .contacts, .notice, .photos, .speech_recognition, .microphone]
    
    init() {
        // 콜백 형태의 status는 초기화 시 값을 받아 온다
        permissionNoti.getStatus(callback: { pmoStatus in
            self.permissionAuthNotice = pmoStatus
        })
    }
    
    // 퍼미션 리스트 권한 요청 수행
    func requestPermissions(permission: [Permissions],
                            isNacessary: Bool,
                            onConfirmPermission: @escaping (_ isSuccess: Bool,_ message: String, _ isNecessary: Bool)-> ()
    ) {
        
        self.permission = permission
        self.isNecessary = isNacessary
        self.callback = onConfirmPermission
        
        permissionDeniedList.removeAll()
        
        // 비교할 리스트 초기화
        for permissionItem in permission {
            if permissionNecessary.contains(permissionItem) {
                permissionDeniedList[permissionItem] = .notDetermined
            }
        }
        
        /*  callkit : CallKit has not needed permission since iOS 10 beta 3
            media_library : 파일 접근은 plist 에서 Supports opening documents in place, Application supports iTunes file sharing 을 YES로 설정하면 접근 가능
            history : 해당하는 권한이 없음.
            biometric_auth : 생체 인식의 경우 생체 인식을 요청할 때 권한 요청이 가능함.
            network : 권한 요청이 필요 없음.
            motion : 권한 요청을 물어볼 필요 없이 NSMotionUsageDescription 포함하면 사용 가능
            bluetooth : 사용을 위해 CBCentralManager 를 선언하면 시스템에서 플루투스 퍼미션 요청함. (따로 요청하는 방식이 아님)
            homekit : 사용시 권한 요청.
         */
        for permissionItem in permission {
            if (permissionItem == .location) {
                locationPermision()
            } else if (permissionItem == .camera) {
                cameraPermission()
            } else if (permissionItem == .contacts) {
                contactPermission()
            } else if (permissionItem == .notice) {
                noticePermission()
            } else if (permissionItem == .photos) {
                photoLibraryPermission()
            } else if (permissionItem == .speech_recognition) {
                recordPermission(permissionItem: permissionItem)
            } else if (permissionItem == .microphone) {
                recordPermission(permissionItem: permissionItem)
            } else if (permissionItem == .health) {
                healthPermission()
            } else if (permissionItem == .calendar) {
                calendarPermission()
            }
        }
    }
    
    func getPermissionAuth(permissionItem: Permissions)-> PmoAuthStatus {
        
        var status = PmoAuthStatus.notDetermined
        if (permissionItem == .location) {
            let permissionData = getLocationPermission()
            if (permissionData == .authorizedWhenInUse || permissionData == .authorizedAlways) {
                status = .authorized
            }
            else if (permissionData == .denied || permissionData == .denied) {
                status = .denied
            }
        } else if (permissionItem == .camera) {
            let permissionData = getCameraPermission()
            if (permissionData == .authorized) {
                status = .authorized
            }
            else if (permissionData == .denied || permissionData == .restricted) {
                status = .denied
            }
        } else if (permissionItem == .contacts) {
            let permissionData = getContactPermission()
            if (permissionData == .authorized) {
                status = .authorized
            }
            else if (permissionData == .denied || permissionData == .restricted) {
                status = .denied
            }
        } else if (permissionItem == .notice) {
            status = permissionAuthNotice
        } else if (permissionItem == .photos) {
            let permissionData = getPhotoPermission()
            if (permissionData == .authorized) {
                status = .authorized
            }
            else if (permissionData == .denied || permissionData == .restricted) {
                status = .denied
            }
        } else if (permissionItem == .speech_recognition || permissionItem == .microphone) {
            let permissionData = getRecordPermission()
            if (permissionData == .granted) {
                status = .authorized
            }
            else if (permissionData == .denied) {
                status = .denied
            }
        } else if (permissionItem == .health) {
            status = getHealthPermission()
            
        } else if (permissionItem == .calendar) {
            let permissionData = getCalendarPermission()
            if (permissionData == .authorized) {
                status = .authorized
            }
            else if (permissionData == .denied || permissionData == .restricted) {
                status = .denied
            }
        } else if (permissionItem == .bluetooth) {
            let permissionData = getBluetoothPermission()
            if (permissionData == .allowedAlways) {
                status = .authorized
            }
            else if (permissionData == .denied || permissionData == .restricted) {
                status = .denied
            }
        }
        
        return status
    }
    
    func getLocationPermission()-> CLAuthorizationStatus {
        return self.permissionLocation.getStatus()
    }
    
    func getCameraPermission()-> AVAuthorizationStatus {
        return permissionCamera.getStatus()
    }
    
    func getContactPermission()-> CNAuthorizationStatus {
        return permissionContacts.getStatus()
    }
    
    func getNotificationPermission(onGetPermission: @escaping (PmoAuthStatus)->()) {
        permissionNoti.getStatus(callback: onGetPermission)
    }
    
    func getPhotoPermission()-> PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus(for: .readWrite)
    }
    
    func getRecordPermission()-> AVAudioSession.RecordPermission {
        return permissionRecord.getStatus()
    }
    
    func getHealthPermission()-> PmoAuthStatus {
        return permissionHealthKit.getStatus()
    }
    
    func getBluetoothPermission()-> CBManagerAuthorization {
        return CBManager.authorization
    }
    func getCalendarPermission()-> EKAuthorizationStatus {
        return permissionCalendar.getStatus()
    }
    
    private func cameraPermission() {
        permissionCamera.requestPermission(onConfirmPermission: { status in
            self.permissionDeniedList[Permissions.camera] = status
            self.confirmPermissions()
        })
    }
    private func locationPermision() {
        permissionLocation.requestPermission(onConfirmPermission: { status in
            self.permissionDeniedList[Permissions.location] = status
            self.confirmPermissions()
        })
    }
    private func contactPermission() {
        permissionContacts.requestPermission(onConfirmPermission: { status in
            self.permissionDeniedList[Permissions.contacts] = status
            self.confirmPermissions()
        })
    }
    private func noticePermission() {
        permissionNoti.requestPermission(onConfirmPermission: { status in
            self.permissionDeniedList[Permissions.notice] = status
            self.confirmPermissions()
        })
    }
    private func photoLibraryPermission() {
        permissionPhotoLibrary.requestPermission(onConfirmPermission: { status in
            self.permissionDeniedList[Permissions.photos] = status
            self.confirmPermissions()
        })
    }
    private func recordPermission(permissionItem: Permissions) {
        permissionRecord.requestPermission(onConfirmPermission: { status in
            self.permissionDeniedList[permissionItem] = status
            self.confirmPermissions()
        })
    }
    private func healthPermission() {
        permissionHealthKit.requestPermission(onConfirmPermission: { status in
            self.permissionDeniedList[Permissions.health] = status
            self.confirmPermissions()
        })
    }
    private func calendarPermission() {
        permissionCalendar.requestPermission(onConfirmPermission: { status in
            self.permissionDeniedList[Permissions.calendar] = status
            self.confirmPermissions()
        })
    }
    
    private func confirmPermissions() {
        var permissionGranted = true
        
        var permissionString : String = ""
        var permissionDeniedString : String = ""
        
        for permissionItem in permission {
            if (permissionDeniedList[permissionItem] == .notDetermined){
                // 아무것도 하지 않고 빠져 나감.
                return
            }
            else if (permissionDeniedList[permissionItem] == .denied) {
                permissionGranted = false
                permissionDeniedString = permissionDeniedString + permissionItem.toString + ", "
            }
            else if (permissionDeniedList[permissionItem] == .authorized) {
                permissionString = permissionString + permissionItem.toString + ", "
            }
        }
                
        if (permissionGranted) {
//            Toast(message: permissionString).show()
            // 모든 권한 승인 시
            callback?(true, permissionString, isNecessary)
        }
        else {
            // 모든 권한 거절 시
            callback?(false, permissionDeniedString, isNecessary)
        }
    }
}


