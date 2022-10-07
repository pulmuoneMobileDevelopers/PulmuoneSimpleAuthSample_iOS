//
//  PulmuonePermissionApp.swift
//  PulmuonePermission
//
//  Created by PMO on 2022/07/27.
//

import SwiftUI

//@main
struct PulmuonePermissionApp: App {
    @ObservedObject var showPopupRepo = PopupState()
    
    @State var isShowing = false
    
    var body: some Scene {
        
        WindowGroup {
            ZStack{
                PermissionContentView(
                    popupState: showPopupRepo,
                    permissionListNecessary:
                        [
                         Permissions.calendar,
                         Permissions.network,
                         Permissions.location,
                         Permissions.camera,
                         Permissions.motion,
                        ],
                    permissionListOptional:
                        [Permissions.notice,
                         Permissions.location,
                         Permissions.biometric_auth],
                    onConfirmPermission: {
                        // 확인 버튼 선택시
                        self.isShowing = false
                    }
                    
                )
//                .onConfirm {
//                    print("confirm clicked")
//                }
                
                ZStack(alignment: .top) {
                    Color.clear
                    Button(action: {
                        self.isShowing.toggle()
                        showPopupRepo.setShow(showing: self.isShowing)
                    }) {
                        Text("Popup").padding(20)
                    }
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(.blue, lineWidth: 1))
        
                }
            }
            
        }
    }
}
