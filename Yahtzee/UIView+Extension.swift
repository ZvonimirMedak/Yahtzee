//
//  UIView+Extension.swift
//  Yahtzee
//
//  Created by Zvonimir Medak on 16.03.2021..
//

import Foundation
import UIKit
extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
