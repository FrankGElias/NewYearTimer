//
//  DataController.swift
//  TimeZoneAPI
//
//  Created by Francis Elias on 7/14/20.
//  Copyright © 2020 Frank. All rights reserved.
//

import Foundation

class DataController : NSObject {

    weak var delegate : DataControllerDelegate?

    override init() {
        super.init()
    }

// MARK: fetch function that handles our request, it sends the response through DataControllerDeleaget methods which is set to our viewController
    
    func fetchZipInfo(_ zip : String?)  {
        let string = "http://localhost:5000/api/timezone/\(zip ?? "")"
        let url = URL(string: string)
        var request = URLRequest(url: url! as URL)
        request.setValue("b064b6d2-8fbd-48b0-ac29-1a88237ce022", forHTTPHeaderField: "X-Application-Key") //**
        request.httpMethod = "GET"
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if (response as? HTTPURLResponse) != nil {
                if let data = data {
                    do {
                        let object = try JSONDecoder().decode(ZipCodeInfoObject.self, from: data)
                        self.delegate?.didFinishFetch(object)
                    } catch let error {
                        self.delegate?.didFailFetch(error)
                    }
                }
            } else {
                self.delegate?.didFailFetch(error)
            }
        }
        dataTask.resume()
    }
}
