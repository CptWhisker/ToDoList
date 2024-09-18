//
//  UIBlockingProgressHUD.swift
//  ToDoList
//
//  Created by user on 18.09.2024.
//

import UIKit
import ProgressHUD

final class loadingHUD {
    
    private static var window: UIWindow? {
        if #available(iOS 13.0, *) {
            let windowScene = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .first
            return windowScene?.windows.first(where: \.isKeyWindow)
        } else {
            return UIApplication.shared.windows.first
        }
    }
    
    static func showAnimation() {
        DispatchQueue.main.async {
            window?.isUserInteractionEnabled = false
            ProgressHUD.animate()
        }
    }
    
    static func dismissAnimation() {
        DispatchQueue.main.async {
            window?.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
        }
    }
}
