//
//  UIDecorator.swift
//  AutoScout24 Tech_Challenge
//
//  Created by Ahmad Atef on 5/11/17.
//  Copyright © 2017 Ahmad Atef. All rights reserved.
//

import Foundation
import SwiftMessages

protocol Decoratable {
    func showMessage(title: String, body : String, alertType: alertType)
}

enum alertType {
    case info
    case success
    case warning
    case error
}

class UIDecorator{
    static let shared = UIDecorator()
    var fontName = "Open Sans"
}

extension UIDecorator : Decoratable{
    func showMessage(title: String, body: String, alertType: alertType) {
        
        let view = MessageView.viewFromNib(layout: .CardView)
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        config.presentationContext = .window(windowLevel: UIWindowLevelNormal)
        config.dimMode = .gray(interactive: true)
        config.preferredStatusBarStyle = .default
        config.duration = .seconds(seconds: 5.0)
        
        switch alertType {
        case .success:
            view.configureTheme(.success)
        case .error:
            view.configureTheme(.error)
        case .info:
            view.configureTheme(.info)
        case .warning:
            view.configureTheme(.warning)
        }
        view.backgroundView.backgroundColor = UIColor.black
        view.backgroundView.alpha = 0.7
        view.titleLabel?.textColor = UIColor.white
        view.button?.isHidden = true
        view.titleLabel?.text = title
        view.titleLabel?.font = UIFont(name: fontName, size: CGFloat(12))
        view.bodyLabel?.text = body
        view.bodyLabel?.font = UIFont(name: fontName, size: CGFloat(15))
        config.interactiveHide = true
        
        view.configureContent(title: title, body: body)
        SwiftMessages.show(config: config, view: view)
    }
}
