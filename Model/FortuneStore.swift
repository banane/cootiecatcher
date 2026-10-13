//
//  FortuneStore.swift
//  Cootie - a game, cootie catcher- for kids, and for kids to learn how to program
//
//  The fortunes, stored with Core Data as in the 2015 AppDelegate and FortuneViewController:
//  the same Fortune.sqlite file and Fortune entity, so App Store players keep the fortunes they typed.
//

import CoreData
import Observation

@MainActor
@Observable
final class FortuneStore {
    // setup application-wide static variable here
    static let resetValues = [
        "You will be president.",
        "Giraffes are neat.",
        "Someone will steal your pencil.",
        "Give someone a dollar.",
        "Nobody gets you, like I get you.",
        "Your secret is safe.",
        "You will make an amazing pie.",
        "Your wish will come true.",
    ]

    /// FortuneString of each Fortune, sorted by FortunePosition.
    private(set) var fortunes: [String] = []

    private let managedObjectContext: NSManagedObjectContext
    private var fortuneObjects: [NSManagedObject] = []

    /// Documents/Fortune.sqlite, where the 2015 app kept its store.
    nonisolated static var defaultStoreURL: URL {
        URL.documentsDirectory.appending(path: "Fortune.sqlite")
    }

    /// `storeURL` nil keeps the store in memory, for tests.
    init(storeURL: URL? = FortuneStore.defaultStoreURL) {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: Self.managedObjectModel)
        do {
            _ = try persistentStoreCoordinator.addPersistentStore(
                type: storeURL == nil ? .inMemory : .sqlite,
                at: storeURL ?? URL(fileURLWithPath: "/dev/null"),
                options: [NSMigratePersistentStoresAutomaticallyOption: true,
                          NSInferMappingModelAutomaticallyOption: true])
        } catch {
            print("In Pers. store coordinator part- Unresolved error \(error)")
        }
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

        checkData()
    }

    /// The fortune under a flap number, 1–8, as in revealFortune.
    func fortune(number fortuneID: Int) -> String {
        let index = fortuneID - 1 // indexes start at 0 not 1
        return fortunes.indices.contains(index) ? fortunes[index] : ""
    }

    /// saveClicked in DetailViewController.
    func update(index: Int, to text: String) {
        fortuneObjects[index].setValue(text, forKey: "FortuneString")
        save()
        fetch()
    }

    /// resetFortunesOK in FortuneViewController.
    func reset() {
        for fort in fetchFortunes() {
            managedObjectContext.delete(fort)
        }
        insertResetValues()
        fetch()
    }

    /// checkData in the AppDelegate.
    private func checkData() {
        if fetchFortunes().count < 8 {
            insertResetValues()
        } else {
            print("fortune count upon app start is: \(fetchFortunes().count)")
        }
        fetch()
    }

    private func insertResetValues() {
        for (i, f_str) in Self.resetValues.enumerated() {
            let fortune = NSEntityDescription.insertNewObject(forEntityName: "Fortune", into: managedObjectContext)
            fortune.setValue(f_str, forKey: "FortuneString")
            fortune.setValue(i, forKey: "FortunePosition")
            save()
        }
    }

    private func fetchFortunes() -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Fortune")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "FortunePosition", ascending: true)]
        return (try? managedObjectContext.fetch(fetchRequest)) ?? []
    }

    private func fetch() {
        fortuneObjects = fetchFortunes()
        fortunes = fortuneObjects.map { ($0.value(forKey: "FortuneString") as? String) ?? "" }
    }

    private func save() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error adding Fortune - error:\(error)")
        }
    }

    /// Fortune.xcdatamodel from 2015, built in code: entity Fortune with
    /// FortunePosition (Integer 16, optional, default 0) and FortuneString (String, optional).
    private static let managedObjectModel: NSManagedObjectModel = {
        let position = NSAttributeDescription()
        position.name = "FortunePosition"
        position.attributeType = .integer16AttributeType
        position.isOptional = true
        position.defaultValue = 0

        let string = NSAttributeDescription()
        string.name = "FortuneString"
        string.attributeType = .stringAttributeType
        string.isOptional = true

        let entity = NSEntityDescription()
        entity.name = "Fortune"
        entity.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        entity.properties = [position, string]

        let model = NSManagedObjectModel()
        model.entities = [entity]
        return model
    }()
}
