Pod::Spec.new do |s|
  s.name         = "MAGCoreData"
  s.version      = "0.0.2"
  s.summary      = "CoreData classes helpers from MadAppGang."

  s.description  = <<-DESC
                   MAGCoreData is Core Data helpers classes to kill boilerplate code.

                   * Easy creating of managed objec context, and child contextes
                   * Helping to parse NSDictionary to NSManagedObjectObject with easy class maping
                   * Category for NSManagedObjectContext for easy objects management (find, updatem create).
                   * Fetch Result controller class for helping data refreshing when data is updated
                   DESC

  s.homepage     = "https://github.com/MadAppGang/MAGCoreData"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license      = "MIT"
  s.author             = { "Ievgen Rudenko" => "i@madappgang.com" }

  s.platform     = :ios, "5.0"
  s.source       = { :git => "https://github.com/MadAppGang/MAGCoreData.git", :tag => "0.0.2" }
  s.source_files  = "MagCoreData", "MagCoreData/**/*.{h,m}"
  s.framework  = "CoreData"
  s.requires_arc = true
  s.dependency 'ISO8601DateFormatterValueTransformer', '~> 0.7.0'
end
