// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CarModel.swift instead.

import CoreData

enum CarModelAttributes: String {
    case cost = "cost"
    case entityId = "entityId"
    case name = "name"
}

enum CarModelRelationships: String {
    case person = "person"
}

@objc
class _CarModel: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "Car"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _CarModel.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var cost: NSNumber?

    // func validateCost(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var entityId: String

    // func validateEntityId(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var name: String

    // func validateName(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged
    var person: PersonModel?

    // func validatePerson(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

}

