//
//  PermissionHealthKit.swift
//  PmoPermissionSample
//
//  Created by PMO on 2022/08/12.
//

import Foundation
import HealthKit

class PermissionHealthKit {
    
    private let allTypes = Set([HKObjectType.workoutType(),
                        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                        HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                        HKObjectType.quantityType(forIdentifier: .heartRate)!])
    
    private let hkStore = HKHealthStore()
    
    func getStatus() -> PmoAuthStatus{
        if (!HKHealthStore.isHealthDataAvailable()) {
            return .notSupported
        }
        let authStatus = hkStore.authorizationStatus(for: HKObjectType.workoutType())
            
        if (authStatus == .notDetermined) {
            return .notDetermined
        }
        else if (authStatus == .sharingDenied) {
            return .denied
        }
        else {
            return .authorized
        }
    }
    
    func requestPermission(onConfirmPermission: @escaping (PmoAuthStatus) -> ()) {
        let authStatus = getStatus()
        if (authStatus == .notDetermined) {
            hkStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
                if success {
                    onConfirmPermission(.authorized)
                }
                else {
                    onConfirmPermission(.denied)
                }
            }
        }
        else {
            onConfirmPermission(authStatus)
        }
    }
}
