//
//  CoreData.swift
//  MarvelMVC
//
//  Created by Abdullah Onur Şimşek on 17.02.2022.
//

import Foundation
import CoreData
import ObjectMapper

class CoreData {
    static func saveCharacter(character: CharactersResultModel){
        let context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: context)
        let newItem = NSManagedObject(entity: entity!, insertInto: context)
        
        let item = Mapper().toJSONString(character) ?? ""
        newItem.setValue(item, forKey: "item")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Saving character error. \(error) - \(error.userInfo)")
        }
    }
    
    static func getSavedCharacters() -> [CharactersResultModel] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        request.returnsObjectsAsFaults = false

        var characters: [CharactersResultModel] = []
           
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let itemResult = data.value(forKey: "item") as! String
                if let characterModel = Mapper<CharactersResultModel>().map(JSONString: itemResult) {
                    characters.append(characterModel)
                }
            }
        } catch {
            print("Fetching characters error")
        }
        
        return characters
    }
    
    static func getSavedCharactersIds() -> [Int] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        request.returnsObjectsAsFaults = false

        var characters: [Int] = []
           
        do {
            let result = try context.fetch(request)

            for data in result as! [NSManagedObject] {
                let itemResult = data.value(forKey: "item") as! String
                let characterModel = Mapper<CharactersResultModel>().mapArray(JSONString: itemResult) ?? []
                for element in characterModel {
                    characters.append(element.id ?? 0)
                }
            }
        } catch {
            print("Fetching characters error")
        }
        
        return characters
    }
    
    static func deleteSavedCharacter(characterId: Int) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Favorites")

        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                for data in result {
                    if let unwrappedResult = data.value(forKey: "item") as? String {
                        if let characterModel = Mapper<CharactersResultModel>().map(JSONString: unwrappedResult) {
                            if characterModel.id == characterId {
                                context.delete(data)
                            }
                        }
                        else {
                            print("unwrappingError")
                        }
                    }
                    else {
                        print("seconUnwrappingError")
                    }
                }
            }
            try context.save()
        } catch {
            print("deleting error")
        }
        print("item deleted")
    }
}
