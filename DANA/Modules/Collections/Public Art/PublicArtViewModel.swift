
//
//  ArchitectsViewModel.swift
//  DANA
//
//  Created by Rini Joseph on 2/7/22.
//

import Foundation
import Alamofire
import CoreData


class PublicArtViewModel: ObservableObject {
    var publicArts : [PublicArtModel] = []
    var imageUrlArray : [ImageModel] = []
    let currentNetworkmanager = networkManager()
    
    
    func makeFetchpublicArtsApiCall(context: NSManagedObjectContext,completionHandler: @escaping () -> (Void)){
        currentNetworkmanager.fetchPublicArtfromDANA {artArray in
            let ArrayforDB = artArray;
            DispatchQueue.main.async {
                self.publicArts = ArrayforDB
                self.saveData(context: context) {
                    completionHandler()
                }
                
            }
            
        }
        
    }
    
    func makeFetchimagesApiCall(context: NSManagedObjectContext,completionHandler: @escaping () -> (Void)){
        let publicArts = fetchallPublicArtsfromDB()
        for art in publicArts {
            if let imageUrl = art.fileUrl{
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
        NotificationCenter.default.post(name: .reloadArt, object: nil)
    }
    
    
    //saving data to core data
    func saveData(context: NSManagedObjectContext, completionHandler: @escaping () -> (Void)){
        publicArts.forEach{(data) in
            let entity = PublicArts(context:context)
            entity.id = Int32(data.id)
            entity.fileUrl = data.files.url
            entity.name = data.element_texts[0].text
            for value in data.element_texts{
                switch value.element.name {
                case "Title":
                    entity.title = value.text
                case "Subject":
                    entity.subject = value.text
                case "Creator":
                    entity.creator = value.text
                case "State":
                    entity.state = value.text
                case "Bibliography":
                    entity.bibliography = value.text
                case "Web Resources":
                    entity.webdetails = value.text
                case "Description":
                    entity.descriptions = value.text
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
        let artsfromDB = fetchallPublicArtsfromDB()
        artsfromDB.forEach{(dataArt) in
            imageUrlArray.forEach{(dataImg) in
                if dataArt.id == dataImg.item.id{
                    dataArt.setValue(dataImg.file_urls.square_thumbnail, forKey: "imageUrl")
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
    func fetchallPublicArtsfromDB()-> Array<PublicArts>{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchedArts = NSFetchRequest<NSFetchRequestResult>(entityName: textConstants.artEntity)
        do {
            let fetchedArts = try context.fetch(fetchedArts) as! [PublicArts]
            print(fetchedArts.count)
            return fetchedArts
        } catch {
            fatalError("Failed to fetch categories: \(error)")
        }
    }
}



