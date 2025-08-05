//
//  ContentView.swift
//  CoreDataMastery
//
//  Created by Arman on 6/8/25.
//

import SwiftUI
import CoreData

class CoreDataViewModel: ObservableObject {
    let container: NSPersistentContainer
    @Published var saveEntities: [FruitEntity] = []
    
    init(){
        container = NSPersistentContainer(name: "FruitsContainer")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error loading core data. \(error)")
            } else {
                print("Successfully loaded core data")
            }
        }
        fetchFruit()
    }
    
    func fetchFruit(){
        let request = NSFetchRequest<FruitEntity>(entityName: "FruitEntity")
        do{
            saveEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching. \(error)")
        }
        
    }
    
    func addFruit(text: String){
        let newFruit = FruitEntity(context: container.viewContext)
        newFruit.name = text
        saveData()
    }
    
    func deleteFruit(indexSet: IndexSet){
        guard let index = indexSet.first else { return }
        let entity = saveEntities[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    func updateFruit(entity: FruitEntity){
        let currentName = entity.name ?? ""
        let newName = currentName + "!"
        entity.name = newName
        saveData()
    }
    
    func saveData(){
        do{
           try container.viewContext.save()
            fetchFruit()
        }
        catch let error{
            print("print error. \(error)")
        }
    }
    
}
struct ContentView: View {
    @StateObject var vm = CoreDataViewModel()
    @State var textFieldText: String = ""
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 20){
                TextField("Add fruit here...", text: $textFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(height: 50)
                    .background(Color.gray).opacity(0.5)
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button{
                    guard !textFieldText.isEmpty else { return }
                    vm.addFruit(text: textFieldText)
                    textFieldText = ""
                } label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                }.padding(.horizontal)
                
                List{
                    ForEach(vm.saveEntities){ entity in
                        Text(entity.name ?? "No Name")
                            .onTapGesture {
                                vm.updateFruit(entity: entity)
                            }
                        
                    }
                    .onDelete(perform: vm.deleteFruit)
                }.listStyle(PlainListStyle())
                
            }
            .navigationTitle("Fruit List")
        }
    }
}

#Preview {
    ContentView()
}
