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
            self.saveData(context: context)
                    }
            completionHandler()
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
                        self.saveImageData(context: context)
                            }
                    completionHandler()
                }
        }
        completionHandler()
    }
    }

    
    //saving data to core data
    func saveData(context: NSManagedObjectContext){
        architects.forEach{(data) in
            let entity = Architects_Firms(context:context)
            entity.id = Int32(data.id)
            entity.fileUrl = data.files.url
            entity.name = data.element_texts[0].text
            //entity.imageUrl = data.url
    }

    do{
        try context.save()
        print("success, saved")
    }
    catch{
        print(error.localizedDescription )
    }
    }
    
    //saving imagedata to core data
    func saveImageData(context: NSManagedObjectContext){
        let architectsfromDB = fetchallArchitectsfromDB()
        architectsfromDB.forEach{(dataArch) in
            imageUrlArray.forEach{(dataImg) in
                if dataArch.id == dataImg.item.id{
                    let entity = Architects_Firms(context:context)
                    entity.imageUrl = dataImg.file_urls.square_thumbnail
                    entity.id = dataArch.id
                    entity.fileUrl = dataArch.fileUrl
                    entity.name = dataArch.name
                    
            }
        }
        
//        imageUrlArray.forEach{(data) in
//            let entity = Architects_Firms(context:context)
//            entity.id = Int32(data.id)
//            entity.imageUrl = data.file_urls.original
    }

    do{
        try context.save()
        print("success, saved")
    }
    catch{
        print(error.localizedDescription )
    }
    }
    
    
    
    
    //fetch all from DB
    func fetchallArchitectsfromDB()-> Array<Architects_Firms>{

        //let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
              let appDelegate = UIApplication.shared.delegate as! AppDelegate
              let context = appDelegate.persistentContainer.viewContext

                let fetchedArchitects = NSFetchRequest<NSFetchRequestResult>(entityName: "Architects_Firms")

                do {
                    let fetchedArchitects = try context.fetch(fetchedArchitects) as! [Architects_Firms]
                    print(fetchedArchitects.count)
                   // print(fetchedArchitects[0])
                    return fetchedArchitects
                } catch {
                    fatalError("Failed to fetch categories: \(error)")
                }


    }
 
    func checkArchitectsisEmpty(entity:String)->Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        var isEmpty = false
        //let predicate = NSPredicate(format: "name == %@", theName)
        //request.predicate = predicate
        request.fetchLimit = 1

        do{
            let count = try context.count(for: request)
            if(count == 0){
            isEmpty = true;
            }
            else{
                isEmpty = false;
            }
          }
        catch let error as NSError {
             print("Could not fetch \(error), \(error.userInfo)")
          }
        return isEmpty
    }
}


