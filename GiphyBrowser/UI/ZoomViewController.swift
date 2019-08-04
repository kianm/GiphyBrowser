//
//  ZoomViewController.swift
//  GiphyBrowser
//
//  Created by Kian Mehravaran on 16.06.19.
//  Copyright © 2019 Kian. All rights reserved.
//

import UIKit
import GiphyClient
import RxSwift

class ZoomViewController: UIViewController {

    private let viewModel = ZoomViewModel()
    private let bag = DisposeBag()
    private let imageView = UIImageView()
    private let FPSInverse = 1.0 / 60.0

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ZoomViewController"
        setupViews()
        bind(to: viewModel)
    }
}

extension ZoomViewController: ViewModelBindable {

    var disposeBag: DisposeBag? {
        return self.bag
    }

    func bind(to viewModel: ZoomViewModel) {
        let input = ZoomViewModel.Input()
        let output = viewModel.transform(input: input)
        title = output.title
        imageView.animateImage(imageSequence: output.imageSequence, fpsInverse: FPSInverse)
    }
}

extension ZoomViewController {
    private func setupViews() {
        view.addAndFitSubView(imageView, inSafeArea: true)
    }
}
