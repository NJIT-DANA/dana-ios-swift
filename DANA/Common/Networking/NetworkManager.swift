//
//  NetworkManager.swift
//  DANA
//
//  Created by Rini Joseph on 2/5/22.
//

import Foundation
import Alamofire
class networkManager{
    
    //fetch buildings  from API
    func fetchBuildingsfromDANA(completionHandler: @escaping (_ buildingsArray: [BuildingModel]) -> (Void)) {
    let request = AF.request(apiConstants.buildingsApi)
    request.responseDecodable(of: [BuildingModel].self) { (response) in
    guard let buildings = response.value else { return }
    print(buildings)
    completionHandler(buildings)
    }
    }

    //fetch architects/architecure  from API
    func fetchArchitectsfromDANA (completionHandler: @escaping (_ architectsArray: [ArchitectsModel]) -> (Void)){
    let request = AF.request(apiConstants.architectsApi)
    request.responseDecodable(of: [ArchitectsModel].self) { (response) in
    guard let architects = response.value else { return }
    print(architects)
    completionHandler(architects)
    }
    }
    //fetch map locations from API
    func fetchMaplocationsfromDANA(completionHandler: @escaping (_ locationsArray: [LocationModel]) -> (Void)) {
    let request = AF.request(apiConstants.geolocationApi)
    request.responseDecodable(of: [LocationModel].self) { (response) in
    guard let maps = response.value else { return }
    print(maps)
    completionHandler(maps)
    }
    }
    
    //fetch Images from API
    func fetchImagefromDANA(_ endUrl: String,completionHandler: @escaping (_ imageurlsArray: [ImageModel]) -> (Void)) {
    let request = AF.request(endUrl)
    request.responseDecodable(of: [ImageModel].self) { (response) in
    guard let images = response.value else { return }
    print(images)
    completionHandler(images)
    }
    }
    //fetch individual locn details from API
    func fetchMapDetailsfromDANA(_ endUrl: String,completionHandler: @escaping (_ locArray: LocationDetailModel) -> (Void)) {
    let request = AF.request(endUrl)
    request.responseDecodable(of: LocationDetailModel.self) { (response) in
    guard let locn = response.value else { return }
    print(locn)
    completionHandler(locn)
    }
    }
    //fetch public spaces from API
    func fetchPublicSpacesfromDANA(completionHandler: @escaping (_ spacesArray: [PublicSpaceModel]) -> (Void)) {
    let request = AF.request(apiConstants.publicspaceApi)
    request.responseDecodable(of: [PublicSpaceModel].self) { (response) in
    guard let publicspaces = response.value else { return }
    print(publicspaces)
    completionHandler(publicspaces)
    }
    }
   
    //fetch public art  from API
    func fetchPublicArtfromDANA(completionHandler: @escaping (_ artArray: [PublicArtModel]) -> (Void)) {
    let request = AF.request(apiConstants.publicartApi)
    request.responseDecodable(of: [PublicArtModel].self) { (response) in
    guard let publicArts = response.value else { return }
    print(publicArts)
    completionHandler(publicArts)
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

