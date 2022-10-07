//
//  PermissionItem.swift
//  PulmuonePermission
//
//  Created by PMO on 2022/08/02.
//

import SwiftUI

struct PermissionItem: View {
    var permission: Permissions
    var permissionImgString: String?
    var iconForegroundColor: Color?
    var iconBackgroundColor: Color?
    var textSize: TextSize?
    var isNecessary: Bool
        
    var body: some View {
        let permissionData = getPermissonData()
        let itemHeight = getItemHeight()
        let stringSize = getTextSize(textSize: textSize)
        
        HStack {
            if (isNecessary) {
                ZStack(alignment: .center) {
                    Image(permissionData.imageMain ?? "warning")
                        .resizable()
                        .scaledToFit()
                        .font(Font.title.weight(.thin))
                        .frame(width: 20, height: 20)
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(iconForegroundColor ?? Color.icon_foreground)
                }
                .frame(width: 36, height: 36, alignment: .center)
//                    .foregroundColor(Color.pulmuone_def)
                .background(iconBackgroundColor ?? Color.icon_background)
                .clipShape(Circle())
            }
            VStack (alignment: .leading, spacing: 0){
                Text(permissionData.mainString)
                    .font(.custom("Pretendard-Bold", size: stringSize))
//                    .font(.system(size: 14))
//                    .fontWeight(.bold)
                    .foregroundColor(Color.title)
                    .frame(height: 20)
                
                Text(permissionData.subString)
                    .font(.custom("Pretendard-Bold", size: stringSize))
//                    .font(.system(size: 14))
//                    .fontWeight(.bold)
                    .foregroundColor(Color.sub_title)
                    .frame(height: 20)
            }
            Spacer()
        }.frame(height: itemHeight)
            .padding(.leading, 6)
    }
    
    func getTextSize(textSize: TextSize?) -> CGFloat {
        var returnSize: CGFloat = 14
        if (textSize == .big) {
            returnSize = 20
        }
        else if (textSize == .middle) {
            returnSize = 17
        }
        return returnSize
    }
    
    func getItemHeight() -> CGFloat{
        var itemHeight: CGFloat = 40
        if isNecessary == true {
            itemHeight = 48
        }
        
        return itemHeight
    }
    
    func getLocaizedString(data: String) -> String {
        var returnData = data.localized
        if (returnData == data) {
            returnData = data.localized_pmo
        }
        
        return returnData
    }
    
    func getPermissonData() -> PermissionData {
        
        var returnData: PermissionData
        
        switch permission {
        
        case .bluetooth :
            returnData = PermissionData(
                mainString: getLocaizedString(data: "pmo_bluetooth"),
                subString: getLocaizedString(data: "pmo_bluetooth_sub"),
                imageMain: permissionImgString ?? "bluetooth")
        case .calendar:
            returnData = PermissionData(
                mainString: getLocaizedString(data: "pmo_calendar"),
                subString: getLocaizedString(data: "pmo_calendar_sub"),
                imageMain: permissionImgString ?? "calendar")
        case .callkit:
            returnData = PermissionData(
                mainString: getLocaizedString(data: "pmo_callkit"),
                subString: getLocaizedString(data: "pmo_callkit_sub"),
                imageMain: permissionImgString ?? "call")
        case .camera:
            returnData = PermissionData(
                mainString: getLocaizedString(data: "pmo_camera"),
                subString: getLocaizedString(data: "pmo_camera_sub"),
                imageMain: permissionImgString ?? "photo")
        case .contacts:
            returnData = PermissionData(
                mainString: getLocaizedString(data: "pmo_contacts"),
                subString: getLocaizedString(data: "pmo_contacts_sub"),
                imageMain: permissionImgString ?? "contacts")
        case .health:
            returnData = PermissionData(
                mainString: getLocaizedString(data: "pmo_health"),
                subString: getLocaizedString(data: "pmo_health_sub"),
                imageMain: permissionImgString ?? "monitor_heart")
        case .homekit:
            returnData = PermissionData(
                mainString: getLocaizedString(data: "pmo_homekit"),
                subString: getLocaizedString(data: "pmo_homekit_sub"),
                imageMain: permissionImgString ?? "home")
        case .location:
            returnData = PermissionData(
                mainString: getLocaizedString(data: "pmo_location"),
                subString: getLocaizedString(data: "pmo_location_sub"),
                imageMain: permissionImgString ?? "location")
        case .biometric_auth :
            returnData = PermissionData(
                mainString: getLocaizedString(data: "pmo_biometric_auth"),
                subString: getLocaizedString(data: "pmo_biometric_auth_sub"),
                imageMain: permissionImgString ?? "fingerprint")
        case .media_library:
            returnData = PermissionData(
                mainString: getLocaizedString(data: "pmo_media_library"),
                subString: getLocaizedString(data: "pmo_media_library_sub"),
                imageMain: permissionImgString ?? "folder_open")
        case .notice:
            returnData = PermissionData(
                mainString: getLocaizedString(data: "pmo_notice"),
                subString: getLocaizedString(data: "pmo_notice_sub"),
                imageMain: permissionImgString ?? "chat_bubble")
        case .microphone:
            returnData = PermissionData(
                mainString: getLocaizedString(data: "pmo_microphone"),
                subString: getLocaizedString(data: "pmo_microphone_sub"),
                imageMain: permissionImgString ?? "mic")
        case .motion:
            returnData = PermissionData(
                mainString: getLocaizedString(data: "pmo_motion"),
                subString: getLocaizedString(data: "pmo_motion_sub"),
                imageMain: permissionImgString ?? "motion_sensor")
        case .photos:
            returnData = PermissionData(
                mainString: getLocaizedString(data: "pmo_photos"),
                subString: getLocaizedString(data: "pmo_photos_sub"),
                imageMain: permissionImgString ?? "photo_library")
            
        case .speech_recognition:
            returnData = PermissionData(
                mainString: getLocaizedString(data: "pmo_speech_recognition"),
                subString: getLocaizedString(data: "pmo_speech_recognition_sub"),
                imageMain: permissionImgString ?? "record_voice")
        
//        case .phone :
//            returnData = PermissionData(
//                mainString: getLocaizedString(data: "pmo_phone"),
//                subString: getLocaizedString(data: "pmo_phone_sub"),
//                imageMain: permissionImgString ?? "list_alt")
            
        case .network:
            returnData = PermissionData(
                mainString: getLocaizedString(data: "pmo_network"),
                subString: getLocaizedString(data: "pmo_network_sub"),
                imageMain: permissionImgString ?? "wifi")
        case .history:
            returnData = PermissionData(
                mainString: getLocaizedString(data: "pmo_history"),
                subString: getLocaizedString(data: "pmo_history_sub"),
                imageMain: permissionImgString ?? "history")
        }
        
        return returnData
    }
                      
      func emptyImage(with size: CGSize) -> UIImage
      {
          UIGraphicsBeginImageContext(size)
          let image = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          return image!
      }
}

struct PermissionData {
//    var isNecessary: Bool
    var mainString: String
    var subString: String
//    var imageMain: Image?
    var imageMain: String?
}

struct PermissionItem_Previews: PreviewProvider {
    static var previews: some View {
        PermissionItem(permission: Permissions.photos, isNecessary: true)
    }
}

