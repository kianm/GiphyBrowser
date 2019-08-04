//
//  Injectables.swift
//  GiphyBrowser
//
//  Created by Kian Mehravaran on 16.06.19.
//  Copyright © 2019 Kian. All rights reserved.
//

import Foundation
import GiphyClient

struct InjectionMaps {
    static let interaction: AppStateInteractorType = AppInteractor()
    static var giphyClient: GiphyClientType = GiphyClient()
    static let uiManager: UIManagerType = UIManager()
}

protocol InteractionInjected {}
extension InteractionInjected {
    var interaction: AppStateInteractorType { return InjectionMaps.interaction}
}

protocol UIManagerInjected {}
extension UIManagerInjected {
    var uiManager: UIManagerType { return InjectionMaps.uiManager}
}

protocol GiphyClientInjected {}
extension GiphyClientInjected {
    public var giphyClient: GiphyClientType { return InjectionMaps.giphyClient}
}
