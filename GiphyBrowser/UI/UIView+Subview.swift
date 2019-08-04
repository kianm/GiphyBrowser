//
//  UIView+Subview.swift
//  GiphyBrowser
//
//  Created by kian on 6/8/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import UIKit

extension UIView {
    func addAndFitSubView(_ view: UIView, inSafeArea: Bool = false) {
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        if inSafeArea {
            view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor).isActive = true
            view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            view.topAnchor.constraint(equalTo: topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        }
    }
    func constrainToParent(insets: UIEdgeInsets = .zero) {
        guard let parent = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        let metrics: [String: Any] =
            ["left": insets.left, "right": insets.right, "top": insets.top, "bottom": insets.bottom]
        parent.addConstraints(["H:|-(left)-[view]-(right)-|", "V:|-(top)-[view]-(bottom)-|"].flatMap {
            NSLayoutConstraint.constraints(withVisualFormat: $0, metrics: metrics, views: ["view": self])
        })
    }
}
