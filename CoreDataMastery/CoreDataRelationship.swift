//
//  CoreDataRelationship.swift
//  CoreDataMastery
//
//  Created by Arman on 7/8/25.
//

import SwiftUI
import CoreData

class CoreDataManager{
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private init(){
        container = NSPersistentContainer(name: "CoreDataContainer")
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        context = container.viewContext
    }
    
    func save(){
        do{
            try context.save()
        } catch let error{
            print("Error saving Core Data. \(error.localizedDescription)")
        }
        
    }
}
class CoreDataRelationshipViewModel: ObservableObject {
    let manager = CoreDataManager.instance
    @Published var businesses: [BusinessEntity] = []
    
}

struct CoreDataRelationship: View {
    @StateObject var vm = CoreDataRelationshipViewModel()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    CoreDataRelationship()
}
