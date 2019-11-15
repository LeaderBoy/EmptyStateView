//
//  Error.swift
//  CCDINews
//
//  Created by 杨志远 on 2019/9/27.
//  Copyright © 2019 BaQiWL. All rights reserved.
//

import Foundation

extension Error {
    func isTimeout() -> Bool {
        let nsError = self as NSError
        return nsError.isTimeout()
    }
    
    func isNotConnectedToInternet() -> Bool {
        let nsError = self as NSError
        return nsError.isNotConnectedToInternet()
    }
}

extension NSError {
    func isURLErrorDomain() -> Bool {
        return self.domain == NSURLErrorDomain
    }
    
    func isTimeout() -> Bool {
        return self.code == NSURLErrorTimedOut
    }
    
    func isNotConnectedToInternet() -> Bool {
        return self.code == NSURLErrorNotConnectedToInternet
    }
    
    func isUnsupportedURL() -> Bool {
        return self.code == NSURLErrorUnsupportedURL
    }
    
    func isResourceUnavailable() -> Bool {
        self.code == NSURLErrorResourceUnavailable
    }
}


