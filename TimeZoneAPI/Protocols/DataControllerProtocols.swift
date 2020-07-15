//
//  DataControllerProtocols.swift
//  TimeZoneAPI
//
//  Created by Francis Elias on 7/14/20.
//  Copyright © 2020 Frank. All rights reserved.
//

import Foundation

// MARK: protocol used to communicate between our DataController and ViewController, in case of success and fail.

protocol DataControllerDelegate : class {
    func didFinishFetch(_ object : ZipCodeInfoObject)
    func didFailFetch(_ error : Error?)
}
