//
//  GeoLocationViewModel.swift
//  DANA
//
//  Created by Littman Library on 2/12/22.
//

import Foundation
import Alamofire
import CoreData

class GeoLocationViewModel:ObservableObject{
    var maps : [LocationModel] = []
  
   // var imageUrlArray : [ImageModel] = []
    let currentNetworkmanager = networkManager()
    
    
    func makeFetchLocationsApiCall(context: NSManagedObjectContext,completionHandler: @escaping () -> (Void)){
        currentNetworkmanager.fetchMaplocationsfromDANA { mapArray in
            let mapArrayforDB = mapArray;
            DispatchQueue.main.async {
                self.maps = mapArrayforDB
                self.saveData(context: context) {
                    completionHandler()
                }
               // self.fetchDetailsfromUrl()
            }
            
        }
        
    }
    
    
    func makeFetchDetailsApiCall(context: NSManagedObjectContext,completionHandler: @escaping () -> (Void)){
        let locns = fetchallLocationsfromDB()
        for locn in locns {
            if let locnUrl = locn.url{
                currentNetworkmanager.fetchMapDetailsfromDANA(locnUrl) { locnDetail in
                    DispatchQueue.main.async {
                        // self.saveData(context: context)
                        self.updateData(context: context,item: locnDetail)
                    }
                    completionHandler()
                }
            }
            completionHandler()
        }
    }
    //saving data to core data
    func saveData(context: NSManagedObjectContext,completionHandler: @escaping () -> (Void)){
        maps.forEach{(data) in
            let entity = GeoLocations(context:context)
            entity.id = Int32(data.id)
            entity.latitude = data.latitude
            entity.longitude = data.longitude
            entity.url = data.item.url
            entity.itemId = Int32(data.item.id)
            entity.address = data.address
        }
        do{
            try context.save()
            print("success, saved map locations")
            completionHandler()
        }
        catch{
            print(error.localizedDescription )
        }
    }
    
    //saving imagedata to core data
    func updateData(context: NSManagedObjectContext, item:LocationDetailModel){
        let locnsfromDB = fetchallLocationsfromDB()
        locnsfromDB.forEach{(dataLocn) in
            
                if dataLocn.itemId == item.id{
                   dataLocn.setValue(item.element_texts[0].text, forKey: "title")
                }
            
        }
        do{
            try context.save()
            print("updated locations details in DB, UPDATED")
        }
        catch{
            print(error.localizedDescription )
        }
    }
    
    //fetch all from DB
    func fetchallLocationsfromDB()-> Array<GeoLocations>{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchedLocations = NSFetchRequest<NSFetchRequestResult>(entityName: textConstants.locationEntity)
        do {
            let fetchedLocations = try context.fetch(fetchedLocations) as! [GeoLocations]
            print(fetchedLocations.count)
            return fetchedLocations
        } catch {
            fatalError("Failed to fetch categories: \(error)")
        }
    }
    

}
