// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TestModel.swift instead.

import CoreData

enum TestModelAttributes: String {
    case binary = "binary"
    case boolValue = "boolValue"
    case date = "date"
    case doubleValue = "doubleValue"
    case entityId = "entityId"
    case intValue = "intValue"
    case string = "string"
    case tranformable = "tranformable"
}

@objc
public class _TestModel: NSManagedObject {

    // MARK: - Class methods

    class func entityName () -> String {
        return "TestModel"
    }

    class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _TestModel.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged
    var binary: NSData?

    // func validateBinary(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var boolValue: NSNumber?

    // func validateBoolValue(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var date: NSDate?

    // func validateDate(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var doubleValue: NSNumber?

    // func validateDoubleValue(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var entityId: String

    // func validateEntityId(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var intValue: NSNumber?

    // func validateIntValue(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var string: String?

    // func validateString(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    @NSManaged
    var tranformable: AnyObject?

    // func validateTranformable(value: AutoreleasingUnsafePointer<AnyObject>, error: NSErrorPointer) {}

    // MARK: - Relationships

}

