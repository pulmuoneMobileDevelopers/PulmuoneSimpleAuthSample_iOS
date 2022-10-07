//
//  PopupVC.swift
//  mcfs
//
//  Created by 이주한 on 2022/09/19.
//  Copyright © 2022 pulmuone. All rights reserved.
//

import Foundation
import UIKit

/// 팝업 타입
enum PopupTpye {
    case cancelAndOK
    case onlyOK
}

class PopupVC: PmoViewController {
    @IBOutlet weak var btnCacnel: UIButton!
    @IBOutlet weak var btnOK: UIButton!
    @IBOutlet weak var popUpView: CustomView!
    @IBOutlet weak var contentsLabel: UILabel!
    
    // 팝업 타입
    var popupType:PopupTpye = .cancelAndOK
    // 팝업 텍스트
    var popupText = ""
    // 취소 버튼 이름
    var cancelBtnName = ""
    // ok 버튼 이름
    var okBtnName = ""
    // 취소 단독 버튼 이름
    var okOneBtnName = ""
    
    private let cornerRadius: CGFloat = 8.0
    
    var completionHandler: ((Bool) -> Void)?

    init(popupType: PopupTpye? = .cancelAndOK, popupText: String = "", cancelBtnName: String = "", okBtnName: String = "", completionHandler: @escaping (Bool) -> Void) {
        super.init()
        self.popupType = popupType!
        self.popupText = popupText
        self.cancelBtnName = cancelBtnName
        self.okBtnName = okBtnName
        self.completionHandler = completionHandler
    }
    
    init(popupType: PopupTpye? = .onlyOK, popupText: String = "", okOneBtnName: String = "", completionHandler: @escaping (Bool) -> Void) {
        super.init()
        self.popupType = popupType!
        self.popupText = popupText
        self.okOneBtnName = okOneBtnName
        self.completionHandler = completionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.layer.cornerRadius = cornerRadius
        
        log.verbose("popupType: \(popupType), okBtnName: \(okBtnName)")
        
        switch popupType {
        case .cancelAndOK:
            btnCacnel.setTitle(cancelBtnName, for: .normal)
            btnOK.setTitle(okBtnName, for: .normal)
            
        case .onlyOK:
            btnOK.setTitle(okOneBtnName, for: .normal)
            btnCacnel.isHidden = true
            let padding: CGFloat = 0.0
            NSLayoutConstraint.activate([
                //mainBody.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
                btnOK.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding),
                btnOK.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding),
                //mainBody.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            ])
        }
        
        contentsLabel.text = popupText
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 그림자 처리
        let v = ShadowView(frame:popUpView.frame)
        view.addSubview(v)
        view.sendSubviewToBack(v)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        log.verbose("viewWillAppear")
        self.setLanguage()
    }
        
    private func setLanguage() {
        log.verbose("setLanguage")
                
        self.btnCacnel.titleLabel?.text = "취소"
        self.btnOK.titleLabel?.text = "확인"
    }
    
    @IBAction func touchedBtnCancle(_ sender: UIButton) {
        self.completionHandler?(false)
    }
    
    @IBAction func touchedBtnOk(_ sender: UIButton) {
        self.completionHandler?(true)
    }    
}

class ShadowView : UIView {
    let cornerRadius: CGFloat = 8.0
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.isOpaque = true
        self.backgroundColor = .black
        self.dropShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = cornerRadius
    }
}
