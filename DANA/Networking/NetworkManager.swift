//
//  NetworkManager.swift
//  DANA
//
//  Created by Rini Joseph on 2/5/22.
//

import Foundation
import Alamofire
class networkManager{
        //fetch map locations from API
        func fetchMaplocationsfromDANA(completionHandler: @escaping () -> (Void)) {
        let request = AF.request(apiConstants.geolocationApi)
        request.responseDecodable(of: [LocationModel].self) { (response) in
        guard let maps = response.value else { return }
        print(maps)
        completionHandler()
        }
        }
    
}
//with out completion handler
 
 //fetch map locations from API
//    func fetchMaplocationsfromDANA() {
//    let request = AF.request(apiConstants.geolocationApi)
//    request.responseDecodable(of: [LocationModel].self) { (response) in
//    guard let maps = response.value else { return }
//    print(maps)
//    }
//    }

