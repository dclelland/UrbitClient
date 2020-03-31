//
//  UrbitCommandRun.swift
//  UrbitKit
//
//  Created by Daniel Clelland on 13/01/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation

public class UrbitCommandRun: UrbitCommand {
    
    public required init(arguments: [String] = []) {
        super.init(arguments: ["run"] + arguments)
    }
    
    public convenience init(pier: URL, daemon: Bool = false, options: [UrbitCommandOption] = []) {
        var arguments: [String] = [pier.path]
        if daemon == true {
            arguments += ["--daemon"]
        }
        self.init(arguments: arguments + options.flatMap { $0.arguments })
    }
    
}
