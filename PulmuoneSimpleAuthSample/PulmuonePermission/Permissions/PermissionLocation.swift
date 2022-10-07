//
//  PermissionCamera.swift
//  PmoPermissionSample
//
//  Created by PMO on 2022/08/11.
//

import Foundation
import CoreLocation

class PermissionLocation: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    private var callback : ((PmoAuthStatus)-> ())?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
    }
    
    func getStatus()-> CLAuthorizationStatus {
        return self.locationManager.authorizationStatus
    }
    
    func requestPermission(onConfirmPermission: @escaping (PmoAuthStatus) -> ()) {
        callback = onConfirmPermission
        
        if (self.locationManager.authorizationStatus == .notDetermined) {
            self.locationManager.requestWhenInUseAuthorization()
        }
        else if (self.locationManager.authorizationStatus == .denied ||
                 self.locationManager.authorizationStatus == .restricted) {
            onConfirmPermission(PmoAuthStatus.denied)
        }
        else if (self.locationManager.authorizationStatus == .authorizedAlways ||
                 self.locationManager.authorizationStatus == .authorizedWhenInUse ) {
            onConfirmPermission(PmoAuthStatus.authorized)
        }
    
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization state: CLAuthorizationStatus) {
        // location Status callback
        if (state == .denied || state == .restricted) {
            callback?(PmoAuthStatus.denied)
        }
        else if (state == .authorizedWhenInUse || state == .authorizedAlways) {
            callback?(PmoAuthStatus.authorized)
        }
    }
}
