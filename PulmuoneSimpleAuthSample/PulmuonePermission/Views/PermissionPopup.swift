//
//  PermissionPopup.swift
//  PulmuonePermission
//
//  Created by PMO on 2022/08/03.
//

import SwiftUI



struct PermissionPopup: View {
        
    @ObservedObject var popupState : PopupState
    var permissionListNecessary: [Permissions]
    var permissionListOptional: [Permissions]
//    @State var isShowing : Bool = false
    
    var body: some View {
        ZStack{}.sheet(isPresented: $popupState.isShowing) {
            PermissionContent(
                permissionListNecessary: permissionListNecessary,
                permissionListOptional: permissionListOptional,
                onConfirm: {}
            )
        }
    }
}
