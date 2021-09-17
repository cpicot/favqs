//
//  UIView+Utils.swift
//  favqs
//
//  Created by Clement Picot on 17/09/2021.
//

import UIKit

extension UIView {
    func rounded() {
        self.layer.cornerRadius = self.bounds.height / 2.0
        self.layer.masksToBounds = true
    }
}
