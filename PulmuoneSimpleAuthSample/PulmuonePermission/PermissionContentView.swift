//
//  PermissionContentView.swift
//  PulmuonePermission
//
//  Created by PMO on 2022/07/28.
//

import SwiftUI


struct PermissionContentView: View {
    
    @ObservedObject var popupState : PopupState
    var permissionListNecessary: [Permissions]
    var permissionListOptional: [Permissions]
    var permissionSettingDesc: String?
    var permissionImage: Dictionary<Permissions, String>?
    var iconForegroundColor: Color?
    var iconBackgroundColor: Color?
    var textSize: TextSize?
    var onConfirmPermission: ()-> ()
    
    // Gesture properties
    @State var offsetHeight: CGFloat = 100

    @GestureState var gestureOffset: CGFloat = 100
    
    var offset: CGFloat {
        popupState.isShowing ? offsetHeight : UIScreen.screenHeight
    }
    
    var popupBackGround: some View {
        GeometryReader { proxy in

            // Frame 설정
//            let frame = proxy.frame(in: .global)

            // bg 블러 처리 위함?
//            Image("bg")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: frame.width, height: frame.height)
        }
//        .blur(radius: getBlurRadius()) // BlurRadius change depends on offset
        .background(BlurView(style: .dark))
        .ignoresSafeArea()
    }
    
    var body: some View {
        
        ZStack{
            // 백그라운드 설정
            if (popupState.isShowing) {
                popupBackGround.transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
                
            }
            
            GeometryReader { proxy in
                        
                // 바텀시트 컨텐츠 영역
                VStack {
                    
                    PermissionContent(permissionListNecessary: permissionListNecessary,
                                      permissionListOptional: permissionListOptional,
                                      setPermissionChangeTitle: permissionSettingDesc,
                                      iconForegroundColor: iconForegroundColor,
                                      iconBackgroundColor: iconBackgroundColor,
                                      textSize: textSize,
                                      permissionImage: permissionImage,
                                      onConfirm: {
                        popupState.isShowing = false
                        self.onConfirmPermission()
                    })
                }
                
                .background(Color.white)
                .clipShape(CustomCorner(corners: [.topLeft, .topRight],
                                            radius: 8)) // radius 설정
                .offset(y: offset)
                .padding(.bottom, offset)
                .animation(.easeInOut(duration: 0.5), value: self.popupState.isShowing)
                // For getting height for drag gesture
                
            }.edgesIgnoringSafeArea(.bottom)
            
        }
        
    }
    
    // Blur radius for background
    func getBlurRadius() -> CGFloat {
        let progress = -offset / (UIScreen.main.bounds.height - 100)
        return progress * 30
    }
    
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct PermissionContentView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionContent(permissionListNecessary: [
                                                    Permissions.calendar,
                                                    Permissions.network],
                          permissionListOptional: [Permissions.notice,
                                                   Permissions.location,
                                                   Permissions.biometric_auth],
                          onConfirm: {}
                          )
        
    }
}



