//
//  AppInteractor.swift
//  GiphyBrowser
//
//  Created by kian on 6/16/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import Foundation

enum AppState {
    case trendingGIFs
    case searchingGIFs
    case gifSelected
}

protocol AppStateInteractorType {
    func setState(_ state: AppState)
}

class AppInteractor: AppStateInteractorType, UIManagerInjected {

    func setState(_ state: AppState) {
        switch state {
        case .trendingGIFs:
            self.uiManager.show(.showTrends)
        case .searchingGIFs:
            self.uiManager.show(.showSearch)
        case .gifSelected:
            self.uiManager.showFullScreen()
        }
    }
}
