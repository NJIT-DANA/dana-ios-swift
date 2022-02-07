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
    
    
    //fetch public spaces from API
    func fetchPublicSpacesfromDANA(completionHandler: @escaping () -> (Void)) {
    let request = AF.request(apiConstants.publicspaceApi)
    request.responseDecodable(of: [PublicSpaceModel].self) { (response) in
    guard let publicspaces = response.value else { return }
    print(publicspaces)
    completionHandler()
    }
        
    }
    //fetch architects/architecure  from API
    func fetchArchitectsfromDANA(completionHandler: @escaping () -> (Void)) {
    let request = AF.request(apiConstants.architectsApi)
    request.responseDecodable(of: [ArchitectsModel].self) { (response) in
    guard let architects = response.value else { return }
    print(architects)
    completionHandler()
    }
    }
    
    //fetch buildings  from API
    func fetchBuildingsfromDANA(completionHandler: @escaping () -> (Void)) {
    let request = AF.request(apiConstants.buildingsApi)
    request.responseDecodable(of: [BuildingModel].self) { (response) in
    guard let buildings = response.value else { return }
    print(buildings)
    completionHandler()
    }
    }
    
    
    //fetch public art  from API
    func fetchPublicArtfromDANA(completionHandler: @escaping () -> (Void)) {
    let request = AF.request(apiConstants.publicartApi)
    request.responseDecodable(of: [PublicArtModel].self) { (response) in
    guard let publicart = response.value else { return }
    print(publicart)
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

