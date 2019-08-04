//
//  Environment.swift
//  GiphyClient
//
//  Created by kian on 6/6/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import Foundation

struct EnvironmentVariables {
    let apiKey: String
    let apiURL: String
    let trendingEndpoint: String
    let searchEndpoint: String
}

final class Environment {

    static private(set) public var variables: EnvironmentVariables = {
        let dict = Environment().getDictFromInfoPlist()
        let vars = EnvironmentVariables(apiKey: dict.sval("API_KEY"),
                                        apiURL: dict.sval("API_URL"),
                                        trendingEndpoint: "/trending",
                                        searchEndpoint: "/search")

        return vars
    }()

    private func getDictFromInfoPlist() -> [String: String] {

        var dict: [String: String] = [:]
        guard let infoPlist = Bundle.main.infoDictionary else {
            fatalError("plist not found")
        }

        var key = "API_KEY"
        guard let apiKey = infoPlist[key] as? String else {
            fatalError("api_key not found in plist")
        }
        dict[key] = apiKey

        key = "API_URL"
        guard let apiURL = infoPlist[key] as? String else {
            fatalError("api_url not found in plist")
        }
        dict[key] = apiURL
        return dict
    }

    private init() {
    }

}

extension Dictionary where Key == String {

    func sval(_ key: String) -> String {
        guard let value = self[key] as? String else {
            fatalError("missing property \(key)")
        }
        return value
    }
}
