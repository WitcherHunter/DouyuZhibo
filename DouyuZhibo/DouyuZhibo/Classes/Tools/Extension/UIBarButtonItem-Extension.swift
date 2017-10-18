//
//  UIBarButtonItem-Extension.swift
//  DouyuZhibo
//
//  Created by 毛豆 on 2017/10/18.
//  Copyright © 2017年 毛豆. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(imageName: String, highlightedImageName: String = "", size: CGSize = CGSize.zero) {
        let btn = UIButton()
        
        btn.setImage(UIImage(named: imageName), for: .normal)
        if highlightedImageName != "" {
            btn.setImage(UIImage(named: highlightedImageName), for: .highlighted)
        }
        
        if size == CGSize.zero {
            btn.sizeToFit()
        } else {
            btn.frame = CGRect(origin: .zero, size: size)
        }
        
        self.init(customView: btn)
    }
}
