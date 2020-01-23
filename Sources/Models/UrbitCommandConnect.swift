//
//  UrbitCommandConnect.swift
//  Urbit
//
//  Created by Daniel Clelland on 13/01/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation

public class UrbitCommandConnect: UrbitCommand {
    
    public required init(arguments: [String] = []) {
        super.init(arguments: ["con"] + arguments)
    }
    
    convenience init(pier: URL) {
        self.init(arguments: [pier.path])
    }
    
}
