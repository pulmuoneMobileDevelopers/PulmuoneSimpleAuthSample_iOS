//
//  PopupState.swift
//  PulmuonePermission
//
//  Created by PMO on 2022/08/04.
//

import SwiftUI

class PopupState: ObservableObject {
    @Published var isShowing: Bool = false
    func setShow(showing: Bool) {
        isShowing = showing
    }
    
    func getShow()-> Bool {
        return isShowing
    }
}
