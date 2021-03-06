//
//  UrbitCommandNew.swift
//  UrbitKit
//
//  Created by Daniel Clelland on 13/01/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation

public class UrbitCommandNew: UrbitCommand {
    
    public required init(arguments: [String] = []) {
        super.init(arguments: ["new"] + arguments)
    }
    
    public enum BootType {
        
        case newComet
        case newFakeship(_ ship: String)
        case newFromKeyfile(_ keyfile: URL)
        
        var arguments: [String] {
            switch self {
            case .newComet:
                return ["--comet"]
            case .newFakeship(let ship):
                return ["--fake", ship]
            case .newFromKeyfile(let keyfile):
                return ["--keyfile", keyfile.path]
            }
        }
        
    }
    
    public convenience init(pier: URL? = nil, bootType: BootType, pill: URL? = Bundle.urbitKitResourceBundle.urbitPillURL, lite: Bool = false, arvo: URL? = nil, options: [UrbitCommandOption] = []) {
        var arguments: [String] = []
        if let pier = pier {
            arguments += [pier.path]
        }
        arguments += bootType.arguments
        if let pill = pill {
            arguments += ["--pill", pill.path]
        }
        if lite == true {
            arguments += ["--lite"]
        }
        if let arvo = arvo {
            arguments += ["--arvo", arvo.path]
        }
        self.init(arguments: arguments + options.flatMap { $0.arguments })
    }
    
}
