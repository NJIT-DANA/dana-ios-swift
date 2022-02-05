//
//  NetworkManager.swift
//  DANA
//
//  Created by Littman Library on 2/5/22.
//

import Foundation
import Alamofire
class networkManager{
   //with out completion handler
    
    //fetch map locations from API
    func fetchMaplocationsfromDANA() {
    let request = AF.request(apiConstants.geolocationApi)
    request.responseDecodable(of: [LocationModel].self) { (response) in
    guard let maps = response.value else { return }
    print(maps)
    }
    }

    
    
    
}

