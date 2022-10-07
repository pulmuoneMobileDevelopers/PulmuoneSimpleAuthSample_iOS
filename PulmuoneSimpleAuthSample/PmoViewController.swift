//
//  LogViewController.swift
//  mcfs
//
//  Created by 이주한 on 2022/09/05.
//  Copyright © 2022 pulmuone. All rights reserved.
//

import UIKit
import SwiftyBeaver
import SwiftKeychainWrapper

class PmoViewController: UIViewController {
    
    public enum ToastMode {
        case NORMAL
        case WARNING
    }
    
    let log = SwiftyBeaver.self
    var console: ConsoleDestination?

    required init?(coder aDecoder: NSCoder) {
        log.verbose("init coder")
        super.init(coder: aDecoder)
        
        if (console == nil) {
            console = ConsoleDestination()
            log.removeAllDestinations()
            log.addDestination(console!)
            
            log.verbose("ConsoleDestination created")
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let _ = self.initLanguage()
        // Do any additional setup after loading the view.
    }
    
    func initLanguage() -> Bundle? {
//        let languageCode = KeychainWrapper.standard.string(forKey: Constants.LoginInfoKeychain.userLangKey) ?? Constants.currentLang
//        if !languageCode.isEmpty {
//            Constants.currentLang = languageCode
//            if (Constants.currentLang == "zh") {
//                Constants.currentLang = "zh-Hans" //xcode에서 중국어 로케일 파일명
//            }
//        }
//        log.verbose("languageCode: \(languageCode), Constants.currentLang: \(Constants.currentLang)")

        //설정된 언어 파일 가져오기
        let path = Bundle.main.path(forResource: Constants.currentLang, ofType: "lproj")
        let bundle = Bundle(path: path!)

        return bundle
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = getRootViewController()

        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }

        return topMostViewController
    }
    
    func getRootViewController() -> UIViewController? {
        return (UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController)
    }
    
//    func customAlertPopup(vc: UIViewController?, message: String, completionHandler: @escaping (Bool) -> Void) {
//        let text: String = message
//        let attributeString = NSMutableAttributedString(string: text) // 텍스트 일부분 색상, 폰트 변경
//        let font = UIFont.boldSystemFont(ofSize: 18)
//        attributeString.addAttribute(.font, value: font, range: (text as NSString).range(of: "\(text)")) // 폰트 적용.
//
//        let alertController = UIAlertController(title: text, message: "", preferredStyle: .alert);
//        alertController.setValue(attributeString, forKey: "attributedTitle")
//
//        let cancelAction = UIAlertAction(title: "취소", style: .cancel) {_ in
//            completionHandler(false)
//        }
//        let okAction = UIAlertAction(title: "확인", style: .default) {_ in
//            completionHandler(true)
//        }
//        alertController.addAction(cancelAction)
//        alertController.addAction(okAction)
//        DispatchQueue.main.async {
//            self.getTopMostViewController()?.present(alertController, animated: true, completion: nil)
//        }
//    }
        
    public func showAlertPopup(popupText: String , okBtnName: String, cancelBtnName: String, completionHandler: @escaping (Bool) -> Void){
        print("showBasicPopup1")
        let popvc = PopupVC(popupType: .cancelAndOK, popupText: popupText, cancelBtnName: cancelBtnName, okBtnName: okBtnName, completionHandler: completionHandler)
        popvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        DispatchQueue.main.async {
            self.getTopMostViewController()?.present(popvc, animated: false, completion: nil)
        }
    }
    
    public func showAlertPopup(popupText: String, okBtnName: String, completionHandler: @escaping (Bool) -> Void){
        print("showBasicPopup2")
        let popvc = PopupVC(popupType: .onlyOK, popupText: popupText, okOneBtnName: okBtnName, completionHandler: completionHandler)
        popvc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        DispatchQueue.main.async {
            self.getTopMostViewController()?.present(popvc, animated: false, completion: nil)
        }
    }
    
    static let DELAY_SHORT = 2.0//1.5
    static let DELAY_LONG = 3.0
    
    func showToast(vc: UIViewController, toastMode: ToastMode = .NORMAL, message: String, font: UIFont = UIFont(name: "Pretendard-Medium", size: 15)!, delay: TimeInterval = DELAY_SHORT) {
        log.verbose("showToast: vc: \(vc)")
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width - (self.view.frame.size.width - 32/2), y: self.view.frame.size.height - 100, width: self.view.frame.size.width - 32, height: 41))
        toastLabel.backgroundColor = toastMode == .NORMAL ? UIColor(rgb: 0x2D3741).withAlphaComponent(0.6) : UIColor(rgb: 0xFDF6F6)
        toastLabel.textColor = toastMode == .NORMAL ? UIColor.white : UIColor(rgb: 0xFF333D)
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 4;
        toastLabel.clipsToBounds = true
        vc.view.addSubview(toastLabel)
        toastLabel.bringSubviewToFront(vc.view)

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            toastLabel.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: delay, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0
            }, completion: {_ in
                toastLabel.removeFromSuperview()
            })
        })
    }
}
