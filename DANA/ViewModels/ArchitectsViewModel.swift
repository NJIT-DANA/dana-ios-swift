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
 
}

