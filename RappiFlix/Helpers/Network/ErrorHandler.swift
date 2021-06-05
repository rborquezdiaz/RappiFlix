//
//  ErrorHandler.swift
//  RappiFlix
//
//  Created by Rodrigo Borquez Diaz on 30/05/21.
//

import Foundation

public enum NetworkError: Error {
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case methodNotAllowed
    case notAcceptable
    case conflict
    case internalServer
    case notImplemented
    case badGateway
    case serviceUnavailable
    case generic
    case badInput
    case badParse
}

extension NetworkError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .badRequest:
            return "The request couldn't be understood by the server. (400)"
        case .unauthorized:
            return "You don't have the required credentials. (401)"
        case .forbidden:
            return "The request was refused by the server. (403)"
        case .notFound:
            return "Couldn't find any matching request. (404)"
        case .notAcceptable:
            return "The request couldn't be accepted by the server. (406)"
        case .methodNotAllowed:
            return "The method specified in the request is not allowed for the resource identified. (405)"
        case .conflict:
            return "Conflicting data on the request. (409)"
        case .internalServer:
            return "The server encountered an unexpected condition. (500)"
        case .notImplemented:
            return "The server does not support the functionality required to fulfill the request. (501)"
        case .badGateway:
            return "Bad Gateway (502)"
        case .serviceUnavailable:
            return "The server is currently unable to handle the request. (503)"
        case .generic:
            return "There was an error."
        case .badInput:
            return "There was an issue generating request."
        case .badParse:
            return "Entity couldn't be parsed properly."
        }
    }
}

class ErrorHandler {
    static func requestErrorFrom(statusCode : Int) -> NetworkError {
        switch statusCode {
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 405:
            return .methodNotAllowed
        case 406:
            return .notAcceptable
        case 409:
            return .conflict
        case 500:
            return .internalServer
        case 501:
            return .notImplemented
        case 502:
            return .badGateway
        case 503:
            return .serviceUnavailable
        default:
            return .generic
        }
    }
}
