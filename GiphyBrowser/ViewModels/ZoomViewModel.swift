//
//  ZoomViewModel.swift
//  GiphyBrowser
//
//  Created by kian on 8/4/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import GiphyClient

final class ZoomViewModel: ViewModelType, GiphyClientInjected {


    struct Input {
    }

    struct Output {
        let title: String
        let imageSequence: UIImageSequence
    }

    func transform(input: ZoomViewModel.Input) -> ZoomViewModel.Output {

        var title = ""
        var imageSequence = UIImageSequence(images: [])
        if let gif = giphyClient.laodItem() {
            title = gif.title
            if let images = gif.imageSequence {
                imageSequence = images
            }
        }
        return Output(title: title, imageSequence: imageSequence)
    }

}
