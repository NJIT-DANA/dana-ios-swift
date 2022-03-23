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
    var imageUrlArray : [ImageModel] = []
  
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
    
    func makeFetchimagesApiCall(context: NSManagedObjectContext,fileUrl:String,completionHandler: @escaping (_ imgArray: Array<ImageModel>) -> (Void)){
       
                currentNetworkmanager.fetchImagefromDANA(fileUrl) { imageurlsArray in
                    let urlArrayforDB = imageurlsArray;
                    DispatchQueue.main.async {
                    self.imageUrlArray = urlArrayforDB
                       
                    }
                    completionHandler(imageurlsArray)
                }
        
         
       // NotificationCenter.default.post(name: .reloadArchitects, object: nil)
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
                    dataLocn.fileurl = item.files.url
                    
                    for value in item.element_texts{
                        switch value.element.name {
                        case "Title":
                            dataLocn.title = value.text
                        case "Description":
                            dataLocn.mapdescription = value.text
                        case "State":
                            dataLocn.state = value.text
                        case "Condition History":
                            dataLocn.conditionhistory = value.text
                        case "Bibliography":
                            dataLocn.bibliography = value.text
                        case "Style":
                            dataLocn.style = value.text
                        default:
                            print("Enjoy your day!")
                        }
                    }

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
    func fetchallLocationsfromDB()-> Array<GeoLocations>{        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchedLocations = NSFetchRequest<NSFetchRequestResult>(entityName: textConstants.locationEntity)
        let sortdescriptor = NSSortDescriptor(keyPath: \GeoLocations.title, ascending: true)
        fetchedLocations.sortDescriptors = [sortdescriptor]
        do {
            let fetchedLocations = try context.fetch(fetchedLocations) as! [GeoLocations]
            print(fetchedLocations.count)
            return fetchedLocations
        } catch {
            fatalError("Failed to fetch categories: \(error)")
        }
    }
    

}
