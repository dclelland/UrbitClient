//
//  UrbitCommandOption.swift
//  UrbitKit
//
//  Created by Daniel Clelland on 13/01/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation

public enum UrbitCommandOption {
    
    case ames(port: UInt16)
    case http(port: UInt16)
    case https(port: UInt16)
    case loopback(port: UInt16)
    case quiet
    case verbose
    case exit
    case dryRun
    case dryFrom(event: UInt64)
    case trace
    case localhost
    case collectEffects
    case offline
    case fullReplay
    
    var arguments: [String] {
        switch self {
        case .ames(let port):
            return ["--ames", String(port)]
        case .http(let port):
            return ["--http-port", String(port)]
        case .https(let port):
            return ["--https-port", String(port)]
        case .loopback(let port):
            return ["--loopback-port", String(port)]
        case .quiet:
            return ["--quiet"]
        case .verbose:
            return ["--verbose"]
        case .exit:
            return ["--exit"]
        case .dryRun:
            return ["--dry-run"]
        case .dryFrom(let event):
            return ["--dry-from", String(event)]
        case .trace:
            return ["--trace"]
        case .localhost:
            return ["--local"]
        case .collectEffects:
            return ["--collect-fx"]
        case .offline:
            return ["--offline"]
        case .fullReplay:
            return ["--full-log-replay"]
        }
    }
    
}
