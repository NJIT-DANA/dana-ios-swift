//
//  BuildingsViewModel.swift
//  DANA
//
//  Created by Littman Library on 2/19/22.
//

import Foundation
import CoreData
import UIKit
class BuildingsViewModel: ObservableObject {

var buildings : [BuildingModel] = []
var imageUrlArray : [ImageModel] = []
let currentNetworkmanager = networkManager()


func makeFetchBuildingsApiCall(context: NSManagedObjectContext,completionHandler: @escaping () -> (Void)){
    currentNetworkmanager.fetchBuildingsfromDANA { buildingsArray in
        let buildingsArrayforDB = buildingsArray;
        DispatchQueue.main.async {
            self.buildings = buildingsArrayforDB
            self.saveData(context: context) {
                completionHandler()
            }
            
        }
        
    }
    
}
    
    
    func makeFetchimagesApiCall(context: NSManagedObjectContext,completionHandler: @escaping () -> (Void)){
        let buildings = fetchallBuildingsfromDB()
        for building in buildings {
            if let imageUrl = building.fileUrl{
                currentNetworkmanager.fetchImagefromDANA(imageUrl) { imageurlsArray in
                    let urlArrayforDB = imageurlsArray;
                    DispatchQueue.main.async {
                        self.imageUrlArray = urlArrayforDB
                        self.updateImageData(context: context)
                    }
                    completionHandler()
                }
            }
            completionHandler()
        }
    }
    
    //saving data to core data
    func saveData(context: NSManagedObjectContext, completionHandler: @escaping () -> (Void)){
        buildings.forEach{(data) in
            let entity = Buildings(context:context)
            entity.id = Int32(data.id)
            entity.fileUrl = data.files.url
            entity.name = data.element_texts[0].text
            for value in data.element_texts{
                switch value.element.name {
                case "Title":
                    entity.title = value.text
                case "Subject":
                    entity.subject = value.text
                case "Description":
                    entity.descriptions = value.text
                case "State":
                    entity.state = value.text
                case "Bibliography":
                    entity.bibliography = value.text
                case "Web Resources":
                    entity.webdetails = value.text
                case "Condition History":
                    entity.condition = value.text
                case "Relation":
                    entity.relation = value.text
                default:
                    print("Enjoy your day!")
                }
            }
        }
        do{
            try context.save()
            print("success, saved")
            completionHandler()
        }
        catch{
            print(error.localizedDescription )
        }
    }
    
    //updating imagedata to core data
    func updateImageData(context: NSManagedObjectContext){
        let buildingfromDB = fetchallBuildingsfromDB()
        buildingfromDB.forEach{(dataBuild) in
            
            if imageUrlArray.count > 0{
                let dataImg = imageUrlArray.first
                if dataBuild.id == dataImg!.item.id{
                    dataBuild.setValue(dataImg!.file_urls.thumbnail, forKey: "imageUrl")
                                }
            }
            
        }
        do{
            try context.save()
            print("success, updated image urls in architects")
        }
        catch{
            print(error.localizedDescription )
        }
    }
    
    //fetch all from DB
    func fetchallBuildingsfromDB()-> Array<Buildings>{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchedBuildings = NSFetchRequest<NSFetchRequestResult>(entityName: textConstants.buildingEntity)
        do {
            let fetchedBuildings = try context.fetch(fetchedBuildings) as! [Buildings]
            print(fetchedBuildings.count)
            return fetchedBuildings
        } catch {
            fatalError("Failed to fetch categories: \(error)")
        }
    
}
}
