//
//  SearchCell.swift
//  GiphyBrowser
//
//  Created by kian on 6/8/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import UIKit
import GiphyClient

class SearchCell: UICollectionViewCell, Configurable, Reusable {

    typealias Object = GIF
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let FPSInverse = 1.0 / 60.0

    func configure(object: Object, indexPath: IndexPath, tag: Int) {
        titleLabel.text = object.title

        self.tag = tag
        configureGIF(object, indexPath: indexPath, tag: tag)
    }

    private func configureGIF(_ object: Object, indexPath: IndexPath, tag: Int) {

        guard let retriever = object.imageSequenceRetriever else {
            return
        }
        retriever(indexPath) { [weak self] (imageSequence: UIImageSequence) in
            if self?.tag == tag {
                self?.imageView.animateImage(imageSequence: imageSequence, fpsInverse: self?.FPSInverse ?? 1.0)
            }
        }
    }

    func displayEnded() {
        self.imageView.stopAnimating()
        self.imageView.animationImages = []
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        displayEnded()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell(self.contentView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCell(_ view: UIView) {

        let views: [String: Any] = [
            "imageView": imageView,
            "titleLabel": titleLabel]

        views.forEach { (_, value: Any) in
            guard let subView = value as? UIView else { return }
            view.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
        }
        var constraints: [NSLayoutConstraint] = []

        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[imageView]-0-|",
            metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[titleLabel]-0-|",
            metrics: nil, views: views)

        constraints += NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[imageView]-10-[titleLabel]-0-|",
            metrics: nil, views: views)
        view.addConstraints(constraints)

        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        titleLabel.textColor = UIScheme.textColor
    }

}
