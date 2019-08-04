//
//  GCErrorType.swift
//  GiphyClient
//
//  Created by kian on 6/6/19.
//  Copyright © 2019 Kian. All rights reserved.
//

import Foundation

enum GCErrorType: Error {
    case resourceNotFound
    case serverError(Int)
    case undefined(Int)
    case badURL
    case locationCouldNotBeObtained
    case noInternetConnection
    case encodingError
    case parsingError(String?)
}

extension GCErrorType: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .resourceNotFound:
            return "Requested Resource was not found"
        case .serverError(let errorCode):
            return "Server Error (\(errorCode))"
        case .undefined(let errorCode):
            return "Undefined error (\(errorCode))"
        case .badURL:
            return "Badly formed URL"
        case .locationCouldNotBeObtained:
            return "Location could not be obtained. Is location enabled?"
        case .noInternetConnection:
            return "No Internet Connection"
        case .encodingError:
            return "Could not convert to Dictionary"
        case .parsingError(let message):
            return message
        }
    }
}
