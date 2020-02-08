//
//  UrbitCommandDebug.swift
//  UrbitKit
//
//  Created by Daniel Clelland on 13/01/20.
//  Copyright © 2020 Protonome. All rights reserved.
//

import Foundation

public class UrbitCommandDebug: UrbitCommand {
    
    public required init(arguments: [String] = []) {
        super.init(arguments: ["bug"] + arguments)
    }
    
}

public class UrbitCommandDebugValidatePill: UrbitCommandDebug {
    
    public required init(arguments: [String] = []) {
        super.init(arguments: ["validate-pill"] + arguments)
    }
    
    public convenience init(pill: URL, printPill: Bool = false, printBoot: Bool = false) {
        var arguments: [String] = [pill.path]
        if printPill == true {
            arguments += ["--print-pill"]
        }
        if printBoot == true {
            arguments += ["--print-boot"]
        }
        self.init(arguments: arguments)
    }
    
}

public class UrbitCommandDebugCollectAllEffects: UrbitCommandDebug {
    
    public required init(arguments: [String] = []) {
        super.init(arguments: ["collect-all-fx"] + arguments)
    }
    
    public convenience init(pier: URL) {
        self.init(arguments: [pier.path])
    }
    
}

public class UrbitCommandDebugValidateEvents: UrbitCommandDebug {
    
    public required init(arguments: [String] = []) {
        super.init(arguments: ["validate-events"] + arguments)
    }
    
    public convenience init(pier: URL, first: UInt64? = nil, last: UInt64? = nil) {
        var arguments: [String] = [pier.path]
        if let first = first {
            arguments += ["--first", String(first)]
        }
        if let last = last {
            arguments += ["--last", String(last)]
        }
        self.init(arguments: arguments)
    }
    
}

public class UrbitCommandDebugEventBrowser: UrbitCommandDebug {
    
    public required init(arguments: [String] = []) {
        super.init(arguments: ["event-browser"] + arguments)
    }
    
    public convenience init(pier: URL) {
        self.init(arguments: [pier.path])
    }
    
}

public class UrbitCommandDebugValidateEffects: UrbitCommandDebug {
    
    public required init(arguments: [String] = []) {
        super.init(arguments: ["validate-effects"] + arguments)
    }
    
    public convenience init(pier: URL, first: UInt64? = nil, last: UInt64? = nil) {
        var arguments: [String] = [pier.path]
        if let first = first {
            arguments += ["--first", String(first)]
        }
        if let last = last {
            arguments += ["--last", String(last)]
        }
        self.init(arguments: arguments)
    }
    
}

public class UrbitCommandDebugPartialReplay: UrbitCommandDebug {
    
    public required init(arguments: [String] = []) {
        super.init(arguments: ["partial-replay"] + arguments)
    }
    
    public convenience init(pier: URL, last: UInt64? = nil) {
        var arguments: [String] = [pier.path]
        if let last = last {
            arguments += ["--last", String(last)]
        }
        self.init(arguments: arguments)
    }
    
}

public class UrbitCommandDebugDawn: UrbitCommandDebug {
    
    public required init(arguments: [String] = []) {
        super.init(arguments: ["dawn"] + arguments)
    }
    
    public convenience init(keyfile: URL) {
        self.init(arguments: [keyfile.path])
    }
    
}

public class UrbitCommandDebugComet: UrbitCommandDebug {
    
    public required init(arguments: [String] = []) {
        super.init(arguments: ["comet"])
    }
    
}
