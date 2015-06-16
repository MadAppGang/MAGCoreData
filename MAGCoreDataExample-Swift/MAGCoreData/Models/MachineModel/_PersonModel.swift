// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PersonModel.swift instead.

import CoreData

enum PersonModelAttributes: String {
    case age = "age"
    case entityId = "entityId"
    case name = "name"
}

enum PersonModelRelationships: String {
    case cars = "cars"
}

@objc
class _PersonModel: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "Person"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _PersonModel.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var age: NSNumber?

    // func validateAge(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var entityId: String

    // func validateEntityId(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var name: String

    // func validateName(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

    @NSManaged
    var cars: NSSet

}

extension _PersonModel {

    func addCars(objects: NSSet) {
        let mutable = self.cars.mutableCopy() as! NSMutableSet
        mutable.unionSet(objects as Set<NSObject>)
        self.cars = mutable.copy() as! NSSet
    }

    func removeCars(objects: NSSet) {
        let mutable = self.cars.mutableCopy() as! NSMutableSet
        mutable.minusSet(objects as Set<NSObject>)
        self.cars = mutable.copy() as! NSSet
    }

    func addCarsObject(value: CarModel!) {
        let mutable = self.cars.mutableCopy() as! NSMutableSet
        mutable.addObject(value)
        self.cars = mutable.copy() as! NSSet
    }

    func removeCarsObject(value: CarModel!) {
        let mutable = self.cars.mutableCopy() as! NSMutableSet
        mutable.removeObject(value)
        self.cars = mutable.copy() as! NSSet
    }

}
