//
//  ArchitectsViewModel.swift
//  DANA
//
//  Created by Rini Joseph on 2/7/22.
//

import Foundation
import Alamofire
import CoreData


class ArchitectsViewModel: ObservableObject {
    var architects : [ArchitectsModel] = []
    var imageUrlArray : [ImageModel] = []
    let currentNetworkmanager = networkManager()
    
    
    func makeFetchArchitectsApiCall(context: NSManagedObjectContext,completionHandler: @escaping () -> (Void)){
        currentNetworkmanager.fetchArchitectsfromDANA { architectsArray in
            let architectsArrayforDB = architectsArray;
            DispatchQueue.main.async {
                self.architects = architectsArrayforDB
                self.saveData(context: context) {
                    completionHandler()
                }
                
            }
            
        }
        
    }
    
    func makeFetchimagesApiCall(context: NSManagedObjectContext,completionHandler: @escaping () -> (Void)){
        let architects = fetchallArchitectsfromDB()
        for architect in architects {
            if let imageUrl = architect.fileUrl{
                currentNetworkmanager.fetchImagefromDANA(imageUrl) { imageurlsArray in
                    let urlArrayforDB = imageurlsArray;
                    DispatchQueue.main.async {
                        self.imageUrlArray = urlArrayforDB
                        // self.saveData(context: context)
                        self.updateImageData(context: context)
                    }
                    completionHandler()
                }
            }
            completionHandler()
        }
        NotificationCenter.default.post(name: .reloadArchitects, object: nil)
    }
    
    
    //saving data to core data
    func saveData(context: NSManagedObjectContext, completionHandler: @escaping () -> (Void)){
        architects.forEach{(data) in
            let entity = Architects_Firms(context:context)
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
                case "Occupation":
                    entity.occupation = value.text
                case "Bibliography":
                    entity.bibilography = value.text
                case "Web Resources":
                    entity.webdetails = value.text
                case "Birth Date":
                    entity.birthdate = value.text
                case "Death Date":
                    entity.deathdate = value.text
                case "Birth Place":
                    entity.birthplace = value.text
                case "Biographical Text":
                    entity.biography = value.text
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
        let architectsfromDB = fetchallArchitectsfromDB()
        architectsfromDB.forEach{(dataArch) in
            if imageUrlArray.count > 0{
                let dataImg = imageUrlArray.first
                if dataArch.id == dataImg!.item.id{
                    dataArch.setValue(dataImg!.file_urls.thumbnail, forKey: "imageUrl")
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
    func fetchallArchitectsfromDB()-> Array<Architects_Firms>{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchedArchitects = NSFetchRequest<NSFetchRequestResult>(entityName: textConstants.architectEntity)
        do {
            let fetchedArchitects = try context.fetch(fetchedArchitects) as! [Architects_Firms]
            print(fetchedArchitects.count)
            return fetchedArchitects
        } catch {
            fatalError("Failed to fetch categories: \(error)")
        }
    }
    
    
//    //check if  DB is empty for architects
//    func checkArchitectsisEmpty(entity:String)->Bool {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
//        var isEmpty = false
//        request.fetchLimit = 1
//        do{
//            let count = try context.count(for: request)
//            if(count == 0){
//                isEmpty = true;
//            }
//            else{
//                isEmpty = false;
//            }
//        }
//        catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
//        return isEmpty
//    }
}


