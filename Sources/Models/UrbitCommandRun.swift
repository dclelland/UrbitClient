//
//  UrbitCommandRun.swift
//  Urbit
//
//  Created by Daniel Clelland on 13/01/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation

public class UrbitCommandRun: UrbitCommand {
    
    public required init(arguments: [String] = []) {
        super.init(arguments: ["run"] + arguments)
    }
    
    public convenience init(pier: URL, options: [UrbitCommandOption] = []) {
        self.init(arguments: [pier.path] + options.flatMap { $0.arguments })
    }
    
}
