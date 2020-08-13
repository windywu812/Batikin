//
//  CoreDataServices.swift
//  Batikin
//
//  Created by Windy on 13/08/20.
//  Copyright © 2020 BatikAja. All rights reserved.
//

import UIKit
import CoreData

class CoreDataServices {
    
    static func readData(completion: @escaping ([BatikModel]) -> ()) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.entityName)
        
        var batiks = [BatikModel]()
        
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            result.forEach { (batik) in
                batiks.append(
                    BatikModel(idBatik: batik.value(forKey: Constant.idBatik) as! UUID,
                               nameBatik: batik.value(forKey: Constant.nameBatik) as! String,
                               imageBatik: batik.value(forKey: Constant.imageBatik) as! Data)
                )}
        } catch let err {
            print(err)
        }
        
        completion(batiks)
    }
    
    static func saveData(_ idBatik: UUID, _ nameBatik: String, _ imageBatik: Data) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.insertNewObject(forEntityName: Constant.entityName, into: context)
        
        entity.setValue(idBatik, forKey: Constant.idBatik)
        entity.setValue(nameBatik, forKey: Constant.nameBatik)
        entity.setValue(imageBatik, forKey: Constant.imageBatik)
        
        do {
            try context.save()
        } catch let err {
            print(err)
        }
        
    }
    
    static func updateData(_ id: UUID, _ name: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.entityName)
        fetchRequest.predicate = NSPredicate(format: "\(Constant.idBatik) = \(id)")
        
        do {
            let fetch = try context.fetch(fetchRequest)
            let dataToUpdate = fetch[0] as! NSManagedObject
            dataToUpdate.setValue(name, forKey: Constant.nameBatik)
            try context.save()
        } catch let err {
            print(err)
        }
        
    }
    
    static func deleteData(_ id: UUID) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constant.entityName)
        fetchRequest.predicate = NSPredicate(format: "\(Constant.idBatik) = \(id)")
        
        do {
            let dataToDelete = try context.fetch(fetchRequest)[0] as! NSManagedObject
            context.delete(dataToDelete)
            
            try context.save()
        } catch let err {
            print(err)
        }
        
    }
}
