//
//  Color.swift
//  PulmuonePermission
//
//  Created by PMO on 2022/08/01.
//

import SwiftUI

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
    
    static let title = Color(red: 38 / 255, green: 38 / 255, blue: 38 / 255)
    static let sub_title = Color(hex: 0x919BA5)//Color(red: 141 / 255, green: 141 / 255, blue: 141 / 255)
    static let divider = Color(red: 225 / 255, green: 230 / 255, blue: 235 / 255)
    
//    static let pulmuone_def = Color(red: 160 / 255, green: 217 / 255, blue: 17 / 255)
    static let pulmuone_def = Color(hex: 0xA0DA11)
    static let pulmuone_pressed = Color(hex: 0x537B0A)
    static let icon_background = Color(hex: 0xF3F5F7)
    static let icon_foreground = Color(hex: 0x919BA5)
}

extension UIScreen {
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenWidth = UIScreen.main.bounds.size.width
}

extension View {
    @ViewBuilder func scrollEnabled(_ enabled: Bool) -> some View {
        if enabled {
            self
        }
        else {
          simultaneousGesture(DragGesture(minimumDistance: 0),
                              including: .all)
        }
    }
    
//    func customSheet<SheetView: View> (isPresented: Binding<Bool>,
//                                       @ViewBuilder sheetView: @escaping ()-> SheetView
//                                       /*, onEnd: @escaping ()-> ()*/)-> some View {
//        return self
//            .overlay(
//                SheetViewHelper(sheetView: sheetView(),
//                                showSeetView: isPresented
//                                /*,onEnd: onEnd*/)
//            )
//    }
}

extension String {
    var localized_pmo: String {
        return NSLocalizedString(self, tableName: "pmo_strings", value: self, comment: "")
    }
}
