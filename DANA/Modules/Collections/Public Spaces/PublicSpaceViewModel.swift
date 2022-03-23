//
//  ArchitectsViewModel.swift
//  DANA
//
//  Created by Rini Joseph on 2/7/22.
//

import Foundation
import Alamofire
import CoreData


class PublicSpaceViewModel: ObservableObject {
    var publicSpaces : [PublicSpaceModel] = []
    var imageUrlArray : [ImageModel] = []
    let currentNetworkmanager = networkManager()
    
    
    func makeFetchpublicSpacesApiCall(context: NSManagedObjectContext,completionHandler: @escaping () -> (Void)){
        currentNetworkmanager.fetchPublicSpacesfromDANA {publicspacesArray in
            let ArrayforDB = publicspacesArray;
            DispatchQueue.main.async {
                self.publicSpaces = ArrayforDB
                self.saveData(context: context) {
                    completionHandler()
                }
                
            }
            
        }
        
    }
    
    func makeFetchimagesApiCall(context: NSManagedObjectContext,completionHandler: @escaping () -> (Void)){
        let publicSpaces = fetchallPublicSpacesfromDB()
        for space in publicSpaces {
            if let imageUrl = space.fileUrl{
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
        print("done")
        NotificationCenter.default.post(name: .reloadSpaces, object: nil)
    }
    
    
    //saving data to core data
    func saveData(context: NSManagedObjectContext, completionHandler: @escaping () -> (Void)){
        publicSpaces.forEach{(data) in
            let entity = PublicSpaces(context:context)
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
                    entity.web = value.text
                case "Condition History":
                    entity.condition = value.text
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
        let spacesfromDB = fetchallPublicSpacesfromDB()
        spacesfromDB.forEach{(dataSpace) in
            if imageUrlArray.count > 0{
                let dataImg = imageUrlArray.first
                if dataSpace.id == dataImg!.item.id{
                    dataSpace.setValue(dataImg!.file_urls.thumbnail, forKey: "imageUrl")
                
                                }
            }
        }
        do{
            try context.save()
            print("success, updated image urls in publicspcaes")
        }
        catch{
            print(error.localizedDescription )
        }
    }
    
    
    
    
    
    //fetch all from DB
    func fetchallPublicSpacesfromDB()-> Array<PublicSpaces>{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchedSpaces = NSFetchRequest<NSFetchRequestResult>(entityName: textConstants.spaceEntity)
      
        do {
            let fetchedSpaces = try context.fetch(fetchedSpaces) as! [PublicSpaces]
            print(fetchedSpaces.count)
            return fetchedSpaces
        } catch {
            fatalError("Failed to fetch categories: \(error)")
        }
    }
    
    
    
}


