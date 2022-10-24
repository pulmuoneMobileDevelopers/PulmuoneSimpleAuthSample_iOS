//
//  PermissionContent.swift
//  PulmuonePermission
//
//  Created by PMO on 2022/08/01.
//

import SwiftUI


enum Permissions {
    case bluetooth, calendar, callkit,
         camera, contacts, health, homekit,
         location, media_library, microphone,
         motion, photos, /*network*,*/
         speech_recognition, notice,
         biometric_auth, history, etc
    //    phone, 전화기록은 iOS 개인정보 정책상 가져올 수 없습니다.
    var toString: String {
        switch self {
            
        case .bluetooth:
            return "블루투스"
        case .calendar:
            return "달력"
        case .callkit:
            return "전화"
        case .camera:
            return "카메라 촬영"
        case .contacts:
            return "연락처"
        case .health:
            return "헬스 정보"
        case .homekit:
            return "홈킷"
        case .location:
            return "위치 정보"
        case .media_library:
            return "미디어 저장소"
        case .microphone:
            return "마이크"
        case .motion:
            return "모션"
        case .photos:
            return "사진 저장소"
//        case .network:
//            return "네트웤"
        case .speech_recognition:
            return "녹음"
        case .notice:
            return "푸시 알림"
        case .biometric_auth:
            return "생체 인증"
        case .history:
            return "앱 기록"
        case .etc:
            return "기타"
        }
    }
}

enum TextSize {
    case small, middle, big
}

// 바텀시트 컨텐츠 설정
struct PermissionContent: View {
    
    var titleTxt: String?
    var permissionListNecessary: [Permissions]
    var permissionListOptional: [Permissions]
    var permissionListNecessaryEtc: [PermissionItem]?
    var permissionListOptionalEtc: [PermissionItem]?
    var setPermissionChangeTitle: String?
    var iconForegroundColor: Color?
    var iconBackgroundColor: Color?
    var textSize: TextSize?
    
    var permissionImage: Dictionary<Permissions, String>?
    var onConfirm: ()-> ()
    
    var body: some View {
        
        let stringSize = getTextSize(textSize: textSize)
        
        VStack(spacing: 0) {
            
            HStack(spacing: 34) {
                
                // title 변경 가능
                Text(titleTxt ?? "앱 접근권한 안내")
                    .font(.custom("Pretendard-Bold", size: 22))
                    //.fontWeight(.bold)
                    .foregroundColor(Color.title)
                    .frame(height: 53)
                
                //                    .background(Color.blue) // 영역 확인용
                Spacer()
            }
            
            Divider()
                .background(Color.divider)
            
            ScrollView(.vertical, showsIndicators: false, content: {
                //                ZStack{}.padding(.bottom, 10)//.background(Color.teal)
                
                Spacer().frame(height: 26)
                
                HStack {
                    
                    Text("필수적 접근권한")
                    //                        .font(.system(size: 18))
                        .font(.custom("Pretendard-Bold", size: stringSize))
                        //.fontWeight(.bold)
                        .foregroundColor(Color.title)
                        .frame(height: 26, alignment: .leading)
                    //                        .background(Color.blue) // 영역 확인용
                    
                    Spacer()
                }.padding(.bottom, 12)
                
                
                ForEach(permissionListNecessary, id: \.self) { permissionData in
                    PermissionItem(permission: permissionData,
                                   permissionImgString: permissionImage?[permissionData],
                                   iconForegroundColor: iconForegroundColor,
                                   iconBackgroundColor: iconBackgroundColor,
                                   textSize: textSize,
                                   isNecessary: true)
                }
                
                let cntNec: Int = permissionListNecessaryEtc?.count ?? 0
                ForEach(0..<cntNec, id: \.self) { num in
                    permissionListNecessaryEtc?[num]
                }
                
                HStack {
                    
                    Text("선택적 접근권한")
                    //                        .font(.system(size: 18))
                        .font(.custom("Pretendard-Bold", size: stringSize))
                        //.fontWeight(.bold)
                        .foregroundColor(Color.title)
                        .frame(height: 26, alignment: .leading)
                    //                        .background(Color.blue) // 영역 확인용
                    
                    Spacer()
                }.padding(.bottom, 10).padding(.top, 26)
                
                ForEach(permissionListOptional, id: \.self) { permissionData in
                    PermissionItem(permission: permissionData,
                                   permissionImgString: permissionImage?[permissionData],
                                   iconForegroundColor: iconForegroundColor,
                                   iconBackgroundColor: iconBackgroundColor,
                                   textSize: textSize,
                                   isNecessary: true)
                }// 기존 디자인이 필수 접근권한과 달랐지만, 동일하게 바뀜.
                
                let cntOpt: Int = permissionListOptionalEtc?.count ?? 0
                ForEach(0..<cntOpt, id: \.self) { num in
                    permissionListOptionalEtc?[num]
                }
                
                HStack {
                    Text("접근권한 변경 방법")
                    //                        .font(.system(size: 18))
                        .font(.custom("Pretendard-Bold", size: stringSize))
                        //.fontWeight(.bold)
                        .foregroundColor(Color.title)
                        .frame(height: 26, alignment: .leading)
                    //                        .background(Color.blue) // 영역 확인용
                    
                    Spacer()
                }.padding(.bottom, 12).padding(.top, 26)
                
                HStack {
                    Text(setPermissionChangeTitle ?? "설정 > 풀무원 앱 > 권한 설정 > 허용")
                    //                        .font(.system(size: 14))
                        .font(.custom("Pretendard-Medium", size: stringSize - 4))
                        //.fontWeight(.bold)
                        .foregroundColor(Color.title)
                        .frame(alignment: .leading)
                    
                    Spacer()
                }
                .padding(.bottom, 38)
                
            })
            
            // https://eunjin3786.tistory.com/232 참조하여 처리.
            Button(action: {
                self.onConfirm()            
            }, label: {
                let font = Font.custom("Pretendard-Bold", size: 18)//.weight(.semibold)
                Text("확인").font(font).foregroundColor(Color.white)
                    .padding(.vertical, 15).frame(maxWidth: .infinity)
            })
            .frame(maxWidth: .infinity)
            .background(Color.pulmuone_def)
            .padding(.bottom, 20)
            
            
        }.padding(.horizontal, 20).padding(.vertical, 30)
            .ignoresSafeArea(.all, edges: .bottom)
            .background(Color.white)
    }
    
    func getTextSize(textSize: TextSize?) -> CGFloat {
        var returnSize: CGFloat = 18
        if (textSize == .big) {
            returnSize = 22
        }
        else if (textSize == .middle) {
            returnSize = 20
        }
        return returnSize
    }
    
}
struct PermissionContent_Previews: PreviewProvider {
    
    static var previews: some View {
        PermissionContent(permissionListNecessary: [
            Permissions.calendar,
            Permissions.camera],
                          permissionListOptional: [Permissions.notice,
                                   Permissions.location,
                                   Permissions.biometric_auth],
                          onConfirm: {}
        )
        
    }
}
